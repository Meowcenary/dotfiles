# archive / unarchive tar, tar.gz, tar.bz
targz() { tar -cvf $1.tar.gz $1; rm -r $1; }
untar { tar -xvf $1; rm -r $1; }

# count files in a directory
# wc - word, line, character, and byte counter
# -l number of lines in each input file is output
numfiles() {
    N="$(ls $1 | wc -l)";
    echo "$N files in $1";
}

# make a directory and immediately enter it
mkcd() { mkdir -p $1; cd $1 }

