# Define some aliases
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias ......='cd ../../../../../'
alias h='history'
alias ll='ls -ahl'
alias ls='ls --color=auto'

# Allow aliases to be sudo’ed
alias sudo='sudo '

# Define some env vars
export EDITOR='vi'
export PS1='\e[33;1m\u\e[0m:\w\$ '

# Larger bash history (allow 32³ entries; default is 500)
export HISTSIZE=32768
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignoredups

# Make some commands not show up in history
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

# Always enable colored `grep` output
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'

# Add the "scripts" folder to PATH to ease use of custom scripts
export PATH=$PATH:/home/taal/scripts

# Export paths to special folders
export DATA_DIR=/home/taal/data
export SCRIPTS_DIR=/home/taal/scripts
