" init.vim for Chiwan Park

set hidden

" 1) read opened files again if changes are occurred outside nvim
" 2) write a modified buffer on each :next, ...
set autoread
set autowrite

" use incremental search
set incsearch

" clipboard sharing
set clipboard+=unnamedplus

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
set mouse=

" draw the signcolumn always
set signcolumn=yes

" conditional plugin helper
function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

call plug#begin('~/.local/share/nvim/plugged')

" onedark.vim
Plug 'joshdick/onedark.vim', Cond(!exists('g:vscode'))

" vim-gitgutter & vim-fugitive
Plug 'airblade/vim-gitgutter', Cond(!exists('g:vscode'))
Plug 'tpope/vim-fugitive', Cond(!exists('g:vscode'))

" vim-surround
Plug 'tpope/vim-surround'

" vim-airline
Plug 'bling/vim-airline', Cond(!exists('g:vscode'))
if !exists('g:vscode')
    let g:airline_theme='onedark'
    let g:airline#extensions#tabline#enabled=1
    let g:airline#extensions#tabline#fnamemod=':t'
    let g:airline#extensions#tabline#buffer_nr_show=1
    let g:airline#extensions#tabline#buffer_nr_format='%s:'
endif

" nerdtree
Plug 'scrooloose/nerdtree', Cond(!exists('g:vscode'))
if !exists('g:vscode')
    map <Leader>nt <ESC>:NERDTreeToggle<CR>
endif

" configuration for html/css
autocmd FileType html setlocal shiftwidth=2 tabstop=2
autocmd FileType css setlocal shiftwidth=2 tabstop=2

" configuration for yaml
autocmd FileType yml setlocal shiftwidth=2 tabstop=2
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2

" fzf (fuzzy finder)
Plug 'junegunn/fzf'

call plug#end()

" colorscheme
if (has("nvim"))
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
if (has("termguicolors"))
  set termguicolors
endif
colorscheme onedark

source $HOME/.config/nvim/init.vim.local
