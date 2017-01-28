let  mapleader = '\'
nmap <leader>ne :NERDTree<cr>
set  nu

highlight LineNr ctermfg = grey 

source ~/vcomments.vim
map <C-a> :call Comment()<CR>
map <C-b> :call Uncomment()<CR>

call plug#begin()
    Plug 'scrooloose/nerdtree'
    Plug 'easymotion/vim-easymotion'
call plug#end()
