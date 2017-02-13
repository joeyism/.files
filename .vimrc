set nocompatible              " be iMproved, required
filetype off                  " required
syntax on
set path+=**
set wildmenu

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

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
Plugin 'L9'
" Git plugin not hosted on GitHub
Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
Plugin 'fatih/vim-go'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Avoid a name conflict with L9

Plugin 'rust-lang/rust.vim'

Plugin 'Valloric/YouCompleteMe', { 'do': './install.sh' }

Plugin 'rhysd/vim-go-impl' 

Plugin 'xolox/vim-misc'

Plugin 'xolox/vim-notes' 

Bundle 'scrooloose/nerdtree'

Bundle 'Xuyuanp/nerdtree-git-plugin'

Bundle 'pangloss/vim-javascript'

Plugin 'mxw/vim-jsx'

Plugin 'leafgarland/typescript-vim'

Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
Plugin 'isRuslan/vim-es6'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

execute pathogen#infect()

filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab
colorscheme dante
set number

if has('vim_starting')
    set nocompatible
    set runtimepath+=~/.vim/bundle/dart-vim-plugin
endif
filetype plugin indent on

" ==================== Vim-go ====================
let g:go_fmt_fail_silently = 0
let g:go_fmt_command = "goimports"
let g:go_autodetect_gopath = 1

let g:go_highlight_space_tab_error = 0
let g:go_highlight_array_whitespace_error = 0
let g:go_highlight_trailing_whitespace_error = 0
let g:go_highlight_extra_types = 0
let g:go_highlight_operators = 0

au FileType go nmap <Leader>s <Plug>(go-def-split)
au FileType go nmap <Leader>v <Plug>(go-def-vertical)
au FileType go nmap <Leader>in <Plug>(go-info)
au FileType go nmap <Leader>ii <Plug>(go-implements)

au FileType go nmap <leader>r  <Plug>(go-run)
au FileType go nmap <leader>b  <Plug>(go-build)
au FileType go nmap <leader>g  <Plug>(go-gbbuild)
au FileType go nmap <leader>t  <Plug>(go-test-compile)
au FileType go nmap <Leader>d <Plug>(go-doc)
au FileType go nmap <Leader>f :GoImports<CR>

" ==================== YouCompleteMe ====================
"let g:ycm_autoclose_preview_window_after_completion = 1
"let g:ycm_min_num_of_chars_for_completion = 1

" ==================== Notes ======================
:let g:notes_directories = ['/home/dante/.vim/bundle/vim-notes/misc/notes/user/', '/home/dante/Documents/QCon/NY2016/Day1/','/home/dante/Documents/QCon/NY2016/Day2/','/home/dante/Documents/QCon/NY2016/Day3/']


" ==================== nerdtree-git-plugin ======================




" My shit
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

"
" leader
" 
command LeaderHelp echo "Commands for \<Leader\>\n" "rc\tshow vimrc\n" "rerc\treload vimrc after changes\n" "..\topen directory here\n" "m0\tmove tab to first\n" "mapy\tset make to python\n" "mago\tset make to golang\n" "make\tmake\n" "mala\trun last make\n" "la\trun last command" "fo\tfold this area"

let mapleader = " "

" show vimrc
map <Leader>rc  :tabe ~/.vimrc<CR>      
" reload vimrc
map <Leader>rerc  :so $MYVIMRC<CR>      
" open directory here
map <Leader>..  :tabe .<CR>             
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
" exit insert mode with Ctrl-p instead of Ctrl-[
imap <C-p>  <Esc>                       
" complete bracket and insert in the middle
imap <C-]><C-]>  {}<Left><CR><CR><Up><Tab>
"{<CR><CR>}<Esc><Up>i<Tab>
" complete the inline
imap <C-)>  <Esc>A)<Esc>
