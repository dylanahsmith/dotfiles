# only for when running interactively
case $- in
    *i*) ;;
      *) return;;
esac

if [ -d ~/.bashrc.d ]; then
       for rc in ~/.bashrc.d/*; do
               if [ -f "$rc" ]; then
                       . "$rc"
               fi
       done
       unset rc
fi

true
