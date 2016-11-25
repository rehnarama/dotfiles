###################################
# Antigen
###################################
source /usr/share/zsh/scripts/antigen/antigen.zsh

antigen use oh-my-zsh

#Use homemade agnoster theme for solarized light
antigen theme https://gist.github.com/anonymous/053976332c1053782789900255a25ec8 agnoster

antigen bundle git
antigen bundle git-extras
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle npm
antigen bundle vi-mode
antigen bundle common-aliases

antigen apply

###################################
# General
###################################
PATH=~/bin:~/.gem/ruby/2.3.0/bin:$PATH

eval `dircolors ~/.dir_colors/dircolors`
###################################
# Sources
###################################
# Sources in __git_ps1
source /usr/share/git/completion/git-prompt.sh

# Sources in antelope aliases
source /home/michael/.antelopealias
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
# Quick install alias
alias installera='yaourt --noconfirm'

# Exit vi-style
alias :q=exit

alias vim='vim --servername VIM'
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

# Should fix so that terminal new tab opens in same dir... But doesn't...
. /etc/profile.d/vte.sh
__vte_osc7
