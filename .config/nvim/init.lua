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
vim.o.mouse = ""


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
vim.api.nvim_set_keymap("n", "<C-[>", ":Telescope lsp_references<CR>", { noremap = true} )
--vim.api.nvim_set_keymap("n", "<C-[>", ":lua vim.lsp.buf.references()<CR>", { noremap = true} )


vim.cmd([[autocmd BufNewFile,BufRead *.sql.j2 set filetype=sql]])
vim.cmd([[autocmd BufNewFile,BufRead *.py.jinja set filetype=python]])

--- Packages
require("plugins")
require("mason").setup()
local lspconfig = require("lspconfig")
lspconfig.pyright.setup{}
lspconfig.buf_ls.setup{}

vim.o.updatetime = 250
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
  callback = function ()
    vim.diagnostic.open_float(nil, {focus=false})
  end
})

-- fzf
local actions = require "fzf-lua.actions"
require'fzf-lua'.setup {
  files = {
    find_opts         = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
    rg_opts           = [[--color=never --files --hidden --follow -g "!.git" -g "!**/node_modules/**" -g "!venv/**"]],
  }
}
vim.keymap.set("n", "<C-f><C-f>",  function()
    require('fzf-lua').grep({ cmd = "rg -g '!node_modules/*'" })
end, { desc = "Find File containing <phrase>" })
vim.api.nvim_set_keymap("n", "<C-p>", ":lua require('fzf-lua').grep()<CR><CR>", { noremap = true} )
vim.keymap.set("n", "<C-f><C-r>", require('fzf-lua').grep_last, { desc = "Find file, Reusing last <phrase>" })
vim.keymap.set("v", "<C-f><C-v>", require('fzf-lua').grep_visual, { desc = "Find Visual-ised words" })
vim.keymap.set("n", "<C-f><C-t>", require('fzf-lua').buffers, { desc = "Find Buffer name" })
vim.keymap.set("n", "<C-f><C-l>", require('fzf-lua').lines, { desc = "Find Line in buffer" })

-- LLM
require("llm").setup({
    backend="huggingface",
    model="bigcode/starcoder",
    auto_generate = false,
    lsp = {
      bin_path = vim.api.nvim_call_function("stdpath", { "data" }) .. "/mason/bin/llm-ls",
    },
    enable_suggestions_on_startup = false,
    enable_suggestions_on_files = "*",
})
vim.keymap.set('i', '<C-l>', function()
  require('llm.completion').lsp_suggest()
end, { noremap = true, silent = true })


local telescope = require('telescope')
telescope.setup{}
telescope.load_extension("ag")
telescope.load_extension("file_browser")



require('nvim-treesitter.configs').setup{highlight={enable=true}}
require("typescript-tools").setup{}
vim.treesitter.language.register('typescript', 'tsx')
vim.treesitter.language.register('typescript', 'ts.jinja')
vim.treesitter.language.register('python', 'py.jinja')


-- Colorscheme
vim.cmd('colorscheme dante')

vim.opt.number = true

