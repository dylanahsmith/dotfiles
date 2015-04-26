[ -z "$PS1" ] && return

PATH="/usr/local/bin"
PATH="$PATH:/usr/local/sbin"
PATH="$PATH:/usr/bin"
PATH="$PATH:/usr/sbin"
PATH="$PATH:/bin"
PATH="$PATH:/sbin"
[ -d '/opt/X11/bin' ] && PATH="$PATH:/opt/X11/bin"
[ -d '/usr/X11/bin' ] && PATH="$PATH:/usr/X11/bin"
[ -d '/usr/local/share/npm/bin' ] && PATH="$PATH:/usr/local/share/npm/bin"
[ -d '/usr/games' ] && PATH="$PATH:/usr/games"
. ~/.bash.d/rbenv.sh
PATH="$HOME/bin:$PATH"
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

# More readable colors for man pages.
if [ "$TERM" = "xterm" -o -n "$COLORTERM" ]; then
    export LESS_TERMCAP_mb=$'\E[01;31m'
    export LESS_TERMCAP_md=$'\E[01;37m'
    export LESS_TERMCAP_me=$'\E[0m'
    export LESS_TERMCAP_se=$'\E[0m'
    export LESS_TERMCAP_so=$'\E[01;44;33m'
    export LESS_TERMCAP_ue=$'\E[0m'
    export LESS_TERMCAP_us=$'\E[01;33m'
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

export PYTHONSTARTUP=$HOME/.pythonrc.py
export NODE_PATH='/usr/local/lib/node_modules'

if type ruby >/dev/null 2>&1; then
  chr() { ruby -e 'puts ARGV.map{|x|Integer(x)}.pack("U*")' "$@"; }
  hex() { ruby -e 'puts ARGV.map{ |x| "0x" + Integer(x).to_s(16) }' "$@"; }
  dec() { ruby -e 'puts ARGV.map{ |x| Integer(x).to_s }' "$@"; }
  float() { ruby -e 'puts ARGV.map{ |x| Float(x).to_s }' "$@"; }
else
  alias hex='printf 0x%x\\n'
  alias dec='printf %d\\n'
  alias float='printf %f\\b'
fi

pycalc() { python -c "print $*"; }

hexdiff() {
    if [ $# -ne 2 ]; then
        echo "Usage: hexdiff FILE1 FILE2" 1>&2
        return 1
    fi
    diff -u <(xxd "$1") <(xxd "$2")
}

alias diff='diff -up'
if [ -x ~/bin/vim ]; then
  alias vim=~/bin/vim
  alias vi=~/bin/vim
  export EDITOR=$HOME/bin/vim
else
  export EDITOR=vim
fi
export GIT_EDITOR=$EDITOR

alias be='bundle exec'

bto() {
  output=`bundle show "$@"`
  if [ $? -eq 0 ]; then
      cd "$output"
  else
      echo "$output" 2>&1
  fi
}

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

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
[ -f /etc/bash_completion ] && . /etc/bash_completion

platform=`uname -s`
[ -f "$HOME/.bash.d/${platform}.sh" ] && . "$HOME/.bash.d/${platform}.sh"
unset platform

. ~/.bash.d/to.sh
. ~/.bash.d/prompt.sh
. ~/.bash.d/rubyopt.sh
. ~/.bash.d/python.sh
[ -f "$HOME/.bash.d/local.sh" ] && . ~/.bash.d/local.sh
true
