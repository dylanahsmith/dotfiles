alias ls='ls -G'
export LSCOLORS="ExGxFxDxCxegedabagacad"
alias ldd='otool -L'
alias open-ports='sudo lsof -iTCP -sTCP:LISTEN -P'

find() {
  if [ $# -eq 0 -o x"${1:0:1}" = x"-" ]; then
    command find . "$@"
  else
    command find "$@"
  fi
}

forward_port() {
  if [ $# -lt 3 ]; then
    sudo ipfw list $1
  elif [ $# -eq 3 ]; then
    number=$1
    source_port=$2
    dest_port=$3
    sudo ipfw add "$number" fwd "127.0.0.1,$dest_port" tcp from any to me dst-port "$source_port"
  else
    echo "usage: $0 RULE_NUM PORT"
  fi
}

function brew_relaunch() {
  launchctl_file="/Library/LaunchDaemons/dev.$1.plist"
  if [ -z "$1" ]; then
    echo "usage: brew_relaunch PACKAGE" 1>&2
  elif [ -f "$launchctl_file" ]; then
    sudo launchctl unload "$launchctl_file"
    sudo launchctl load "$launchctl_file"
  else
    echo "$launchctl_file not found" 1>&2
  fi
}

alias chrome='"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"'
