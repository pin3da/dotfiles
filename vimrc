" Based on https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim

set nocompatible
filetype off

set wildmenu
set wildignore=*.o,*~,*.pyc

set hid
set ignorecase
set smartcase
set hlsearch
set incsearch
set lazyredraw
set showmatch
set mat=2
set mouse=a
set list
set listchars=tab:→\ ,trail:×

set autoindent
set smartindent
set expandtab
set smarttab
set tabstop=2
set shiftwidth=2
set number

set dir=~/.cache/vim,/tmp

set laststatus=2


" Sorry my fish.. you don't play well with vundle..
if &shell =~ "/fish"
    set shell=/bin/sh
endif

" Enable side bars only if there is enough room
" if &columns > 79
"    set colorcolumn=+4
"    if &columns > 83
"        set number
"        if &columns > 84 | set foldcolumn=1 | endif
"    endif
" endif



" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions+=e
    set t_Co=256
    set guitablabel=%M\ %t
endif


" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l


" Return to last edit position when opening files
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" Delete trailing spaces (only files with extension)
autocmd BufWritePre *.* :%s/\s\+$//e


" set the runtime path to include Vundle and initialize
"set rtp+=~/.vim/bundle/Vundle.vim
set runtimepath+=$HOME/.vim/bundle/Vundle.vim/
call vundle#rc()
Plugin 'gmarik/Vundle.vim'

Plugin 'scrooloose/nerdtree'

" Color schemes
Plugin 'flazz/vim-colorschemes'

" Statusline
Plugin 'bling/vim-airline'
Plugin 'bling/vim-bufferline'

" call vundle#end()            " required
filetype plugin indent on    " required

syntax on
colorscheme wombat256mod
" colorscheme bubblegum


"""
""" Plugin-specific customizations
"""
let s:p_settings="$HOME/.vim/plugin_settings/*.vim"
execute join(map(split(glob(s:p_settings)), '"source " . v:val'), "\n")
