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

" deoplete.nvim
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
let g:deoplete#enable_at_startup=1

" vim-javacomplete2
Plug 'artur-shaik/vim-javacomplete2'
autocmd FileType java setlocal omnifunc=javacomplete#Complete

" pydoc.vim (Python)
Plug 'https://github.com/fs111/pydoc.vim.git'

" jedi-vim (Python)
Plug 'davidhalter/jedi-vim'
let g:jedi#popup_on_dot=0
let g:jedi#popup_select_first=0
let g:jedi#force_py_version=3

" python-mode (Python)
Plug 'python-mode/python-mode'
set foldlevel=99
let g:pymode_options_colorcolumn=0
let g:pymode_lint_ignore="E501,E402"

call plug#end()
