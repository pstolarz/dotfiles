set nocompatible
set backspace=indent,eol,start
set notimeout
set background=dark

" no bell
set vb t_vb=

set listchars=tab:»\ ,space:·,eol:¬
"set listchars=tab:>-,trail:-,eol:$
set listchars+=extends:>,precedes:<

" tab settings
set expandtab softtabstop=4 shiftwidth=4 tabstop=4

" no extra keybidings except ones defined in this script
mapclear
mapclear!

noremap <C-Up> <C-Y>
noremap <C-Down> <C-E>

" switch between buffers and tabs
nnoremap ]b :bnext<CR>
nnoremap [b :bprev<CR>
nnoremap ]t :tabnext<CR>
nnoremap [t :tabprev<CR>

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
nnoremap <Leader>l :set list!<CR>:set list?<CR>
nnoremap <Leader>p :pclose<CR>

" paste last change from . register
nnoremap <Leader>. ".P

if has('spell')
nnoremap <Leader>s :set spell!<CR>:set spell?<CR>
endif

if has('extra_search')
  set incsearch
  set hlsearch
  nnoremap <Leader>n :noh<CR>
endif

if has('quickfix')
  " like <C-W><C-I> but in preview
  nnoremap <Leader><C-W><C-I> :ps <C-R><C-W><CR>
endif

if has('unix')
  language en_US.UTF-8
else
  " windows settings
  set grepprg=grep\ -n
  language English
endif

if has('mouse')
  set mouse=a
endif

set number
set showmode
if has('cmdline_info')
  set showcmd
endif

if has('folding')
  " syntax folding method
  set foldmethod=syntax
  set foldlevelstart=99
endif

if has('mksession')
  set sessionoptions+=unix,slash
  set viewoptions+=unix,slash
endif

if has('cindent')
  " fix default indents
  set cinoptions=:0,g0,t0,(s
  "set cinoptions+=N-s
endif

if has('insert_expand')
set completeopt=preview,menuone
"set completeopt+=noinsert
endif

if has('wildmenu')
  set wildmenu
  set wildoptions=pum
endif

if has('eval')
  " <C-R> extensions: curent dir/file/full file path
  noremap! <C-R><C-E><C-W> <C-R>=getcwd()<CR>
  noremap! <C-R><C-E><C-F> <C-R>=expand('%')<CR>
  noremap! <C-R><C-E><C-P> <C-R>=expand('%:p')<CR>

  function WinViewSave()
    let w:saved_view=winsaveview()
  endfunction

  function WinViewRestore()
    if exists('w:saved_view')
      call winrestview(w:saved_view)
    endif
  endfunction

  " highligh keyword under the cursor (normal mode)
  nnoremap <Leader>* :call WinViewSave()<CR>*:call WinViewRestore()<CR>:echo<CR>
  nnoremap <Leader># :call WinViewSave()<CR>#:call WinViewRestore()<CR>:echo<CR>

  " selected block search (visual mode)
  vnoremap <Leader>* y:call WinViewSave()<CR>:exe '/\V'.tr(escape(@","\\/\b\e\f\n\r\t"),"\b\e\f\n\r\t","befnrt")<CR>:call WinViewRestore()<CR>:echo<CR>
  vnoremap <Leader># y:call WinViewSave()<CR>:exe '?\V'.tr(escape(@","\\?\b\e\f\n\r\t"),"\b\e\f\n\r\t","befnrt")<CR>:call WinViewRestore()<CR>:echo<CR>

  if has('statusline')
    set laststatus=2
    set statusline=%n
    set statusline+=\ %<%F%m
    set statusline+=\ [
    set statusline+=%{&ft!=''?&ft:'?'}
    set statusline+=\ %{&ff}
    set statusline+=\ %{&enc}%{&fenc!=''&&\ &fenc!=&enc?'->'.&fenc:''}
    set statusline+=]%=
    set statusline+=\ %P
    set statusline+=\ L%l/%L
    set statusline+=\ C%v%{charcol('.')!=col('.')?'\|'.col('.'):''}
    "set statusline+=\ [0x%{printf('%X',line2byte(line('.'))+col('.')-2)}]
  endif

  function s:SetTab(set, ...)
    if (a:0 <= 0)
      echo 'expandtab:'.(&et?'space':'tab').' softtabstop:'.&sts.' shiftwidth:'.&sw.' tabstop:'.&ts
      return
    endif

    if (a:1==?'s' || a:1==?'sp' || a:1==?'space')
      exe a:set.' et'
    elseif (a:1==?'t' || a:1==?'tab')
      exe a:set.' noet'
    endif

    if (a:0<=1)|return|endif
    exe a:set.' sts='.a:2.'|'.a:set.' sw='.a:2

    if (a:0<=2)|return|endif
    exe a:set.' ts='.a:3
  endfunction

  command -nargs=* SetTab call s:SetTab('set', <f-args>)
  command -nargs=* SetTabLoc call s:SetTab('setl', <f-args>)
  command -range Trim <line1>,<line2>s/\s\+$//
  command TrimAll %Trim

  function ByteOff()
    let b:off = line2byte(line('.'))+col('.')-2
    if (b:off >= 0)
      echo printf('Byte offset: %d, 0x%x', b:off, b:off)
    else
      echo 'Byte offset: ?'
    endif
  endfunction

  " byte offset of char under the cursor
  nnoremap <Leader>o :call ByteOff()<CR>
endif

au BufNewFile,BufRead *.ino,*.cppm,*.ixx setf cpp
au BufNewFile,BufRead *.y,*.pio setf c

filetype plugin indent on

if has('syntax')
  set colorcolumn=80
  syntax on
endif

command CtagsGen !ctags -R --c-kinds=+px --c++-kinds=+px . &
command CtagsGenFg !ctags -R --c-kinds=+px --c++-kinds=+px .

command GtagsGen !gtags &
command GtagsGenFg !gtags

command GlobalUpdate !global -u &
command GlobalUpdateFg !global -u

" :Man command support
runtime! ftplugin/man.vim
nnoremap <Leader>K :Man <C-R><C-W><CR>

if has('nvim')
  au UIEnter * set guifont=Monospace:h9
endif

"
" vim plugins section
"
if has('eval')
  if has('nvim')
    let s:vim_rtp = stdpath('config')
  elseif has('unix')
    let s:vim_rtp = '~/.vim'
  else
    " windows settings
    let s:vim_rtp = $VIM.'/vimfiles'
  endif
  let s:vim_rtp = expand(s:vim_rtp)

  " utility function to install vim-plug
  function InstallVimPlug()
    exe '!curl -fLo '.shellescape(s:vim_rtp.'/autoload/plug.vim').
      \ ' --create-dirs'.
      \ ' https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  endfunction

  " vim-plug is required; if not installed exit the script
  if strlen(globpath(&runtimepath, 'autoload/plug.vim')) <= 0
    finish
  endif

  " vim-plug home (works much predictable when passed expanded via global var)
  let g:plug_home = s:vim_rtp.'/plugged'

  call plug#begin()
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'tomasiser/vim-code-dark'
    Plug 'morhetz/gruvbox'
    Plug 'pstolarz/vim-scripts'
    Plug 'tpope/vim-fugitive'
    Plug 'preservim/nerdcommenter'
    Plug 'mhinz/vim-signify'
    Plug 'preservim/tagbar'
    Plug 'ycm-core/YouCompleteMe'
  call plug#end()

 if strlen(globpath(&runtimepath, 'plugin/airline.vim')) > 0
    let g:airline_experimental = 1
    let g:airline_symbols_ascii = 1
    let g:airline_section_c = "%n %<%F%m"
    let g:airline_section_y = "%{&ff} %{&enc}%{&fenc!='' && &fenc!=&enc ? '->'.&fenc : ''}"
    let g:airline_section_z = "%P L%l/%L C%v%{charcol('.')!=col('.') ? '|'.col('.') : ''}"

    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#whitespace#mixed_indent_algo = 1
    if exists('g:ycm_auto_hover')
      let g:airline#extensions#ycm#enabled = 1
    endif

    nnoremap <Leader>hf :SignifyDiff<CR>
    nnoremap <Leader>hd :SignifyHunkDiff<CR>
    nnoremap <Leader>hu :SignifyHunkUndo<CR>
  endif

  if strlen(globpath(&runtimepath, 'colors/codedark.vim')) > 0
    let g:codedark_italics = 0
  endif

  if strlen(globpath(&runtimepath, 'colors/gruvbox.vim')) > 0
    let g:gruvbox_italic = 0
    let g:gruvbox_contrast_dark='low'   " hard, medium, low
    let g:gruvbox_contrast_light='medium'
    if !has('gui_running')
      let g:gruvbox_guisp_fallback = 'bg'
    endif
  endif

  if exists('g:gruvbox_italic')
    colorscheme gruvbox
  elseif exists('g:codedark_italics')
    colorscheme codedark
  endif

  if strlen(globpath(&runtimepath, 'plugin/gtags.vim')) > 0
    let g:Gtags_No_Auto_Jump = 1
    nnoremap <Leader>] :Gtags <C-R><C-W><C-Left>
  endif

  if strlen(globpath(&runtimepath, 'plugin/signify.vim')) > 0
    let g:signify_sign_change = '~'
  endif

  if strlen(globpath(&runtimepath, 'plugin/tagbar.vim')) > 0
    let g:tagbar_left = 1
  endif

  if strlen(globpath(&runtimepath, 'plugin/youcompleteme.vim')) > 0
    let g:ycm_min_num_of_chars_for_completion = 99
    let g:ycm_auto_hover = ''
    let g:ycm_confirm_extra_conf = 0
    let g:ycm_show_diagnostics_ui = 0
    let g:ycm_echo_current_diagnostic = 0
    let g:ycm_key_detailed_diagnostics = '<Leader>yd'
    let g:ycm_error_symbol = 'E'
    let g:ycm_warning_symbol = 'W'

    function YcmStart()
      if g:ycm_show_diagnostics_ui == 0
        let g:ycm_show_diagnostics_ui = 1
        call youcompleteme#Enable()
      endif
    endfunction

    nnoremap <Leader>y] :YcmCompleter GoTo
    nnoremap <Leader>yi <plug>(YCMHover)
    nnoremap <Leader>yf :YcmCompleter FixIt<CR>
    nnoremap <Leader>yl :YcmForceCompileAndDiagnostics<CR>:YcmDiags<CR>
    nnoremap <Leader>ys :call YcmStart()<CR>
  endif
endif

" vim: set et ts=2 sw=2 sts=0:
