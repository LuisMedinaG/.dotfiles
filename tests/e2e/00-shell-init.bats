#!/usr/bin/env bats
# E2E Test 1: Interactive shell completes initialization without errors.
#
# Verifies that `zsh -i -c exit` succeeds and produces no error output.
# Any "command not found", compinit security warning, or Zinit clone failure
# will appear on stderr and cause this test to fail.

setup() {
  load "${BATS_SUPPORT_PATH}/load.bash" 2>/dev/null || true
  load "${BATS_ASSERT_PATH}/load.bash"  2>/dev/null || true
}

@test "interactive shell exits cleanly (status 0)" {
  run zsh -i -c 'echo READY'
  [ "$status" -eq 0 ]
  [[ "$output" == *"READY"* ]]
}

@test "no 'command not found' errors on startup" {
  run zsh -i -c exit
  [ "$status" -eq 0 ]
  # stderr must not contain command-not-found noise
  [[ "$output" != *"command not found"* ]]
  [[ "$output" != *"No such file or directory"* ]]
}

@test "no compinit insecure directories warning" {
  run zsh -i -c exit
  [[ "$output" != *"insecure directories"* ]]
}
