rubyv() {
  local ruby_version="$1"
  if [ -z "$ruby_version" ]; then
    echo "usage: rubyv VERSION [ruby_argument ...]"
    return 1
  fi
  shift
  (chruby "${ruby_version}" && ruby "$@")
}

lldb_ruby() {
  lldb -O 'command script import ~/.lldb/ruby.py' "$@"
}

rb_backtrace() {
  local pid="$1"
  if [ $# -eq 0 ]; then
    echo "usage: rb_backtrace PID"
    return 1
  fi
  lldb -p $pid -O 'command script import ~/.lldb/ruby.py' -o rb_backtrace --batch
}

alias rubydir='ruby -w -e "puts ARGV.flat_map{ |d| Dir[d] }"'

alias be='bundle exec'

# Useful for renaming rails migrations to re-run them
alias migrate-date='date -u "+%Y%m%d%H%M%S"'
