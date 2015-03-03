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

archey3
