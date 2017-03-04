set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=$HOME/vimfiles/bundle/Vundle.vim
call vundle#begin('$HOME/vimfiles/bundle/')
source $HOME/.plugins.vim
call vundle#end()

source $HOME/.common.vim
