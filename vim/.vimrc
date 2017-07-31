set showcmd
set number
set showmatch
set ignorecase
set smartcase
set backspace=2
set autoindent
set textwidth=79
set formatoptions=c,q,r,t
set ruler
set background=dark
set mouse=a
set hlsearch
set incsearch
set paste

" use space rather than tabs
set tabstop=4
set softtabstop=0
set expandtab
set shiftwidth=4
set smarttab

filetype plugin indent on
syntax on

" capital letter alternative to some commands
command! W  write
command! Q  quit

" external plugins
call plug#begin('~/.vim/plugged/')
    Plug 'lervag/vimtex'
call plug#end()
