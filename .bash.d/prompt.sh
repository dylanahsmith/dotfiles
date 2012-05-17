if [ "$SSH_CONNECTION" != "" ]; then
    hostname_in_prompt="@\h"
fi

__cursor_column() {
  # See: http://stackoverflow.com/questions/2575037/how-to-get-the-cursor-position-in-bash
  exec < /dev/tty
  oldstty=$(stty -g)
  stty raw -echo min 0
  # u7 (User string #7) is "\e[6n" for xterm
  tput u7 > /dev/tty
  stty "$oldstty"

  local curcol
  read -s -d R curcol
  curcol="${curcol##*;}"
  echo -n "$curcol"
}

## These slow down a cd into a large repository
#GIT_PS1_SHOWDIRTYSTATE=1
#GIT_PS1_SHOWUNTRACKEDFILES=1
#GIT_PS1_SHOWUPSTREAM="auto"

__set_err() { return $1; }

normal="$(tput sgr0)"

# force_newline must preserve error status for error_in_prompt.
force_newline='$(
  err=$?
  [ "$(__cursor_column)" -eq 1 ] || printf "\[\e[01;31m\]\n\$"
  __set_err $err
)'

error_in_prompt='$(err=$?; [ $err -eq 0 ] || echo "\[\e[01;31m\]$err:")'
jobs_in_prompt='$(count=$(jobs -p | wc -w | tr -d " "); [ $count -le 0 ] || echo "\[\e[01;33m\]$count:")'
git_in_prompt='$(__git_ps1 "\[\e[1;30m\](%s)")'
if [ "$TERM" = screen ]; then
    screen_win_in_prompt='W$WINDOW:'
fi
PS1="\[\e]0;\w\a\]\[$normal\]${force_newline}${error_in_prompt}${jobs_in_prompt}\[$normal\]${screen_win_in_prompt}\[\e[1;32m\]\u${hostname_in_prompt}\[$normal\]:\[\e[1;34m\]\w$git_in_prompt\[$normal\]\$ "
unset force_newline error_in_prompt jobs_in_prompt \
      screen_win_in_prompt git_in_prompt hostname_in_prompt normal
