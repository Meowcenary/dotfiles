# This file is sourced when running statx and
# other programs which call xinit

# turn off terminal bell
xset -b

# set capslock to ctrl key
setxkbmap -option caps:ctrl_modifier

# run blackbox, any line after an exec 
# command will be ignored
exec blackbox
