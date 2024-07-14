local M = {}

local packer_bootstrap = false

local function init_packer()
  local fn = vim.fn
  local path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(path)) > 0 then
    packer_bootstrap = fn.system {
      "git",
      "clone",
      "--depth=1",
      "https://github.com/wbthomason/packer.nvim",
      path
    }
    vim.cmd [[packadd packer.nvim]]
  end
end

init_packer()

function M.setup()
  local conf = {
    compile_path = vim.fn.stdpath("config") .. "/lua/packer_compiled.lua",
    display = {
      open_fn = function()
        return require("packer.util").float { border = "rounded" }
      end
    }
  }

  local function plugins(use)
    use { "wbthomason/packer.nvim" }
    use {
      "navarasu/onedark.nvim",
      config = require("config.colorscheme").setup
    }
    use {
        "airblade/vim-gitgutter",
        branch = "main"
    }
    use { "tpope/vim-surround" }
    use {
      "scrooloose/nerdtree",
      config = require("config.nerdtree").setup,
    }
    use {
      "nvim-lualine/lualine.nvim",
      config = require("config.lualine").setup,
      requires = { "nvim-tree/nvim-web-devicons", opt = true },
    }
    use {
      "akinsho/bufferline.nvim",
      requires = "nvim-tree/nvim-web-devicons",
      config = require("config.bufferline").setup,
    }
    use {
      "nvim-treesitter/nvim-treesitter",
      run = require("config.treesitter").run_on_update,
      config = require("config.treesitter").setup,
    }
    use { "hrsh7th/vim-vsnip" }
    use { "hrsh7th/cmp-vsnip" }
    use { "hrsh7th/cmp-nvim-lsp" }
    use {
      "hrsh7th/nvim-cmp",
      config = require("config.completion").setup,
    }
    use {
      "neovim/nvim-lspconfig",
      config = require("config.lsp").setup,
    }
    use { "github/copilot.vim" }
  end

  vim.loader.enable()
  pcall(require, "packer_compiled")
  require("packer").init(conf)
  require("packer").startup(plugins)
end

return M

