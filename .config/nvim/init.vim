" Plugins ------------------------------ {{{

call plug#begin('~/.config/nvim/plugged')

" color scheme
Plug 'morhetz/gruvbox'
set termguicolors
let g:gruvbox_italic = 1
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_sign_column='bg0'
" Plug 'tomasiser/vim-code-dark'
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
let NERDTreeMinimalUI=1

" easier commenting
Plug 'preservim/nerdcommenter'

" tag bar
Plug 'majutsushi/tagbar'

" line for each indentation
Plug 'yggDroot/indentline'

" lint
Plug 'dense-analysis/ale'
let g:ale_linters = {'c': ['clangd'], 'cpp': ['clangd']}
let g:ale_fixers = {'c': ['clangtidy', 'clang-format'], 'cpp': ['clangtidy', 'clang-format']}
let g:ale_cpp_cc_options='-std=c++20 -Wall'
let g:ale_cpp_clangd_options='--clang-tidy'

" completion
Plug 'Shougo/deoplete.nvim'
let g:deoplete#enable_at_startup = 1
set completeopt=menu,noinsert

" undo history
Plug 'mbbill/undotree'
let g:undotree_SplitWidth=25
let g:undotree_ShortIndicators=1
let g:undotree_HelpLine=0

call plug#end()

"call deoplete#custom#option('sources', {
"            \ '_': ['ale'],
"            \})
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
colorscheme gruvbox
" Those are handled by gruvbox but might be needed with other colorscheme 
" highlight Normal ctermbg=NONE
" highlight nonText ctermbg=NONE
" highlight EndOfBuffer ctermbg=NONE
" highlight Folded ctermbg=NONE
" highlight Conceal ctermbg=NONE
" highlight SpellBad ctermbg=NONE 
"
" ale colors
" highlight clear ALEErrorSign
" highlight clear ALEWarningSign
" highlight ALEErrorSign ctermbg=234 ctermfg=Red
" highlight ALEWarningSign ctermbg=234 ctermfg=Red

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
" Shortcuts -------------- -------------- {{{
" enable left/right arrow to move to prev/next line
set whichwrap=b,s,<,>,[,]

" leader
let mapleader=","

" source shortcut
nnoremap <leader>sv :source ~/.config/nvim/init.vim

" tagbar
nnoremap <leader>t :TagbarToggle<CR> 

" nerdtree
nnoremap <leader>m :NERDTreeToggle<CR>
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif

" nerdcommenter
inoremap <C-c> <plug>NERDCommenterInsert

" ale
inoremap <F2> <Esc>:ALEHover<CR>
noremap <F2> :ALEHover<CR>
inoremap <F14> <Esc>:ALEDetail<CR>
noremap <F14> :ALEDetail<CR>
inoremap <F3> <Esc>:ALENext<CR>
noremap <F3> :ALENext<CR>
inoremap <F4> <Esc>:ALEGoToDefinition<CR>
noremap <F4> :ALEGoToDefinition<CR>
inoremap <F16> <Esc>:ALEFindReferences<CR>
noremap <F16> :ALEFindReferences<CR>

" undotree
inoremap <F15> <Esc>:UndotreeToggle<CR>
noremap <F15> :UndotreeToggle<CR>

" window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
inoremap <C-h> <C-\><C-N><C-w>h
inoremap <C-j> <C-\><C-N><C-w>j
inoremap <C-k> <C-\><C-N><C-w>k
inoremap <C-l> <C-\><C-N><C-w>l

" terminal (for Termdebug)
tnoremap <Esc> <C-\><C-N>
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l

" }}}
" Misc -------------------------------- {{{
" line number
set number

" command line 
set noshowcmd
set noshowmode

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
" Statusline -------------------------- {{{
set laststatus=2

function! LinterError() abort 
    let l:count = ale#statusline#Count(bufnr(''))
    let l:error = l:count.error + l:count.style_error
    
    if l:error != 0 
        return l:error
    endif
    return ""
endfun

function! LinterWarning() abort
    let l:count = ale#statusline#Count(bufnr(''))
    let l:error = l:count.error + l:count.style_error
    let l:warning = l:count.warning - l:count.style_warning

    if l:warning != 0 
        return l:warning
    endif
    return ""

endfun

function! ModeName() abort
    let l:mode = mode()
    if l:mode == 'i'
        return "INSERT"
    elseif l:mode == 'v' || l:mode == 'V'
        return "VISUAL"
    elseif l:mode == 'r' || l:mode == 'R'
        return "REPLACE"
    elseif l:mode == 's' || l:mode == 'S'
        return "SELECT"
    endif
    return ""
endfun

set statusline=%#TabLineSel#
set statusline+=%(%{ModeName()}\ %)
set statusline+=%f
set statusline+=\ %h
set statusline+=\ %r
set statusline+=\ %w
set statusline+=%=
set statusline+=%#CursorLineNr#%(Err:\ %{LinterError()}%)
set statusline+=%#CursorLineNr#%(\ Warn:\ %{LinterWarning()}%)
set statusline+=%#TabLineSel#
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\ 
"}}}
" vim:foldmethod=marker:foldlevel=0 
