source $VIMRUNTIME/defaults.vim

scriptencoding utf-8
set encoding=utf-8

set nomodeline
set title
set number
set background=dark
set noswapfile

" Hide gui toolbar
set guioptions-=T

" case insenstive search for lowercase pattern
set ignorecase
set smartcase

set hlsearch
set display=lastline
set wildmode=longest,list,full
set hidden

set tags=./tags,../tags,../../tags,../../../tags,../../../../tags,../../../../../tags,tags

vnoremap . :norm.<CR>
map Y y$
set formatprg=fmt

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
  command! -nargs=1 UseSpaces set expandtab softtabstop=<args> shiftwidth=<args>
  command! -nargs=1 UseTabs set noexpandtab tabstop=<args> softtabstop=<args> shiftwidth=<args>
  command! -nargs=1 UseMixed set noexpandtab tabstop=8 softtabstop=<args> shiftwidth=<args>
  UseSpaces 2
  command! SudoSave execute 'w !sudo tee % > /dev/null'

  set list
  command! SpecialListChars execute 'set listchars=tab:»·,trail:·'
  command! BasicListChars execute 'set listchars=tab:>-,trail:-'
  SpecialListChars
  highlight SpecialKey ctermfg=Brown
  highlight PmenuSel cterm=bold ctermbg=3

  highlight MatchParen cterm=underline ctermbg=NONE
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

let g:ruby_indent_assignment_style = 'variable'

" Avoid automatically running untrusted code so vim
" can be used to review that code
if getcwd() =~ "untrusted" || getcwd() =~? "downloads"
  let g:lsp_auto_enable = 0
else
  if executable('rust-analyzer')
    au User lsp_setup call lsp#register_server({
          \   'name': 'Rust Language Server',
          \   'cmd': {server_info->['rust-analyzer']},
          \   'whitelist': ['rust'],
          \ })
  endif

  if executable('clangd')
    au User lsp_setup call lsp#register_server({
          \   'name': 'clangd',
          \   'cmd': {server_info->['clangd']},
          \   'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
          \ })
  endif
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-b> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
