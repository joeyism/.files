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

"
" leader
" 
command! LeaderHelp echo "Commands for \<Leader\>\n" "rc\tshow vimrc\n" "rerc\treload vimrc after changes\n" "..\topen directory here\n" "m0\tmove tab to first\n" "mapy\tset make to python\n" "mago\tset make to golang\n" "make\tmake\n" "mala\trun last make\n" "la\trun last command" "fo\tfold this area"

let mapleader = " "

" show vimrc
map <Leader>rc  :tabe ~/.vimrc<CR>
" reload vimrc
map <Leader>rerc  :so $MYVIMRC<CR>
" open directory here
map <Leader>..  :tabe %<CR><F3><C-w>l:q<CR>
" move tab to first
map <Leader>m0  :tabm0<CR>
" set make to python
map <Leader>mapy  :set makeprg=python\ %<CR>    
" set make to go
map <Leader>mago  :set makegrg=go\ run\ %<CR>
" run/make
map <Leader>make  :make<CR>
" run last make
map <Leader>mala  :make<Up><CR>
" last
map <Leader>la  :<Up><CR>               
" fold one
map <Leader>fo  $zf%j
" add new line
map <Leader><CR>  o<Esc>
" find in other file
map <Leader>**  *N<C-w><C-w>n
" Make space after work
map <Leader><Space>  a 
" move to buffer
nnoremap <Leader>e :ls<CR>:b 
nnoremap <Leader>l :bn<CR>
nnoremap <Leader>h :bp<CR>
" use tag to find method under cursor
map <Leader>tf "ryaw:tag <C-R>"<CR>:tags<CR>
" next buffer
map <Leader>bn :bn<CR>
map <Leader>bp :bp<CR>
" exit insert mode with Ctrl-p instead of Ctrl-[
imap <C-p>  <Esc>                       
" complete bracket and insert in the middle
imap <C-]><C-]>  {}<Left><CR><CR><Up><Tab>
"{<CR><CR>}<Esc><Up>i<Tab>
" complete the inline
imap <C-e>  <Esc>A)<Esc>

" autocmd FileType html imap <C-m>  <Esc>F<y%$pF<a/F>i

"Scala
" Find file from imports
map <Leader>sff  vaW"syo<Esc>"sp0x:s/\./\//g<CR>:silent! s/_/\*/g<CR>"sddu:tabfind **/<C-R>s<Backspace>
" Find file from under highlighted cursor (above without the visual)
map <Leader>sfv  "syo<Esc>"sp0x:s/\./\//g<CR>:silent! s/_/\*/g<CR>"sddu:tabfind **/<C-R>s<Backspace>
" Find next, and scroll down a little
map <Leader>ne  n<C-e><C-e><C-e><C-e><C-e>

imap <C-p>  <Esc>

