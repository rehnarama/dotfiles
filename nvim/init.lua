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
	-- lazy.nvim
	{
		"folke/snacks.nvim",
		---@type snacks.Config
		opts = {
			dashboard = {

				sections = {
					{ section = "header" },
					{ icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
					{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
					{ section = "startup" },
				}
			}
		}
	},
	{
		"mistweaverco/kulala.nvim",
		ft = { "http", "rest" },
		keys = {
		},
		opts = {
			global_keymaps = true,
		},
	},
	{
		"voldikss/vim-floaterm",

		-- Keys for easy access
		keys = {
			{
				"<M-f>",
				"<cmd>FloatermToggle<cr>",
				mode = { "n", "t" },
				desc = "Toggle Floaterm", -- Description for which-key
			},
		},
	},
	{ "LunarVim/bigfile.nvim", opts = {} },
	{
		"williamboman/mason.nvim",
		opts = {},
	},
	{ 'nvim-lua/plenary.nvim', },
	{
		"MunsMan/kitty-navigator.nvim",
		keys = {
			{ "<M-h>", function() require("kitty-navigator").navigateLeft() end,  desc = "Move left a Split",  mode = { "n" } },
			{ "<M-j>", function() require("kitty-navigator").navigateDown() end,  desc = "Move down a Split",  mode = { "n" } },
			{ "<M-k>", function() require("kitty-navigator").navigateUp() end,    desc = "Move up a Split",    mode = { "n" } },
			{ "<M-l>", function() require("kitty-navigator").navigateRight() end, desc = "Move right a Split", mode = { "n" } },
		},
		build = {
			"cp navigate_kitty.py ~/.config/kitty",
			"cp pass_keys.py ~/.config/kitty",
		},
	},
	{
		'nvim-pack/nvim-spectre',
		keys = {
			{
				"<leader>S",
				function()
					require("spectre").toggle()
				end,
			},
			{
				"<leader>sw",
				function()
					require("spectre").open_visual({ select_word = true })
				end,
			},
			{
				"<leader>sw",
				function()
					require("spectre").open_visual()
				end,
				mode = "v"
			},
			{
				"<leader>sp",
				function()
					require("spectre").open_file_search({ select_word = true })
				end,
			},
		},
		dependencies = { 'nvim-lua/plenary.nvim' },
	},
	{
		'neovim/nvim-lspconfig',
		dependencies = { 'saghen/blink.cmp' },

		-- example using `opts` for defining servers
		opts = {
			servers = {
				ts_ls = {
					init_options = {
						maxTsServerMemory = 4096
					}
				},
				eslint = {},
				qmlls = {
					cmd = { "qmlls6" }
				},
				cssls = {},
				rust_analyzer = {},
				graphql = {},
				clangd = {},
				java_language_server = {},
				pyright = {},
				ruff = {},
				omnisharp = {
					cmd = { "/home/astrid/.local/share/nvim/mason/packages/omnisharp/omnisharp" },
				},
				-- csharp_ls = {},
				biome = {
					cmd = { "npx", "biome", "lsp-proxy" }
				},
				jsonls = {},
				bashls = {},
				lua_ls = {
					-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
					on_init = function(client)
						if client.workspace_folders then
							local path = client.workspace_folders[1].name
							if path ~= vim.fn.stdpath('config') and (vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc')) then
								return
							end
						end

						client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
							runtime = {
								-- Tell the language server which version of Lua you're using
								-- (most likely LuaJIT in the case of Neovim)
								version = 'LuaJIT'
							},
							-- Make the server aware of Neovim runtime files
							workspace = {
								checkThirdParty = false,
								library = {
									vim.env.VIMRUNTIME
									-- Depending on the usage, you might want to add additional paths here.
									-- "${3rd}/luv/library"
									-- "${3rd}/busted/library",
								}
								-- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
								-- library = vim.api.nvim_get_runtime_file("", true)
							}
						})
					end,
					settings = {
						Lua = {}
					}
				}
			}
		},
		config = function(_, opts)
			local on_attach = function(client, bufnr)
				-- Use treesitter, disable highlighting from LSP
				-- client.server_capabilities.semanticTokensProvider = nil

				-- Enable completion triggered by <c-x><c-o>
				-- vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

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

			local lspconfig = require('lspconfig')
			for server, config in pairs(opts.servers) do
				-- passing config.capabilities to blink.cmp merges with the capabilities in your
				-- `opts[server].capabilities, if you've defined it
				config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
				config.on_attach = on_attach
				lspconfig[server].setup(config)
			end
		end,

		-- example calling setup directly for each LSP
	},
	"onsails/lspkind.nvim",
	{
		"lewis6991/gitsigns.nvim",
		opts = {},
	},
	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},
	"mfussenegger/nvim-dap",
	{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform will run multiple formatters sequentially
				python = { "ruff_organize_imports", "ruff_format" },
				-- Use a sub-list to run only the first available formatter
				json = { "prettierd", "prettier", stop_after_first = true },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				javascriptreact = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "prettierd", "prettier", stop_after_first = true },
				cs = { "csharpier" }
			},
		},
	},
	--	{
	--		"rcarriga/nvim-notify",
	--		keys = {
	--			{
	--				"<leader><Esc>",
	--				function()
	--					require("notify").dismiss({ silent = true, pending = true })
	--				end,
	--				desc = "Dismiss all Notifications",
	--			},
	--		},
	--		opts = {
	--			timeout = 3000,
	--			max_height = function()
	--				return math.floor(vim.o.lines * 0.75)
	--			end,
	--			max_width = function()
	--				return math.floor(vim.o.columns * 0.75)
	--			end,
	--			on_open = function(win)
	--				vim.api.nvim_win_set_config(win, { zindex = 100 })
	--			end,
	--			stages = "static",
	--		},
	--	},
	"stevearc/dressing.nvim",
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			-- calling `setup` is optional for customization
			require("fzf-lua").setup({
				previewers = {
					builtin = {
						extensions = {
							["png"] = { "ueberzugpp" },
							["jpg"] = { "ueberzugpp" },
							["jpeg"] = { "ueberzugpp" },
							["gif"] = { "ueberzugpp" },
							["webp"] = { "ueberzugpp" },
						},
						ueberzug_scaler = "fit_contain",
					}
				}
			})
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
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		opts = {
			enable_autocmd = false,
		}
	},
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
		opts = {
			default_file_explorer = true,
			watch_for_changes = true
		},
		cmd = "Oil",
		main = "oil",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = false
	},
	"tpope/vim-abolish",
	{
		"lukas-reineke/virt-column.nvim",
		opts = {
			char = "│",
			config = {
				highlight = "hl-IblIndent",
			},
		},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		---@module "ibl"
		---@type ibl.config
		opts = {
			exclude = {
				filetypes = { "dashboard" }
			}
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
	{
		'saghen/blink.cmp',
		-- optional: provides snippets for the snippet source
		dependencies = 'rafamadriz/friendly-snippets',

		-- use a release tag to download pre-built binaries
		version = '0.11.0',
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' for mappings similar to built-in completion
			-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
			-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
			-- See the full "keymap" documentation for information on defining your own keymap.
			keymap = {
				preset = 'super-tab',
			},

			appearance = {
				-- Sets the fallback highlight groups to nvim-cmp's highlight groups
				-- Useful for when your theme doesn't support blink.cmp
				-- Will be removed in a future release
				use_nvim_cmp_as_default = true,
				-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = 'normal'
			},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { 'lsp', 'path', 'snippets', 'buffer' },
			},

			signature = { enabled = true },

			completion = {
				menu = {
					auto_show = true,

					-- nvim-cmp style menu
					draw = {
						columns = {
							{ "label",     "label_description", gap = 1 },
							{ "kind_icon", "kind" }
						},
					}
				},


				-- Show documentation when selecting a completion item
				documentation = { auto_show = true },

				-- Display a preview of the selected item on the current line
				ghost_text = { enabled = false },
			}
		},
		opts_extend = { "sources.default" }
	}
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
vim.keymap.set("n", "<C-K>", dapui.eval)

-- Telescope

local fzflua = require("fzf-lua")
vim.keymap.set("n", "<C-p>", fzflua.files, { silent = true })
vim.keymap.set("n", "<C-f>", fzflua.live_grep, { silent = true })
vim.keymap.set("v", "<C-f>", fzflua.grep_visual, { silent = true })
vim.keymap.set("n", "<C-l>", fzflua.buffers, { silent = true })

vim.keymap.set("n", "gd", function()
	fzflua.lsp_definitions({ jump1 = true, async_or_timeout = 10000 })
end, {})
vim.keymap.set("n", "gD", function()
	fzflua.lsp_typedefs({ jump1 = true, async_or_timeout = 10000 })
end, {})
vim.keymap.set("n", "gi", function()
	fzflua.lsp_implementations({ jump1 = true, async_or_timeout = 10000 })
end, {})
vim.keymap.set("n", "gr", function()
	fzflua.lsp_references({ jump1 = true, async_or_timeout = 10000 })
end, {})

vim.keymap.set("n", "<leader><space>", fzflua.lsp_workspace_symbols, {})

vim.keymap.set("n", "<leader><leader>", fzflua.builtin, {})

vim.keymap.set("n", "<C-space>", fzflua.resume, {})


vim.diagnostic.config({
	virtual_text = {
		current_line = true
	},
	virtual_lines = false,
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
vim.keymap.set(
	"t",                         -- Mode: "t" for terminal mode
	"<Esc><Esc>",                -- The key sequence to trigger the mapping
	"<C-\\><C-n>",               -- The command to execute: exit terminal mode to normal mode
	{
		desc = "Exit terminal mode", -- Description for which-key or other plugins
		noremap = true,          -- Use non-recursive mapping
		silent = true,           -- Don't show the command in the command line
	}
)


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

vim.opt.title = true

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
	vim.o.guifont = "CaskaydiaCove Nerd Font:h13"
	vim.g.neovide_cursor_trail_size = 0.2

	local pyenv = require("pyenv-neovide")
	pyenv.setup({})

	local nvm = require("nvm-neovide")
	nvm.setup({
		default_node_version = "v22.13.1"
	})
end

vim.api.nvim_create_autocmd("VimLeave", {
	pattern = "*",
	command = "silent !zellij action switch-mode normal"
})
