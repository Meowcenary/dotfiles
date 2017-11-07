" The hopes of this configuration are to provide these features...
" - A way to navigate files with NERDTree
" - Faster movement with existing VIM shortcuts through EasyMotion
" - Highligthing and clearing search keywords using vanilla VIM settings
" - Syntax linting / code smell detection with syntastic
" - Remove whitespace on save / set tabs to spaces by filetype
" - Quick file navigation with ctrl+p (which is both a plugin
"     and the command used to invoke it
" - Easy commenting with universal shortcut for all files

" from better-whitespace, automatically strip trailing whitespace on save
autocmd BufEnter * EnableStripWhitespaceOnSave

" file type tab settings
autocmd Filetype ruby setlocal tabstop=2 shiftwidth=2 expandtab
autocmd Filetype python setlocal tabstop=4 shiftwidth=4 expandtab
autocmd Filetype javascript setlocal tabstop=4 shiftwidth=4 expandtab

" NERDTree config, set leader
let  mapleader = '\'
nmap <leader>t :NERDTree<cr>

" syntastic config options
" syntastic is not too complicated but you should really read up on what
" all of these configuration options are doing if you ever forget
" IMPORTANT: you have to actually install all the syntax checkers you want
"   to use. E.g flake8, rubocop, etc. syntastic just connects vim to a
"   linter program

let g:syntastic_mode_map = { 'mode': 'passive',
                          \ 'active_filetypes': [],
                          \ 'passive_filetypes': [] }

let g:syntastic_auto_loc_list=1

" by default only location list only updated when
" :Errors command is run with the below command
" always update location list when checkers run
let g:syntastic_always_populate_loc_list=1

" use f keys to control syntax checking
nnoremap <silent> <F5> :SyntasticCheck<CR>
nnoremap <silent> <F4> :Errors<CR>
nnoremap <silent> <F3> :lclose<CR>
nnoremap <silent> <F2> :SyntasticReset<CR>

" syntastic file checkers, view a full list of file checkers with :help syntastic-checkers
" a checker listed in [] brackets will tell syntastic what to use automatically on :SyntasticCheck

" the syntax for each checker follows below pattern
" let g:syntastic_<filetype>_checkers = ['checker-name']
" to tell syntastic what executable version to run provide path
" let g:syntastic_ruby_ruby_exec = 'path/to/ruby/version'
let g:syntastic_ruby_checkers = ['mri', 'rubocop']
let g:syntastic_ruby_ruby_exec = '/home/eric/.rubies/ruby-2.3.0/bin/ruby'

let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_python_exec = '/usr/bin/python3'

" set ctrlp to open files in new tabs on carriage return (clicking enter)
" normal behavior is for file to open in split buffer also possible to open
" file in new tab without this config by using <Ctrl-p> and then <Ctrl-t>
" instead of carriage return (clicking enter)
let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<c-t>'],
    \ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'],
    \ }

" remap ctrl b from scroll visible buffer back one page
" to open ctrlp in buffer mode
nnoremap <silent> <C-b> :CtrlPBuffer<CR><C-b>

" config options for vanilla vim
set nu
set cursorline
set cursorcolumn

" nohlsearch or noh command hides highlighting
set hlsearch

" <Ctrl-l> redraws the screen and removes and search highlighting
nnoremap <silent> <C-l> :nohl<CR><C-l>

" set color for vertical bar
highlight LineNr ctermfg = grey

" set color scheme, currently using custom badwolf color scheme
" install custom color schemes to ~/.vim/colors/<color_name>.vim
" DO NOT use plugins for colors, just download the color scheme
colorscheme badwolf

" other color schemes for different computers
" colorscheme elflord
" colorscheme slate
" colorscheme industry

" required to have airline plugin display
set laststatus=2

" plugins managed with vimplug: https://github.com/junegunn/vim-plug
" to install run, after installing vimplug, run :PlugInstall
" to remove a plugin, delete from this list and run :PlugClean
" to upgrade existing plugins run :PlugUpdate
" to upgrade vimplug run :PlugUpgrade
call plug#begin()
    Plug 'scrooloose/nerdtree'
    Plug 'easymotion/vim-easymotion'
    Plug 'ntpeters/vim-better-whitespace'
    Plug 'vim-airline/vim-airline'
    Plug 'scrooloose/syntastic'
    Plug 'kien/ctrlp.vim'
    Plug 'tomtom/tcomment_vim'
call plug#end()

" Plugins that have been previously used
"
" Plug 'bronson/vim-trailing-whitespace'
" Plug 'valloric/youcompleteme'
"
" Deprecated function replaced by tcomment_vim
"
" function is in vcomments.vim , config here
" source ~/vcomments.vim
" map <C-a> :call Comment()<CR>
" map <C-b> :call Uncomment()<CR>

