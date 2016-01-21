if type rbenv >/dev/null 2>&1; then
  if [ -x "$HOME/.rbenv/bin/rbenv" ]; then
    PATH="$HOME/.rbenv/bin:$PATH"
  fi
  eval "$(rbenv init --no-rehash -)"
fi
