#!/bin/sh
cat << 'EOF'

  TMUX CHEAT SHEET                          PREFIX: C-b  (or C-a)
  ──────────────────────────────────────────────────────────────

  PANES
    prefix + %          Split right (horizontal)
    prefix + "          Split down (vertical)
    prefix + x          Kill pane (confirm)
    prefix + z          Zoom / unzoom pane
    M-Left/Right/Up/Down  Navigate panes (no prefix)

  WINDOWS
    M-1 .. M-8          Select window 1-8
    M-9 / M-0           Last / first window
    M-[ / M-]           Previous / next window
    prefix + 9 / 0      Last / first window
    prefix + c          New window
    prefix + ,          Rename window
    prefix + &          Kill window

  SESSIONS
    prefix + d          Detach from session
    prefix + $          Rename session
    prefix + ( / )      Previous / next session
    prefix + s          List and switch sessions

  COPY MODE  (enter with prefix + [)
    v                   Begin selection
    C-v                 Toggle rectangle mode
    y                   Yank selection and exit

  UTILITIES
    prefix + y          Toggle sync-panes (type in all panes at once)
    prefix + m          Toggle mouse
    prefix + t          Toggle status bar
    prefix + r          Reload config
    prefix + ?          This help

  PLUGINS  (TPM)
    prefix + I          Install new plugins
    prefix + U          Update plugins

  ──────────────────────────────────────────────────────────────
  q to close

EOF
