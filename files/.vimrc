if filereadable(expand("~/.vim/autoload/pathogen.vim"))
  call pathogen#infect()
end
set nocompatible
set nomodeline
set backspace=indent,eol,start
set title
set number
set ruler
set showcmd
set background=dark

" Hide gui toolbar
set guioptions-=T

" case insenstive search for lowercase pattern
set ignorecase
set smartcase

set incsearch
set hlsearch
set display=lastline
set wildmode=longest,list,full
set wildmenu
set hidden

set tags=./tags,../tags,../../tags,../../../tags,../../../../tags,../../../../../tags,tags

vnoremap . :norm.<CR>
map Y y$
map Q gq
set formatprg=fmt

if has("syntax")
  syntax on
endif
if has("mouse")
  set mouse=a
endif

if exists(":function")
  function! GitGrep(...)
    let save = &grepprg
    set grepprg=git\ grep\ -n\ $*
    let s = 'grep'
    for i in a:000
      let s = s . ' ' . i
    endfor
    exe s
    let &grepprg = save
  endfunction
  if has("user_commands")
    command! -nargs=? G call GitGrep(<f-args>)
  endif
end

if has("user_commands")
  command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
                  \ | wincmd p | diffthis
  command! -nargs=1 UseSpaces set expandtab softtabstop=<args> shiftwidth=<args>
  command! -nargs=1 UseTabs set noexpandtab tabstop=<args> softtabstop=<args> shiftwidth=<args>
  command! -nargs=1 UseMixed set noexpandtab tabstop=8 softtabstop=<args> shiftwidth=<args>
  UseSpaces 4
  command! SudoSave execute 'w !sudo tee % > /dev/null'

  set list
  command! SpecialListChars execute 'set listchars=tab:»·,trail:·'
  command! BasicListChars execute 'set listchars=tab:>-,trail:-'
  SpecialListChars
  highlight SpecialKey ctermfg=Brown
  highlight PmenuSel cterm=bold ctermbg=3

  highlight MatchParen cterm=underline ctermbg=NONE
endif
if has("autocmd")
  filetype plugin indent on
else
  set autoindent
endif
if has("autocmd")
  if has("ruby")
    function SetTitle()
      ruby system("printf '\033];#{VIM::evaluate('expand("%:t")')}\a'")
    endfunction
    auto BufEnter * call SetTitle()
    auto BufFilePre * call SetTitle()
  endif
endif

" Change to the directory of the file being edited
command! Cdf execute 'cd ' . expand("%:h")

let mapleader = ","
set wildignore+=.git,node_modules

" Make vim faster
set synmaxcol=300
set ttyfast
set ttyscroll=3
set lazyredraw

command! Go !go run %
