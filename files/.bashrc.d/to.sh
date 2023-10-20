to() { eval "$(to.rb "$@")"; }
_to() {
  COMPREPLY=( $(to.rb --complete "${COMP_WORDS[@]:1:$COMP_CWORD}") )
}
complete -F _to to
