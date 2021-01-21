export EDITOR=vim
export HISTCONTROL=ignoreboth  # uniq entries in history
export PATH=~/.local/bin:$PATH:/usr/local/bin
alias open=xdg-open

# show git repo status in prompt
source ~/.myconfig/git-prompt.sh
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(__git_ps1 " (%s)")$ '

# default formats for coreutils
export TIME_STYLE=long-iso  # https://www.gnu.org/software/coreutils/manual/html_node/Formatting-file-timestamps.html
export BLOCK_SIZE="'k"  # https://www.gnu.org/software/coreutils/manual/html_node/Block-size.html

# make mc exit to the current directory
alias mc='. /usr/share/mc/bin/mc-wrapper.sh'

# fixssh function to help with ssh agent forwarding when using tmux
fixssh() {
	eval $(tmux show-env    \
		|sed -n 's/^\(SSH_[^=]*\)=\(.*\)/export \1="\2"/p')
}

# if running tmux, keep a separate bash history for each pane
if [[ $TMUX ]]; then
	HISTDIR=~/.tmux/bash_history
	[[ -d $HISTDIR ]] || mkdir -m 700 $HISTDIR
	# Set history file based on tmux session and window number. Multiple panes in the same window
	# will share their history
	HISTFILE=$HISTDIR/`tmux display -pt "${TMUX_PANE}" '#{session_name}.#{window_index}'`
	# Append new history entries to the history file each time when showing the prompt.
	if [[ $PROMPT_COMMAND != *"history -a"* ]]; then
		PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
	fi
fi

# allow node to use more memory, see
# https://stackoverflow.com/questions/38558989/node-js-heap-out-of-memory
export NODE_OPTIONS=--max_old_space_size=4096

alias open='xdg-open'

# Search bash history of all tmux panes
hgrep() { grep "$1" ~/.tmux/bash_history/*; }
