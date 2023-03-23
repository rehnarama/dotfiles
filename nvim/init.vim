


call plug#begin()
" Make sure you use single quotes

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp', { 'branch': 'main' }
Plug 'hrsh7th/cmp-buffer', { 'branch': 'main' }
Plug 'hrsh7th/cmp-path', { 'branch': 'main' }
Plug 'hrsh7th/cmp-cmdline', { 'branch': 'main' }
Plug 'hrsh7th/nvim-cmp', { 'branch': 'main' }

Plug 'jose-elias-alvarez/null-ls.nvim', { 'branch': 'main' }
Plug 'MunifTanjim/prettier.nvim', { 'branch': 'main' }

Plug 'RRethy/vim-illuminate'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'natecraddock/telescope-zf-native.nvim'

Plug 'stevearc/dressing.nvim'

Plug 'olimorris/onedarkpro.nvim'
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

" Plug 'sheerun/vim-polyglot'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

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
colorscheme onelight

" So that we exit terminal-mode with escape
tnoremap <Esc> <C-\><C-n>

" This makes vim more reliably with tools that detect changes on save
set backupcopy=yes

" Set the terminal title when opening file in buffer
set title

lua <<EOF
  require'nvim-treesitter.configs'.setup {
    ensure_installed = "all", -- one of "all"  (parsers with maintainers), or a list of languages
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
" set wildoptions=pum
" set pumblend=15

" Split on the other side
set splitbelow
set splitright

set mouse=a

" Key bind make -s
nmap <leader>mk :make -s<cr>

" Start with no folds closed
set foldlevelstart=99


""""""""""" telescope config

lua <<EOF

local builtin = require('telescope.builtin')
local telescope = require('telescope')
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<C-g>', builtin.live_grep, {})
vim.keymap.set('n', '<C-f>', builtin.current_buffer_fuzzy_find, {})
vim.keymap.set('n', '<C-l>', builtin.buffers, {})
vim.keymap.set('n', '<C-h>', builtin.help_tags, {})

vim.keymap.set('n', 'gd', builtin.lsp_definitions, {})
vim.keymap.set('n', '<leader>D', builtin.lsp_type_definitions, {})
vim.keymap.set('n', 'gi', builtin.lsp_implementations, {})
vim.keymap.set('n', 'gr', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>e', builtin.diagnostics, {})

vim.keymap.set('n', '<leader><space>', builtin.lsp_workspace_symbols, {})

vim.keymap.set('n', '<leader><leader>', builtin.builtin, {})

telescope.setup({
	defaults = {
		path_display = { "truncate" }
	}
})

telescope.load_extension("zf-native")

EOF


"""""""""""" LSP Config

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

lua <<EOF
  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      -- { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  -- vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)

	vim.api.nvim_create_autocmd("CursorHold", {
	  buffer = bufnr,
	  callback = function()
	    local opts = {
	      focusable = false,
	      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
	      border = 'rounded',
	      source = 'always',
	      prefix = ' ',
	      scope = 'cursor',
	    }
	    vim.diagnostic.open_float(nil, opts)
	  end
	})

end
  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['tsserver'].setup {
    capabilities = capabilities,
    on_attach = on_attach
  }
  require('lspconfig')['rust_analyzer'].setup {
    capabilities = capabilities,
    on_attach = on_attach
  }
  require('lspconfig')['clangd'].setup {
    capabilities = capabilities,
    on_attach = on_attach
  }

local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        -- null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.formatting.prettier
    },
})

EOF

set updatetime=1000


""""""""""" Easy align configuration
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(LiveEasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(LiveEasyAlign)



""" VIM FUGITIVE

let g:fubitive_domain_pattern = 'stash\.int\.klarna\.net'


