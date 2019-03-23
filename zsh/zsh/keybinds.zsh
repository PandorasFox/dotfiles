# vim bindings!
bindkey -v
export KEYTIMEOUT=1

zmodload zsh/complist
# shift-tab in completions
bindkey -M menuselect '^[[Z' reverse-menu-complete

# up/down history searching
autoload -U history-search-end

zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# Better searching in command mode
bindkey -M vicmd "k" history-beginning-search-backward-end
bindkey -M vicmd "j" history-beginning-search-forward-end

# Beginning search with arrow keys
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end
bindkey "^[OA" history-beginning-search-backward-end
bindkey "^[OB" history-beginning-search-forward-end

# ctrl-left-right
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

sudo-command-line() {
	[[ -z $BUFFER ]] && zle up-history
	if [[ $BUFFER == sudo\ * ]]; then
		LBUFFER="${LBUFFER#sudo }"
	elif [[ $BUFFER == $EDITOR\ * ]]; then
		LBUFFER="${LBUFFER#$EDITOR }"
		LBUFFER="sudoedit $LBUFFER"
	elif [[ $BUFFER == sudoedit\ * ]]; then
		LBUFFER="${LBUFFER#sudoedit }"
		LBUFFER="$EDITOR $LBUFFER"
	else
		LBUFFER="sudo $LBUFFER"
	fi
}
zle -N sudo-command-line
# Defined shortcut keys: [Esc] [Esc]
bindkey "^Z" sudo-command-line
bindkey -M vicmd 'S' sudo-command-line

# shift-tab in completions
# bindkey -M menuselect '^[[Z' reverse-menu-complete


