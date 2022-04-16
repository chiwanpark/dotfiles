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

" configuration for yaml
autocmd FileType yml setlocal shiftwidth=2 tabstop=2
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2

" fzf (fuzzy finder)
Plug 'junegunn/fzf'

" nerdcommenter
Plug 'scrooloose/nerdcommenter'

" vim-cpp-modern (Modern C++ syntax highlighting)
Plug 'bfrg/vim-cpp-modern'

" vim-lsp (Language Server Protocol)
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

" flutter and dart
Plug 'dart-lang/dart-vim-plugin'
Plug 'thosakwe/vim-flutter'

call plug#end()

" lsp handler
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    inoremap <expr> <Tab> pumvisible() ? '<C-n>' : '<Tab>'
    inoremap <expr> <S-Tab> pumvisible() ? '<C-p>' : '<S-Tab>'
    inoremap <expr> <cr> pumvisible() ? asyncomplete#close_popup() : '<cr>'
    nmap <buffer> <leader>gd <plug>(lsp-definition)
    nmap <buffer> <leader>gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>gi <plug>(lsp-implementation)
    nmap <buffer> <leader>gr <plug>(lsp-rename)
    nmap <buffer> <leader>k <plug>(lsp-hover)
    nmap <buffer> <leader>p <plug>(lsp-code-action)
endfunction

" pyls
if executable('pyls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'allowlist': ['python'],
        \ 'workspace_config': {'pyls': {'configurationSources': ['flake8']}}
        \ })
endif

" clangd
if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd']},
        \ 'allowlist': ['c', 'cpp', 'objc', 'objcpp'],
        \ })
endif

" typescript-language-server for javascript
if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'typescript-language-server-js',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
        \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'package.json'))},
        \ 'whitelist': ['javascript', 'javascript.jsx'],
        \ })
endif
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2

" language server for flutter
if executable('flutter')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'dart_ls',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, '/opt/flutter/bin/cache/dart-sdk/bin/dart /opt/flutter/bin/cache/dart-sdk/bin/snapshots/analysis_server.dart.snapshot --lsp --client-id vim']},
        \ 'allowlist': ['dart'],
        \ })
endif
let g:dart_style_guide=2

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" colorscheme
if (has("nvim"))
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
if (has("termguicolors"))
  set termguicolors
endif
colorscheme onedark

source $HOME/.config/nvim/init.vim.local
