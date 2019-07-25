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

" external plugins
call vundle#begin()
    Plugin 'VundleVim/Vundle.vim'
    Plugin 'fatih/vim-go'
call vundle#end()

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

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"
imap <c-space> <Plug>(asyncomplete_force_refresh)
set completeopt+=preview
