#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -f ~/.bash/.bash_utils ]; then
    . ~/.bash/.bash_utils
fi

if [ -f ~/.bash/.bash_aliases ]; then
    . ~/.bash/.bash_aliases
fi

if [ -f ~/.bash/.bash_prompt ]; then
    . ~/.bash/.bash_prompt
fi

if [ -f ~/.bash/.bash_env ]; then
    . ~/.bash/.bash_env
fi

systemctl --user enable opentabletdriver.service --now