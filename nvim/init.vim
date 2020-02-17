
function GetPlugDir()
  if (has('win32'))
    return '$LOCALAPPDATA/nvim/plugged'
  else
    return  '~/.config/nvim/plugged'
  endif
endfunction

let plugdir = GetPlugDir()

call plug#begin(plugdir)
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

" Linting and LSP
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}

" Editorconfig plugin
Plug 'editorconfig/editorconfig-vim'

Plug 'sheerun/vim-polyglot'
Plug 'lervag/vimtex'

" Snippets are separated from the engine. Add this if you want them:
Plug 'honza/vim-snippets'

Plug 'https://github.com/junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Initialize plugin system
call plug#end()


" Report that we have true color terminal
set termguicolors
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set background=light
set guifont=Cascadia\ Code:h13


" Set colorscheme 
colorscheme NeoSolarized

" So that we exit terminal-mode with escape
tnoremap <Esc> <C-\><C-n>

" Set shell to powershell core
"set shell=pwsh

" This makes vim more reliably with tools that detect changes on save
set backupcopy=yes

" Set leader and localleader to comma
let mapleader = ","
let maplocalleader = ","

nnoremap <leader>cd :cd %:p:h<CR>

" Remove highlight with leader+enter
nnoremap <leader><CR> :noh<CR>

" Make scrolling happen when 5 characters from top/bottom/left/right
set scrolloff=5
set sidescrolloff=5

" Use hidden buffers
set hidden

" Ignore casing in search/replace/etc.
set ignorecase
" Overrides ignore case if it contains upper case character
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

set wrap
set linebreak
set textwidth=80

" Ignore setting
set wildignore=.git,node_modules,.meteor,*.min.*,OneDrive

" Wild menu uses popup menu, which is a bit blended
if has('nvim-0.4')
  set wildoptions=pum
  set pumblend=15
endif

" Split on the other side
set splitbelow
set splitright

"let g:tmux_navigator_no_mappings = 1

" Key bind make -s
nmap <leader>mk :make -s<cr>

" Unfortunately, to enable markdown folding we have to put this here
" Since it doesn't work to put it in ftplugin markdown for some reason
let g:markdown_folding=1

" Start with no folds closed
set foldlevelstart=99

let g:vimtex_view_general_viewer = 'SumatraPDF'
let g:vimtex_view_general_options
      \ = '-reuse-instance -forward-search @tex @line @pdf'
let g:vimtex_view_general_options_latexmk = '-reuse-instance'


""""""""""" Polyglot settings
" I'd rather use vimtex than latex-box which is included in polyglot
" So let's disable polyglots latex support
let g:polyglot_disabled = ['latex']

""""""""""" UltiSnips config
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
"let g:UltiSnipsExpandTrigger="<tab>"
"let g:UltiSnipsJumpForwardTrigger="<c-b>"
"let g:UltiSnipsJumpBackwardTrigger="<c-z>"


""""""""""" FZF config

nmap <C-p> :Files<cr>
nmap <C-l> :Buffers<cr>

""""""""""" Coc configuration


" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes


" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` for navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
vmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use `:Format` for format current buffer
command! -nargs=0 Format :call CocAction('format')
nmap <leader>fa :Format<CR>

" Use `:Fold` for fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

command! -nargs=0 Prettier :CocCommand prettier.formatFile

""""""""""" Easy align configuration
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(LiveEasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(LiveEasyAlign)


if ($WAYLAND_DISPLAY) 
  let g:clipboard = {
      \   'name': 'wayland',
      \   'copy': {
      \      '+': 'wl-copy',
      \      '*': 'wl-copy',
      \    },
      \   'paste': {
      \      '+': 'wl-paste -n',
      \      '*': 'wl-paste -n',
      \   },
      \   'cache_enabled': 0,
      \ }
endif
