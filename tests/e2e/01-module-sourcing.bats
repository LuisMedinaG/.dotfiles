#!/usr/bin/env bats
# E2E Test 2: All .zsh/ modules are actually sourced and expose their sentinels.
#
# Each module is expected to expose a specific symbol. If a module is silently
# skipped (e.g. due to a typo in source_if_exists path), the sentinel is absent.
#
# NOTE: bats-core's `run` captures combined stdout+stderr by default. zsh's
# interactive startup in CI can emit warnings to stderr (compinit, no TTY)
# that pollute $output. We extract the last non-empty line of $output for
# tests that assert a specific value.

setup() {
  load "${BATS_SUPPORT_PATH}/load.bash" 2>/dev/null || true
  load "${BATS_ASSERT_PATH}/load.bash"  2>/dev/null || true
}

# Return the last non-empty line of $output. Use after `run` to isolate the
# command's actual stdout from any stderr noise.
_last_line() {
  echo "$output" | awk 'NF { last = $0 } END { print last }'
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
  histfile=$(_last_line)
  [ -n "$histfile" ]
  [[ "$histfile" == */* ]]
}

@test "history.zsh: HISTSIZE is at least 10000" {
  run zsh -i -c 'echo $HISTSIZE'
  [ "$status" -eq 0 ]
  size=$(_last_line)
  [ "$size" -ge 10000 ]
}

@test "options.zsh: EXTENDED_GLOB is set" {
  run zsh -i -c '[[ -o extendedglob ]] && echo YES'
  [ "$status" -eq 0 ]
  last=$(_last_line)
  [ "$last" = "YES" ]
}

@test "prompt.zsh: PROMPT is non-empty" {
  run zsh -i -c 'echo "$PROMPT"'
  [ "$status" -eq 0 ]
  prompt=$(_last_line)
  [ -n "$prompt" ]
}

@test "aliases.zsh: local overrides file is sourced without error" {
  # aliases.local may not exist — source_if_exists must not error either way
  run zsh -i -c 'echo ok'
  [ "$status" -eq 0 ]
}
