

let plugdir = '~/.config/nvim/plugged'

call plug#begin(plugdir)
" Make sure you use single quotes

Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'neovim/nvim-lspconfig'
"Plug 'nvim-lua/completion-nvim'
"Plug 'hrsh7th/nvim-compe'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'sonph/onehalf', { 'rtp': 'vim' }

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" For easier (de)surrounding of text objects with operators
Plug 'tpope/vim-surround'

" Toggle comments with an operator, 'gc'
Plug 'tpope/vim-commentary'

" Repeat un-repeatable things with '.'
Plug 'tpope/vim-repeat'

" An improved netrw fork 
Plug 'tpope/vim-vinegar'

" Editorconfig plugin
Plug 'editorconfig/editorconfig-vim'

" Plug 'sheerun/vim-polyglot'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'petrbroz/vim-glsl'

Plug 'honza/vim-snippets'

Plug 'tpope/vim-fugitive'
Plug 'tommcdo/vim-fubitive'

Plug 'wellle/targets.vim'

" Initialize plugin system
call plug#end()

" Report that we have true color terminal
set termguicolors
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
" set guifont=Cascadia\ Code:h13
colorscheme onehalflight

" So that we exit terminal-mode with escape
tnoremap <Esc> <C-\><C-n>

" This makes vim more reliably with tools that detect changes on save
set backupcopy=yes

if has('nvim-0.5')

lua <<EOF
  require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = {
      enable = true,              -- false will disable the whole extension
      use_languagetree = true, -- Use this to enable language injection
    },
    indent = {
      enable = true
    },  
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },
    textobjects = { enable = true }
  }
EOF

  set foldmethod=expr
  set foldexpr=nvim_treesitter#foldexpr()

endif


" Set leader and localleader to comma
let mapleader = ","
let maplocalleader = ","

nnoremap <leader>cd :cd %:p:h<CR>

" Remove highlight with leader+enter
nnoremap <leader><CR> :noh<CR>

" Make scrolling happen when 5 characters from top/bottom/left/right
set scrolloff=5
set sidescrolloff=5

" Use hidden buffers
set hidden

" Ignore casing in search/replace/etc.
set ignorecase
" Overrides ignore case if it contains upper case character
set smartcase

" Allow hidden buffers
set hidden

" Show realtime effect of substitute commands
set inccommand=nosplit

" Try to guess what indent level next row should have
set smartindent

" Set tab to spaces
set tabstop=2
set shiftwidth=2
set expandtab

" Set line numbers
set number
" But turn it off in terminal windows!
augroup TerminalStuff
  autocmd TermOpen * setlocal nonumber norelativenumber
augroup END

" Set a colored column at column 80
set colorcolumn=80

set wrap
set linebreak
set textwidth=80

" Ignore setting
set wildignore=.git,node_modules,.meteor,*.min.*,OneDrive

" Wild menu uses popup menu, which is a bit blended
if has('nvim-0.4')
  set wildoptions=pum
  set pumblend=15
endif

" Split on the other side
set splitbelow
set splitright

set mouse=a

" Key bind make -s
nmap <leader>mk :make -s<cr>

" Unfortunately, to enable markdown folding we have to put this here
" Since it doesn't work to put it in ftplugin markdown for some reason
let g:markdown_folding=1

" Start with no folds closed
set foldlevelstart=99


""""""""""" telescope config
nnoremap <C-p> <cmd>Telescope find_files<cr>
nnoremap <C-f> <cmd>Telescope live_grep<cr>
nnoremap <C-l> <cmd>Telescope buffers<cr>

"""""""""""" LSP Config

"" Set completeopt to have a better completion experience
"set completeopt=menuone,noinsert,noselect
"
"lua << EOF
"local nvim_lsp = require('lspconfig')
"
"-- Use an on_attach function to only map the following keys 
"-- after the language server attaches to the current buffer
"local on_attach = function(client, bufnr)
"  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
"  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
"
"  --Enable completion triggered by <c-x><c-o>
"  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
"
"  -- Mappings.
"  local opts = { noremap=false, silent=true }
"
"  -- See `:help vim.lsp.*` for documentation on any of the below functions
"  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
"  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
"  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
"  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
"  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
"  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
"  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
"  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
"  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
"  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
"  buf_set_keymap('n', '<leader>ac', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
"  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
"  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
"  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
"  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
"  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
"  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
"
"end
"
"-- Use a loop to conveniently call 'setup' on multiple servers and
"-- map buffer local keybindings when the language server attaches
"local servers = { "tsserver" }
"for _, lsp in ipairs(servers) do
"  nvim_lsp[lsp].setup { on_attach = on_attach }
"end
"EOF

"""""""""" Coc configuration


" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
				\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` for navigate diagnostics
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

autocmd CursorHold * silent call CocActionAsync('highlight')


" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
vmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use `:Format` for format current buffer
command! -nargs=0 Format :call CocAction('format')
nmap <leader>fa :Format<CR>

" Use `:Fold` for fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>



""""""""""" Easy align configuration
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(LiveEasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(LiveEasyAlign)



""" VIM FUGITIVE

let g:fubitive_domain_pattern = 'stash\.int\.klarna\.net'


