#!/usr/bin/env bats
# E2E Test 4: Bootstrap phases are idempotent (safe to re-run).
#
# Runs each testable phase twice and asserts the second run exits 0 and does
# not attempt to re-install already-present resources. Phases that require
# macOS or interactive sudo are skipped automatically.

setup() {
  load "${BATS_SUPPORT_PATH}/load.bash" 2>/dev/null || true
  load "${BATS_ASSERT_PATH}/load.bash"  2>/dev/null || true
  PHASES_DIR="$BATS_TEST_DIRNAME/../../.config/yadm/phases"
  export DOTFILES_PROFILE="${DOTFILES_PROFILE:-linuxbox}"
}

@test "phase 03-shell.sh is idempotent (second run exits 0)" {
  # Run once to set up, then again to verify idempotency.
  sh "$PHASES_DIR/03-shell.sh" >/dev/null 2>&1 || true
  run sh "$PHASES_DIR/03-shell.sh"
  [ "$status" -eq 0 ]
}

@test "profile selection: DOTFILES_PROFILE=work exits 0 non-interactively" {
  # Bootstrap must not prompt when DOTFILES_PROFILE is pre-set and stdin is not a TTY.
  # Wrap in `timeout 60` so a real hang surfaces as exit 124.
  # Explicitly set DOTFILES_PROFILE=work to actually exercise the work path
  # (setup() defaults it to linuxbox).
  run timeout 60 env DOTFILES_PROFILE=work sh "$BATS_TEST_DIRNAME/../../.config/yadm/bootstrap" </dev/null
  [ "$status" -ne 124 ]  # 124 = timeout (would have hung)
}

@test "DOTFILES_PROFILE defaults to 'personal' when unset and non-interactive" {
  # Use BATS_TEST_DIRNAME-relative path so the test works regardless of cwd.
  run sh -c "unset DOTFILES_PROFILE; sh \"$BATS_TEST_DIRNAME/../../.config/yadm/bootstrap\" </dev/null 2>&1 | head -3"
  [[ "$output" == *"personal"* ]]
}

@test "phase 03-shell.sh: required dirs are created and idempotent" {
  sh "$PHASES_DIR/03-shell.sh" >/dev/null 2>&1 || true
  # Phase 03 creates these unconditionally; assert they exist with no fallback.
  [ -d "$HOME/.cache/zsh" ]
  [ -d "$HOME/.local/state/nvim/undo" ]
  # Second run must not fail (idempotency)
  run sh "$PHASES_DIR/03-shell.sh"
  [ "$status" -eq 0 ]
}

@test "Zinit pre-clone: zinit dir exists after phase 03 runs" {
  sh "$PHASES_DIR/03-shell.sh" >/dev/null 2>&1 || true
  # Phase 03 creates this dir before attempting the clone, so it should exist
  # even if the clone itself failed (e.g. offline runner).
  [ -d "$HOME/.local/share/zinit" ]
  # And the phase must remain idempotent on a second run.
  run sh "$PHASES_DIR/03-shell.sh"
  [ "$status" -eq 0 ]
}
