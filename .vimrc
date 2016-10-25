set nocompatible
set backspace=indent,eol,start
set background=dark
set notimeout
set vb t_vb=

" no extra keybidings except ones defined in this script
mapclear
mapclear!

"noremap <C-Up> <C-Y>
"noremap <C-Down> <C-E>

vnoremap <Leader>k @=":m '<-2\rgv"<CR>
vnoremap <Leader><Up> @=":m '<-2\rgv"<CR>
vnoremap <Leader>j @=":m '>+1\rgv"<CR>
vnoremap <Leader><Down> @=":m '>+1\rgv"<CR>

if has("mouse")
  set mouse=a
endif

if has("extra_search")
  set incsearch
  set hlsearch
  noh
  nnoremap <Leader>n :noh<CR>
endif

set number
set showmode
if has("cmdline_info")
  set showcmd
endif

if has("statusline")
  set laststatus=2
  set statusline=%n>%<
  set statusline+=%F%m
  set statusline+=\ [%{&ft!=''?toupper(&ft):'?'}\ %{&ff}\ %{&enc}%{&fenc!=''&&\ &fenc!=&enc?'->'.&fenc:''}]
  set statusline+=%=\ L%l/%L\ C%c%V
  "set statusline+=\ [0x%{printf('%X',line2byte(line('.'))+col('.')-2)}]
  set statusline+=\ %P
endif

set path+=./inc,./include

if has("unix")
  language en_US.UTF-8
else
  language English
endif

set listchars=tab:»\ ,space:·,eol:¬
"set listchars=tab:>-,trail:-,eol:$
set listchars+=extends:>,precedes:<

" soft-tab set to 4 spaces
set sts=4 sw=4 et

if (has("eval"))
  function s:set_tab(set, ...)
    if (a:0 <= 0)
      echo "expandtab:".(&et?"space":"tab")." softtabstop:".&sts." shiftwidth:".&sw." tabstop:".&ts
      return
    endif

    if (a:1==?"s" || a:1==?"sp" || a:1==?"space")
      exe a:set." et"
    elseif (a:1==?"t" || a:1==?"tab")
      exe a:set." noet"
    endif

    if (a:0<=1)|return|endif
    exe a:set." sts=".a:2."|".a:set." sw=".a:2

    if (a:0<=2)|return|endif
    exe a:set." ts=".a:3
  endfunction

  command -nargs=* SetTab call s:set_tab("set", <f-args>)
  command -nargs=* SetTabLoc call s:set_tab("setl", <f-args>)
  command -range Trim <line1>,<line2>s/\s\+$//
  command TrimAll %Trim

  vnoremap <Leader>* y:exe '/\V'.tr(escape(@","\\/\b\e\f\n\r\t"),"\b\e\f\n\r\t","befnrt")<CR>
  vnoremap <Leader># y:exe '?\V'.tr(escape(@","\\?\b\e\f\n\r\t"),"\b\e\f\n\r\t","befnrt")<CR>
endif

filetype plugin indent on

if has("insert_expand")
  set completeopt+=noinsert
endif

if has("syntax")
  set colorcolumn=80
  syntax on
endif

" vim: set et ts=2 sw=2 sts=0:
