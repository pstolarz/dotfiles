set nocompatible
set backspace=indent,eol,start
set notimeout
set background=dark

" no bell
set vb t_vb=

set listchars=tab:»\ ,space:·,eol:¬
"set listchars=tab:>-,trail:-,eol:$
set listchars+=extends:>,precedes:<

" soft-tab set to 4 spaces
set softtabstop=4 shiftwidth=4 expandtab

" no extra keybidings except ones defined in this script
mapclear
mapclear!

noremap <C-Up> <C-Y>
noremap <C-Down> <C-E>

" single line block moves
vnoremap <Leader>k @=":m '<-2\rgv"<CR>
vnoremap <Leader><Up> @=":m '<-2\rgv"<CR>
vnoremap <Leader>j @=":m '>+1\rgv"<CR>
vnoremap <Leader><Down> @=":m '>+1\rgv"<CR>

" no-magic search
nnoremap <Leader>/ /\V
nnoremap <Leader>? ?\V

nnoremap <Leader><Leader> :set wrapscan!<CR>:set wrapscan?<CR>
nnoremap <Leader>w :set wrap!<CR>:set wrap?<CR>

if has("extra_search")
  set incsearch
  set hlsearch
  nnoremap <Leader>n :noh<CR>
endif

if has("quickfix")
  " like <C-W><C-I> but in preview
  nnoremap <Leader><C-W><C-I> :ps <C-R><C-W><CR>
endif

if has("unix")
  language en_US.UTF-8
  let s:vim_rtp = '~/.vim'
else
  " windows settings
  set grepprg=grep\ -n
  language English
  let s:vim_rtp = $VIM.'/vimfiles'
endif

if has("mouse")
  set mouse=a
endif

set number
set showmode
if has("cmdline_info")
  set showcmd
endif

if has("folding")
  " syntax folding method
  set foldmethod=syntax
  set foldlevelstart=99
endif

if has("mksession")
  set sessionoptions+=unix,slash
  set viewoptions+=unix,slash
endif

if has("cindent")
  " fix default indents
  set cinoptions=:0,g0,t0,(s
  "set cinoptions+=N-s
endif

if has("insert_expand")
  set completeopt+=menuone,noinsert
endif

if has("eval")
  " <C-R> extensions: curent dir/file/full file path
  noremap! <C-R><C-E><C-W> <C-R>=getcwd()<CR>
  noremap! <C-R><C-E><C-F> <C-R>=expand("%")<CR>
  noremap! <C-R><C-E><C-P> <C-R>=expand("%:p")<CR>

  " selected block search
  vnoremap <Leader>* y:exe '/\V'.tr(escape(@","\\/\b\e\f\n\r\t"),"\b\e\f\n\r\t","befnrt")<CR>
  vnoremap <Leader># y:exe '?\V'.tr(escape(@","\\?\b\e\f\n\r\t"),"\b\e\f\n\r\t","befnrt")<CR>

  if has("statusline")
    set laststatus=2
    set statusline=%n>%<
    set statusline+=%F%m
    set statusline+=\ [%{&ft!=''?toupper(&ft):'?'}\ %{&ff}\ %{&enc}%{&fenc!=''&&\ &fenc!=&enc?'->'.&fenc:''}]
    set statusline+=%=\ L%l/%L\ C%c%V
    "set statusline+=\ [0x%{printf('%X',line2byte(line('.'))+col('.')-2)}]
    set statusline+=\ %P
  endif

  function s:SetTab(set, ...)
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

  command -nargs=* SetTab call s:SetTab("set", <f-args>)
  command -nargs=* SetTabLoc call s:SetTab("setl", <f-args>)
  command -range Trim <line1>,<line2>s/\s\+$//
  command TrimAll %Trim

  function ByteOff()
    let b:off = line2byte(line("."))+col(".")-2
    if (b:off >= 0)
      echo printf("Byte offset: %d, 0x%x", b:off, b:off)
    else
      echo "Byte offset: ?"
    endif
  endfunction

  " byte offset of char under the cursor
  nnoremap <Leader>o :call ByteOff()<CR>
endif

filetype plugin indent on

if has("syntax")
  set colorcolumn=80
  syntax on
endif

" :Man command support
runtime! ftplugin/man.vim
nnoremap <Leader>K :Man <C-R><C-W><CR>

" gtags plugin config
let g:Gtags_No_Auto_Jump = 1
nnoremap <Leader>] :Gtags <C-R><C-W><C-Left>

"
" vim-plug plugins go below
"
if has("eval")
  " util function to install vim-plug
  function InstallVimPlug()
    exe '!curl -fLo '.s:vim_rtp.'/autoload/plug.vim --create-dirs '.
      \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  endfunction

  " vim-plug is required; if not installed exit the script
  if strlen(globpath(&runtimepath, "autoload/plug.vim")) <= 0
    finish
  endif

  call plug#begin(s:vim_rtp.'/plugged')
    Plug 'pstolarz/vim-scripts'
"    Plug 'ycm-core/YouCompleteMe'
  call plug#end()
endif

" vim: set et ts=2 sw=2 sts=0:
