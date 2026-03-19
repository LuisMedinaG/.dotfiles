#!/bin/sh
#
# Test runner — validates dotfiles without installing anything.
#
# Run locally:   sh tests/run_all.sh
# Run in Docker: docker build -t dotfiles-test -f Dockerfile.test . && docker run --rm dotfiles-test
#
set -eu

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
  # Check root zsh files + all .zsh files under ~/.zsh/
  for file in "$HOME/.zshenv" "$HOME/.zshrc" "$HOME/.zprofile"; do
    if [ -f "$file" ]; then
      if $ZSH_BIN -n "$file" 2>/dev/null; then
        pass "$(basename "$file")"
      else
        fail "$(basename "$file") — syntax error"
      fi
    fi
  done
  find "$HOME/.zsh" -name '*.zsh' -type f 2>/dev/null | sort | while read -r file; do
    if $ZSH_BIN -n "$file" 2>/dev/null; then
      pass "$(basename "$file")"
    else
      fail "$(basename "$file") — syntax error"
    fi
  done
else
  warn "zsh not found, skipping syntax checks"
fi

echo ""

# ─── Test 2: Script syntax check (auto-detect shebang) ───
# Collects all scripts, checks sh scripts with sh -n, bash scripts with bash -n
SH_SCRIPTS=""
BASH_SCRIPTS=""

for file in \
  "$HOME/.config/yadm/bootstrap" \
  "$HOME/.config/yadm/phases"/*.sh \
  "$HOME/.local/bin"/*
do
  [ -f "$file" ] || continue
  shebang=$(head -1 "$file" 2>/dev/null)
  case "$shebang" in
    *bash*) BASH_SCRIPTS="$BASH_SCRIPTS $file" ;;
    *sh*)   SH_SCRIPTS="$SH_SCRIPTS $file" ;;
  esac
done

echo "▶ Shell script syntax check (sh -n)"
for file in $SH_SCRIPTS; do
  if sh -n "$file" 2>/dev/null; then
    pass "$(basename "$file")"
  else
    fail "$(basename "$file") — syntax error"
  fi
done

echo ""
echo "▶ Bash script syntax check (bash -n)"
for file in $BASH_SCRIPTS; do
  if bash -n "$file" 2>/dev/null; then
    pass "$(basename "$file")"
  else
    fail "$(basename "$file") — syntax error"
  fi
done

echo ""

# ─── Test 3: ShellCheck (if available) ───
echo "▶ ShellCheck (static analysis)"

if command -v shellcheck >/dev/null 2>&1; then
  # SC1091: Can't follow sourced files (expected in dotfiles)
  # SC2312: Consider invoking separately to check exit status
  for file in $SH_SCRIPTS $BASH_SCRIPTS; do
    if shellcheck --exclude=SC1091,SC2312 --severity=warning "$file" 2>/dev/null; then
      pass "$(basename "$file")"
    else
      fail "$(basename "$file") — shellcheck warnings"
    fi
  done
else
  warn "shellcheck not installed, skipping (brew install shellcheck)"
fi

echo ""

# ─── Test 4: Brewfile syntax ───
echo "▶ Brewfile validation"

for brewfile in "$HOME/.config/brew"/Brewfile*; do
  [ -f "$brewfile" ] || continue
  INVALID_LINES=$(grep -nvE '^\s*(#|$|tap |brew |cask |mas |vscode |whalebrew )' "$brewfile" 2>/dev/null || true)
  if [ -z "$INVALID_LINES" ]; then
    pass "$(basename "$brewfile") syntax valid"
  else
    fail "$(basename "$brewfile") has invalid lines:"
    echo "$INVALID_LINES" | head -5
  fi
done

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
echo "▶ Phase scripts have set -eu"

for file in "$HOME/.config/yadm/phases"/*.sh; do
  if [ -f "$file" ]; then
    if grep -q "^set -eu" "$file"; then
      pass "$(basename "$file") has set -eu"
    else
      fail "$(basename "$file") missing set -eu"
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

# Check for deprecated Homebrew taps in all Brewfiles
DEPRECATED_TAPS=false
for brewfile in "$HOME/.config/brew"/Brewfile*; do
  [ -f "$brewfile" ] || continue
  if grep -qE 'tap "homebrew/(core|cask|bundle)"' "$brewfile" 2>/dev/null; then
    fail "$(basename "$brewfile") contains deprecated default taps"
    DEPRECATED_TAPS=true
  fi
done
if [ "$DEPRECATED_TAPS" = false ]; then
  pass "No deprecated taps in Brewfiles"
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
