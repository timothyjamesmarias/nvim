vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- remaps
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", ";", ":")
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("n", "<Tab>", ":bnext<CR>")
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>")
vim.keymap.set("n", "<leader>t", ":enew<CR>")
vim.keymap.set("n", "<leader>q", ":bd<CR>")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>")
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<leader>g", ":Neogit<CR>")
vim.keymap.set("n", "<leader>vv", ":vsp<CR>")

-- plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"navarasu/onedark.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			local onedark = require("onedark")
			onedark.setup({
				style = "darker",
			})
			onedark.load()
			vim.cmd([[colorscheme onedark]])
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local nvimtree = require("nvim-tree")
			nvimtree.setup()
			vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		dependencies = {
			"windwp/nvim-ts-autotag",
		},
		config = function()
			local treesitter = require("nvim-treesitter.configs")
			treesitter.setup({
				highlight = {
					enable = true,
				},
				modules = {},
				indent = { enable = true },
				autotag = { enable = true },
				ensure_installed = {
					"json",
					"javascript",
					"typescript",
					"yaml",
					"html",
					"css",
					"markdown",
					"markdown_inline",
					"bash",
					"lua",
					"vim",
					"dockerfile",
					"gitignore",
					"ruby",
					"php",
					"c",
					"cpp",
					"python",
				},
				auto_install = true,
			})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.3",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
			vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
		end,
	},
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			local mason = require("mason")
			local mason_lspconfig = require("mason-lspconfig")
			mason.setup()
			mason_lspconfig.setup()
		end,
	},
	{
		"tpope/vim-commentary",
	},
	{
		"neovim/nvim-lspconfig",
		-- event = { "BufReadPre", "BufNewFile" },
		lazy = false,
		dependencies = {
			{ "antosha417/nvim-lsp-file-operations", config = true },
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local on_attach = function(client, buffer)
				vim.keymap.set("n", "gr", ":Telescope lsp_references<CR>")
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
				vim.keymap.set("n", "gd", ":Telescope lsp_definitions<CR>")
				vim.keymap.set("n", "gi", ":Telescope lsp_implementations<CR>")
				vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>")
				vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
				vim.keymap.set("n", "<leader>D", ":Telescope diagnostics bufnr=0<CR>")
				vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)
				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
				vim.keymap.set("n", "K", vim.lsp.buf.hover)
				vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>")
			end

			lspconfig["html"].setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})
			lspconfig["lua_ls"].setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = {
								"vim",
								"require",
							},
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})
			lspconfig["volar"].setup({
				on_attach = on_attach,
				capabilities = capabilities,
        filetypes = { "vue", "javascript", "typescript", "javascriptreact", "typescriptreact" },
			})
      lspconfig["tailwindcss"].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
			lspconfig["cssls"].setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})
			lspconfig["solargraph"].setup({
				on_attach = on_attach,
				capabilities = capabilities,
				filetypes = { "ruby", "slim", "erb", "rake" },
			})
			lspconfig["bashls"].setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})
			lspconfig["dockerls"].setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})
			lspconfig["marksman"].setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})
			lspconfig["intelephense"].setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"nvim-telescope/telescope.nvim", -- optional
			"sindrets/diffview.nvim", -- optional
			"ibhagwan/fzf-lua", -- optional
		},
		config = function()
			local neogit = require("neogit")
			neogit.setup({})
			vim.keymap.set("n", "<leader>g<CR>", ":Neogit")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			local lualine = require("lualine")
			lualine.setup({
				options = {
					icons_enabled = true,
					theme = "auto",
					component_separators = { left = "|", right = "|" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {
						statusline = {},
						winbar = {},
					},
					ignore_focus = {},
					always_divide_middle = true,
					globalstatus = false,
					refresh = {
						statusline = 1000,
						tabline = 1000,
						winbar = 1000,
					},
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics", require("auto-session.lib").current_session_name },
					lualine_c = { "filename" },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = {},
			})
		end,
	},
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			local bufferline = require("bufferline")
			vim.opt.termguicolors = true
			bufferline.setup()
		end,
	},
	{
		"startup-nvim/startup.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		config = function()
			local startup = require("startup")
			startup.setup({ theme = "dashboard" })
		end,
	},
	{
		"github/copilot.vim",
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			local gitsigns = require("gitsigns")
			gitsigns.setup({
				current_line_blame = true,
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol",
					delay = 0,
					ignore_whitespace = false,
				},
			})
		end,
	},
	{
		"mhartington/formatter.nvim",
		config = function()
			local formatter = require("formatter")
			local util = require("formatter.util")
			formatter.setup({
				filetype = {
					ruby = {
						require("formatter.filetypes.ruby").standardrb,
						function()
							return {
								exe = "bin/standardrb",
								args = { "--fix" },
								stdin = true,
							}
						end,
					},
					lua = {
						require("formatter.filetypes.lua").stylua,
						function()
							return {
								exe = "stylua",
								args = {
									"--search-parent-directories",
									"--stdin-filepath",
									util.escape_path(util.get_current_buffer_file_path()),
									"--",
									"-",
								},
								stdin = true,
							}
						end,
					},
					["*"] = {
						require("formatter.filetypes.any").remove_trailing_whitespace,
					},
				},
			})
			vim.keymap.set("n", "<leader>f", ":Format<CR>")
		end,
	},
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"mfussenegger/nvim-dap-python",
			"nvim-telescope/telescope.nvim",
			"nvim-telescope/telescope-dap.nvim",
			"suketa/nvim-dap-ruby",
		},
		config = function() end,
	},
	{
		"rmagatti/auto-session",
		dependenceis = {
			"rmagatti/session-lens",
		},
		config = function()
			local auto_session = require("auto-session")
			auto_session.setup({
				log_level = "error",
				auto_session_suppress_dirs = { "~/", "~/projects", "~/Downloads", "/" },
			})
		end,
	},
})

-- options
vim.cmd("syntax on")

vim.opt.clipboard = "unnamedplus"
vim.opt.background = "dark"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.smartindent = true
vim.opt.mouse = a
vim.opt.spelllang = "en_us"
vim.opt.spell = true
vim.opt.updatetime = 1000

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.scrolloff = 8
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
