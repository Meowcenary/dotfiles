At some point in the near future I'll need to reorganize things as I start
filling the repo with more distro specific linux config files and scripts,
but for now many of the new files, particularly extra readmes and
anything related to x windows are all planned to go into an archlinux
directory with everything else not relating enough to anything else
to be worthy of a directory.

.vimrc:
   uses vim-plug from here: https://github.com/junegunn/vim-plug

   mostly getting plugins from http://vimawesome.com/

   vim commands: :FixWhitespace , removes whitespace at end of lines
                 ctrl + a , comments out a section of code
                 ctrl + b , uncomments out a section of code

   *airline requires 'set laststatus=2' in vimrc to work*

   *syntastic requires a syntax checker*
   e.g for python using flake8
   check out the documenation online, dont bother with the vim command

.gitconfig:
    shortcuts for git. these are all lifted from other gitconfig files
    that were shared with me

