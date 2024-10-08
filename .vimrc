set nocompatible              " be iMproved, required
filetype off                  " required
syntax on
set path+=**
set wildmenu
filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab
set number
set splitright
set splitbelow
set showcmd
set clipboard=unnamed
set hidden
set cursorline
set cursorlineopt=number

   
" - ^x^n for JUST this file
" - ^x^f for filenames (works with our path trick!)
" - ^x^] for tags only
" - ^n for anything specified by the 'complete' option

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'scrooloose/nerdtree'

Plugin 'vim-scripts/dante.vim'

Plugin 'vim-airline/vim-airline'

Plugin 'vim-airline/vim-airline-themes'

Plugin 'majutsushi/tagbar'

Plugin 'romainl/Apprentice'

Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

Plugin 'junegunn/fzf.vim'

Plugin 'pixelneo/vim-python-docstring'

Plugin 'Quramy/tsuquyomi'

Plugin 'dense-analysis/ale'

Plugin 'fatih/vim-go'

Plugin 'jupyter-vim/jupyter-vim'

Plugin 'vim-terraform'

Plugin 'PProvost/vim-ps1'

Plugin 'prabirshrestha/vim-lsp'

call vundle#end()            " required

" My shit
colorscheme dante
"set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim/
set laststatus=2
silent! map <F2> :NERDTreeToggle<CR>
silent! map <F3> :NERDTreeFind<CR>
silent! map <F4> :Tagbar<CR>
silent! map <F5> :TagbarShowTag<CR>

"airline
let g:airline#extensions#tabline#enabled = 1
"scala
let g:scala_scaladoc_indent = 1
autocmd BufRead,BufNewFile *.scala set filetype=scala

"delete buffer and quit file
command! -bar Q bdelete|quit

function! MergeTabs()
  if tabpagenr() == 1
    return
  endif
  let bufferName = bufname("%")
  if tabpagenr("$") == tabpagenr()
    close!
  else
    close!
    tabprev
  endif
  split
  execute "buffer " . bufferName
endfunction


nmap <C-W>u :call MergeTabs()<CR>

if &diff
    colorscheme apprentice
endif
set omnifunc=syntaxcomplete#Complete
"
" leader
" 

let mapleader = " "

" show vimrc
map <Leader>rc  :tabe ~/.vimrc<CR>
" reload vimrc
map <Leader>rerc  :so $MYVIMRC<CR>
" copy name of current path/filename.ext into registry
map <Leader>yf :let @+=@%<CR>
" add to current line, then new line below. For reformatting python code
nnoremap <silent> <C-j> Ja<CR><Esc>
" move between buffers
nnoremap <silent> <C-l> :bn<CR>
nnoremap <silent> <C-h> :bp<CR>
" move screen
nnoremap <silent> <C-M-L> <C-W>>
nnoremap <silent> <C-M-H> <C-W><
" terminal
nnoremap <silent> <C-t><C-t> :vertical terminal<CR>
nnoremap <silent> <C-t><C-h> :terminal<CR>
" save/load
map <Leader>ss  :mks! saved.vim<CR>
map <Leader>sl  :source saved.vim<CR>
map <Leader>ip  oimport ipdb; ipdb.set_trace()<Esc>:w<CR>
map <Leader>pd  oimport pdb; pdb.set_trace()<Esc>:w<CR>
map <Leader>tf  :Terraform fmt<CR>
map <Leader>ret :!ctags --recurse=yes --exclude=.git --exclude=BUILD --exclude=.svn --exclude=vendor --exclude=node_modules --exclude=db --exclude=log --exclude=venv<CR>


function! CloseAllBuffersButCurrent()
  let curr = bufnr("%")
  let last = bufnr("$")

  if curr > 1    | silent! execute "1,".(curr-1)."bd"     | endif
  if curr < last | silent! execute (curr+1).",".last."bd" | endif
endfunction


"python
let g:pymode_lint_ignore = ["E501", "W", "E111", "E0100"]
let g:pymode_options_colorcolumn = 0
"au FileType python setl sw=2 sts=2 et

command! W  write

"typescript
autocmd BufNewFile,BufRead *.ts set syntax=typescript
set omnifunc=syntaxcomplete#Complete
"" Press F8 when cursor is above a require path, and it'll open the path
"" assuming the extension of file is same as current file
map <F8> :let mycurf=expand('%:p:h')."/".expand("<cfile>").".".expand('%:e')<CR>:execute("e ".mycurf)<CR>
set ballooneval
autocmd FileType typescript setlocal balloonexpr=tsuquyomi#balloonexpr()
autocmd FileType typescript nmap <buffer> <Leader>tt : <C-u>echo tsuquyomi#hint()<CR>


"nerdtree
let NERDTreeIgnore = ['\.pyc$', '__pycache__']

"ale
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
let g:airline#extensions#ale#enabled = 1
let g:ale_python_pylint_options = "--init-hook='import sys; sys.path.append(\".\")'"
let g:ale_completion_enabled = 1
autocmd FileType javascript,typescript,python,c,cpp,go,rust ALEEnableBuffer


"vim-go
let g:go_debug_windows = {
      \ 'vars':       'rightbelow 60vnew',
      \ 'stack':      'rightbelow 10new',
\ }

"jupyter-vim
nnoremap <silent> <C-j><C-x> :JupyterSendCell<CR>
nnoremap <silent> <C-j><C-r> :JupyterRunFile<CR>

" terraform
autocmd BufNewFile,BufRead *.tf set syntax=terraform

hi CursorLineNr cterm=none ctermfg=11
let g:ale_linters = {'python': ['pyright']}
