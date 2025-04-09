return require('packer').startup(function(use)
  use {
    "wbthomason/packer.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "scrooloose/nerdtree",
    "vim-scripts/dante.vim",
    "editorconfig/editorconfig-vim",
    run = ":MasonUpdate" -- :MasonUpdate updates registry contents
  }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
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
  use {
    'huggingface/llm.nvim',
    config = function()
      require('llm').setup({
        -- Your llm.nvim configuration here
      })
    end
  }
  use { "ibhagwan/fzf-lua",
    -- optional for icon support
    requires = { "nvim-tree/nvim-web-devicons" }
    -- or if using mini.icons/mini.nvim
    -- requires = { "echasnovski/mini.icons" }
  }
end)
