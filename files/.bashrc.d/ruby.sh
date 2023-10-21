# user install chruby with `PREFIX=$HOME/local make install`
if [ -s ~/local/share/chruby/ ]; then
  source ~/local/share/chruby/chruby.sh
  source ~/local/share/chruby/auto.sh
fi

# Useful for renaming rails migrations to re-run them
alias migrate-date='date -u "+%Y%m%d%H%M%S"'

lldb_ruby() {
  lldb -O 'command script import ~/.lldb/ruby.py' "$@"
}

rb_backtrace() {
  local pid="$1"
  if [ $# -eq 0 ]; then
    echo "usage: rb_backtrace PID"
    return 1
  fi
  lldb -p $pid -O 'command script import ~/.lldbinit.d/ruby.py' -o rb_backtrace --batch
}

alias ri='ri -f ansi'

gto() {
  output=`gem open -e echo "$*"`
  if [ $? -eq 0 ]; then
      cd "$output"
  else
      echo "$output" 2>&1
  fi
}

alias be='bundle exec'

bto() {
  output=`bundle info "$*" --path`
  if [ $? -eq 0 ]; then
      cd "$output"
  else
      echo "$output" 2>&1
  fi
}
