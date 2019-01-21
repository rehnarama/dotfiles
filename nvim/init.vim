" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('$LOCALAPPDATA/nvim/plugged')

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" For nice colours
Plug 'iCyMind/NeoSolarized'
Plug 'soft-aesthetic/soft-era-vim'

" For easier (de)surrounding of text objects with operators
Plug 'tpope/vim-surround'

" Toggle comments with an operator, 'gc'
Plug 'tpope/vim-commentary'

" Repeat un-repeatable things with '.'
Plug 'tpope/vim-repeat'

" An improved netrw fork 
Plug 'tpope/vim-vinegar'

" For finding files
Plug 'Shougo/denite.nvim'

" Linting and LSP
Plug 'w0rp/ale'

" Editorconfig plugin
Plug 'editorconfig/editorconfig-vim'

" rust support
Plug 'rust-lang/rust.vim'

" Initialize plugin system
call plug#end()

" Report that we have true color terminal
set termguicolors
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set background=light

" Set colorscheme 
colorscheme NeoSolarized

" So that we exit terminal-mode with escape
tnoremap <Esc> <C-\><C-n>

" Set shell to powershell core
"set shell=pwsh

" Set leader and localleader to comma
let mapleader = ","
let maplocalleader = ","

" Remove highlight with leader+enter
nnoremap <leader><CR> :noh<CR>

" Use hidden buffers
set hidden

" Overrides ignore case if mathing case
set smartcase

" Allow hidden buffers
set hidden

" Show realtime effect of substitute commands
set inccommand=nosplit

" Try to guess what indent level next row should have
set smartindent

" Set tab to spaces
set tabstop=2
set shiftwidth=2
set expandtab

" Set line numbers
set number
" But turn it off in terminal windows!
augroup TerminalStuff
  autocmd TermOpen * setlocal nonumber norelativenumber
augroup END

" Set a colored column at column 80
set colorcolumn=80

" Ignore setting
set wildignore=.git,node_modules,.meteor,*.min.*,OneDrive

""""""""""" Easy align configuration
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(LiveEasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(LiveEasyAlign)

""""""""""" Denite configuration
" Opens buffer picker and file picker with ctrl+p
nmap <C-p> :Denite buffer file/rec<CR>

" For file picker, use ripgrep
call denite#custom#var('file/rec', 'command',
  \ ['rg', '--files'])

" For grep, use ripgrep
call denite#custom#var('grep', 'command', ['rg'])
call denite#custom#var('grep', 'default_opts',
		\ ['-i', '--vimgrep', '--no-heading'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

" When browsing denite entries, press escape to enter 'normal mode'
call denite#custom#map(
	      \ 'insert',
	      \ '<Esc>',
	      \ '<denite:enter_mode:normal>',
	      \)

