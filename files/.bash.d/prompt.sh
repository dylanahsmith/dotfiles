if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    chroot_in_prompt="($(cat /etc/debian_chroot))"
fi

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

# From "Color Handling" section of terminfo(5):
#   COLOR   VALUE       RGB
#   black     0     0,  0,  0
#   red       1     max,0,  0
#   green     2     0,  max,0
#   yellow    3     max,max,0
#   blue      4     0,  0,  max
#   magenta   5     max,0,  max
#   cyan      6     0,  max,max
#   white     7     max,max,max
# For xterm "\e[1;3${i}m" = `tput bold; tput setaf $i`
normal="$(tput sgr0)"

# hangs on read if `tput u7` isn't supported by the terminal
if [ x"$(tput u7)" != x"" ]; then
  # force_newline must preserve error status for error_in_prompt.
  force_newline='$(
    err=$?
    [ "$(__cursor_column)" -eq 1 ] || printf "\[\e[01;31m\]\n\$"
    __set_err $err
  )'
fi

error_in_prompt='$(err=$?; [ $err -eq 0 ] || echo "\[\e[01;31m\]$err:")'
jobs_in_prompt='$(count=$(jobs -p | wc -w | tr -d " "); [ $count -le 0 ] || echo "\[\e[01;33m\]$count:")'
if type __git_ps1 > /dev/null 2>&1; then
    git_in_prompt='$(__git_ps1 "\[\e[1;30m\](%s)")'
fi
if [ "$TERM" != linux ]; then
    set_term_title='\[\e]0;${chroot_in_prompt}\w\a\]'
fi
if [ "$TERM" = screen ]; then
    screen_win_in_prompt="\[$normal\]W$WINDOW:"
fi

PS1="${set_term_title}\[$normal\]"
PS1="$PS1${force_newline}"
PS1="$PS1${error_in_prompt}"
PS1="$PS1${jobs_in_prompt}"
PS1="$PS1${screen_win_in_prompt}"
PS1="$PS1\[\e[1;32m\]\u${hostname_in_prompt}"
PS1="$PS1\[$normal\]:\[\e[1;34m\]\w"
PS1="$PS1${git_in_prompt}\[$normal\]\$ "

unset error_in_prompt \
      force_newline \
      git_in_prompt \
      hostname_in_prompt \
      jobs_in_prompt \
      normal \
      screen_win_in_prompt \
      set_term_title
