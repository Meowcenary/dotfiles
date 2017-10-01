#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

#replace -eq 1 with something like -le 3 (for vt1 to vt3) if you want
#graphical logins on more than virtual terminal
if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
	#if you want to remain logged in when x session ends
	#use startx, otherwise use exec startx
	#exec startx
	startx
fi
