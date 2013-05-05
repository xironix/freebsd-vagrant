# Paths
if [[ $EUID -ne 0 ]]; then
  export PATH=$(ruby -rubygems -e "puts Gem.user_dir")/bin:$PATH
  export GEM_HOME=$(ruby -rubygems -e "puts Gem.user_dir")
fi

# Default Editor
export EDITOR="vim"
export PAGER="less"

# Specific settings depending on whether you're root or not
if [[ $EUID -eq 0 ]]; then
  USER_INFO="\[\033[1;31m\]\u\[\033[1;37m\]@\[\033[1;31m\]\h"
else
  USER_INFO="\[\033[1;32m\]\u\[\033[1;37m\]@\[\033[1;32m\]\h"
fi

CON_INFO="\[\033[1;34m\]\$(/usr/bin/tty | sed -e 's:/dev/::')"
FILES_INFO="\[\033[1;36m\]\$(ls -1 | wc -l | sed 's: ::g') files"
SIZE_INFO="\[\033[1;33m\]\$(ls -lah | grep -m 1 total | sed 's/total //')b"
DIR_INFO="\[\033[0;34m\]\w"
PROMPT="\[\033[1;36m\] $ \[\033[0m\]"

PS1="\n${USER_INFO}\[\033[1;37m\] :: ${CON_INFO}\[\033[1;37m\] :: ${FILES_INFO} ${SIZE_INFO}\n${DIR_INFO}${PROMPT}"

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=1000
export HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Bash regular expression support
shopt -s extglob

# Manual compilation
export CFLAGS="-O2 -march=native -mtune=generic -pipe"
export CXXFLAG="${CFLAGS}"

# Alias definitions.
if [ -r ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# Enable programmable completion features
if [ -r /usr/local/share/bash-completion/bash_completion.sh ]; then
  . /usr/local/share/bash-completion/bash_completion.sh
fi

# Custom functions
if [ -r ~/.bash_functions ]; then
  . ~/.bash_functions
fi

