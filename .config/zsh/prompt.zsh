# ───── Prompt ─────
autoload -Uz colors && colors

# Autoload zsh's `add-zsh-hook` and `vcs_info` functions
autoload -Uz add-zsh-hook vcs_info

# Set prompt substitution so we can use the vcs_info_message variable
setopt prompt_subst

# Run the `vcs_info` hook to grab git info before displaying the prompt
add-zsh-hook precmd vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats '%b%u%c'
# Format when the repo is in an action (merge, rebase, etc)
# zstyle ':vcs_info:git*' actionformats '%F{14}⏱ %*%f'
zstyle ':vcs_info:git*' unstagedstr '*'
zstyle ':vcs_info:git*' stagedstr '+'
# This enables %u and %c (unstaged/staged changes) to work
zstyle ':vcs_info:*:*' check-for-changes true

# Prompt: <last two directory components> <Git info> <user indicator>
PROMPT=' %{$fg[cyan]%}%2~%f %F{blue}${vcs_info_msg_0_}%f %# '
RPROMPT='%F{8}⎇ %F{7}⏱ %*%f'

# Oh My Posh:
# eval "$(oh-my-posh init zsh)"
