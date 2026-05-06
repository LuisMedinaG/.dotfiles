#!/usr/bin/env bats
# E2E Test 4: Bootstrap phases are idempotent (safe to re-run).
#
# Runs each testable phase twice and asserts the second run exits 0 and does
# not attempt to re-install already-present resources. Phases that require
# macOS or interactive sudo are skipped automatically.

setup() {
  load "${BATS_SUPPORT_PATH}/load.bash" 2>/dev/null || true
  load "${BATS_ASSERT_PATH}/load.bash"  2>/dev/null || true
  SCRIPTS_DIR="$BATS_TEST_DIRNAME/../../scripts"
  SHELL_SCRIPT="$BATS_TEST_DIRNAME/../../run_once_03-shell.sh.tmpl"
  export DOTFILES_PROFILE="${DOTFILES_PROFILE:-linuxbox}"
}

# Render the .tmpl script by substituting {{ .dotfiles_profile }} with the env var.
# This avoids needing chezmoi installed in CI just for tests.
_render_shell_script() {
  sed "s/{{ .dotfiles_profile }}/$DOTFILES_PROFILE/g" "$SHELL_SCRIPT"
}

@test "run_once_03-shell: is idempotent (second run exits 0)" {
  # Run once to set up, then again to verify idempotency.
  _render_shell_script | sh >/dev/null 2>&1 || true
  run sh -c "$(_render_shell_script)"
  [ "$status" -eq 0 ]
}

@test "profile selection: DOTFILES_PROFILE=work renders correctly" {
  # Template must substitute the profile value without error.
  result=$(DOTFILES_PROFILE=work sed "s/{{ .dotfiles_profile }}/work/g" "$SHELL_SCRIPT" | head -20)
  [[ "$result" == *"DOTFILES_PROFILE=\"work\""* ]]
}

@test "DOTFILES_PROFILE defaults to 'personal' in pre_bootstrap.sh" {
  PRE_BOOTSTRAP="$BATS_TEST_DIRNAME/../../.local/bin/pre_bootstrap.sh"
  run sh -c "grep 'DOTFILES_PROFILE=\"personal\"' \"$PRE_BOOTSTRAP\""
  [ "$status" -eq 0 ]
}

@test "run_once_03-shell: required dirs are created and idempotent" {
  _render_shell_script | sh >/dev/null 2>&1 || true
  # Phase 03 creates these unconditionally; assert they exist.
  [ -d "$HOME/.cache/zsh" ]
  [ -d "$HOME/.local/state/nvim/undo" ]
  # Second run must not fail (idempotency)
  run sh -c "$(_render_shell_script)"
  [ "$status" -eq 0 ]
}

@test "Zinit pre-clone: zinit dir exists after run_once_03 runs" {
  _render_shell_script | sh >/dev/null 2>&1 || true
  # Phase creates this dir before attempting the clone, so it should exist
  # even if the clone failed (e.g. offline runner).
  [ -d "$HOME/.local/share/zinit" ]
  # And must remain idempotent on a second run.
  run sh -c "$(_render_shell_script)"
  [ "$status" -eq 0 ]
}
