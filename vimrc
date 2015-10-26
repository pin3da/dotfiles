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

" set dir=~/.cache/vim,/tmp
set nowritebackup
set noswapfile
set nobackup

set laststatus=2


" Sorry my fish.. you don't play well with vundle..
if &shell =~ "/fish"
    set shell=/bin/sh
endif

" Enable side bars only if there is enough room
" if &columns > 79
"   set colorcolumn=+4
"   if &columns > 83
"       set number
"       if &columns > 84 | set foldcolumn=1 | endif
"   endif
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

" Unite - browsing stuff inside vim with an uniform interface
Plugin 'Shougo/unite.vim'
Plugin 'Shougo/vimfiler.vim'
Plugin 'Shougo/vimproc.vim'
Plugin 'tsukkee/unite-help'

" Color schemes
Plugin 'flazz/vim-colorschemes'

" Check syntax
Plugin 'scrooloose/syntastic'

" Nodejs syntax
Plugin 'jelera/vim-javascript-syntax'

" Statusline
Plugin 'bling/vim-airline'
Plugin 'bling/vim-bufferline'

" Comments
Plugin 'scrooloose/nerdcommenter'

" Multiple cursors
Plugin 'terryma/vim-multiple-cursors'

" Ember stuff
Plugin 'dsawardekar/ember.vim'
Plugin 'mustache/vim-mustache-handlebars'

" call vundle#end()            " required
filetype plugin indent on    " required

syntax on
colorscheme wombat256mod

"  Move lines
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" No arrows ):
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" format the entire file
nmap <leader>fef gg=G

" F-keys
"
" F2: Close current buffer
" F3: Toggle file explorer
" F4: Toggle numbering/fold column
" F5: Toggle column bar
" F6: Toggle whitespace visibility
noremap <F2> :confirm bdel<CR>
noremap <F3> :VimFilerExplorer<CR>
noremap <F4> :set number!<CR>:let &foldcolumn=&fdc==0?1:0<CR>
noremap <F5> :let &colorcolumn=(&cc == '' ? '+4' : '')<CR>
noremap <F6> :set list!<CR>
" Turn off highliting until next search
nnoremap <silent><CR> :noh<CR>
" Moving around buffers
noremap <Leader>l :bnext!<CR>
noremap <Leader>h :bprevious!<CR>

" Make <shift> + O faster.
:set timeout timeoutlen=5000 ttimeoutlen=100

" Toggling the list style
let g:netrw_liststyle=3


"""
""" Plugin-specific customizations
"""
let s:p_settings="$HOME/.vim/plugin_settings/*.vim"
execute join(map(split(glob(s:p_settings)), '"source " . v:val'), "\n")
