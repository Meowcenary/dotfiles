let  mapleader = '\'
nmap <leader>ne :NERDTree<cr>
set  nu

highlight LineNr ctermfg = grey 

call plug#begin()
    Plug 'scrooloose/nerdtree'
    Plug 'easymotion/vim-easymotion'
call plug#end()
