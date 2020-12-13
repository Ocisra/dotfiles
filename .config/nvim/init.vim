" Plugins ------------------------------ {{{

call plug#begin('~/.config/nvim/plugged')

" color scheme
Plug 'morhetz/gruvbox'
set termguicolors
let g:gruvbox_bold=0
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
" ugly workaround so ultisnips won't override my mapping of <Tab>
" this won't be fixed by maintainer of ultisnips
let g:UltiSnipsExpandTrigger='<NUL>'
let g:UltiSnipsListSnippets=''
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
let g:tagbar_compact=2
let g:tagbar_ctags_options=['/home/ocisra/.config/ctags/']

" line for each indentation
Plug 'yggDroot/indentline'

" lsp
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/diagnostic-nvim'
let g:diagnostic_insert_delay=1

" completion
Plug 'nvim-lua/completion-nvim'
let g:completion_enable_snippet='UltiSnips'
" i have to remap <CR> or it will override other mapping (auto-pair)
let g:completion_confirm_key=""
imap <expr> <CR> pumvisible() ? complete_info()["selected"] != "-1" ? "\<Plug>(completion_confirm_completion)" : "\<C-e>\<CR>" : "\<CR>"
set completeopt=noinsert,noselect,menuone
set shortmess+=c

" undo history
Plug 'mbbill/undotree'
let g:undotree_SplitWidth=25
let g:undotree_ShortIndicators=1
let g:undotree_HelpLine=0

call plug#end()

" load ls 
lua << EOF
    local on_attach_vim = function(client)
        require'completion'.on_attach(client)
        require'diagnostic'.on_attach(client)
    end
    require'nvim_lsp'.clangd.setup{on_attach=on_attach_vim}
    require'nvim_lsp'.bashls.setup{on_attach=on_attach_vim}
    require'nvim_lsp'.vimls.setup{on_attach=on_attach_vim}
EOF
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
" Color --------- ----------------------- {{{
" syntax highlighting
filetype plugin on
syntax on

" color scheme
set t_Co=256
colorscheme gruvbox

" lsp diagnostics
" highlights won't break if the colorscheme is changed but it may not render
" so well
call sign_define("LspDiagnosticsErrorSign", {"text": ">>", "texthl": "ErrorMsg"})
call sign_define("LspDiagnosticsWarningSign", {"text": "--", "texthl": "WarningMsg"})
call sign_define("LspDiagnosticsInformationSign", {"text": "..", "texthl": "Question"})
call sign_define("LspDiagnosticsHintSign", {"text": ".", "texthl": "Title"})

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
" Shortcuts --------- ----- -------- ------ {{{
" enable left/right arrow to move to prev/next line
set whichwrap=b,s,<,>,[,]

" leader
let mapleader=","

" source shortcut
noremap <leader>sv <cmd>source ~/.config/nvim/init.vim<CR>

" completion
inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" snippets
inoremap <C-u> <cmd>call UltiSnips#ExpandSnippetOrJump()<CR>

" tagbar
nnoremap <leader>t :TagbarToggle<CR> 

" nerdtree
nnoremap <leader>m :NERDTreeToggle<CR>
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif

" jumps
noremap <leader>o <C-o>
noremap <leader>i <C-i>

" lsp
" unconvenient mapping is wanted, they are only used while debugging 
noremap <F2> <cmd>lua vim.lsp.buf.code_action()<CR>
noremap <F14> <cmd>lua vim.lsp.buf.formatting()<CR>
noremap <F3> <cmd>lua vim.lsp.buf.rename()<CR>
noremap <F15> <cmd>lua vim.lsp.buf.references()<CR>
noremap <F16> <cmd>lua vim.lsp.buf.type_definition()<CR>
noremap <F4> <cmd>lua vim.lsp.buf.declaration()<CR>
noremap <leader>d <cmd>lua vim.lsp.buf.definition()<CR>
noremap <leader>ee <cmd>lua vim.lsp.util.show_line_diagnostics()<CR>
noremap <leader>ep <cmd>PrevDiagnosticCycle<CR>
noremap <leader>en <cmd>NextDiagnosticCycle<CR>


" undotree
" shift F1 is not convenient, change if i use regularly 
inoremap <F13> <cmd>UndotreeToggle<CR>
noremap <F13> <cmd>UndotreeToggle<CR>

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
tnoremap <C-h> <C-\><C-N><C-w>h
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k
tnoremap <C-l> <C-\><C-N><C-w>l

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

set whichwrap+=<,>,h,l

" }}}
" Scripts ----------------------------- {{{
command RightColumn :source ~/.config/nvim/scripts/right-column.vim 
" }}}
" Statusline -------------------------- {{{
set laststatus=2

function! ErrorCount() abort 
    let l:errorCount=luaeval("vim.lsp.util.buf_diagnostics_count([[Error]])")
    if l:errorCount != 0
        return l:errorCount
    endif
    return ""
endfun

function! WarningCount() abort
    let l:warningCount=luaeval("vim.lsp.util.buf_diagnostics_count([[Warning]])")
    if l:warningCount != 0
        return l:warningCount
    endif
    return ""
endfun

function! ModeName() abort
    let l:mode = mode()
    if l:mode == 'i'
        return "-- INSERT --"
    elseif l:mode == 'v' || l:mode == 'V'
        return "-- VISUAL --"
    elseif l:mode == 'r' || l:mode == 'R'
        return "-- RPLACE --"
    elseif l:mode == 's' || l:mode == 'S'
        return "-- SELECT --"
    endif
    return ""
endfun

set statusline=%(%#DiffAdd#%{ModeName()}%#TabLineSel#\ %)
set statusline+=%#TabLineSel#
set statusline+=%f
set statusline+=\ %h
set statusline+=\ %r
set statusline+=\ %w
set statusline+=%=
set statusline+=%#CursorLineNr#%(Err:\ %{ErrorCount()}%)
set statusline+=%#CursorLineNr#%(\ Warn:\ %{WarningCount()}%)
set statusline+=%#TabLineSel#
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\ 
"}}}
" vim:foldmethod=marker:foldlevel=0 
