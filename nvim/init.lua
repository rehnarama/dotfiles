local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ","
vim.g.maplocalleader = ","

require("lazy").setup({
	{ "williamboman/mason.nvim", opts = {} },
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason.nvim" },
		opts = {
			ensure_installed = {
				"lua-language-server",
				"stylua",
				"shellcheck",
				"editorconfig-checker",
				-- "misspell",
				"shfmt",
				"prettierd",
				"codelldb",
				"css-lsp",
				"rust-analyzer",
				"graphql-language-service-cli",
				"clangd",
				"jedi-language-server",
				"typescript-language-server",
				-- "java-language-server",
				"eslint_d",
				"eslint-lsp",
			},
			auto_update = false,
			run_on_start = true,
			start_delay = 3000, -- 3 second delay
			debounce_hours = 5, -- at least 5 hours between attempts to install/update
		},
	},
	{
		"mfussenegger/nvim-lint",
		main = "lint",
		dependencies = { "mason.nvim" },
		opts = {
			-- Event to trigger linters
			events = { "BufWritePost", "BufReadPost", "InsertLeave" },
			linters_by_ft = {},
		},
		config = function(_, opts)
			local lint = require("lint")
			lint.linters_by_ft = opts.linters_by_ft

			vim.api.nvim_create_autocmd(opts.events, {
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},
	{ "folke/neoconf.nvim", cmd = "Neoconf" },
	{
		"folke/neodev.nvim",
		opts = {
			library = { plugins = { "nvim-dap-ui" }, types = true },
		},
	},
	"neovim/nvim-lspconfig",
	"onsails/lspkind.nvim",
	{
		"lewis6991/gitsigns.nvim",
		opts = {},
	},
	{ "hrsh7th/cmp-nvim-lsp", branch = "main" },
	{ "hrsh7th/cmp-buffer", branch = "main" },
	{ "hrsh7th/cmp-path", branch = "main" },
	{ "hrsh7th/cmp-cmdline", branch = "main" },
	{ "hrsh7th/cmp-calc", branch = "main" },
	{ "hrsh7th/nvim-cmp", branch = "main" },
	"folke/trouble.nvim",
	"mfussenegger/nvim-dap",
	{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		config = function()
			require("dashboard").setup({
				theme = "doom",
				config = {
					center = {
						{
							action = "Telescope find_files",
							desc = " Find file",
							icon = " ",
							key = "f",
						},
						{
							action = "ene | startinsert",
							desc = " New file",
							icon = " ",
							key = "n",
						},
						{
							action = "Telescope oldfiles",
							desc = " Recent files",
							icon = " ",
							key = "r",
						},
						{
							action = "Telescope live_grep",
							desc = " Find text",
							icon = " ",
							key = "g",
						},
						{
							action = "e $MYVIMRC",
							desc = " Config",
							icon = " ",
							key = "c",
						},
						{
							action = 'lua require("persistence").load()',
							desc = " Restore Session",
							icon = " ",
							key = "s",
						},
						{
							action = "qa",
							desc = " Quit",
							icon = " ",
							key = "q",
						},
					},
				},
			})
		end,
		dependencies = { { "nvim-tree/nvim-web-devicons" } },
	},
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = { options = vim.opt.sessionoptions:get() },
		keys = {
			{
				"<leader>qs",
				function()
					require("persistence").load()
				end,
				desc = "Restore Session",
			},
			{
				"<leader>ql",
				function()
					require("persistence").load({ last = true })
				end,
				desc = "Restore Last Session",
			},
			{
				"<leader>qd",
				function()
					require("persistence").stop()
				end,
				desc = "Don't Save Current Session",
			},
		},
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform will run multiple formatters sequentially
				python = { "ruff_organize_imports", "ruff_format" },
				-- Use a sub-list to run only the first available formatter
				json = { { "prettierd", "prettier" } },
				javascript = { { "prettierd", "prettier" } },
				javascriptreact = { { "prettierd", "prettier" } },
				typescript = { { "prettierd", "prettier" } },
				typescriptreact = { { "prettierd", "prettier" } },
			},
		},
	},
	{
		"rcarriga/nvim-notify",
		keys = {
			{
				"<leader><Esc>",
				function()
					require("notify").dismiss({ silent = true, pending = true })
				end,
				desc = "Dismiss all Notifications",
			},
		},
		opts = {
			timeout = 3000,
			max_height = function()
				return math.floor(vim.o.lines * 0.75)
			end,
			max_width = function()
				return math.floor(vim.o.columns * 0.75)
			end,
			on_open = function(win)
				vim.api.nvim_win_set_config(win, { zindex = 100 })
			end,
			stages = "static",
		},
	},
	{ "MunifTanjim/nui.nvim", lazy = true },
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
		config = function(_, opts)
			opts.sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = {
					"progress",
					{
						-- Show @recording message: https://github.com/folke/noice.nvim/wiki/Configuration-Recipes#show-recording-messages
						require("noice").api.statusline.mode.get,
						cond = require("noice").api.statusline.mode.has,
						color = { fg = "#ff9e64" },
					},
				},
				lualine_z = { "location" },
			}
			opts.options = {
				always_divide_middle = false,
			}

			opts.tabline = {
				lualine_a = {
					{
						"tabs",
						max_length = vim.o.columns,
						mode = 1,
						show_modified_status = false,
						fmt = function(_name, context)
							local winnr = vim.fn.tabpagewinnr(context.tabnr)

							local twd = vim.fn.getcwd(winnr, context.tabnr)
							local tail = vim.fn.fnamemodify(twd, ":t")

							return tail
						end,
					},
				},
			}
			require("lualine").setup(opts)
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "%d+L, %d+B" },
							{ find = "; after #%d+" },
							{ find = "; before #%d+" },
						},
					},
					view = "mini",
				},
			},
			presets = {
				bottom_search = false,
				command_palette = true,
				long_message_to_split = true,
			},
		},
		keys = {
			{
				"<S-Enter>",
				function()
					require("noice").redirect(vim.fn.getcmdline())
				end,
				mode = "c",
				desc = "Redirect Cmdline",
			},
			{
				"<leader>snl",
				function()
					require("noice").cmd("last")
				end,
				desc = "Noice Last Message",
			},
			{
				"<leader>snh",
				function()
					require("noice").cmd("history")
				end,
				desc = "Noice History",
			},
			{
				"<leader>sna",
				function()
					require("noice").cmd("all")
				end,
				desc = "Noice All",
			},
			{
				"<leader>snd",
				function()
					require("noice").cmd("dismiss")
				end,
				desc = "Dismiss All",
			},
			{
				"<c-f>",
				function()
					if not require("noice.lsp").scroll(4) then
						return "<c-f>"
					end
				end,
				silent = true,
				expr = true,
				desc = "Scroll forward",
				mode = { "i", "n", "s" },
			},
			{
				"<c-b>",
				function()
					if not require("noice.lsp").scroll(-4) then
						return "<c-b>"
					end
				end,
				silent = true,
				expr = true,
				desc = "Scroll backward",
				mode = { "i", "n", "s" },
			},
		},
	},
	"RRethy/vim-illuminate",
	"nvim-lua/popup.nvim",
	"nvim-lua/plenary.nvim",
	"stevearc/dressing.nvim",
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			-- calling `setup` is optional for customization
			require("fzf-lua").setup({})
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			integrations = {
				aerial = true,
				alpha = true,
				cmp = true,
				dashboard = true,
				flash = true,
				gitsigns = true,
				headlines = true,
				illuminate = true,
				indent_blankline = { enabled = true },
				leap = true,
				lsp_trouble = true,
				mason = true,
				markdown = true,
				mini = true,
				native_lsp = {
					enabled = true,
					underlines = {
						errors = { "undercurl" },
						hints = { "undercurl" },
						warnings = { "undercurl" },
						information = { "undercurl" },
					},
				},
				navic = { enabled = true, custom_bg = "lualine" },
				neotest = true,
				neotree = true,
				noice = true,
				notify = true,
				semantic_tokens = true,
				telescope = true,
				treesitter = true,
				treesitter_context = true,
				which_key = true,
			},
		},
	},
	"junegunn/vim-easy-align",
	{ "JoosepAlviste/nvim-ts-context-commentstring", opts = {
		enable_autocmd = false,
	} },
	"tpope/vim-sleuth",
	"tpope/vim-surround",
	{
		"numToStr/Comment.nvim",
		opts = {},
		lazy = false,
		config = function(_, opts)
			opts.pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
			require("Comment").setup(opts)
		end,
	},
	"tpope/vim-repeat",
	{
		"stevearc/oil.nvim",
		opts = {},
		cmd = "Oil",
		main = "oil",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	"tpope/vim-abolish",
	"L3MON4D3/LuaSnip",
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			exclude = {
				filetypes = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
				},
			},
		},
	}, -- Update plugins on update
	{
		"lukas-reineke/virt-column.nvim",
		main = "virt-column",
		opts = {
			char = "│",
			config = {
				highlight = "hl-IblIndent",
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "VeryLazy" },
		init = function(plugin)
			-- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
			-- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
			-- no longer trigger the **nvim-treeitter** module to be loaded in time.
			-- Luckily, the only thins that those plugins need are the custom queries, which we make available
			-- during startup.
			require("lazy.core.loader").add_to_rtp(plugin)
			require("nvim-treesitter.query_predicates")
		end,
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		keys = {
			{
				"<c-space>",
				desc = "Increment selection",
			},
			{
				"<bs>",
				desc = "Decrement selection",
				mode = "x",
			},
		},
		---@type TSConfig
		---@diagnostic disable-next-line: missing-fields
		opts = {
			highlight = {
				enable = true,
			},
			indent = {
				enable = true,
			},
			ensure_installed = "all",
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
			textobjects = {
				enable = true,
			},
		},
		---@param opts TSConfig
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	"tpope/vim-fugitive",
	"tpope/vim-rhubarb",
	"nvim-tree/nvim-web-devicons",
})

-- Colorscheme
vim.opt.termguicolors = true
vim.cmd("colorscheme catppuccin-latte")

-- Filetype configs
vim.filetype.add({
	extension = {
		pipeline = "pipeline",
	},
})

-- Oil
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- dap
local dap = require("dap")
local dapui = require("dapui")

dapui.setup()

dap.adapters.lldb = {
	type = "executable",
	command = "/usr/bin/lldb-vscode", -- adjust as needed, must be absolute path
	name = "lldb",
}

dap.configurations.cpp = {
	{
		name = "Launch",
		type = "lldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		args = {},

		-- 💀
		-- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
		--
		--    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
		--
		-- Otherwise you might get the following error:
		--
		--    Error on launch: Failed to attach to the target process
		--
		-- But you should be aware of the implications:
		-- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
		-- runInTerminal = false,
	},
}

vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
vim.keymap.set("n", "<leader>c", dap.continue)
vim.keymap.set("n", "<leader>so", dap.step_over)
vim.keymap.set("n", "<leader>si", dap.step_into)
vim.keymap.set("n", "<leader>d", dap.repl.open)
vim.keymap.set("n", "<M-k>", dapui.eval)

-- Telescope

local fzflua = require("fzf-lua")
vim.keymap.set("n", "<C-p>", fzflua.files, {})
vim.keymap.set("n", "<C-f>", fzflua.live_grep, {})
vim.keymap.set("n", "<C-l>", fzflua.buffers, {})

vim.keymap.set("n", "gd", function()
	fzflua.lsp_definitions({ jump_to_single_result = true })
end, {})
vim.keymap.set("n", "gD", function()
	fzflua.lsp_typedefs({ jump_to_single_result = true })
end, {})
vim.keymap.set("n", "gi", function()
	fzflua.lsp_implementations({ jump_to_single_result = true })
end, {})
vim.keymap.set("n", "gr", function()
	fzflua.lsp_references({ jump_to_single_result = true })
end, {})

vim.keymap.set("n", "<leader><space>", fzflua.lsp_workspace_symbols, {})

vim.keymap.set("n", "<leader><leader>", fzflua.builtin, {})

vim.keymap.set("n", "<C-space>", fzflua.resume, {})

-- Trouble

local trouble = require("trouble")
trouble.setup({
	auto_preview = false,
})
vim.keymap.set("n", "<leader>xx", function()
	require("trouble").toggle()
end)
vim.keymap.set("n", "<leader>xw", function()
	require("trouble").toggle("workspace_diagnostics")
end)
vim.keymap.set("n", "<leader>xd", function()
	require("trouble").toggle("document_diagnostics")
end)
vim.keymap.set("n", "<leader>xq", function()
	require("trouble").toggle("quickfix")
end)
vim.keymap.set("n", "<leader>xl", function()
	require("trouble").toggle("loclist")
end)
vim.keymap.set("n", "gR", function()
	require("trouble").toggle("lsp_references")
end)

-- nvim-cmp
local cmp = require("cmp")
local lspkind = require("lspkind")
local luasnip = require("luasnip")

-- Utility for super tab
local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
				-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
				-- that way you will only jump inside the snippet region
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "path" },
		{ name = "luasnip" }, -- For luasnip users.
		{ name = "calc" },
	}, {
		{ name = "buffer" },
	}),
	window = {
		--completion = {
		--  winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
		--  col_offset = -3,
		--  side_padding = 0,
		--},
		-- documentation = cmp.config.window.bordered(),
	},
	formatting = {
		fields = { "kind", "abbr", "menu" },
		expandable_indicator = true,
		format = function(entry, vim_item)
			local kind =
				lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50, ellipsis_char = "…" })(entry, vim_item)

			local strings = vim.split(kind.kind, "%s", { trimempty = true })
			kind.kind = " " .. (strings[1] or "") .. " "
			kind.menu = "    (" .. (strings[2] or "") .. ")"

			return kind
		end,
	},
})

-- Lsp Config
local on_attach = function(client, bufnr)
	-- Use treesitter, disable highlighting from LSP
	client.server_capabilities.semanticTokensProvider = nil

	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
	vim.keymap.set("v", "<leader>ca", vim.lsp.buf.code_action, bufopts)
	local float_opts = {
		focusable = true,
		close_events = {
			--"BufLeave",
			"CursorMoved",
			"InsertEnter",
			"FocusLost",
		},
		border = "rounded",
		source = "always",
		prefix = " ",
		scope = "cursor",
	}

	vim.keymap.set("n", "<C-k>", function()
		vim.diagnostic.open_float(float_opts)
	end, bufopts)
end
-- Set up lspconfig.

local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require("lspconfig")["tsserver"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})
require("lspconfig")["eslint"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})
require("lspconfig")["cssls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})
require("lspconfig")["rust_analyzer"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})
require("lspconfig")["graphql"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})
require("lspconfig")["clangd"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})
require("lspconfig")["java_language_server"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})
require("lspconfig")["pyright"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})
require("lspconfig")["ruff"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	update_in_insert = true,
	severity_sort = true,
})

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Folds

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false -- disable fold at startup

-- Custom keymaps
vim.keymap.set("n", "<leader><CR>", "<CMD>noh<CR>")
vim.keymap.set("x", "ga", "<Plug>(LiveEasyAlign)")
vim.keymap.set("n", "ga", "<Plug>(LiveEasyAlign)")

-- Custom commands

vim.api.nvim_create_user_command("Format", function(args)
	local range = nil
	if args.count ~= -1 then
		local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
		range = {
			start = { args.line1, 0 },
			["end"] = { args.line2, end_line:len() },
		}
	end
	require("conform").format({ async = true, lsp_fallback = true, range = range })
end, { range = true })

vim.keymap.set("n", "<leader>f", "<CMD>Format<CR>")
vim.keymap.set("v", "<leader>f", "<CMD>Format<CR>")

-- General settings
vim.opt.backupcopy = "yes"
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5

vim.opt.hidden = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "nosplit"
vim.opt.smartindent = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.number = true

vim.opt.colorcolumn = "80"
vim.opt.wrap = true
vim.opt.linebreak = true

vim.opt.wildignore = ".git,node_modules,.meteor,*.min.*,OneDrive"

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.list = true
vim.opt.listchars = "trail:-,nbsp:+,space: ,tab:║ ,"

vim.opt.completeopt = "menuone,noselect"

vim.opt.updatetime = 1000

-- Neovide/gui config
if vim.g.neovide then
	vim.o.guifont = "CaskaydiaCove Nerd Font:h12" -- text below applies for VimScript
	vim.g.neovide_cursor_trail_size = 0.2
end
