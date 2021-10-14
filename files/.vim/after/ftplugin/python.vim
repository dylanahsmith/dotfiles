" Vim filetype plugin file from Vim tip
" Language: Python
" URL: http://vim.wikia.com/wiki/Automatically_add_Python_paths_to_Vim_path

setlocal expandtab softtabstop=4 shiftwidth=4
setlocal suffixesadd=.py
setlocal keywordprg=pydoc

" FIXME: Handle `python` command not being available
"python << EOF
"import os
"import sys
"import vim
"for p in sys.path:
"    # Add each directory in sys.path, if it exists
"    if os.path.isdir(p):
"        # Command 'set' needs backslash before each space
"        vim.command(r"setlocal path+=%s" % (p.replace(" ", r"\ ")))
"EOF
