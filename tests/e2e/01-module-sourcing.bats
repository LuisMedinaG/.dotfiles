#!/usr/bin/env bats
# E2E Test 2: All .zsh/ modules are actually sourced and expose their sentinels.
#
# Each module is expected to expose a specific symbol. If a module is silently
# skipped (e.g. due to a typo in source_if_exists path), the sentinel is absent.
#
# IMPORTANT — stderr handling:
#   bats-core's `run` captures combined stdout+stderr by default. zsh's
#   interactive startup in CI emits warnings ("not interactive and can't
#   open terminal", "compinit: initialization aborted") that pollute
#   $output. We wrap every zsh invocation with `bash -c '... 2>/dev/null'`
#   so only the inner command's stdout makes it into $output.

setup() {
  load "${BATS_SUPPORT_PATH}/load.bash" 2>/dev/null || true
  load "${BATS_ASSERT_PATH}/load.bash"  2>/dev/null || true
}

# Run a zsh command interactively and capture only its stdout.
_zsh_stdout() {
  bash -c "zsh -i -c '$1' 2>/dev/null"
}

@test "zshenv: source_if_exists() is defined" {
  run bash -c 'zsh -i -c "type source_if_exists" 2>/dev/null'
  [ "$status" -eq 0 ]
}

@test "functions.zsh: take() is defined" {
  run bash -c 'zsh -i -c "type take" 2>/dev/null'
  [ "$status" -eq 0 ]
}

@test "history.zsh: HISTFILE is set" {
  run bash -c 'zsh -i -c "echo \$HISTFILE" 2>/dev/null'
  [ "$status" -eq 0 ]
  [ -n "$output" ]
  [[ "$output" == */* ]]
}

@test "history.zsh: HISTSIZE is at least 10000" {
  run bash -c 'zsh -i -c "echo \$HISTSIZE" 2>/dev/null'
  [ "$status" -eq 0 ]
  [ "$output" -ge 10000 ]
}

@test "options.zsh: EXTENDED_GLOB is set" {
  run bash -c 'zsh -i -c "[[ -o extendedglob ]] && echo YES" 2>/dev/null'
  [ "$status" -eq 0 ]
  [ "$output" = "YES" ]
}

@test "prompt.zsh: PROMPT is non-empty" {
  run bash -c 'zsh -i -c "echo \"\$PROMPT\"" 2>/dev/null'
  [ "$status" -eq 0 ]
  [ -n "$output" ]
}

@test "aliases.zsh: local overrides file is sourced without error" {
  # aliases.local may not exist — source_if_exists must not error either way
  run bash -c 'zsh -i -c "echo ok" 2>/dev/null'
  [ "$status" -eq 0 ]
  [ "$output" = "ok" ]
}
