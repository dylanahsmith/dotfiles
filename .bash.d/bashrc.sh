[ -z "$PS1" ] && return

PATH="$HOME/bin"
PATH="$PATH:/usr/local/bin"
PATH="$PATH:/usr/local/sbin"
PATH="$PATH:/usr/bin"
PATH="$PATH:/usr/sbin"
PATH="$PATH:/bin"
PATH="$PATH:/sbin"
PATH="$PATH:/opt/X11/bin"
[ -d '/opt/X11/bin' ] && PATH="$PATH:/opt/X11/bin"
[ -d '/usr/X11/bin' ] && PATH="$PATH:/usr/X11/bin"
[ -d '/usr/games' ] && PATH="$PATH:/usr/games"
export PATH

shopt -s histappend
HISTCONTROL=ignoredups:ignorespace
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s checkwinsize
export COLUMNS LINES

# less options
# -R   output color escape sequences
# -S   chop long lines
# -M   long prompt
export LESS="RSM"

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

export PYTHONSTARTUP=$HOME/.pythonrc.py
export NODE_PATH='/usr/local/lib/node_modules'

unichr() {
  python -c "print unichr($*)"
}

alias diff='diff -up'
alias hex='printf 0x%x\\n'
alias dec='printf %d\\n'
alias float='printf %f\\b'
if [ -x ~/bin/vim ]; then
  alias vim=~/bin/vim
  alias vi=~/bin/vim
  export EDITOR=$HOME/bin/vim
else
  export EDITOR=vim
fi
export GIT_EDITOR=$EDITOR

alias be='bundle exec'

to() { eval "$(to.rb "$@")"; }
_to() {
  COMPREPLY=( $(to.rb --complete "${COMP_WORDS[@]:1:$COMP_CWORD}") )
}
complete -F _to to

bto() { eval "$(bto.rb "$@")"; }

alias curl='curl -s -S'

es-request() {
  curl -sS -X"$1" "http://localhost:9200/$2" -d "$3" | jsonpretty
}
alias es-get='es-request GET'
alias es-put='es-request PUT'
alias es-post='es-request POST'
alias es-delete='es-request DELETE'
alias es-head='es-request HEAD'

gitrepo-url() {
  git config remote.origin.url | sed -En 's/^git(@|:\/\/)([a-zA-Z0-9.]+)(:|\/)(.+)\/(.+).git$/http:\/\/\2\/\4\/\5.git/p'
}

ghg() {
  open "$(gitrepo-url)"
}

# use colours
alias ri='ri -f ansi'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

platform=`uname -s`
[ -f "$HOME/.bash.d/${platform}.sh" ] && . "$HOME/.bash.d/${platform}.sh"
unset platform

. ~/.bash.d/prompt.sh
[ -f "$HOME/.bash.d/local.sh" ] && . ~/.bash.d/local.sh
. ~/.bash.d/rbenv.sh
