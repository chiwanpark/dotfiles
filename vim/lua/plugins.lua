return {
  {
    "arcticicestudio/nord-vim",
    lazy = false,
    priority = 1000,
    config = function()
      require("config.colorscheme").setup()
    end,
  },
  {
    "airblade/vim-gitgutter",
    branch = "main",
  },
  {
    "tpope/vim-surround",
  },
  {
    "scrooloose/nerdtree",
    config = function()
      require("config.nerdtree").setup()
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("config.lualine").setup()
    end,
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("config.bufferline").setup()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("config.treesitter").setup()
    end,
  },
  { "hrsh7th/vim-vsnip" },
  { "hrsh7th/cmp-vsnip" },
  { "hrsh7th/cmp-nvim-lsp" },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
    },
    config = function()
      require("config.completion").setup()
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("config.lsp").setup()
    end,
  },
  {
    "github/copilot.vim",
    config = function()
      require("config.copilot").setup()
    end,
  },
}

