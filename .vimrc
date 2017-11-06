"File type tab settings
autocmd Filetype ruby setlocal tabstop=2 shiftwidth=2 expandtab
autocmd Filetype python setlocal tabstop=4 shiftwidth=4 expandtab

" NERDTree config, set leader
let  mapleader = '\'
nmap <leader>t :NERDTree<cr>

" syntastic config options
let g:syntastic_mode_map = { 'mode': 'passive',
                          \ 'active_filetypes': [],
                          \ 'passive_filetypes': [] }
let g:syntastic_auto_loc_list=1

" by default only location list only updated when
" :Errors command is run with the below command
" always update location list when checkers run
let g:syntastic_always_populate_loc_list=1

" nmap <leader>c :SyntasticCheck<cr>
" nnoremap <silent> <F5> :SyntasticCheck<CR>
" nnoremap <silent> <F4> :lclose<CR>
" nnoremap <silent> <F3> :SyntasticReset<CR>

" syntastic file checkers, view a full list of file checkers with :help syntastic-checkers
" a checker listed in [] brackets will tell syntastic what to use automatically on :SyntasticCheck

" the syntax for each checker follows below pattern
" let g:syntastic_<filetype>_checkers = ['checker-name']
" to tell syntastic what executable version to run provide path
" let g:syntastic_ruby_ruby_exec = 'path/to/ruby/version'
let g:syntastic_ruby_checkers = ['mri', 'rubocop']
let g:syntastic_ruby_ruby_exec = '~/.rvm/rubies/ruby-2.3.0/bin/ruby'

let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_python_exec = '/usr/bin/python3'

" config options for vanilla vim
set nu
set cursorline
set cursorcolumn

" set color for vertical bar
highlight LineNr ctermfg = grey

" set color scheme
colorscheme slate

" other color schemes
" colorscheme elflord

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
call plug#end()
