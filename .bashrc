#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep="grep --color=auto"
alias ping="ping -c1 archlinux.org"
alias wifi="sudo wifi-menu -o"
alias lsa="ls -a"
alias screen='grim -g "$(slurp)" screenshot.png' #'grim' and 'slurp' are wayland utilities
alias maintenance='sudo ~/script/maintenance.sh' #personal script for maintenance
alias start='wifi; maintenance'
#line displayed before your command on the shell
PS1="\n\[\033[1;37m\]\342\224\214\$([[ \$? != 0 ]] && echo -e \"(\[\033[0;31m\]\xE2\x9C\x97\[\033[1;37m\])\")\342\224\200($(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\033[01;34m\]\u@\h'; fi)\[\033[1;37m\])\342\224\200(\[\033[1;34m\]\A \d\[\033[1;37m\])\[\033[1;37m\]\342\224\200(\[\033[1;32m\]\w\[\033[1;37m\])\342\224\200(\[\033[1;32m\]\$(ls -1 | wc -l | sed 's: ::g') files, \$(ls -sh | head -n1 | sed 's/total //')b\[\033[1;37m\])\n\342\224\224\342\224\200> \[\033[0m\]"

# Automatically prepend 'cd ' when a path is typed
shopt -s autocd


export EDITOR=vim
export Term=screen-256color
