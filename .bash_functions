# archive unarchive tar.gz
targz() { tar -cvf $1.tar.gz $1; rm -r $1; }

# extract any archive type
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

