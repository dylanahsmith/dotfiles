platform_sh="$HOME/.bashrc.d/platform/$(uname -s).sh"
[ -f "$platform_sh" ] && . "$platform_sh"
unset platform_sh
