# ───── Prompt ─────
autoload -Uz colors && colors

# Autoload zsh's `add-zsh-hook` and `vcs_info` functions
autoload -Uz add-zsh-hook vcs_info

# Set prompt substitution so we can use the vcs_info_message variable
setopt prompt_subst

# Guard: only call vcs_info when actually inside a git repo.
# Walk $PWD upward checking for .git — filesystem only, no subprocess.
# This avoids forking git on every prompt render when outside a repo
# (e.g. large NFS mounts, home dir, non-project dirs).
_in_git_repo() {
  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    # .git is a dir for normal repos, a file for worktrees
    [[ -d "$dir/.git" || -f "$dir/.git" ]] && return 0
    dir="${dir:h}"
  done
  return 1
}

_vcs_info_precmd() {
  if _in_git_repo; then
    vcs_info
  else
    vcs_info_msg_0_=""
  fi
}

add-zsh-hook precmd _vcs_info_precmd

zstyle ':vcs_info:*' enable git
# Distinct colors: branch (magenta), unstaged (yellow), staged (green)
zstyle ':vcs_info:git*' formats '%F{magenta}%b%F{yellow}%u%F{green}%c%f'
# Show current action during rebase, merge, cherry-pick, etc.
zstyle ':vcs_info:git*' actionformats '%F{magenta}%b%f %F{red}(%a)%f%F{yellow}%u%F{green}%c%f'
zstyle ':vcs_info:git*' unstagedstr '*'
zstyle ':vcs_info:git*' stagedstr '+'
# This enables %u and %c (unstaged/staged changes) to work
zstyle ':vcs_info:*:*' check-for-changes true

# Prompt: exit-status arrow, directory, git info
# ❯ is cyan on success, red on failure
PROMPT='%(?.%F{cyan}.%F{red})❯%f %F{blue}%2~%f ${vcs_info_msg_0_} '
RPROMPT='%F{8}%*%f'

# Oh My Posh:
# eval "$(oh-my-posh init zsh)"
