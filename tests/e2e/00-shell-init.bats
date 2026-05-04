#!/usr/bin/env bats
# E2E Test 1: Interactive shell completes initialization without errors.
#
# Verifies that zsh starts up cleanly. We explicitly capture stderr (via
# `2>&1`) for the negative assertions, since the whole point is to detect
# warnings emitted to stderr. But we also need a way to assert exit status
# isn't masked by noise — done with the bash wrapper that suppresses stderr.

setup() {
  load "${BATS_SUPPORT_PATH}/load.bash" 2>/dev/null || true
  load "${BATS_ASSERT_PATH}/load.bash"  2>/dev/null || true
}

@test "interactive shell exits cleanly (status 0)" {
  # Suppress stderr so warnings don't affect status capture
  run bash -c 'zsh -i -c "echo READY" 2>/dev/null'
  [ "$status" -eq 0 ]
  [ "$output" = "READY" ]
}

@test "no 'command not found' errors on startup" {
  # Capture stderr too — that's where these warnings would appear
  run bash -c 'zsh -i -c exit 2>&1'
  [[ "$output" != *"command not found"* ]]
  [[ "$output" != *"No such file or directory"* ]]
}

@test "no compinit insecure directories warning" {
  run bash -c 'zsh -i -c exit 2>&1'
  [[ "$output" != *"insecure directories"* ]]
}
