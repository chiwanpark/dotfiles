" init.vim for Chiwan Park

set hidden

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

" nerdtree
Plug 'scrooloose/nerdtree'
map <Leader>nt <ESC>:NERDTreeToggle<CR>

" deoplete.nvim
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
let g:deoplete#enable_at_startup=1
let g:deoplete#enable_smart_case=1
let g:deoplete#auto_complete_start_length=2
let g:deoplete#sources={}
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" vim-javacomplete2
Plug 'artur-shaik/vim-javacomplete2'
autocmd FileType java setlocal shiftwidth=2 tabstop=2 omnifunc=javacomplete#Complete
autocmd FileType java JCEnable
let g:deoplete#sources.java=['jc', 'javacomplete2', 'file', 'buffer']

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

" deoplete-jedi (Python)
Plug 'zchee/deoplete-jedi'

" jedi-vim (Python)
Plug 'davidhalter/jedi-vim'
let g:jedi#completions_enabled=0

" python-mode (Python)
Plug 'python-mode/python-mode', {'branch': 'develop'}
set foldlevel=99
let g:pymode_options_colorcolumn=0
let g:pymode_lint_ignore=["E501", "E402"]
let g:pymode_rope=0

" vimtex (LaTeX)
Plug 'lervag/vimtex'
autocmd FileType tex setlocal shiftwidth=2 tabstop=2
let g:vimtex_compiler_latexmk = {
  \ 'options': [
  \     '-pdf',
  \     '-verbose',
  \     '-bibtex',
  \     '-file-line-error',
  \     '-synctex=1',
  \     '--interaction=nonstopmode',
  \  ],
  \}

call plug#end()

source $HOME/.config/nvim/init.vim.local
