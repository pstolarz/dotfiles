if trim(execute('colorscheme')) ==# 'default'
  set background=light
endif

" no bell
set vb t_vb=

set guioptions-=m
set guioptions-=tT
set guioptions-=a
set guioptions+=A

if has('unix')
  set guifont=Monospace\ 10
else
  " windows settings
  set guifont=Consolas:h10
endif

if has('eval')
  nnoremap <Leader>F :call FontSizeChange(1)<CR>:set guifont<CR>
  nnoremap <Leader>f :call FontSizeChange(-1)<CR>:set guifont<CR>
endif

" vim: set et ts=2 sw=2 sts=0:
