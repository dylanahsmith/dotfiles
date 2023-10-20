[ -z "$PS1" ] && return

[ -d '/usr/local/share/npm/bin' ] && PATH="$PATH:/usr/local/share/npm/bin"
PATH="$HOME/bin:$PATH"
export PATH

# Not available in old version of bash (e.g. one preinstalled with MacOS)
shopt -s globstar 2> /dev/null || true

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

hexdiff() {
    if [ $# -ne 2 ]; then
        echo "Usage: hexdiff FILE1 FILE2" 1>&2
        return 1
    fi
    diff -u <(xxd "$1") <(xxd "$2")
}

alias diff='diff -up'

alias vi='vim'
export EDITOR=vim
export GIT_EDITOR=$EDITOR

if type rlwrap >/dev/null 2>&1; then
  alias d8='rlwrap d8'
fi

alias devgo="$HOME/src/go/bin/go"

gto() {
  output=`gem open -e echo "$*"`
  if [ $? -eq 0 ]; then
      cd "$output"
  else
      echo "$output" 2>&1
  fi
}

bto() {
  output=`bundle info "$*" --path`
  if [ $? -eq 0 ]; then
      cd "$output"
  else
      echo "$output" 2>&1
  fi
}

alias curl='curl -s -S'

gitrepo-url() {
  git config remote.origin.url | sed -En 's/^(git|https)(@|:\/\/)([a-zA-Z0-9.]+)(:|\/)(.+)\/(.+).git$/https:\/\/\3\/\5\/\6/p'
}

ghopen() {
  open "$(gitrepo-url)"
}

ghpr() {
  local branch_name=`git rev-parse --abbrev-ref ${1:-HEAD}`
  if [[ `git config remote.origin.url` == https* && `git config remote.dylan.url` == git* ]]; then
    branch_name="dylanahsmith:$branch_name"
  fi
  open "$(gitrepo-url)/compare/$branch_name"
}

ghcommit() {
  open "$(gitrepo-url)/commit/$1"
}

ghfetchpr() {
  git fetch origin "pull/$1/head:pull-$1"
}

ghclone() {
  git clone "git@github.com:$1.git"
}

ghaddremote() {
  local repo_name=`git config remote.origin.url | sed -En 's/^git@github\.com:.+\/(.+).git$/\1/p'`
  git remote add -f "$1" "https://github.com/$1/$repo_name.git"
}

ghcheckoutpr() {
  git fetch origin "pull/$1/head:pull-$1" && git checkout "pull-$1"
}

git-del-squash-merged() {
  if [ $# -eq 0 ]; then
    local orig_branch=`git branch --show-current`
    local main_branch=`git branch --list master main | cut -c 3- | head -1`
    if [ -n "$orig_branch" -a "$orig_branch" != "$main_branch" -a "$orig_branch" != main ]; then
      git rebase -q origin && git checkout -q "$main_branch" && git rebase -q origin && git branch -d "$orig_branch"
    else
      echo "Must be used on a non-main branch" 1>&2
      false
    fi
  else
    local branch
    for branch in "$@"; do
      git checkout -q "$branch" && git rebase -q origin && git checkout -q - && git branch -d "$branch"
    done
  fi
}

# use colours
alias ri='ri -f ansi'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# rustup shell setup
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
[ -f /etc/bash_completion ] && . /etc/bash_completion

platform=`uname -s`
[ -f "$HOME/.bashrc.d/${platform}.sh" ] && . "$HOME/.bashrc.d/${platform}.sh"
unset platform

. ~/.bashrc.d/to.sh
. ~/.bashrc.d/ruby.sh
. ~/.bashrc.d/android.sh
. ~/.bashrc.d/python.sh
[ -f "$HOME/.bashrc.d/local.sh" ] && . ~/.bashrc.d/local.sh
. ~/.bashrc.d/prompt.sh
true
