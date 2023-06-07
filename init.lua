--remaps
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("n", "<Tab>", ":bnext<CR>")
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>")
vim.keymap.set("n", "<leader>t", ":enew<CR>")
vim.keymap.set("n", "<leader>qq", ":q!<CR>")
vim.keymap.set("n", "ZZ", ":bd<CR>")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>")
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>vv", ":vsp<CR>")

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>ss', builtin.live_grep, {})
-- open file_browser with the path of the current buffer
vim.api.nvim_set_keymap(
  "n",
  "<space>fb",
  ":Telescope file_browser path=%:p:h select_buffer=true",
  { noremap = true }
)

-- plugins
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use { "nvim-telescope/telescope.nvim", requires = "nvim-lua/plenary.nvim" }
  use  "jose-elias-alvarez/null-ls.nvim"
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }
  use { 
    "williamboman/mason.nvim", 
    "williamboman/mason-lspconfig.nvim", 
    "neovim/nvim-lspconfig", 
  } 
  use ('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  use {'akinsho/bufferline.nvim', tag = "v3.*", requires = 'nvim-tree/nvim-web-devicons'}
  use 'mfussenegger/nvim-dap'
  use 'tpope/vim-commentary'
  use 'tpope/vim-surround'
  use 'tpope/vim-repeat'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'tpope/vim-unimpaired'
  use 'tpope/vim-dispatch'
  use 'tpope/vim-dadbod'
  use 'tpope/vim-abolish'
  use 'tpope/vim-sleuth'
  use 'tpope/vim-endwise'
  use 'tpope/vim-rails'
  use 'tpope/vim-bundler'
  use 'tpope/vim-rake'
  use 'tpope/vim-projectionist'
  use 'tpope/vim-markdown'
  use 'tpope/vim-git'
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional
    },
    config = function()
      require("nvim-tree").setup {}
    end
  }
  use {
  'maxmx03/solarized.nvim',
  config = function ()
    local success, solarized = pcall(require, 'solarized')

    vim.o.background = 'dark'

    solarized:setup {
      config = {
        theme = 'neovim',
        transparent = false
      }
    }

    vim.cmd 'colorscheme solarized'
  end
}
end)

--options

vim.cmd('syntax on')

vim.opt.clipboard = "unnamedplus"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.smartindent = true
vim.opt.mouse = a
vim.opt.spelllang = 'en_us'
vim.opt.spell = true

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

require 'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "go", "lua", "vim", "vimdoc", "query", "ruby", "python", "bash", "json", "yaml", "html", "css", "php", "rust", "javascript", "typescript"},

  sync_install = false,

  auto_install = true,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

require("mason").setup()
require("mason-lspconfig").setup()
require('lualine').setup()
require("bufferline").setup()
require("nvim-tree").setup()
require("mason-lspconfig").setup_handlers {
    function (server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup {}
    end
}
-- local null_ls = require("null-ls")

-- null_ls.setup({
--     sources = {
--     },
-- })

