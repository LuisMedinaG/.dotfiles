# +---------+
# | General |
# +---------+

# Load completions
[ -n "$BREW_COMPLETIONS_PATH" ] && fpath=($BREW_COMPLETIONS_PATH $fpath)
zmodload zsh/complist

# zsh-abbr is loaded via Zinit in plugins/init.zsh (works on macOS + Linux)

# ───── Optimized Completion System Init ─────
autoload -U compinit

# Define zcompdump file location
zcompdump_file="${ZDOTDIR:-$HOME}/.zcompdump"

# shell-safety.COMPLETION.1
if [[ -f "$zcompdump_file" && -z "$zcompdump_file"(#qN.mh-24) ]]; then
  compinit -i -d "$zcompdump_file" -D && compdump
else
  compinit -i -d "$zcompdump_file"
fi
unset zcompdump_file
_comp_options+=(globdots) # With hidden files

# +---------+
# | Options |
# +---------+

setopt GLOB_COMPLETE    # Show autocompletion menu with globs
setopt MENU_COMPLETE    # Automatically highlight first element of completion menu
setopt AUTO_LIST        # Automatically list choices on ambiguous completion.
setopt COMPLETE_IN_WORD # Complete from both ends of a word.

# Use hjlk in menu selection (during completion)
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect '^xu' undo # Undo

# +---------+
# | zstyles |
# +---------+

# Ztyle pattern
# :completion:<function>:<completer>:<command>:<argument>:<tag>

# Define completers
zstyle ':completion:*' completer _extensions _complete _approximate

# Use cache for commands using cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.cache/zsh/zcompcache"

zle -C alias-expansion complete-word _generic
bindkey '^Xa' alias-expansion
zstyle ':completion:alias-expansion:*' completer _expand_alias



# Allow you to select in a menu (overridden by fzf-tab below when loaded)
zstyle ':completion:*' menu select

# Autocomplete options for cd instead of directory stack
zstyle ':completion:*' complete-options true

zstyle ':completion:*' file-sort modification

# Formatting
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %d --%f'
zstyle ':completion:*:*:*:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'

# Only display some tags for the command cd
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories


# Case-insensitive matching (important feature)
# See ZSHCOMPWID "completion matching control"
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*' keep-prefix true

# ------------------------------------
# fzf-tab plugin configuration
# Only override menu if fzf-tab will actually be loaded
# ------------------------------------

# These settings are safe regardless of fzf-tab
zstyle ':completion:*:git-checkout:*' sort false
zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"
zstyle ":completion:*:descriptions" format "[%d]"

# fzf-tab zstyles are applied in plugins/init.zsh after Zinit loads fzf-tab



# fzf-tab preview zstyles live in plugins/init.zsh (after fzf-tab is loaded)

# shell-safety.COMPLETION.2
_ssh_completion_hosts() {
  {
    command cat ~/.ssh/config ~/.ssh/config-*(N) /etc/ssh/ssh_config 2>/dev/null |
      command awk '
        tolower($0) ~ /^[[:space:]]*host([[:space:]]|=)/ {
          sub(/^[[:space:]]*[^[:space:]=]+[[:space:]]*=?[[:space:]]*/, "")
          sub(/#.*/, "")
          for (i = 1; i <= NF; i++) {
            gsub(/^"|"$/, "", $i)
            if ($i !~ /[?*!]/ && $i != "") print $i
          }
        }'

    command cat ~/.ssh/known_hosts /etc/ssh/ssh_known_hosts 2>/dev/null |
      command awk '
        NF && $1 !~ /^[#@|]/ {
          n = split($1, hosts, ",")
          for (i = 1; i <= n; i++) {
            host = hosts[i]
            if (host ~ /^\[.*\]:[0-9]+$/) {
              sub(/^\[/, "", host)
              sub(/\]:[0-9]+$/, "", host)
            }
            if (host !~ /[?*!\[\]]/ && host != "") print host
          }
        }'

    command awk '{ sub(/#.*/, ""); for (i = 2; i <= NF; i++) print $i }' /etc/hosts
  } | command sort -u
}

zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${(f)"$(_ssh_completion_hosts)"})'
