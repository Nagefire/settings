#locale
export LC_ALL="en_US.UTF-8"

#netctl start wlp8s0-Billy\ Goat 

# neat aliases
alias ls="ls --color=auto"
alias ll="ls -l"
alias la="ls -a"
alias pacman="pacman --color auto"

export EDITOR=vim

# completion
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
autoload -U compinit
compinit

# prompt
autoload -U colors && colors
PROMPT_NAME="%{${fg_bold[yellow]}%}%n "
PROMPT_CWD="%{${fg_bold[cyan]}%}%~ "
PROMPT_ARROW="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ %s)"
PS1="$PROMPT_NAME$PROMPT_CWD$PROMPT_ARROW%{$reset_color%}"

#Make keys work
bindkey '\e[1~' beginning-of-line
bindkey '\e[6~' end-of-history
bindkey '\e[4~' end-of-line

case $TERM in (xterm*)
bindkey '\eOH'  beginning-of-line
bindkey '\eOF'  end-of-line
esac

bindkey '\e[3~' delete-char
bindkey '\e[6~' end-of-history
bindkey '\e[2~' redisplay

archey3
