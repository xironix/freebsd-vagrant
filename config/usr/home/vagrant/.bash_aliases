# Modified Commands
alias diff='colordiff'              # requires colordiff package
alias grep='grep --color=auto'
alias more='less'
alias df='df -h'
alias du='du -c -h'
alias mkdir='mkdir -p'
alias ..='cd ..'

# new commands
alias da='date "+%A, %B %d, %Y [%T]"'
alias du1='du --max-depth=1'
alias hist='history | grep'         # requires an argument
alias openports='ss --all --numeric --processes --ipv4 --ipv6'
alias pg='ps -Af | grep $1'         # requires an argument

# privileged access
if [ $UID -ne 0 ]; then
  alias sudo='sudo '
  alias sr='sudo su - root'
  alias scat='sudo cat'
  alias svim='sudo vim'
  alias root='sudo su'
  alias reboot='sudo systemctl reboot'
  alias poweroff='sudo systemctl poweroff'
fi

# ls
alias ls='ls -hFG'
alias lr='ls -R'      # recursive ls
alias ll='ls -l'
alias la='ll -A'
alias lx='ll -BX'     # sort by extension
alias lz='ll -rS'     # sort by size
alias lt='ll -rt'     # sort by date
alias lm='la | more'

# safety features
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -I'                    # 'rm -i' prompts for every file
alias ln='ln -i'

# We want vim!
alias vi='vim -p'

# Portsnap
alias psu='portsnap fetch ; portsnap update'

# Portmaster
alias pm='portmaster -BCD'
alias pmu='portmaster -BCDa'

# System Sources
alias ssf='svn co http://svn0.us-east.freebsd.org/base/release/9.1.0/ /usr/src'
alias ssu='svn update /usr/src'

