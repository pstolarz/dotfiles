set background=light

" no bell
set vb t_vb=

set guioptions-=m
set guioptions-=tT
set guioptions-=a
set guioptions+=A

if has("unix")
  set guifont=Monospace\ 9
else
  " windows settings
  set guifont=Consolas:h9
endif

" vim: set et ts=2 sw=2 sts=0:
