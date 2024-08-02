local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end


-- Colorscheme
vim.cmd('colorscheme dante')

vim.opt.number = true

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
require("llm").setup({
})
