" Fix clipboard integration with WSL
let g:clipboard = {
      \   'name': 'wsl-clipboard',
      \   'copy': {
      \      '+': 'win32yank.exe -i',
      \      '*': 'win32yank.exe -i',
      \    },
      \   'paste': {
      \      '+': 'win32yank.exe -o',
      \      '*': 'win32yank.exe -o',
      \   },
      \   'cache_enabled': 1,
      \ }


call plug#begin('~/.config/nvim/plugged')
Plug 'junegunn/vim-easy-align'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdcommenter'
Plug 'lifepillar/vim-solarized8'
Plug 'airblade/vim-gitgutter'
Plug 'cohama/lexima.vim'
Plug 'tpope/vim-repeat'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'ervandew/supertab'

Plug 'mileszs/ack.vim'
call plug#end()

colorscheme solarized8_dark

" Set leader to comma
let mapleader = ","
let g:mapleader = ","

" Ignore these folders
set wildignore+=*/node_modules/*,*/.meteor/*

" Ignore case when searching
set ignorecase

" Overrides ignore case if mathing case
set smartcase

" Allow hidden buffers
set hidden

" Disables highlight after a search
map <silent> <leader><cr> :noh<cr>

" Spaces instead of tab
set expandtab

" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2

" Try to guess what indent level next row should have
set smartindent

" Move a line of text using ALT+[jk] or Command+[jk] on mac
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Move from split windows with ctrl-h/j/k/l
nnoremap <C-k> :wincmd k<CR>
nnoremap <C-j> :wincmd j<CR>
nnoremap <C-h> :wincmd h<CR>
nnoremap <C-l> :wincmd l<CR>

" Use <Esc> to exit terminal mode
tnoremap <Esc> <C-\><C-n>

" Toggle nerdtree on leader d
map <leader>d :NERDTreeToggle<cr>

" Show lines numbers
set number

" Insert snippet on Ctrl-J
let g:UltiSnipsExpandTrigger='<C-j>'
imap <C-k>   <c-y>,

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

set inccommand=nosplit

nmap <C-p> :FZF<cr>
