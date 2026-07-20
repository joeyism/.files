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
  use { "ibhagwan/fzf-lua",
    -- optional for icon support
    requires = { "nvim-tree/nvim-web-devicons" }
    -- or if using mini.icons/mini.nvim
    -- requires = { "echasnovski/mini.icons" }
  }
  use {
    'milanglacier/minuet-ai.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'hrsh7th/nvim-cmp'
    }
  }
  -- You'll also need nvim-cmp and its sources for autocompletion
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp',
    }
  }
  use {
    "milanglacier/yarepl.nvim"
  }
  use {
    "klepp0/nvim-baml-syntax",
    requires = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("baml_syntax").setup()
    end,
  }
  use {
    "NickvanDyke/opencode.nvim",
    requires = { "folke/snacks.nvim" },
    config = function()
      vim.o.autoread = true
      vim.keymap.set({ "n", "x" }, "<C-o><C-o>", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode…" })
      vim.keymap.set({ "n", "x" }, "<C-o><C-x>", function() require("opencode").select() end,                          { desc = "Execute opencode action…" })
      vim.keymap.set({ "n", "t" }, "<C-o><C-.>", function() require("opencode").toggle() end,                           { desc = "Toggle opencode" })
      vim.keymap.set({ "n", "x" }, "<C-o>go",  function() return require("opencode").operator("@this ") end,        { desc = "Add range to opencode", expr = true })
      vim.keymap.set("n",          "<C-o>goo", function() return require("opencode").operator("@this ") .. "_" end, { desc = "Add line to opencode", expr = true })
    end
  }
  use {
    'j-morano/buffer_manager.nvim',
    requires = {'nvim-lua/plenary.nvim'},
  }
end)
