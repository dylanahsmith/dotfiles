[ -z "$PS1" ] && return

if [ -d ~/.bashrc.d ]; then
       for rc in ~/.bashrc.d/*; do
               if [ -f "$rc" ]; then
                       . "$rc"
               fi
       done
       unset rc
fi

true
