### Directory Listing

# ls - list the contents of a directory
# -1 list a single file per a row
# -A list files including hidden excluding .. and .
# -C force display in columns (often default)
# -F append special characters (often just adding / to directories)
# -G allow color coded display
# -h display storage size in human readable format (e.g MB, GB)
# -l list files in long format
# -t order files by time with most recent first
# -r reverse output order
#
# Example long format output with -h flag:
#    A   B         C   D      E       F       G          H
#    |{       }    | {   }  {   }    { } {          } {       }
#    -rw-r--r--    1 Admin  staff    11K Feb  5 13:34 README.md
#
#    (A) ftype: - , normal file
#               d , directory
#	        s , socket file
#               l , link file

#    (B) permissions: r , read
#                     w , write
#                     x , execute
#
#    (C) the number of links
#    (D) the file's owner (username)
#    (E) the file's group
#    (F) the storage size of the file
#    (G) time stamp with month, hour, minute
#    (H) the file's name
alias ll='ls -AFGhl'
alias lll='ls -AFGhl | less'
alias la='ls -ACFG'
alias l='ls -CFG'

### Utility

# *** This should be removed after the new function is tested***
# update this to a function at some point in the future so it can
# take an argument with head -n
#
# ps - process status
# -A display information about other users' processes, including those without controlling terminals
# -o display information associated with space or comma separated keyword list
#
# Example column names with descriptions:
#    user - process owner user name
#    uid - process owner user id
#    pid - process id
#    pcpu - percentage of cpu process is using
#
# head - show specified number of lines for a file or output
# -n specify the number of lines you want to show
alias cpu='ps -Ao user,uid,comm,pid,pcpu,tty -r | head -n 6'
# *** This should be removed after the new function is tested***

# df - display free disk space
# -H human readable format (Gigabyte, Megabyte, etc) in base 10 sizes
alias ds='df -H'

# history - displays
# grep - file parser that should install with linux by default
# ack - alternative to grep that should NOT be installed by default
alias hs='history | grep'

# *** This should be removed after the new function is tested***
# update this to check if file extension is .tar or .tar.gz and
# then use proper unarchive command
#
# tar - archive/unarchive groups of files similar to zip
# -x extract a tar ball
# -z decompress and extract the contents of a tar.gz file
# -j decompress and extrat the contents of a .tar.bz2 file
# -v verbose output, show progress while extracting
# -f provide an archive or a tarball at the end of the command
#    e.g tar -f some_tarball.tar
alias untar='tar -xvf'
alias untargz='tar -xzvf'
alias untarbz='tar -xjvf'
# *** This should be removed after the new function is tested***

### ExtendMed

alias exmed='cd ~/ExtendMedProjects'
alias cme='cd ~/ExtendMedProjects/cme'
alias asmgr='cd ~/ExtendMedProjects/asset_manager'
alias eprt='cd ~/ExtendMedProjects/expert-portal'
alias sprt='cd ~/ExtendMedProjects/speaker_portal'
alias reg='cd ~/ExtendMedProjects/patient_reg'
alias hec='cd ~/ExtendMedProjects/health-expert-connect'
