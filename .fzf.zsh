#!/usr/bin/env zsh

if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
fi

source <(fzf --zsh)

_fzf_comprun() {
    local command=$1; shift
    case "$command" in
        ls|cd)        rg -d . | fzf --preview 'tree -C {} | head -200' "$@";;
        *)            fzf "$@" ;;
    esac
}

_fzf_compgen_path() {
    fd --type f --strip-cwd-prefix --hidden --follow --exclude .git "$1"
}

_fzf_compgen_dir() {
   fd --type d --hidden --follow --exclude ".git" "$1"
}
