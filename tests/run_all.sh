#!/bin/sh
#
# Test runner — validates dotfiles without installing anything.
#
# Run locally:   sh tests/run_all.sh
# Run in Docker: docker build -t dotfiles-test -f Dockerfile.test . && docker run --rm dotfiles-test
#
set -e

PASS=0
FAIL=0
TESTS_DIR="$(cd "$(dirname "$0")" && pwd)"

# Colors (only if terminal supports them)
if [ -t 1 ]; then
  GREEN='\033[0;32m'
  RED='\033[0;31m'
  YELLOW='\033[0;33m'
  NC='\033[0m'
else
  GREEN='' RED='' YELLOW='' NC=''
fi

pass() {
  PASS=$((PASS + 1))
  printf "  ${GREEN}✓${NC} %s\n" "$1"
}

fail() {
  FAIL=$((FAIL + 1))
  printf "  ${RED}✗${NC} %s\n" "$1"
}

warn() {
  printf "  ${YELLOW}⚠${NC} %s\n" "$1"
}

echo ""
echo "═══════════════════════════════════════"
echo "  Dotfiles Test Suite"
echo "═══════════════════════════════════════"
echo ""

# ─── Test 1: ZSH syntax check ───
echo "▶ ZSH syntax check"

# Find zsh — might be in different locations
ZSH_BIN=""
for candidate in /bin/zsh /usr/bin/zsh /opt/homebrew/bin/zsh /usr/local/bin/zsh; do
  if [ -x "$candidate" ]; then
    ZSH_BIN="$candidate"
    break
  fi
done

if [ -n "$ZSH_BIN" ]; then
  for file in \
    "$HOME/.zshenv" \
    "$HOME/.zshrc" \
    "$HOME/.zsh/options.zsh" \
    "$HOME/.zsh/history.zsh" \
    "$HOME/.zsh/completion.zsh" \
    "$HOME/.zsh/functions.zsh" \
    "$HOME/.zsh/aliases.zsh" \
    "$HOME/.zsh/prompt.zsh" \
    "$HOME/.zsh/tools/fzf.zsh" \
    "$HOME/.zsh/plugins/init.zsh"
  do
    if [ -f "$file" ]; then
      if $ZSH_BIN -n "$file" 2>/dev/null; then
        pass "$(basename "$file")"
      else
        fail "$(basename "$file") — syntax error"
      fi
    else
      warn "$(basename "$file") — not found, skipped"
    fi
  done
else
  warn "zsh not found, skipping syntax checks"
fi

echo ""

# ─── Test 2: Shell script syntax (sh -n) ───
echo "▶ Shell script syntax check (sh -n)"

for file in \
  "$HOME/.config/yadm/bootstrap" \
  "$HOME/.config/yadm/phases/01-homebrew.sh" \
  "$HOME/.config/yadm/phases/02-dotfiles.sh" \
  "$HOME/.config/yadm/phases/03-shell.sh" \
  "$HOME/.config/yadm/phases/04-macos.sh" \
  "$HOME/.local/bin/pre_bootstrap.sh" \
  "$HOME/.local/bin/create_dev_folders.sh"
do
  if [ -f "$file" ]; then
    if sh -n "$file" 2>/dev/null; then
      pass "$(basename "$file")"
    else
      fail "$(basename "$file") — syntax error"
    fi
  else
    warn "$(basename "$file") — not found, skipped"
  fi
done

echo ""

# ─── Test 3: Bash script syntax ───
echo "▶ Bash script syntax check (bash -n)"

for file in \
  "$HOME/.local/bin/rfv"
do
  if [ -f "$file" ]; then
    if bash -n "$file" 2>/dev/null; then
      pass "$(basename "$file")"
    else
      fail "$(basename "$file") — syntax error"
    fi
  else
    warn "$(basename "$file") — not found, skipped"
  fi
done

echo ""

# ─── Test 4: ShellCheck (if available) ───
echo "▶ ShellCheck (static analysis)"

if command -v shellcheck >/dev/null 2>&1; then
  for file in \
    "$HOME/.config/yadm/bootstrap" \
    "$HOME/.config/yadm/phases/01-homebrew.sh" \
    "$HOME/.config/yadm/phases/02-dotfiles.sh" \
    "$HOME/.config/yadm/phases/03-shell.sh" \
    "$HOME/.local/bin/pre_bootstrap.sh" \
    "$HOME/.local/bin/rfv"
  do
    if [ -f "$file" ]; then
      # SC1091: Can't follow sourced files (expected in dotfiles)
      # SC2312: Consider invoking separately to check exit status
      if shellcheck --exclude=SC1091,SC2312 --severity=warning "$file" 2>/dev/null; then
        pass "$(basename "$file")"
      else
        fail "$(basename "$file") — shellcheck warnings"
      fi
    fi
  done
else
  warn "shellcheck not installed, skipping (brew install shellcheck)"
fi

echo ""

# ─── Test 5: Brewfile syntax ───
echo "▶ Brewfile validation"

BREWFILE="$HOME/.config/brew/Brewfile"
if [ -f "$BREWFILE" ]; then
  # Check that every line is a valid Brewfile directive or comment
  INVALID_LINES=$(grep -nvE '^\s*(#|$|tap |brew |cask |mas |vscode |whalebrew )' "$BREWFILE" 2>/dev/null || true)
  if [ -z "$INVALID_LINES" ]; then
    pass "Brewfile syntax valid"
  else
    fail "Brewfile has invalid lines:"
    echo "$INVALID_LINES" | head -5
  fi
else
  warn "Brewfile not found"
fi

echo ""

# ─── Test 6: Required files exist ───
echo "▶ Required files check"

for file in \
  "$HOME/.zshenv" \
  "$HOME/.zshrc" \
  "$HOME/.zprofile" \
  "$HOME/.config/yadm/bootstrap" \
  "$HOME/.config/brew/Brewfile"
do
  if [ -f "$file" ]; then
    pass "$(basename "$file") exists"
  else
    fail "$(basename "$file") missing"
  fi
done

echo ""

# ─── Test 7: Bootstrap phases are executable-compatible ───
echo "▶ Phase scripts have set -e"

for file in "$HOME/.config/yadm/phases"/*.sh; do
  if [ -f "$file" ]; then
    if grep -q "^set -e" "$file"; then
      pass "$(basename "$file") has set -e"
    else
      fail "$(basename "$file") missing set -e"
    fi
  fi
done

echo ""

# ─── Test 8: No common mistakes ───
echo "▶ Common mistake detection"

# Check for the old .Brewfile bug
if grep -r "\.Brewfile" "$HOME/.config/yadm/" 2>/dev/null; then
  fail "Found reference to .Brewfile (should be Brewfile)"
else
  pass "No .Brewfile references"
fi

# Check for deprecated Homebrew taps
if [ -f "$BREWFILE" ] && grep -qE 'tap "homebrew/(core|cask|bundle)"' "$BREWFILE" 2>/dev/null; then
  fail "Brewfile contains deprecated default taps"
else
  pass "No deprecated taps in Brewfile"
fi

# Check for hardcoded /opt/homebrew without fallback in bootstrap scripts
for file in "$HOME/.config/yadm/phases"/*.sh "$HOME/.config/yadm/bootstrap"; do
  if [ -f "$file" ] && grep -q '/opt/homebrew' "$file" && ! grep -q '/usr/local' "$file"; then
    fail "$(basename "$file") hardcodes /opt/homebrew without Intel fallback"
  fi
done
pass "Bootstrap scripts support both Apple Silicon and Intel"

echo ""

# ─── Summary ───
echo "═══════════════════════════════════════"
TOTAL=$((PASS + FAIL))
printf "  Results: ${GREEN}%d passed${NC}, ${RED}%d failed${NC} (out of %d)\n" "$PASS" "$FAIL" "$TOTAL"
echo "═══════════════════════════════════════"
echo ""

# Exit with failure if any tests failed
[ "$FAIL" -eq 0 ]
