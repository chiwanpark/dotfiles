" init.vim for Chiwan Park

" 1) read opened files again if changes are occurred outside nvim
" 2) write a modified buffer on each :next, ...
set autoread
set autowrite

" use incremental search
set incsearch

" tab and indent setting
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set autoindent

" turn on line number
set number

" syntax highlighting
syntax on

" disable mouse
set mouse-=a

call plug#begin('~/.local/share/nvim/plugged')

" vim-gitgutter & vim-fugitive
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" vim-surround
Plug 'tpope/vim-surround'

" vim-airline
Plug 'bling/vim-airline'
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#fnamemod=':t'

" denite.nvim
Plug 'Shougo/denite.nvim'

" deoplete.nvim
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
let g:deoplete#enable_at_startup=1
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" vim-javacomplete2
Plug 'artur-shaik/vim-javacomplete2'
autocmd FileType java setlocal shiftwidth=2 tabstop=2 omnifunc=javacomplete#Complete

" neoformat
Plug 'sbdchd/neoformat'
let g:neoformat_java_google = {
    \ 'exe': 'java',
    \ 'args': ['-jar ~/.local/share/nvim/external-tools/google-java-format-1.5-all-deps.jar', '-'],
    \ 'stdin': 1,
    \ }
let g:neoformat_enabled_java = ['google']

" configuration for xml
autocmd FileType xml setlocal shiftwidth=2 tabstop=2 omnifunc=xmlcomplete#CompleteTags

" pydoc.vim (Python)
Plug 'https://github.com/fs111/pydoc.vim.git'

" deoplete-jedi
Plug 'zchee/deoplete-jedi'

" python-mode (Python)
Plug 'python-mode/python-mode'
set foldlevel=99
let g:pymode_options_colorcolumn=0
let g:pymode_lint_ignore="E501,E402"

call plug#end()

source $HOME/.config/nvim/init.vim.local
