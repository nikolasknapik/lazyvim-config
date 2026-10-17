# Apple Terminal can erase RGB backgrounds using the profile background.
# Use the tested no-BCE entry only for Neovim in that terminal.
nvim() {
  if [[ "$TERM_PROGRAM" == "Apple_Terminal" && "$TERM" == "xterm-256color" && -z "$TMUX" ]]; then
    TERMINFO="$HOME/.config/nvim/terminal/terminfo" command nvim "$@"
  else
    command nvim "$@"
  fi
}
