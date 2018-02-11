# Improvements:
#
# - update ff (find file) to have two new flags one
#   for searching hidden files in addition to visible files
# - finish writing function to find and delete files

# archive unarchive tar.gz
targz() { tar -cvf $1.tar.gz $1; rm -r $1; }

# extract any archive type
# on **Debian 9 with MATE** by default can handle all formats except rar
# install rar with: sudo apt install -y rar
extract()
{
    if [ -f $1 ] ; then
         case $1 in
            *.tar.bz2)
                tar xvjf $1
                ;;
            *.tar.gz)
                tar xvzf $1
                ;;
            *.bz2)
                bunzip2 $1
                ;;
            *.rar)
                unrar x $1
                ;;
            *.gz)
                gunzip $1
                ;;
            *.tar)
                tar xvf $1
                ;;
            *.tbz2)
                tar xvjf $1
                ;;
            *.tgz)
                tar xvzf $1
                ;;
            *.zip)
                unzip $1
                ;;
            *.Z)
                uncompress $1
                ;;
            *.7z)
                7z x $1
                ;;
            *)
                echo "'$1' cannot be extracted via extract"
                ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# # count files in a directory
# # wc - word, line, character, and byte counter
# # -l number of lines in each input file is output
numfiles() {
    N="$(ls $1 | wc -l)";
    echo "$N files in $1";
}

# make a directory and immediately enter it
mkcd() { mkdir -p $1; cd $1; }

# search for files that contain any part of name recursively in a directory
# uses a ternary operator with the following syntax
# [[ condition ]] && true branch || false branch;
#
# bash is very picky and there must be spaces between the condition and brackets
# and a semicolon at the end or it will throw errors. see below erroneous examples
#
# The below syntax will not work because there are no spaces between
# the condition and the brackets
#
# [[condition]] && true branch || false branch;
#
# The below syntax will not work because there is no semicolon at the end
#
# [[ condition ]] && true branch || false branch
ff() { [[ ! -z $1 ]] && find . -name "*$1*" -type f || echo 'Error: enter a file name'; }

# WIP
# -----------------------------------------------------
# - find all files in directory and subdirectories that
# - contain a provided string list those files in a nice
#   format
# - show confirm message after list, require capital YES
#   to delete else cancel out
# - display success, error, or cancel message
#
# ffd()
# {
#     find . -name "*$1*" -type f
# }

