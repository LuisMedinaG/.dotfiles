#!/bin/sh
#
# Phase 0: Backup — preserve existing dotfiles before yadm overwrites them.
#
# Creates a timestamped backup of any tracked file that already exists in $HOME.
# Only files that would be overwritten by `yadm checkout` are backed up.
#
# Run standalone:  sh "$(chezmoi source-path)/scripts/00-backup.sh"
#
set -eu

echo "═══ Phase 0: Backup ═══"

cd "$HOME" || exit 1

BACKUP_DIR="$HOME/.config/chezmoi-backup/$(date +%Y%m%d_%H%M%S)"

# Get list of files chezmoi would apply (or fallback to key files).
tracked_files=""
if command -v chezmoi >/dev/null 2>&1; then
  tracked_files="$(chezmoi managed 2>/dev/null || true)"
fi

# Fallback if chezmoi isn't initialised yet
if [ -z "$tracked_files" ]; then
  tracked_files=".zshenv .zshrc .zprofile .gitconfig .config/nvim/init.vim .config/tmux/tmux.conf"
fi

backed_up=0
for file in $tracked_files; do
  # Skip non-user files (CI, docs, tests, etc.)
  case "$file" in
    .github/*|tests/*|Dockerfile*|README*|CLAUDE*|WORK*|*.md) continue ;;
  esac

  src="$HOME/$file"
  if [ -f "$src" ] && [ -s "$src" ]; then
    dest="$BACKUP_DIR/$file"
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    backed_up=$((backed_up + 1))
  fi
done

if [ "$backed_up" -gt 0 ]; then
  echo "Backed up $backed_up file(s) to:"
  echo "  $BACKUP_DIR"
  echo ""
  echo "After bootstrap, review the backup and merge what you need into:"
  echo "  ~/.zshenv.local   (env vars, PATH — loaded by ALL shells)"
  echo "  ~/.zprofile.local (login-shell setup — version managers, etc.)"
  echo "  ~/.zshrc.local    (aliases, functions, interactive config)"
else
  echo "No existing files to back up."
fi

echo "✓ Phase 0 complete."
