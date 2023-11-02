#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# exec sway on login on tty1
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
	export XDG_CURRENT_DESKTOP=sway
    exec sway
fi
