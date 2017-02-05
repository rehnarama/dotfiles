###################################
# Antigen
###################################
source ~/.bin/antigen.zsh

antigen use oh-my-zsh

#Use homemade agnoster theme for solarized light
antigen theme https://gist.github.com/anonymous/053976332c1053782789900255a25ec8 agnoster

antigen bundle git
antigen bundle git-extras
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle npm
antigen bundle common-aliases
antigen bundle vi-mode

antigen apply

###################################
# General
###################################
PATH=~/.bin:$PATH

# Enables vi-mode
#bindkey -v

###################################
# Sources
###################################
###################################
# Exports
###################################
# Fixes meteor mongod
export LC_ALL=en_GB.UTF-8

# Uses vim as default editor
export EDITOR=vim

###################################
# Aliases
###################################
# Exit vi-style
alias :q=exit

alias vim=nvim
###################################
# Installation lines
###################################
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/michael/.zshrc'

autoload -Uz compinit
#compinit
# End of lines added by compinstall

if [ $TERMINIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi

# added by travis gem
[ -f /home/michael/.travis/travis.sh ] && source /home/michael/.travis/travis.sh
