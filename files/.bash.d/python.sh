if which virtualenvwrapper.sh > /dev/null 2>&1; then
  export WORKON_HOME=~/.virtualenvs
  . `which virtualenvwrapper.sh`
fi

calc() {
    python3 -c "print($*)"
}
