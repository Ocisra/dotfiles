#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# exec sway on login
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
	exec sway
fi
