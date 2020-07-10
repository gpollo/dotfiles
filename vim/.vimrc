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
    Plugin 'dense-analysis/ale'
call vundle#end()

" use space rather than tabs
set tabstop=4
set softtabstop=0
set expandtab
set shiftwidth=4
set smarttab

filetype plugin indent on
syntax on
au BufRead,BufNewFile .clang-tidy set filetype=yaml

" capital letter alternative to some commands
command! W  write
command! Q  quit

" load ctags recursively
:set tags=tags;/

"""""""""""
" Hotkeys "
"""""""""""

nnoremap <nowait> dec :LspDeclaration<CR>
nnoremap <nowait> def :LspDefinition<CR>
nnoremap <nowait> qdec :LspPeekDeclaration<CR>
nnoremap <nowait> qdef :LspPeekDefinition<CR>

"""""""""""""""""""""""""""
" Language Configurations "
"""""""""""""""""""""""""""

let g:ale_linters={
\  'c': ['clangtidy'],
\  'cpp': ['clangtidy'],
\}

" configuration "

let g:lsp_diagnostics_enabled = 0

" c/c++ "

if executable('ccls')
   au User lsp_setup call lsp#register_server({
      \ 'name': 'ccls',
      \ 'cmd': {server_info->['ccls']},
      \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
      \ 'initialization_options': {'cache': {'directory': '/tmp/ccls/cache' }},
      \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
      \ })
endif
let g:ale_c_clangtidy_executable = 'clang-tidy'
autocmd BufEnter * if &filetype ==# 'c' | :call SetCompilationDatabaseBuildDirectory() | endif

let g:ale_cpp_clangtidy_executable = 'clang-tidy'
autocmd BufEnter * if &filetype ==# 'cpp' | :call SetCompilationDatabaseBuildDirectory() | endif

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

""""""""""""""""""""
" Helper Functions "
""""""""""""""""""""

" finds and set the dir containing C/C++ compilation database "
func! SetCompilationDatabaseBuildDirectory()
    let l:db_pre = expand('%:h')
    let l:db_post = ''

    while !filereadable(l:db_pre . l:db_post . '/compile_commands.json')
        " probe a potential build dir
        if filereadable(l:db_pre . l:db_post . '/build/compile_commands.json')
            let l:db_post = l:db_post . '/build'
            break
        endif

        " otherwise try a directory up
        let l:db_post = l:db_post . '/..'

        " Give up after after 10 dirs up (5 + 3 * 10).
        if strlen(l:db_post) > 35
            let l:db_post = ''
            break
        endif
    endwhile


    let g:ale_c_clangtidy_options = '-p=''' . l:db_pre . l:db_post . ''''
    let g:ale_cpp_clangtidy_options = '-p=''' . l:db_pre . l:db_post . ''''
    "let g:clang_compilation_database = l:db_pre . l:db_post
    "let g:syntastic_c_clang_tidy_post_args = '-p=''' . l:db_pre . l:db_post . ''''
    "let g:syntastic_cpp_clang_tidy_post_args = g:syntastic_c_clang_tidy_post_args
endfunc
