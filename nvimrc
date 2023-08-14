vim.o.encofing = 'utf-8'
vim.o.tabstop = 8
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.ambiwidth = 'double'
vim.o.number = true
vim.o.showmatch = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true
vim.o.matchtime = 1
vim.o.backup = true
vim.o.undofile = true

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

require('lazy').setup({
  -- Essentials
  "editorconfig/editorconfig-vim",
  'nvim-treesitter/nvim-treesitter',

  -- LSP stuff
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",

  -- My friend who actually writes code ;)
  "github/copilot.vim",

  -- Completion
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/nvim-cmp",

  -- Fuzzy finder
  -- https://github.com/nvim-telescope/telescope.nvim
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.2',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },

  -- https://github.com/nvim-lualine/lualine.nvim
  "nvim-lualine/lualine.nvim",

  -- Better prompt UIs
  "stevearc/dressing.nvim",

  -- Change cursor colors based on mode
  -- https://github.com/mvllow/modes.nvim
  {
    'mvllow/modes.nvim',
    tag = 'v0.2.0',
  },

  -- Git line statuses
  -- https://github.com/lewis6991/gitsigns.nvim
  "lewis6991/gitsigns.nvim",

  -- Standalone UI for nvim-lsp progress
  -- https://github.com/j-hui/fidget.nvim
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach",
  },

  -- https://github.com/numToStr/Comment.nvim
  'numToStr/Comment.nvim',
  -- https://github.com/kylechui/nvim-surround
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup()
    end
  }
})

require('lualine').setup({
  options = {
    icons_enabled = false,
    component_separators = { left = ' ', right = ' ' },
    section_separators = { left = ' ', right = ' ' },
  }  
})

require('dressing').setup()
require('modes').setup()
require('gitsigns').setup()
require("fidget").setup()

local cmp = require('cmp')
cmp.setup({
  sources = cmp.config.sources({
    {name = 'nvim_lsp'},
    {name = 'nvim_lsp_signature_help'},
    {name = 'path'},
    {name = 'buffer'},
    {name = 'nvim_lua'},
    {name = 'luasnip'},
    {name = 'cmdline'},
    {name = 'git'},
  }),
})

local telescope = require("telescope")
telescope.setup({
  fzf = {
    fuzzy = true,                    
    override_generic_sorter = true,  
    override_file_sorter = true,     
    case_mode = "smart_case",        
  }
})
telescope.load_extension('fzf')

require("mason").setup()
require("mason-lspconfig").setup()
