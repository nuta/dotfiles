vim.o.encoding = 'utf-8'
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
vim.opt.shortmess:append({ I = true })
vim.opt.undodir = vim.fn.expand('~/.config/nvim/undo/')
vim.opt.backupdir = vim.fn.expand('~/.config/nvim/backup/')
vim.opt.directory = vim.fn.expand('~/.config/nvim/swp/')

-- nvim-tree encourages this
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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
  -- Color scheme
  "rebelot/kanagawa.nvim",
  
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
  
  -- File Tree
  "nvim-tree/nvim-tree.lua",

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

require('modes').setup()
require('gitsigns').setup()
require("fidget").setup()

require("nvim-tree").setup({
  sort_by = "case_sensitive",
})

vim.g.copilot_filetypes = {
  markdown = true
}

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
local telescope_actions = require("telescope.actions")
telescope.setup({
  disable_devicons = true,
  defaults = {
      mappings = {
          i = {
              ["<esc>"] = telescope_actions.close,
          },
      },
  },
  fzf = {
    fuzzy = true,                    
    override_generic_sorter = true,  
    override_file_sorter = true,     
    case_mode = "smart_case",

  }
})
telescope.load_extension('fzf')

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "rust_analyzer", "clangd", "gopls", "tsserver" },
  automatic_installation = true,
})

require('kanagawa').setup({
  compile = true,
  undercurl = true,
  keywordStyle = { italic = true},
  statementStyle = { bold = true },
  transparent = true,
  terminalColors = true,
  theme = "wave",
  background = {
      dark = "dragon",
      light = "lotus"
  },
})
vim.cmd("colorscheme kanagawa")

local telescope_builtin = require('telescope.builtin')

function file_picker()
  telescope_builtin.find_files {
    previewer = false,
    shorten_path = true,
    layout_strategy = "horizontal",  
  }
end

vim.g.mapleader = ' '
vim.keymap.set('n', '<leader><Space>', file_picker, {})
vim.keymap.set('n', '<leader>g', telescope_builtin.live_grep, {})
vim.keymap.set('n', '<leader>b', telescope_builtin.buffers, {})
vim.keymap.set('n', '<leader>t', "<cmd>NvimTreeToggle<CR>", {})
vim.keymap.set('n', '<leader>w', '<C-w>k', {})
vim.keymap.set('n', '<leader>s', '<C-w>j', {})
vim.keymap.set('n', '<leader>a', '<C-w>h', {})
vim.keymap.set('n', '<leader>d', '<C-w>l', {})
vim.keymap.set('n', '<leader>|', '<C-w>v', {})
vim.keymap.set('n', '<leader>-', '<C-w>s', {})
vim.keymap.set('n', '<leader>=', '<C-w>=', {})
vim.keymap.set('n', '<leader>c', '<C-w>c', {})
vim.keymap.set('n', '<leader>q', '<cmd>q<CR>', {})
vim.keymap.set('n', '<C-s>', '<cmd>w<CR>', {})
vim.keymap.set('i', '<C-s>', '<cmd>w<CR>', {})
vim.keymap.set('i', '<M-BS>', '<C-w>', {})

-- Some Emacs bindings
vim.api.nvim_set_keymap('i', '<C-a>', '<Home>', {})
vim.api.nvim_set_keymap('i', '<C-e>', '<End>', {})
vim.api.nvim_set_keymap('i', '<C-w>', '<C-[>diwa', {})
vim.api.nvim_set_keymap('c', '<C-a>', '<Home>', {})
vim.api.nvim_set_keymap('c', '<C-e>', '<End>', {})
vim.api.nvim_set_keymap('c', '<C-w>', '<C-[>diwa', {})
vim.api.nvim_set_keymap('n', '<C-a>', '^', {})
vim.api.nvim_set_keymap('n', '<C-e>', '$', {})


vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argv(0) == '' then
      file_picker()
    end
  end
})