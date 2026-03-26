# ───── Prompt ─────
autoload -Uz colors && colors

# Autoload zsh's `add-zsh-hook` and `vcs_info` functions
autoload -Uz add-zsh-hook vcs_info

# Set prompt substitution so we can use the vcs_info_message variable
setopt prompt_subst

# Run the `vcs_info` hook to grab git info before displaying the prompt
add-zsh-hook precmd vcs_info

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
