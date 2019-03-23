SSH_ENV=$HOME/.ssh/environment

function start_agent() {
	# start ssh-agent and setup environment
	ssh-agent -s | sed 's/^echo/#echo/' >! $SSH_ENV
	chmod 600 $SSH_ENV
	. $SSH_ENV > /dev/null

	# load identies
	echo "starting ssh-agent..."
	ssh-add $HOME/.ssh/id_rsa
}

if [ -f "$SSH_ENV" ]; then
	. $SSH_ENV > /dev/null
	ps $SSH_AGENT_PID | grep "ssh-agent -s$" >/dev/null || {
		start_agent;
	}
else
	start_agent;
fi
