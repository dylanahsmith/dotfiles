if exists(':TagbarToggle')
  " Opening/Closing tag list on one tab will affect other tabs automatically
  autocmd TabLeave * let g:tarbar_onTabLeave = bufwinnr('__Tagbar__')
  autocmd TabEnter * if (g:tarbar_onTabLeave >= 0) != (bufwinnr('__Tagbar__') >= 0) | call tagbar#ToggleWindow() | endif

  nmap <leader>t :TagbarToggle<CR>
endif
