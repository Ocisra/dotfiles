" Plugins ------------------------------ {{{

call plug#begin('~/.config/nvim/plugged')

" color scheme
Plug 'tomasiser/vim-code-dark'
Plug 'bfrg/vim-cpp-modern'

" latex
Plug 'lervag/vimtex'
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
let g:vimtex_fold_enabled=1
set conceallevel=2
let g:tex_conceal='abdmg'

" snipets
Plug 'sirver/ultisnips'
let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsJumpBackwardTrigger='<s-tab>'
let g:UltiSnipsSnippetDirectories=["UltiSnips", "snippet"]

" auto pair
Plug 'jiangmiao/auto-pairs'

" tree explorer
Plug 'preservim/nerdtree'

" tag bar
Plug 'majutsushi/tagbar'

" line for each indentation
Plug 'yggDroot/indentline'

" lint
Plug 'dense-analysis/ale'

" completion
Plug 'Shougo/deoplete.nvim'
let g:deoplete#enable_at_startup = 1

call plug#end()

call deoplete#custom#option('sources', {
            \ '_': ['ale'],
            \})
" }}}
" System ------------------------------- {{{
" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages.
runtime! archlinux.vim

" do not load defaults if vimrc is missing
let skip_defaults_vim=1

" viminfo
set viminfo='10,<50,:20,%,n~/.vim/.viminfo

" mouse support
set mouse=a

" don't update screen during macro/script execution
set lazyredraw

" disable swap file
set noswapfile

" }}}
" Color -------------------------------- {{{
" syntax highlighting
filetype plugin on
syntax on

" color scheme
set t_Co=256
colorscheme codedark
highlight Normal ctermbg=NONE
highlight nonText ctermbg=NONE
highlight EndOfBuffer ctermbg=NONE
highlight Folded ctermbg=NONE
highlight Conceal ctermbg=NONE
highlight SpellBad ctermbg=NONE 


" ale colors
highlight clear ALEErrorSign
highlight clear ALEWarningSign
highlight ALEErrorSign ctermbg=234 ctermfg=Red
highlight ALEWarningSign ctermbg=234 ctermfg=Red

" highlight current line
set cursorline
" }}}
" Code layout -------------------------- {{{
" indentation
filetype indent on
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4
set softtabstop=4

" folding
set foldenable
set foldmethod=syntax
set foldnestmax=10
set foldlevelstart=3
nnoremap <space> za

" line break not in the middle of a word
set linebreak
" }}}
" Shortcuts ---------------------------- {{{
" enable left/right arrow to move to prev/next line
set whichwrap=b,s,<,>,[,]

" leader
let mapleader=","

" source shortcut
nnoremap <leader>sv :source ~/.config/nvim/init.vim

nnoremap <leader>t :TagbarToggle<CR> 
nnoremap <leader>m :NERDTreeToggle<CR>
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
noremap <F1> <Esc>:ALEHover<CR>
noremap <F4> <Esc>:ALEGoToDefinition<CR>


" }}}
" Misc -------------------------------- {{{
" line number
set number

" show last command entered
set showcmd

" searching
set ignorecase
set smartcase
set incsearch

" menu for tab complete
set wildmenu

set modeline
set modelines=5

set splitbelow
set splitright

" }}}
" Latex -------------------------------- {{{

" }}}
" vim:foldmethod=marker:foldlevel=0 
