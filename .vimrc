"File type tab settings
autocmd Filetype ruby setlocal tabstop=2 shiftwidth=2 expandtab

" NERDTree config, set leader
let  mapleader = '\'
nmap <leader>t :NERDTree<cr>

" syntastic config options
let g:syntastic_mode_map = { 'mode': 'passive',
                          \ 'active_filetypes': [],
                          \ 'passive_filetypes': [] }
let g:syntastic_auto_loc_list=1

nnoremap <silent> <F5> :SyntasticCheck<CR>
nnoremap <silent> <F4> :lclose<cr>
nnoremap <silent> <F3> :SyntasticReset<CR>

" config options for vanilla vim
set nu
set cursorline
set cursorcolumn

" set color for vertical bar
highlight LineNr ctermfg = grey

" required to have airline plugin display
set laststatus=2

" function is in vcomments, config here
source ~/vcomments.vim
map <C-a> :call Comment()<CR>
map <C-b> :call Uncomment()<CR>

" plugins, managed with vimplug
call plug#begin()
    Plug 'scrooloose/nerdtree'
    Plug 'easymotion/vim-easymotion'
    Plug 'bronson/vim-trailing-whitespace'
    Plug 'vim-airline/vim-airline'
    Plug 'scrooloose/syntastic'
    Plug 'valloric/youcompleteme'
call plug#end()
