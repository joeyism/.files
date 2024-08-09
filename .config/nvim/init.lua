local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

vim.opt.compatible = false
vim.opt.filetype = off
vim.cmd('syntax on')
vim.opt.path:append('**')
vim.opt.wildmenu = true
vim.cmd('filetype plugin indent on')
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.showcmd = true
vim.opt.clipboard = 'unnamed'
vim.opt.hidden = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'


-- Key mappings
vim.g.mapleader = ' '
vim.api.nvim_set_keymap('n', '<F2>', ':NERDTreeToggle<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<F3>', ':NERDTreeFind<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<F4>', ':Tagbar<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<F5>', ':TagbarShowTag<CR>', {silent = true})

-- Airline settings
vim.g['airline#extensions#tabline#enabled'] = 1


vim.opt.omnifunc = 'syntaxcomplete#Complete'

-- Leader mappings
vim.api.nvim_set_keymap('n', '<Leader>rc', ':tabe ~/.config/nvim/init.lua<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>rerc', ':luafile $MYVIMRC<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>yf', ':let @+=@%<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-j>', 'Ja<CR><Esc>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-l>', ':bn<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-h>', ':bp<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-M-L>', '<C-W>>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-M-H>', '<C-W><', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-t><C-t>', ':vertical terminal<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-t><C-h>', ':terminal<CR>', {noremap = true, silent = true})

-- More leader mappings
vim.api.nvim_set_keymap('n', '<Leader>ss', ':mks! saved.vim<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>sl', ':source saved.vim<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>ip', 'oimport ipdb; ipdb.set_trace()<Esc>:w<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>pd', 'oimport pdb; pdb.set_trace()<Esc>:w<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>tf', ':Terraform fmt<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>ret', ':!ctags --recurse=yes --exclude=.git --exclude=BUILD --exclude=.svn --exclude=vendor --exclude=node_modules --exclude=db --exclude=log --exclude=venv<CR>', {noremap = true})


--- Packages
require("plugins")
require("mason").setup()
local lspconfig = require("lspconfig")
lspconfig.pyright.setup{}
lspconfig.bufls.setup{}

vim.o.updatetime = 250
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
  callback = function ()
    vim.diagnostic.open_float(nil, {focus=false})
  end
})
--require("llm").setup({
--})
local telescope = require('telescope')
telescope.setup{}
telescope.load_extension("ag")


-- Colorscheme
vim.cmd('colorscheme dante')

vim.opt.number = true

