if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi

alias ls='ls -G'
export LSCOLORS="ExGxFxDxCxegedabagacad"
alias ldd='otool -L'

find() {
  if [ $# -eq 0 -o x"${1:0:1}" = x"-" ]; then
    command find . "$@"
  else
    command find "$@"
  fi
}
