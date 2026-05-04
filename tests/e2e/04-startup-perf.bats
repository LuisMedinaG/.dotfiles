#!/usr/bin/env bats
# E2E Test 5: Shell startup time budget.
#
# A regression gate: asserts that the mean of 5 `zsh -i -c exit` runs
# stays below STARTUP_BUDGET_MS (default 400ms). Tune the env var for
# the current machine's baseline.
#
# Usage locally:  STARTUP_BUDGET_MS=250 bats tests/e2e/04-startup-perf.bats
# Usage in CI:    budget is set via the workflow env (default 400ms).

STARTUP_BUDGET_MS="${STARTUP_BUDGET_MS:-400}"
RUNS=5

setup() {
  load "${BATS_SUPPORT_PATH}/load.bash" 2>/dev/null || true
  load "${BATS_ASSERT_PATH}/load.bash"  2>/dev/null || true
  # Warm caches before measuring
  zsh -i -c exit >/dev/null 2>&1 || true
}

# Measure mean wall-clock time for N runs of `zsh -i -c exit`.
# Returns result in milliseconds via stdout.
_mean_startup_ms() {
  local total_ns=0 i elapsed_ns start_ns end_ns
  for i in $(seq 1 "$RUNS"); do
    start_ns=$(date +%s%N)
    zsh -i -c exit >/dev/null 2>&1
    end_ns=$(date +%s%N)
    elapsed_ns=$(( end_ns - start_ns ))
    total_ns=$(( total_ns + elapsed_ns ))
  done
  echo $(( total_ns / RUNS / 1000000 ))
}

@test "mean zsh startup time is under ${STARTUP_BUDGET_MS}ms" {
  if ! command -v date >/dev/null || ! date +%s%N | grep -q '[0-9]'; then
    skip "nanosecond date not available on this platform"
  fi

  mean_ms=$(_mean_startup_ms)
  echo "Mean startup: ${mean_ms}ms  (budget: ${STARTUP_BUDGET_MS}ms, runs: ${RUNS})"

  if [ "$mean_ms" -ge "$STARTUP_BUDGET_MS" ]; then
    echo ""
    echo "HINT: profile with:  ZPROF=1 zsh -i -c exit"
    false
  fi
}

@test "shell-time() function is available and returns output" {
  run zsh -i -c 'shell-time 1'
  [ "$status" -eq 0 ]
  [ -n "$output" ]
}
