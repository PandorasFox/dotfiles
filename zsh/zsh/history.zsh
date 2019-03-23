# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
setopt sharehistory
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=$ZDOTDIR/.zsh_history
