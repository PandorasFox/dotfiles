local files=(
  history.zsh
  prompt.zsh
  completion.zsh
  aliases.zsh
  tmux.zsh
  keybinds.zsh
  ssh-agent.zsh
  env.zsh
)

#if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
#	exec sway
#fi

for i in $files; do
  if [[ -e $ZDOTDIR/$i ]]; then
    source $ZDOTDIR/$i
  fi
done
