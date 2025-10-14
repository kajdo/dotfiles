--=============================================================================
-- NEOVIM CONFIGURATION - KICKSTART BASE WITH CUSTOM MODIFICATIONS
--=============================================================================
-- This config is based on kickstart.nvim with personal customizations
-- For help: :help <topic> or https://neovim.io/doc/
--=============================================================================

--=============================================================================
-- GUI specific configs
--=============================================================================
if vim.g.neovide then
  -- set a nerd font
  vim.opt.guifont = "CaskaydiaMono NFM:h14"
  -- Remap Ctrl+V in Command-line mode (c) to paste from the system register (+)
  vim.keymap.set('c', '<C-v>', '<C-r>+', {desc = 'Paste from system clipboard in command-line mode'})
  -- Remap Ctrl+V in Insert mode (i) to paste from the system register (+)
  vim.keymap.set('i', '<C-v>', '<C-r>+', {desc = 'Paste from system clipboard in insert mode'})
end


--=============================================================================
-- SETUP for wsl and/or neovide
--=============================================================================
-- Detect if wsl or ubuntu - to enable mason
-- Check for common environment variables present in WSL/Ubuntu but not NixOS
-- You can pick the most reliable one for your setup.
local is_wsl_ubuntu = (os.getenv("WSL_DISTRO_NAME") == "Ubuntu" or os.getenv("IS_WSL"))

-- Set the global variable used by the mason plugin config
if is_wsl_ubuntu then
	vim.g.enable_mason_on_wsl = true
	-- Optional: Set a flag to help with package location
	vim.g.package_manager = "mason"
else
	vim.g.enable_mason_on_wsl = false
	vim.g.package_manager = "nixos"
end

--=============================================================================
-- BASIC SETUP & LEADER KEY
--=============================================================================
-- Set leader keys before anything else (plugins use these)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Enable Nerd Font support for icons
vim.g.have_nerd_font = true

--=============================================================================
-- CORE EDITOR OPTIONS
--=============================================================================
-- Line numbers and cursor
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

-- UI/UX improvements
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 10

-- Search behavior
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- File handling
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Window splitting
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Whitespace visualization
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Live substitution preview
vim.opt.inccommand = "split"

--=============================================================================
-- BASIC KEYMAPS
--=============================================================================
-- Clear search highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic quickfix
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Terminal mode escape
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Disable arrow keys (force hjkl usage)
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

--=============================================================================
-- AUTOCOMMANDS
--=============================================================================
-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

--=============================================================================
-- PLUGIN MANAGER SETUP (LAZY.NVIM)
--=============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

--=============================================================================
-- PLUGIN CONFIGURATIONS
--=============================================================================
require("lazy").setup({
	--=============================================================================
	-- ESSENTIAL PLUGINS
	--=============================================================================

	-- Auto-detect indentation settings
	"tpope/vim-sleuth",

	--=============================================================================
	-- FILE EXPLORATION & SEARCH
	--=============================================================================

	{ -- Fuzzy finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			require("telescope").setup({
				defaults = {
					mappings = {
						i = { ["<C-c>"] = require("telescope.actions").close },
						n = { ["<C-c>"] = require("telescope.actions").close },
					},
				},
				extensions = {
					["ui-select"] = { require("telescope.themes").get_dropdown() },
				},
			})

			-- Load extensions
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			-- Keymaps
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
			vim.keymap.set("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })
			vim.keymap.set("n", "<leader>s/", function()
				builtin.live_grep({ grep_open_files = true, prompt_title = "Live Grep in Open Files" })
			end, { desc = "[S]earch [/] in Open Files" })
			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [N]eovim files" })
		end,
	},

	--=============================================================================
	-- LANGUAGE SERVER PROTOCOL (LSP)
	--=============================================================================

	{ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		config = function()
			-- Configure LSP servers using new vim.lsp.config API
			vim.lsp.config("ts_ls", {
				cmd = { "typescript-language-server", "--stdio" },
				filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
			})

			vim.lsp.config("pyright", {
				cmd = { "pyright-langserver", "--stdio" },
				filetypes = { "python" },
			})

			vim.lsp.config("bashls", {
				cmd = { "bash-language-server", "start" },
				filetypes = { "sh", "bash" },
			})

			vim.lsp.config("dockerls", {
				cmd = { "docker-langserver", "--stdio" },
				filetypes = { "dockerfile" },
			})

			vim.lsp.config("yamlls", {
				cmd = { "yaml-language-server", "--stdio" },
				filetypes = { "yaml", "yml" },
			})

			vim.lsp.config("vimls", {
				cmd = { "vim-language-server", "--stdio" },
				filetypes = { "vim" },
			})

			vim.lsp.config("eslint", {
				cmd = { "vscode-eslint-language-server", "--stdio" },
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
			})

			-- Enable all configured LSP servers
			vim.lsp.enable({ "ts_ls", "pyright", "bashls", "dockerls", "yamlls", "vimls", "eslint" })

			-- Disable virtual text (using tiny-inline-diagnostic plugin instead)
			vim.diagnostic.config({ virtual_text = false })

			-- LSP keymaps and autocommands
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- Navigation
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					-- Symbol search
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
					map(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)

					-- Actions
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

					-- Document highlighting
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})
					end

					-- Inlay hints
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			-- LSP capabilities for nvim-cmp
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
		end,
	},

	--=============================================================================
	-- CODE FORMATTING
	--=============================================================================

	{ -- Autoformat
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = true,
			format_on_save = function(bufnr)
				local disable_filetypes = { c = true, cpp = true }
				return {
					timeout_ms = 500,
					lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black" },
				json = { "biome" },
				html = { "prettierd" },
			},
		},
	},

	--=============================================================================
	-- AUTOCOMPLETION
	--=============================================================================

	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})

			-- Main cmp setup
			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = "menu,menuone,noinsert" },
				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete({}),
					["<C-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<C-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp", group_index = 1 },
					{ name = "luasnip", group_index = 2 },
					{ name = "path", group_index = 3 },
					{ name = "buffer", group_index = 3 },
					{ name = "lazydev", group_index = 0 },
				}),
			})

			-- SQL-specific completion
			cmp.setup.filetype({ "sql", "mysql", "psql" }, {
				sources = cmp.config.sources({
					{ name = "vim-dadbod-completion" },
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},

	--=============================================================================
	-- SYNTAX HIGHLIGHTING & TREESITTER
	--=============================================================================

	{ -- Treesitter for syntax highlighting
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
			},
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = { enable = true, disable = { "ruby" } },
		},
		config = function(_, opts)
			require("nvim-treesitter.install").prefer_git = true
			require("nvim-treesitter.configs").setup(opts)
		end,
	},

	--=============================================================================
	-- UI/UX ENHANCEMENTS
	--=============================================================================

	{ -- Git signs in gutter
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},

	{ -- Todo comments highlighting
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},

	{ -- Mini.nvim collection (text objects, surroundings, etc)
		"echasnovski/mini.nvim",
		config = function()
			-- Better Around/Inside textobjects
			require("mini.ai").setup({ n_lines = 500 })

			-- Add/delete/replace surroundings (brackets, quotes, etc)
			require("mini.surround").setup()

			-- Statusline disabled (using lualine instead)
			-- require("mini.statusline").setup({ use_icons = vim.g.have_nerd_font })
		end,
	},

	--=============================================================================
	-- CUSTOM PLUGINS (from lua/custom/plugins/)
	--=============================================================================

	{ import = "custom.plugins" },
	require("kickstart.plugins.indent_line"),
	require("kickstart.plugins.autopairs"),
})

--=============================================================================
-- MODELINE (VIM SETTINGS)
--=============================================================================
-- vim: ts=2 sts=2 sw=2 et
