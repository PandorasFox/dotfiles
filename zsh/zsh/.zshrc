local files=(
  $ZDOTDIR/history.zsh
  $ZDOTDIR/prompt.zsh
  $ZDOTDIR/completion.zsh
  $ZDOTDIR/aliases.zsh
  $ZDOTDIR/tmux.zsh
  $ZDOTDIR/keybinds.zsh
  $ZDOTDIR/ssh-agent.zsh
)

for i in $files; do
  if [[ -e $i ]]; then
    source $i
  fi
done
