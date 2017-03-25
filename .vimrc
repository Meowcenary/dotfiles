let  mapleader = '\'
nmap <leader>t :NERDTree<cr>

set nu
set cursorline
set cursorcolumn

highlight LineNr ctermfg = grey

source ~/vcomments.vim
map <C-a> :call Comment()<CR>
map <C-b> :call Uncomment()<CR>

call plug#begin()
    Plug 'scrooloose/nerdtree'
    Plug 'easymotion/vim-easymotion'
    Plug 'bronson/vim-trailing-whitespace'
call plug#end()
