[ -z "$PS1" ] && return

export PATH="$HOME/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/opt/X11/bin:/usr/X11/bin"

HISTCONTROL=ignoredups:ignorespace

shopt -s checkwinsize
export COLUMNS LINES

export LESS="RSM"
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
bto() { eval "$(bto.rb "$@")"; }

if { ! type jsonpretty && type ruby; } >/dev/null 2>&1; then
  jsonpretty() { ruby -rjson -e "puts JSON.pretty_generate(JSON.parse(STDIN.read))"; }
fi

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

platform=`uname -s`
[ -f "$HOME/.config.d/bash/${platform}.sh" ] && . "$HOME/.config.d/bash/${platform}.sh"
unset platform

. ~/.config.d/bash/prompt.sh
. ~/.config.d/bash/private.sh
. ~/.config.d/bash/rbenv.sh
