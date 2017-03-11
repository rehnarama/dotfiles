export TERM="xterm-256color"
export POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(background_jobs context dir vcs)
export POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status rbenv virtualenv vi_mode)
export POWERLEVEL9K_PROMPT_ON_NEWLINE=true
export POWERLEVEL9K_MODE='awesome-fontconfig'
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

	zgen load bhilburn/powerlevel9k powerlevel9k
	zgen load zsh-users/zsh-syntax-highlighting
	zgen load joel-porquet/zsh-dircolors-solarized.git

	zgen save
fi
# Fix for powerlevel9k vi_mode indicator
source ~/.vi_mode.zsh
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

