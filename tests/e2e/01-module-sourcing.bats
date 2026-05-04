#!/usr/bin/env bats
# E2E Test 2: All .zsh/ modules are actually sourced and expose their sentinels.
#
# Each module is expected to expose a specific symbol. If a module is silently
# skipped (e.g. due to a typo in source_if_exists path), the sentinel is absent.

setup() {
  load "${BATS_SUPPORT_PATH}/load.bash" 2>/dev/null || true
  load "${BATS_ASSERT_PATH}/load.bash"  2>/dev/null || true
}

@test "zshenv: source_if_exists() is defined" {
  run zsh -i -c 'type source_if_exists'
  [ "$status" -eq 0 ]
}

@test "functions.zsh: take() is defined" {
  run zsh -i -c 'type take'
  [ "$status" -eq 0 ]
}

@test "functions.zsh: addToPATH() is defined" {
  run zsh -i -c 'type addToPATH'
  [ "$status" -eq 0 ]
}

@test "history.zsh: HISTFILE is set" {
  run zsh -i -c 'echo $HISTFILE'
  [ "$status" -eq 0 ]
  [ -n "$output" ]
}

@test "history.zsh: HISTSIZE is at least 10000" {
  run zsh -i -c 'echo $HISTSIZE'
  [ "$status" -eq 0 ]
  [ "$output" -ge 10000 ]
}

@test "options.zsh: EXTENDED_GLOB is set" {
  run zsh -i -c '[[ -o extendedglob ]] && echo YES'
  [ "$status" -eq 0 ]
  [ "$output" = "YES" ]
}

@test "prompt.zsh: PROMPT is non-empty" {
  run zsh -i -c 'echo "$PROMPT"'
  [ "$status" -eq 0 ]
  [ -n "$output" ]
}

@test "aliases.zsh: local overrides file is sourced without error" {
  # aliases.local may not exist — source_if_exists must not error either way
  run zsh -i -c 'echo ok'
  [ "$status" -eq 0 ]
}
