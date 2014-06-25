alias ls='ls -G'
export LSCOLORS="ExGxFxDxCxegedabagacad"
alias ldd='otool -L'
alias open-ports='sudo lsof -iTCP -sTCP:LISTEN -P'
alias stat='stat -x'

find() {
  if [ $# -eq 0 -o x"${1:0:1}" = x"-" ]; then
    command find . "$@"
  else
    command find "$@"
  fi
}
