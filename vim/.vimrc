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
set colorcolumn=100

" used to remember last session
set viminfo='20,<1000

" preview window colors (white around black)
highlight Pmenu ctermfg=15 ctermbg=0

" external plugins
call vundle#begin()
    Plugin 'VundleVim/Vundle.vim'
    Plugin 'fatih/vim-go'
    Plugin 'prabirshrestha/async.vim'
    Plugin 'prabirshrestha/vim-lsp'
    Plugin 'prabirshrestha/asyncomplete.vim'
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

" load ctags recursively
:set tags=tags;/

"""""""""""
" Hotkeys "
"""""""""""

map <nowait> dec :LspDeclaration<CR>
map <nowait> def :LspDefinition<CR>
map <nowait> qdec :LspPeekDeclaration<CR>
map <nowait> qdef :LspPeekDefinition<CR>

""""""""""""""""""""""""""""
" Language Server Protocol "
""""""""""""""""""""""""""""

" configuration "

let g:lsp_diagnostics_enabled = 0

" c/c++ "

if executable('ccls')
   au User lsp_setup call lsp#register_server({
      \ 'name': 'ccls',
      \ 'cmd': {server_info->['ccls']},
      \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
      \ })
endif

" python "

if executable('pyls')
    " pip install python-language-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ })
endif

" go "

if executable('go-langserver')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'go-langserver',
        \ 'cmd': {server_info->['go-langserver', '-gocodecompletion']},
        \ 'whitelist': ['go'],
        \ })
    autocmd BufWritePre *.go LspDocumentFormatSync
endif

" bash "

if executable('bash-language-server')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'bash-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'bash-language-server start']},
        \ 'whitelist': ['sh'],
        \ })
endif

" docker "

if executable('docker-langserver')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'docker-langserver',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'docker-langserver --stdio']},
        \ 'whitelist': ['dockerfile'],
        \ })
endif

" java "

if executable('java')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'eclipse.jdt.ls',
        \ 'cmd': {server_info->[
        \     'java',
        \     '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        \     '-Dosgi.bundles.defaultStartLevel=4',
        \     '-Declipse.product=org.eclipse.jdt.ls.core.product',
        \     '-Dlog.level=ALL',
        \     '-noverify',
        \     '-Dfile.encoding=UTF-8',
        \     '-Xmx1G',
        \     '-data',
        \     getcwd()
        \ ]},
        \ 'whitelist': ['java'],
        \ })
endif
