#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep="grep --color=auto"
alias pacman="pacman --color=auto"
alias dmesg="dmesg -T"

alias ping="ping -c1 archlinux.org"
alias wifi="sudo wifi-menu -o"
alias screen='grim -g "$(slurp)" screenshot.png' #'grim' and 'slurp' are wayland utilities
alias maintenance='sudo ~/script/maintenance.sh' #personal script for maintenance
alias start='wifi; maintenance'
alias usb='sudo ~/script/usb.sh'
alias cmon='conky -dc ~/.config/conky/cpu-mem-proc; conky -dc ~/.config/conky/network; conky -dc ~/.config/conky/disk'
#line displayed before your command on the shell
#for the colors : \033[colorcodem\] (don't forget the m)
#                 colorcode can be the form : 1;code for native bash colors 
#                                             38;5;code for ansi sequence in foreground
#                                             48;5;code for ansi sequence in background
PS1="\n\[\033[1;37m\]\342\224\214\$([[ \$? != 0 ]] && echo -e \"(\[\033[0;31m\]\xE2\x9C\x97\[\033[1;37m\])\")\342\224\200($(if [[ ${EUID} == 0 ]]; then echo '\[\033[38;5;34m\]\h'; else echo '\[\033[38;5;34m\]\u@\h'; fi)\[\033[1;37m\])\342\224\200(\[\033[38;5;34m\]\A \d\[\033[1;37m\])\[\033[1;37m\]\342\224\200(\[\033[38;5;34m\]\w\[\033[1;37m\])\n\342\224\224\342\224\200> \[\033[0m\]"

# Automatically prepend 'cd ' when a path is typed
shopt -s autocd
# Correct spelling error in 'cd'
shopt -s cdspell
# Correct spelling error in directory typing
shopt -s dirspell


export EDITOR=nvim
export Term=screen-256color
