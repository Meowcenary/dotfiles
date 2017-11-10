" THINGS TO ADD
" - need syntastic checker and runtime for javascript and jsx, probably ESLint
" - autocomplete for ruby, javasript, jsx, yaml, and other rails related stuff
"   for now you complete me is promising, but kind of hard to install
" - decide if fugitive is even worthwhile or not (probably not)
"
" The hopes of this configuration are to provide these features...
" - A way to visualize and navigate a file structure with NERDTree
" - Quickly search for files in structure and open buffers with ctrlp
" - Search for phrases with ackvim
" - Faster movement with existing vim shortcuts through EasyMotion
" - Highlighting and clearing search keywords using vanilla vim settings
"     and vim-polyglot
" - Syntax linting / code smell detection with syntastic
" - Remove whitespace on save / set tabs to spaces by filetype
" - Easy commenting with universal command for all filetypes
" - Status bar using airline
" - Git integration to vim and airline status bar with fugitive
"
" These are the most frequently used shortcuts, each key is separated with
" a '-' but should be entered as a chord or in quick sequence (e.g g-c-c means
" click g and then c twice)
"
" g-c-c : toggle commenting on a line or area
" \-t : open NERD TREE
" \-\ <some motion key> : invoke easy motion in direction of motion key
" ctrl-p : open ctrlp in file search
" ctrl-b : open ctrlp in buffer search
" f5 : run syntastic checkers
" f4 : open synatstic error buffer
" f3 : close synatstic error buffer
" f2 : clear (reset) syntastic error checkers
" :Ack [options] {pattern} [{directories}] : search recursively through
"     directories starting at the current working directory by default
"     be careful when running this on a large directory in a vim buffer
" :Git [git command] : due to fugitive this will run the git command even
"     with the aliases from your gitconfig and spit it out in a terminal
"     there are some other commands specific to fugitive, but  I dont use
"     them so I wont go into that. Read more here: https://github.com/tpope/vim-fugitive
" ctrl-w : this is the opening command for commands invovling buffer splits on a tab
"     the below commands follow the initial ctrl-w
"
"     ctrl-w : cycle through buffers
"     h, j, k, l : move to the nearest tab in the vim movement key direction specified
"     s : open a horizontal split
"     v : open a vertical split
"     c : close the current buffer
"     o : close the other buffer leaving just the current one if there are several open

" from better-whitespace, automatically strip trailing whitespace on save
autocmd BufEnter * EnableStripWhitespaceOnSave

" Using with vim-polyglot to highlight syntax on nearly all filetypes
syntax on

" file type tab settings, these might be handled by vim-polyglot too
autocmd Filetype ruby setlocal tabstop=2 shiftwidth=2 expandtab
autocmd Filetype python setlocal tabstop=4 shiftwidth=4 expandtab
autocmd Filetype javascript setlocal tabstop=4 shiftwidth=4 expandtab

" NERDTree config
" defaults left in
" gt : move right one tab
" gT : move left one tab
" <number>gt : move to the <number> tab
"               e.g 4gt goes to tab 4

" set leader and invocation for side file tree view
let  mapleader = '\'
nmap <leader>t :NERDTree<cr>

" quickly move to first or last tab
nnoremap <silent> tl :tablast<CR>
nnoremap <silent> tf :tabfirst<CR>

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
"
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

" <Ctrl-l> redraws the screen removing search highlighting and snytastic markings
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

" [Formatting Note] this would probably make more sense at the top of the file
"                   so that anyone could see what plugins are installed before seeing how
"                   how they're all configured
"
" plugins managed with vimplug: https://github.com/junegunn/vim-plug
" to install run, after installing vimplug, run :PlugInstall
" to remove a plugin, delete from this list and run :PlugClean
" to upgrade existing plugins run :PlugUpdate
" to upgrade vimplug run :PlugUpgrade
" to view existing plugin statuses run :PlugStatus
call plug#begin()
    Plug 'scrooloose/nerdtree'
    Plug 'easymotion/vim-easymotion'
    Plug 'ntpeters/vim-better-whitespace'
    Plug 'vim-airline/vim-airline'
    Plug 'scrooloose/syntastic'
    Plug 'kien/ctrlp.vim'
    Plug 'tomtom/tcomment_vim'
    Plug 'mileszs/ack.vim'
    Plug 'sheerun/vim-polyglot'
    Plug 'tpope/vim-fugitive'
call plug#end()

" Plugins and functions that have been previously used
"
" Plug 'bronson/vim-trailing-whitespace'
" Plug 'valloric/youcompleteme'
"
" function is in vcomments.vim , config here
" source ~/vcomments.vim
" map <C-a> :call Comment()<CR>
" map <C-b> :call Uncomment()<CR>

