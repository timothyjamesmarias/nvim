vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- remaps
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", ";", ":")
vim.keymap.set("i", "jj", "<Esc>", { silent = true })
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { silent = true })
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { silent = true })
vim.keymap.set("n", "<leader>n", ":enew<CR>", { silent = true })
vim.keymap.set("n", "<leader>q", ":bd<CR>", { silent = true })
vim.keymap.set("n", "n", "nzzzv", { silent = true })
vim.keymap.set("n", "N", "Nzzzv", { silent = true })
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", { silent = true })
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", { silent = true })
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", { silent = true })
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", { silent = true })
vim.keymap.set("n", "<leader>g", ":Neogit<CR>", { silent = true })
vim.keymap.set("n", "<leader>vv", ":vsp<CR>", { silent = true })
vim.keymap.set("n", "<leader>ss", "/")

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
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme tokyonight]])
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
			vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { silent = true })
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		dependencies = {
			"windwp/nvim-ts-autotag",
			"JoosepAlviste/nvim-ts-context-commentstring",
			"EmranMR/tree-sitter-blade",
			"HiPhish/nvim-ts-rainbow2",
			"nvim-treesitter/nvim-treesitter-context",
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
				ensure_installed = "all",
				auto_install = true,
				context_commentstring = {
					enable = true,
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["aa"] = "@class.outer",
							["ia"] = "@class.inner",
						},
					},
				},
				rainbow = {
					enable = true,
					extended_mode = true,
					strategy = require("ts-rainbow").strategy.global,
				},
			})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.3",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { silent = true })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { silent = true })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { silent = true })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { silent = true })
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
		lazy = false,
		dependencies = {
			{ "antosha417/nvim-lsp-file-operations", config = true },
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"saadparwaiz1/cmp_luasnip",
			"L3MON4D3/LuaSnip",
			"onsails/lspkind-nvim",
		},
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local cmp = require("cmp")
			local lspkind = require("lspkind")
			local luasnip = require("luasnip")

			local has_words_before = function()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			local on_attach = function(client, buffer)
				vim.keymap.set("n", "gr", ":Telescope lsp_references<CR>")
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
				vim.keymap.set("n", "gd", ":Telescope lsp_definitions<CR>")
				vim.keymap.set("n", "gi", ":Telescope lsp_implementations<CR>")
				vim.keymap.set("n", "gt", ":Telescope lsp_type_definitions<CR>")
				vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
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

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				formatting = {
					format = lspkind.cmp_format(),
				},
				mapping = {
					["<C-n>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<C-p>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "buffer" },
					{ name = "path" },
					{ name = "luasnip" },
				},
				experimental = {
					native_menu = false,
					ghost_text = true,
				},
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
			vim.keymap.set("n", "<leader>g<CR>", ":Neogit", { silent = true })
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"rmagatti/auto-session",
		},
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
					lualine_x = { "searchcount", "fileformat", "filetype" },
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
			bufferline.setup({
				options = {
					diagnostics = "nvim_lsp",
					diagnostics_indicator = function(count, level, diagnostics_dict, context)
						local icon = level:match("error") and " " or " "
						return " " .. icon .. count
					end,
					separator_style = "slant",
					tab_size = 20,
					offsets = {
						{
							filetype = "NvimTree",
							text = "File Explorer",
							highlight = "Directory",
							separator = true,
						},
					},
				},
			})
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
			vim.keymap.set("n", "<leader>f", ":Format<CR>", { silent = true })
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
		"rmagatti/session-lens",
		dependenceis = {
			"rmagatti/auto-session",
			"nvim-telescope/telescope.nvim",
			"nvim-lualine/lualine.nvim",
		},
		config = function()
			local auto_session = require("auto-session")
			local session_lens = require("session-lens")
			auto_session.setup({
				log_level = "error",
				auto_session_suppress_dirs = { "~/", "~/projects", "~/Downloads", "/" },
				auto_session_use_git_branch = true,
				auto_restore_enabled = true,
				auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
				auto_session_enabled = true,
				auto_session_create_enabled = true,
				post_cwd_changed_hook = function()
					require("lualine").refresh()
				end,
			})
			session_lens.setup({})
			vim.keymap.set("n", "<leader>se", ":Telescope session-lens search_session<CR>")
		end,
	},
	{
		"slim-template/vim-slim",
		config = function()
			vim.cmd("au BufNewFile,BufRead *.slim set filetype=slim")
		end,
	},
	{
		"voldikss/vim-floaterm",
		config = function()
			vim.keymap.set("n", "<leader>tt", ":FloatermToggle<CR>")
			vim.keymap.set("t", "<leader>tt", "<C-\\><C-n>:FloatermToggle<CR>")
		end,
	},
	{
		"folke/twilight.nvim",
	},
  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup({})
      vim.keymap.set("n", "<leader>D", ":TroubleToggle<CR>")
    end,
  }
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
vim.opt.completeopt = { "menuone", "longest", "preview" }
vim.opt.ignorecase = true
vim.opt.smartcase = true

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
