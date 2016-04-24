# Define some aliases
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias ......='cd ../../../../../'
alias h='history'
alias ll='ls -hl'
alias ls='ls --color=auto'

# Define some env vars
export EDITOR='vi'
export PS1='\w\$ '

export HISTFILE=/root/workbench/.bash_history
export HISTSIZE=32768
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignoredups

# Make some commands not show up in history
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

# Add the "root" folder to PATH to ease use of custom scripts
export PATH=$PATH:/root/toolbox

# Export paths to special folders for future-proof scripting
export TAAL_DATA_DIR=/root/data
export TAAL_SUPPLIES_DIR=/root/supplies
export TAAL_TOOLBOX_DIR=/root/scripts
export TAAL_WORKBENCH_DIR=/root/workbench
