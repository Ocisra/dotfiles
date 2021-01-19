" Plugins ------------------------------ {{{

call plug#begin('~/.config/nvim/plugged')

" color scheme

Plug 'morhetz/gruvbox'
set termguicolors
let g:gruvbox_bold=0
let g:gruvbox_italic = 1
let g:gruvbox_contrast_dark='medium'
let g:gruvbox_sign_column='bg0'
Plug 'bfrg/vim-cpp-modern'

" latex
"Plug 'lervag/vimtex'
"let g:tex_flavor='latex'
"let g:vimtex_view_method='zathura'
"let g:vimtex_quickfix_mode=0
"let g:vimtex_fold_enabled=1
set conceallevel=2
"let g:tex_conceal='abdmg'

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

" line for each indentation
Plug 'yggDroot/indentline'

" lsp
Plug 'neovim/nvim-lspconfig'
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

    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text=false,
        }
    )

    local on_attach_vim = function(client)
        require'completion'.on_attach(client)
    end

    local sumneko_root_path = "/home/ocisra/build/lua-language-server"

    require'lspconfig'.clangd.setup{on_attach=on_attach_vim}
    require'lspconfig'.bashls.setup{on_attach=on_attach_vim}
    require'lspconfig'.vimls.setup{on_attach=on_attach_vim}
    require'lspconfig'.sumneko_lua.setup{
        on_attach=on_attach_vim,
        cmd={sumneko_root_path .. "/bin/Linux/lua-language-server", "-E", sumneko_root_path .. "/main.lua" },
    }
    require'lspconfig'.texlab.setup{on_attach=on_attach_vim}
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
syntax enable

" color scheme
set t_Co=256
colorscheme gruvbox
hi NonText guifg=#ff0000

" lsp diagnostics
" highlights won't break if the colorscheme is changed but it may not render
" so well
sign define LspDiagnosticsSignError text=>> texthl=ErrorMsg
sign define LspDiagnosticsSignWarning text=-- texthl=WarningMsg
sign define LspDiagnosticsSignInformation text=.. texthl=Question
sign define LspDiagnosticsSignHint text=. texthl=Title

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

" folding
set foldenable
set foldmethod=syntax
set foldnestmax=10
set foldlevelstart=5

set textwidth=80

" line break not in the middle of a word
set linebreak
" }}}
" Shortcuts --------- ----- -------- ------ {{{
" enable left/right arrow to move to prev/next line
set whichwrap=b,s,<,>,[,]

" leader
let mapleader=","

" remove search highlight
nnoremap <leader>vhl :nohl<CR>

" toggle vim options
nnoremap <leader>vl :set list!<CR>
nnoremap <leader>vn :set relativenumber!<CR>

" source shortcut
nnoremap <leader>sv :source $MYVIMRC<CR>

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

" movement
nnoremap j gj
nnoremap k gk

" quickfix
nnoremap cn :cn<CR>
nnoremap cp :cp<CR>
nnoremap gc :.cc<CR>
nnoremap cq :ccl<CR>

" buffer
nnoremap bn :bn<CR>
nnoremap bp :bp<CR>

" lsp
" unconvenient mapping is wanted, they are only used while debugging 
nnoremap <leader>= <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <leader>aa <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <leader>h <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <leader>ar <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <leader>qb <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <leader>qw <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <leader>qi <cmd>lua vim.lsp.buf.incoming_calls()<CR>
nnoremap <leader>qo <cmd>lua vim.lsp.buf.outgoing_calls()<CR>
nnoremap <leader>gt <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <leader>gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <leader>gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <leader>gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <leader>ee <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <leader>ep <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <leader>en <cmd>lua vim.lsp.diagnostic.goto_next()<CR>


" undotree
" shift F1 is not convenient, change if i use regularly 
inoremap <F13> <cmd>UndotreeToggle<CR>
nnoremap <F13> <cmd>UndotreeToggle<CR>

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
set relativenumber

" list show unwanted spaces, highlighted with NonText
set listchars=tab:<->,trail:-,nbsp:+

" command line 
set noshowcmd
set noshowmode

" searching
set ignorecase
set smartcase
set incsearch

" let some line between the cursor and the edge of the screen
set scrolloff=3

" menu for tab complete
set wildmenu

set modeline
set modelines=3

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
    let l:errorCount=luaeval("vim.lsp.diagnostic.get_count(0,[[Error]])")
    if l:errorCount != 0
        return l:errorCount
    endif
    return ""
endfun

function! WarningCount() abort
    let l:warningCount=luaeval("vim.lsp.diagnostic.get_count(0,[[Warning]])")
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
