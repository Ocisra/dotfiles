" Plugins ------------------------------ {{{

call plug#begin('~/.config/nvim/plugged')
Plug 'junegunn/vim-plug'

" color scheme
Plug 'morhetz/gruvbox'
set termguicolors
let g:gruvbox_bold=0
let g:gruvbox_italic = 1
let g:gruvbox_contrast_dark='medium'
let g:gruvbox_sign_column='bg0'
"Plug 'sainnhe/gruvbox-material'
"let g:gruvbox_material_better_performance = 1
"let g:gruvbox_material_background = 'medium'
"let g:gruvbox_material_foreground = 'original'

" snippets
Plug 'sirver/ultisnips'
" ugly workaround so ultisnips won't override my mapping of <Tab>
" this won't be fixed by maintainer of ultisnips
let g:UltiSnipsExpandTrigger='<NUL>'
let g:UltiSnipsListSnippets=''
let g:UltiSnipsSnippetDirectories=["UltiSnips", "snippet"]

" auto pair
"Plug 'jiangmiao/auto-pairs'
Plug 'windwp/nvim-autopairs'

" more text objects
Plug 'wellle/targets.vim'

" tree explorer
Plug 'preservim/nerdtree'
let NERDTreeMinimalUI=1
let NERDTreeWinSize=25

" easier commenting
Plug 'preservim/nerdcommenter'

" line for each indentation
Plug 'yggDroot/indentline'

set completeopt=noinsert,noselect,menuone
set shortmess+=c
if has('nvim')
    " completion
    Plug 'hrsh7th/cmp-nvim-lsp', {'branch': 'main'}
    Plug 'hrsh7th/cmp-buffer', {'branch': 'main'}
    Plug 'hrsh7th/cmp-path', {'branch': 'main'}
    Plug 'hrsh7th/cmp-nvim-lsp-signature-help', {'branch': 'main'}
    Plug 'quangnguyen30192/cmp-nvim-ultisnips', {'branch': 'main'}
    "Plug 'hrsh7th/cmp-cmdline', {'branch': 'main'}
    Plug 'hrsh7th/nvim-cmp', {'branch': 'main'}

    " lsp
    Plug 'neovim/nvim-lspconfig'
    let g:diagnostic_insert_delay=1

    " debugger
    "Plug 'mfussenegger/nvim-dap'

    " java
    "Plug 'mfussenegger/nvim-jdtls'    
endif

call plug#end()

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
let g:load_doxygen_syntax=1
let g:doxygen_end_punctuation='[.]$'

" color scheme
set t_Co=256
colorscheme gruvbox
hi NonText guifg=#ff0000
hi link doxygenComment Comment
hi link doxygenBrief GruvboxPurple

" lsp diagnostics
" highlights won't break if the colorscheme is changed but it may not render
" so well
sign define DiagnosticSignError text=>> texthl=ErrorMsg
sign define DiagnosticSignWarn text=-- texthl=WarningMsg
sign define DiagnosticSignInfo text=.. texthl=Question
sign define DiagnosticSignHint text=. texthl=Title

" lsp semantic highlighting
hi link @lsp.type.variable Gruvboxfg1
hi link @lsp.typemod.variable.globalScope GruvboxBlue
hi link @lsp.typemod.variable.readonly GruvboxBlue
hi link @lsp.type.parameter Gruvboxfg1
hi link @lsp.type.property Gruvboxfg1
hi link @lsp.type.namespace GruvboxPurple
hi link @lsp.type.class GruvboxYellow

" nvim-cmp
hi link CmpItemKindDefault GruvboxGray
hi link CmpItemAbbr GruvboxGray 
hi link CmpItemKindText GruvboxAqua
hi link CmpItemKindFunction GruvboxPurple
hi link CmpItemKindKeyword GruvboxRed
hi link CmpItemKindSnippet GruvboxGreen
hi link CmpItemKindVariable GruvboxOrange
hi link CmpItemKindReference GruvboxRed

" nvim-dap
sign define DapBreakpoint text=● texthl=GruvboxRed
sign define DapBreakpointCondition text=© texthl=GruvboxRed
sign define DapBreakpointRejected text=⨂ texthl=GruvboxRed
sign define DapStopped text=→ texthl=GruvboxRed

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

set textwidth=90

" line break not in the middle of a word
set linebreak
set breakindent
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

" latex
let g:tex_flavor='latex'
set conceallevel=2

" }}}
" Scripts ----------------------------- {{{
command RightColumn :source ~/.config/nvim/scripts/right-column.vim
" }}}
" Statusline -------------------------- {{{
set laststatus=2

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
set statusline+=%#TabLineSel#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\ 
"}}}
" Shortcuts --------- ----- -------- ------ {{{
" enable left/right arrow to move to prev/next line
set whichwrap=b,s,<,>,[,]

" leader
let mapleader=","

" remove search highlight
nnoremap <leader>vh :nohl<CR>

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

" nerdtree
nnoremap <leader>m :NERDTreeToggle<CR>
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") && v:this_session == '' | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif

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
nnoremap <leader>= <cmd>lua vim.lsp.buf.format { async = true }<CR>
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
nnoremap <leader>ee <cmd>lua vim.diagnostic.open_float()<CR>
nnoremap <leader>ep <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <leader>en <cmd>lua vim.diagnostic.goto_next()<CR>

inoremap <C-s> <cmd>lua vim.lsp.buf.signature_help()<CR>


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

" dap
noremap <F4> <cmd>lua require'dap'.repl.toggle({height=15})<CR>
noremap <F5> <cmd>lua require'dap'.continue()<CR>
noremap <S-F5> <cmd>lua require'dap'.terminate()<CR>
noremap <F7> <Esc>:!make
noremap <F8> <cmd>lua require'dap'.toggle_breakpoint(vim.fn.input("Condition: "))<CR>
noremap <S-F8> <cmd>lua require'dap'.toggle_breakpoint("",vim.fn.input("Stop at encounter number: "))<CR>
noremap <F9> <cmd>lua require'dap'.toggle_breakpoint()<CR>
noremap <S-F9> <cmd>lua require'dap'.clear_breakpoints()<CR>
noremap <F10> <cmd>lua require'dap'.step_over()<CR>
noremap <F11> <cmd>lua require'dap'.step_into()<CR>
noremap <S-F11> <cmd>lua require'dap'.step_out()<CR>
lua << EOF
--local widgets = require'dap.ui.widgets'
--scope_sb = widgets.sidebar(widgets.scopes)
--vim.api.nvim_set_keymap('n', '<S-F4>', '<cmd>lua scope_sb.toggle()<CR>', {noremap=true,  silent=true})
--frame_sb = widgets.sidebar(widgets.frames)
--vim.api.nvim_set_keymap('n', '<F3>', '<cmd>lua frame_sb.toggle()<CR>', {noremap=true,  silent=true})
--thread_sb = widgets.sidebar(widgets.threads, {width=30}, 'topleft vsplit')
--vim.api.nvim_set_keymap('n', '<S-F3>', '<cmd>lua thread_sb.toggle()<CR>', {noremap=true,  silent=true})
EOF

set langmap=à@,è`

" }}}
" Lua ---------------------------- {{{
if has('nvim')
lua << EOF
-- helpers {{{
function split (str, sep)
   if sep == nil then
      sep = "%s"
   end
   local t={}
   for s in string.gmatch(str, "([^"..sep.."]+)") do
      table.insert(t, s)
   end
   return t
end
-- }}}
-- nvim-dap {{{
--local dap = require'dap'
--dap.defaults.fallback.external_terminal = {
--    command = 'kitty';
--    args = {'-e'};
--}
--dap.adapters = {
--    python = {
--        type = 'executable';
--        command = 'python';
--        args = { '-m', 'debugpy.adapter' };
--    },
--    codelldb = {
--        type = 'server',
--        port = "${port}",
--        executable = {
--            command = '/home/ocisra/build/codelldb-bin/extension/adapter/codelldb',
--            args = {"--port", "${port}"},
--        }
--    }
--}
--dap.configurations = {
--    python = {
--        {
--            -- The first three options are required by nvim-dap
--            type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
--            request = 'launch';
--            name = "Launch";
--            program = "${file}"; -- This configuration will launch the current file if used.
--            env = {SDL_VIDEODRIVER = "x11"};
--        },{
--            -- The first three options are required by nvim-dap
--            type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
--            request = 'launch';
--            name = "Launch (external terminal)";
--            program = "${file}"; -- This configuration will launch the current file if used.
--            terminal = 'external',
--            env = {SDL_VIDEODRIVER = "x11"};
--        },{
--            -- The first three options are required by nvim-dap
--            type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
--            request = 'launch';
--            name = "Launch (args)";
--            program = "${file}"; -- This configuration will launch the current file if used.
--            args = function()
--                return vim.fn.input('Arguments: ')
--            end,
--            env = {SDL_VIDEODRIVER = "x11"};
--        },
--    },
--    cpp = {
--        {
--            name = 'Launch',
--            type = 'codelldb',
--            request = 'launch',
--            program = function()
--                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--            end,
--            cwd = '${workspaceFolder}',
--            args = {},
--            env = {LD_LIBRARY_PATH = "./libs/"},
--        },{
--            name = 'Launch (external terminal)',
--            type = 'codelldb',
--            request = 'launch',
--            program = function()
--                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--            end,
--            cwd = '${workspaceFolder}',
--            args = {},
--            env = {LD_LIBRARY_PATH = "./libs/"},
--            terminal = 'external',
--        },{
--            name = 'Launch (args)',
--            type = 'codelldb',
--            request = 'launch',
--            program = function()
--                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--            end,
--            cwd = '${workspaceFolder}',
--            args = function()
--                return split(vim.fn.input('Arguments: '))
--            end,
--            env = {LD_LIBRARY_PATH = "./libs/"},
--        },
--    },
--    asm = {
--        {
--            name = 'Launch (break _start)',
--            type = 'codelldb',
--            request = 'launch',
--            program = function()
--                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--            end,
--            cwd = '${workspaceFolder}',
--            args = {},
--            -- hack because stopOnEntry does not work
--            -- breakpoints also don't work
--            preRunCommands = {"b _start"},
--        }
--    }
--}
--dap.configurations.c = dap.configurations.cpp
-- }}}
-- nvim-cmp {{{
    local cmp = require'cmp'
    cmp.setup({
        snippet = {
            -- REQUIRED - you must specify a snippet engine
            expand = function(args)
                vim.fn["UltiSnips#Anon"](args.body)
            end,
        },
        mapping = { 
            ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
            ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
            ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
            ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' }),
            ['<C-y>'] = cmp.config.disable,
            ['<C-e>'] = cmp.mapping({
                i = cmp.mapping.abort(),
                c = cmp.mapping.close(),
            }),
            -- Do not accept currently selected item.
            -- Set `select` to `true` to auto select first item.
            ['<CR>'] = cmp.mapping.confirm({ select = false }),
        },
        sources = cmp.config.sources({
            -- { name = 'nvim_lsp_signature_help' }, -- pop up too big
            { name = 'nvim_lsp' },
            { name = 'ultisnips' },
        }, {
            { name = 'buffer' },
        }),
        formatting = {
            format = function(entry, vim_item)
                vim_item.menu = entry:get_completion_item().detail
                return vim_item
            end
        }
    })

    -- Use buffer source for `/` (if you enabled `native_menu`, this won't work).
--    cmp.setup.cmdline('/', {
--        sources = {
--            { name = 'buffer' }
--        }
--    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work).
--    cmp.setup.cmdline(':', {
--        sources = cmp.config.sources({
--            { name = 'path' }
--        }, {
--            { name = 'cmdline' }
--        })
--    })
--- }}}
--- lsp {{{
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text=false,
        }
    )

    local sumneko_root_path = "/home/ocisra/build/lua-language-server"

    require'lspconfig'.pylsp.setup{
        on_attach=on_attach_vim,
        capabilities = capabilities,
        settings = {
            pylsp = {
                plugins = {
                    pycodestyle = {
                            ignore = {'E701', 'E704', 'E116', 'E117', 'E266'},
                            maxLineLength = 100
                    }
                }
            }
        }
    }
    require'lspconfig'.clangd.setup{
        on_attach=on_attach_vim,
        capabilities = capabilities,
    }
    require'lspconfig'.bashls.setup{
        on_attach=on_attach_vim,
        capabilities = capabilities,
    }
    require'lspconfig'.vimls.setup{
        on_attach=on_attach_vim,
        capabilities = capabilities,
    }
    require'lspconfig'.lua_ls.setup{
        on_attach=on_attach_vim,
        capabilities = capabilities,
        cmd={sumneko_root_path .. "/bin/Linux/lua-language-server", "-E", sumneko_root_path .. "/main.lua" },
    }
    require'lspconfig'.texlab.setup{
        on_attach=on_attach_vim,
        capabilities = capabilities,
        settings = {
            texlab = {
                build = {
                    args = { "-interaction=nonstopmode", "-synctex=1", "%f" },
                    executable = "lualatex",
                },
            }
        }
    }
    require'lspconfig'.cssls.setup{
        on_attach=on_attach_vim,
        capabilities=capabilities,
    }
    require'lspconfig'.html.setup{
        on_attach=on_attach_vim,
        capabilities=capabilities,
    }
    require'lspconfig'.eslint.setup{
        on_attach=on_attach_vim,
        capabilities=capabilities,
    }
    require'lspconfig'.phpactor.setup{
        on_attach=on_attach_vim,
        capabilities=capabilities,
    }
--- }}}
--- autopairs {{{
require'nvim-autopairs'.setup {}
local cmp_autopairs = require'nvim-autopairs.completion.cmp'
--cmp.event:on(
  --  'confirm_done',
    --cmp_autopairs.on_confirm_done({
    --filetypes = {
        -- "*" is a alias to all filetypes
      --  ["*"] = {
        --    ["("] = {
          --      kind = {
            --        cmp.lsp.CompletionItemKind.Function,
              --      cmp.lsp.CompletionItemKind.Method,
                --},
          --      handler = handlers["*"]
        --    }
      --  },
    --}
  --  })
--)
--- }}}
EOF
endif
" }}}
" vim:foldmethod=marker:foldlevel=0
