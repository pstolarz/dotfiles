set nocompatible
set backspace=indent,eol,start
set notimeout
set background=dark
" no bell
set vb t_vb=

" no extra keybidings except ones defined in this script
mapclear
mapclear!

noremap <C-Up> <C-Y>
noremap <C-Down> <C-E>

nnoremap <Leader>/ :set wrapscan!<CR>:set wrapscan?<CR>
" no-magic search
nnoremap <Leader><Leader> /\V

" single line block moves
vnoremap <Leader>k @=":m '<-2\rgv"<CR>
vnoremap <Leader><Up> @=":m '<-2\rgv"<CR>
vnoremap <Leader>j @=":m '>+1\rgv"<CR>
vnoremap <Leader><Down> @=":m '>+1\rgv"<CR>

" <C-R> extensions: curent dir/file/full file path
noremap! <C-R><C-E><C-W> <C-R>=getcwd()<CR>
noremap! <C-R><C-E><C-F> <C-R>=expand("%")<CR>
noremap! <C-R><C-E><C-P> <C-R>=expand("%:p")<CR>

if has("mouse")
  set mouse=a
endif

if has("quickfix")
  " like <C-W><C-I> but in preview
  nnoremap <Leader><C-W><C-I> :ps <C-R><C-W><CR>
endif

if has("extra_search")
  set incsearch
  set hlsearch
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

if has("unix")
  language en_US.UTF-8
else
  language English
endif

set listchars=tab:»\ ,space:·,eol:¬
"set listchars=tab:>-,trail:-,eol:$
set listchars+=extends:>,precedes:<

" soft-tab set to 4 spaces
set softtabstop=4 shiftwidth=4 expandtab

if has("eval")
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

  " selected block search
  vnoremap <Leader>* y:exe '/\V'.tr(escape(@","\\/\b\e\f\n\r\t"),"\b\e\f\n\r\t","befnrt")<CR>
  vnoremap <Leader># y:exe '?\V'.tr(escape(@","\\?\b\e\f\n\r\t"),"\b\e\f\n\r\t","befnrt")<CR>
endif

if has("cindent")
  " fix default indents
  set cinoptions=:0,g0,t0,(s
  "set cinoptions+=N-s
endif

filetype plugin indent on

if has("insert_expand")
  set completeopt+=noinsert
endif

if has("syntax")
  set colorcolumn=80
  syntax on
endif

" :Man command support
runtime! ftplugin/man.vim
nnoremap <Leader>K :Man <C-R><C-W><CR>

" vim: set et ts=2 sw=2 sts=0:
