# Not available in old version of bash (e.g. one preinstalled with MacOS)
shopt -s globstar 2> /dev/null || true

shopt -s histappend
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s checkwinsize
export COLUMNS LINES

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
[ -f /etc/bash_completion ] && . /etc/bash_completion

