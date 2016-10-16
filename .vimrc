set nocompatible
set backspace=indent,eol,start
set background=dark
set vb t_vb=

if has("mouse")
  set mouse=a
endif

if has("extra_search")
  set incsearch
  set hlsearch
  noh
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
  set statusline+=\ [%Y\ %{&ff}\ %{&enc}%{&fenc!=''&&\ &fenc!=&enc?'->'.&fenc:''}]
  set statusline+=%=\ L%l/%L\ C%c%V
  "set statusline+=\ [0x%{printf('%X',line2byte(line('.'))+col('.')-2)}]
  set statusline+=\ %P
endif

if has("unix")
  language en_US.UTF-8
else
  language English
endif

" no extra keybidings except ones defined below
mapclear
mapclear!
"noremap <C-Up> <C-Y>
"noremap <C-Down> <C-E>

set listchars=tab:>-,trail:-,extends:>,precedes:<,eol:¬

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
