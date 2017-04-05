export TERM="xterm-256color"
export KEYTIMEOUT=1 #Reduces lag when switching vi mode
###################################
# ZGEN
###################################
source ~/.zgen/zgen.zsh

if ! zgen saved; then
    zgen oh-my-zsh

    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/common-aliases
    zgen oh-my-zsh plugins/vi-mode

    zgen load denysdovhan/spaceship-zsh-theme spaceship
    zgen load zsh-users/zsh-syntax-highlighting
    zgen load joel-porquet/zsh-dircolors-solarized.git

	zgen save
fi

source ~/.spaceship-theme

###################################
# General
###################################
PATH=~/.bin:$PATH

###################################
# Sources
###################################
###################################
# Exports
###################################
# Uses vim as default editor
export EDITOR=vim

export DEFAULT_USER=michael

###################################
# Aliases
###################################
# Exit vi-style
alias :q=exit

###################################
# Tmux
###################################
if [ -z "$TMUX" ]; then
    base_session='main'
    # Create a new session if it doesn't exist
    tmux has-session -t $base_session || tmux new-session -d -s $base_session
    # Are there any clients connected already?
    client_cnt=$(tmux list-clients | wc -l)
    if [ $client_cnt -ge 1 ]; then
        session_name=$base_session"-"$client_cnt
        tmux new-session -d -s $session_name
        tmux -2 attach-session -t $session_name \; set-option destroy-unattached
        builtin exit
    else
        tmux -2 attach-session -t $base_session
        builtin exit
    fi
fi
###################################
# Installation lines
###################################
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
#zstyle :compinstall filename '/home/michael/.zshrc'

#autoload -Uz compinit
#compinit
# End of lines added by compinstall

if [ $TERMINIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi

