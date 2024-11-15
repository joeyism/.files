return require('packer').startup(function(use)
  use {
    "wbthomason/packer.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "huggingface/llm.nvim",
    "scrooloose/nerdtree",
    "vim-airline/vim-airline",
    "vim-airline/vim-airline-themes",
    "vim-scripts/dante.vim",
    "editorconfig/editorconfig-vim",
    run = ":MasonUpdate" -- :MasonUpdate updates registry contents
  }
  use { 
    "nvim-lua/plenary.nvim",
    "kelly-lin/telescope-ag",
    "nvim-telescope/telescope.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
  }
  use {
    'nvim-treesitter/nvim-treesitter',
  }
  use {
    "pmizio/typescript-tools.nvim",
    requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("typescript-tools").setup {}
    end,
  }
end)
