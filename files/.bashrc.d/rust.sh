if [ -s "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

cargo-to() {
  local path=$(cargo-to.rb "$@")
  if [ $? -eq 0 ]; then
    cd "$path"
  fi
}
