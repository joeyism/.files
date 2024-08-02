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
    run = ":MasonUpdate" -- :MasonUpdate updates registry contents
  }
end)
