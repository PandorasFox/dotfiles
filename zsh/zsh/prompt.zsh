# Prompt goodies
function check_last_exit_code() {
	if [[ $LAST_EXIT_CODE -ne 0 ]]; then
		local EXIT_CODE_PROMPT=''
		EXIT_CODE_PROMPT+="%F{$ACCENT}[%f%B%F{$ACCENT}$LAST_EXIT_CODE%f%b%F{$ACCENT}]%f"
		echo "$EXIT_CODE_PROMPT"
	fi
}

function precmd() {
	export LAST_EXIT_CODE=$?
	local ZSH_CMD_TIME_STOP=$SECONDS
	echo -en "\e]2;zsh\a"
	if [[ "$ZSH_CMD_RUNNING" = "true" ]]; then
		export ZSH_CMD_TIME_ELAPSED=$((ZSH_CMD_TIME_STOP - ZSH_CMD_TIME_START))
	else
		export ZSH_CMD_TIME_ELAPSED=0
	fi
	if [[ $ZSH_CMD_TIME_ELAPSED -gt 120 ]]; then
		print -n "\a"
	fi
	export ZSH_CMD_RUNNING=false
}

function preexec() {
	echo -en "\e]2;$2\a"
	export ZSH_CMD_TIME_START=$SECONDS
	export ZSH_CMD_RUNNING=true
	export RPROMPT='%F{$ACCENT} $(vi_mode_prompt_info)   $(date "+%H:%M:%S")%f'
	export PROMPT_COMMAND="$PROMPT_COMMAND;echo -ne \"\033]0;\$(pwd) \007\""
}

function timer() {
	if [[ $ZSH_CMD_TIME_ELAPSED -gt 15 ]]; then
		local time_elapsed=$(printf '%dh:%02dm:%02ds\n' $(($ZSH_CMD_TIME_ELAPSED/3600)) $(($ZSH_CMD_TIME_ELAPSED%3600/60)) $(($ZSH_CMD_TIME_ELAPSED%60)))
		echo $time_elapsed
	fi
}

FG=255
ACCENT=36
if [[ $UID == 0 || $EUID == 0 ]]; then
  ACCENT=220
fi
#for i in {0..255} ; do
#    printf "\x1b[48;5;%sm%3d\e[0m " "$i" "$i"
#    if (( i == 15 )) || (( i > 15 )) && (( (i-15) % 6 == 0 )); then
#        printf "\n";
#    fi
#done

setopt prompt_subst
export PROMPT='%F{$ACCENT}┌%f%F{$FG}%n%f%F{$ACCENT}@%f%B%F{$FG}%M%f%b%F{$FG}-%f%F{$ACCENT}(%f%B%F{$FG}%~%f%b%F{$ACCENT}) %f $(check_last_exit_code) %F{$ACCENT}$(timer)%f
%F{$ACCENT}└> %f'
# Updates editor information when the keymap changes.
function zle-keymap-select() {
	zle reset-prompt
	zle -R
}
zle -N zle-keymap-select
function vi_mode_prompt_info() {
	echo "${${KEYMAP/vicmd/[% NORMAL]%}/(main|viins)/[% INSERT]%}"
}

export RPROMPT='%F{$ACCENT}$(vi_mode_prompt_info)'
