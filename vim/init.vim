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
set mouse-=a

" draw the signcolumn always
set signcolumn=yes

call plug#begin('~/.local/share/nvim/plugged')

" onedark.vim
Plug 'joshdick/onedark.vim'

" vim-gitgutter & vim-fugitive
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" vim-surround
Plug 'tpope/vim-surround'

" vim-airline
Plug 'bling/vim-airline'
let g:airline_theme='onedark'
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#fnamemod=':t'
let g:airline#extensions#tabline#buffer_nr_show=1
let g:airline#extensions#tabline#buffer_nr_format='%s:'

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

" neoformat
Plug 'sbdchd/neoformat'

" neomake
Plug 'neomake/neomake'

" configuration for xml and html
autocmd FileType xml setlocal shiftwidth=2 tabstop=2 omnifunc=xmlcomplete#CompleteTags
autocmd FileType html setlocal shiftwidth=2 tabstop=2 omnifunc=xmlcomplete#CompleteTags

" configuration for yaml
autocmd FileType yml setlocal shiftwidth=2 tabstop=2
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2

" pydoc.vim (Python)
Plug 'https://github.com/fs111/pydoc.vim.git'

" deoplete-jedi (Python)
Plug 'zchee/deoplete-jedi'

" jedi-vim (Python)
Plug 'davidhalter/jedi-vim'
let g:jedi#completions_enabled=0

" vimtex (LaTeX)
Plug 'lervag/vimtex'
autocmd FileType tex setlocal shiftwidth=2 tabstop=2
let g:vimtex_compiler_latexmk = {
  \ 'options': [
  \     '-verbose',
  \     '-bibtex',
  \     '-file-line-error',
  \     '-synctex=1',
  \     '--interaction=nonstopmode',
  \  ],
  \}
let g:tex_flavor='latex'

" jsx
Plug 'mxw/vim-jsx'

" LanguageClient-neovim
Plug 'autozimu/LanguageClient-neovim', {
  \ 'branch': 'next',
  \ 'do': 'bash install.sh',
  \ }
let g:LanguageClient_autoStart=1
let g:LanguageClient_serverCommands={}
let g:LanguageClient_diagnosticsEnable=0 " temporarily disable diagnostics for all languages
nnoremap <F5> :call LanguageClient_contextMenu()<CR>
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <leader>g :call LanguageClient#textDocument_definition()<CR>
nnoremap <leader>rr :call LanguageClient#textDocument_rename()<CR>

" Configuration for Java
"
let g:JavaComplete_ClasspathGenerationOrder = ['Maven', 'Eclipse', 'Gradle', 'Ant']
Plug 'artur-shaik/vim-javacomplete2'
autocmd FileType java setlocal shiftwidth=2 tabstop=2 omnifunc=javacomplete#Complete

" Configuration for PHP
autocmd FileType php setlocal shiftwidth=2 tabstop=2 omnifunc=xmlcomplete#CompleteTags

" Configuration for Julia
Plug 'JuliaEditorSupport/julia-vim'

" scss-syntax.vim (SCSS)
Plug 'cakebaker/scss-syntax.vim'
autocmd FileType scss setlocal shiftwidth=2 tabstop=2

" echodoc.vim (parameter doc)
Plug 'Shougo/echodoc.vim'

" fzf (fuzzy finder)
Plug 'junegunn/fzf'

" nerdcommenter
Plug 'scrooloose/nerdcommenter'

call plug#end()

" neomake setting
call neomake#configure#automake('rw', 1000)

" colorscheme
if (has("nvim"))
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
if (has("termguicolors"))
  set termguicolors
endif
colorscheme onedark

source $HOME/.config/nvim/init.vim.local
