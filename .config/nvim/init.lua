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
vim.api.nvim_set_keymap('n', '<F4>', ':Telescope lsp_document_symbols<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<F5>', ':Telescope lsp_document_symbols ignore_symbols=variable<CR>', {silent = true})

-- Airline settings
-- vim.g['airline#extensions#tabline#enabled'] = 1


vim.opt.omnifunc = 'syntaxcomplete#Complete'

-- Leader mappings
vim.api.nvim_set_keymap('n', '<Leader>rc', ':tabe ~/.config/nvim/init.lua<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>rerc', ':luafile $MYVIMRC<CR>', {noremap = true})
-- vim.api.nvim_set_keymap('n', '<Leader>yf', ':let @+=@%<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>yf', ":let @+=expand('%:.')<CR>", {noremap = true})
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
vim.api.nvim_set_keymap('n', '<Leader>bp', 'obreakpoint()<Esc>:w<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>pd', 'oimport pdb; pdb.set_trace()<Esc>:w<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>tf', ':Terraform fmt<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>ret', ':!ctags --recurse=yes --exclude=.git --exclude=BUILD --exclude=.svn --exclude=vendor --exclude=node_modules --exclude=db --exclude=log --exclude=venv<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>pyt', ':s/\\//\\./g<CR>0ifrom <Esc>$bdexbhxi import <Esc>:w<CR>', {noremap = true})
vim.api.nvim_set_keymap("n", "<C-[>", ":Telescope lsp_references<CR>", { noremap = true} )
--vim.api.nvim_set_keymap('t', '<C-n>', '<C-\\><C-n>', { desc = 'Quick normal mode' })
--vim.api.nvim_set_keymap("n", "<C-[>", ":lua vim.lsp.buf.references()<CR>", { noremap = true} )


vim.cmd([[autocmd BufNewFile,BufRead *.sql.j2 set filetype=sql]])
vim.cmd([[autocmd BufNewFile,BufRead *.py.jinja set filetype=python]])

--- Packages
require("plugins")
require("mason").setup()
vim.lsp.config.pyright = {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', '.git' },
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true
      }
    }
  }
}
vim.lsp.enable('pyright')

vim.lsp.config.buf_ls = {
  cmd = { 'bufls', 'serve' },
  filetypes = { 'proto' }
}
vim.lsp.enable('buf_ls')
vim.keymap.set("n", "]g", vim.diagnostic.goto_next)
vim.keymap.set("n", "[g", vim.diagnostic.goto_prev)

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


local telescope = require('telescope')
telescope.setup{}
telescope.load_extension("ag")
telescope.load_extension("file_browser")



require("typescript-tools").setup{}
vim.treesitter.language.register('typescript', 'tsx')
vim.treesitter.language.register('typescript', 'ts.jinja')
vim.treesitter.language.register('python', 'py.jinja')


-- Colorscheme
vim.cmd('colorscheme dante')

vim.opt.number = true

-- Set up the LSP
vim.lsp.config.jsonls = {
  cmd = { 'vscode-json-language-server', '--stdio' },
  filetypes = { 'json', 'jsonc' },
  root_markers = { '.git' }
}
vim.lsp.enable('jsonls')

vim.lsp.config.terraformls = {
  cmd = { 'terraform-ls', 'serve' },
  filetypes = { 'terraform', 'hcl' },
  root_markers = { '.terraform', '.git' }
}
vim.lsp.enable('terraformls')

vim.lsp.config.eslint = {
  cmd = { 'vscode-eslint-language-server', '--stdio' },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' },
  root_markers = { '.eslintrc', '.eslintrc.js', '.eslintrc.json', 'package.json', '.git' }
}
vim.lsp.enable('eslint')

vim.lsp.config.baml = {
  cmd = { 'uv', 'run', 'baml-cli', 'lsp' },
  filetypes = { 'baml' },
  root_markers = { 'baml_src', '.git' }
}
vim.lsp.enable('baml')

--- lualine
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'powerline',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = false,
    refresh = {
      statusline = 100,
      tabline = 100,
      winbar = 100,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {{'filename', path=1}},
    lualine_x = {'diff', 'diagnostics', 'lsp_status', 'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_d = {'searchcount'},
    lualine_e = {'selectioncount'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {
    lualine_a = {{'buffers', show_filename_only = false, mode = 0, symbols = {alternate_file=""}, use_mode_colors = true}},
    lualine_z = {'tabs'},
  },
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

local cmp = require('cmp')
cmp.setup {
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
    -- Other sources you might want
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
}

require('yarepl.extensions.aider').setup {
  wincmd = 'vertical 30 split'
}

require('yarepl').setup {
  metas = { aider = require('yarepl.extensions.aider').create_aider_meta() }
}
-- Set up a timer that keeps checking and forcing normal mode
local timer = nil

local function setup_terminal_normal_mode()
  if timer then
    timer:stop()
  end
  
  if vim.bo.buftype == 'terminal' then
    timer = vim.loop.new_timer()
    timer:start(0, 100, vim.schedule_wrap(function() -- Check every 100ms
      if vim.bo.buftype == 'terminal' and vim.fn.mode() == 't' then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, true, true), 'n', false)
      elseif vim.bo.buftype ~= 'terminal' then
        -- Stop timer when we leave terminal buffers
        if timer then
          timer:stop()
          timer = nil
        end
      end
    end))
  end
end

vim.api.nvim_create_autocmd({'BufEnter', 'WinEnter'}, {
  pattern = 'term://*',
  callback = setup_terminal_normal_mode,
})
