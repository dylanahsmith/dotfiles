if [ -x "$HOME/.rbenv/bin/rbenv" ]; then
  PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init --no-rehash -)"
fi
