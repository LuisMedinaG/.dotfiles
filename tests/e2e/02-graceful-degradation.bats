#!/usr/bin/env bats
# E2E Test 3: Graceful degradation when optional tools are absent.
#
# Run in a minimal container where eza, bat, rg, nvim, pyenv, jenv, zoxide, fzf
# are all missing. `zsh -i -c exit` must still succeed (status 0) and must not
# print any "command not found" errors — every optional tool is guarded with
# `command -v` before use.

setup() {
  load "${BATS_SUPPORT_PATH}/load.bash" 2>/dev/null || true
  load "${BATS_ASSERT_PATH}/load.bash"  2>/dev/null || true

  # Record which tools are genuinely absent so we can assert accordingly.
  _have() { command -v "$1" >/dev/null 2>&1; }
}

@test "shell initialises even when eza is absent" {
  if _have eza; then skip "eza is installed — degradation not testable here"; fi
  run zsh -i -c 'echo ok'
  [ "$status" -eq 0 ]
  [[ "$output" != *"command not found: eza"* ]]
}

@test "shell initialises even when bat is absent" {
  if _have bat; then skip "bat is installed"; fi
  run zsh -i -c 'echo ok'
  [ "$status" -eq 0 ]
  [[ "$output" != *"command not found: bat"* ]]
}

@test "shell initialises even when zoxide is absent" {
  if _have zoxide; then skip "zoxide is installed"; fi
  run zsh -i -c 'echo ok'
  [ "$status" -eq 0 ]
}

@test "shell initialises even when pyenv is absent" {
  if _have pyenv; then skip "pyenv is installed"; fi
  run zsh -i -c 'echo ok'
  [ "$status" -eq 0 ]
}

@test "shell initialises even when fzf is absent" {
  if _have fzf; then skip "fzf is installed"; fi
  run zsh -i -c 'echo ok'
  [ "$status" -eq 0 ]
  [[ "$output" != *"command not found: fzf"* ]]
}

@test "nvim alias falls back gracefully when nvim is absent" {
  if _have nvim; then skip "nvim is installed"; fi
  # alias must simply not be set — not error on shell startup
  run zsh -i -c 'echo ok'
  [ "$status" -eq 0 ]
}
