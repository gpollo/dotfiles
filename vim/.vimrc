set nocompatible
filetype off 

set tabstop=4
set shiftwidth=4
set smarttab
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
set colorcolumn=80

set rtp+=/usr/share/vim/vimfiles/autoload/vundle.vim

call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'lervag/vimtex'
call vundle#end()

filetype plugin indent on
syntax on

set expandtab
