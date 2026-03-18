" ╔══════════════════════════════════════════════════════════════╗
" ║  Minimalist Neovim Config — Sane Defaults for Getting Started  ║
" ╚══════════════════════════════════════════════════════════════╝
"
" Tips for learning vim:
"   :Tutor           — built-in 30-min interactive tutorial (start here!)
"   h/j/k/l          — left/down/up/right
"   i                — enter insert mode (type text)
"   Esc or jk        — back to normal mode
"   :w               — save, :q — quit, :wq — save+quit
"   dd               — delete line, yy — copy line, p — paste
"   /pattern         — search, n/N — next/prev match
"   u / Ctrl-r       — undo / redo
"   ciw              — change inner word (delete word + insert mode)

" ───── Basics ─────
set nocompatible             " Use Vim defaults (not vi)
filetype plugin indent on    " Detect filetypes, load plugins + indent rules
syntax enable                " Syntax highlighting

" ───── Appearance ─────
set number                   " Show line numbers
set relativenumber           " Relative line numbers (great for jumping: 5j, 12k)
set cursorline               " Highlight the current line
set signcolumn=yes           " Always show sign column (no layout shift)
set termguicolors            " True color support
set showmatch                " Briefly highlight matching bracket
set scrolloff=8              " Keep 8 lines visible above/below cursor
set sidescrolloff=8          " Keep 8 columns visible left/right of cursor
set colorcolumn=80           " Soft ruler at 80 chars

" ───── Indentation ─────
set expandtab                " Spaces instead of tabs
set tabstop=4                " Tab = 4 spaces visually
set shiftwidth=4             " Indent = 4 spaces
set smartindent              " Auto-indent new lines
set shiftround               " Round indent to multiple of shiftwidth

" ───── Search ─────
set ignorecase               " Case-insensitive search...
set smartcase                " ...unless you type uppercase
set incsearch                " Search as you type
set hlsearch                 " Highlight search results

" ───── Usability ─────
set mouse=a                  " Enable mouse (scrolling, clicking, selecting)
set clipboard=unnamedplus    " Use system clipboard (yank/paste work with Cmd+C/V)
set hidden                   " Allow switching buffers without saving
set undofile                 " Persistent undo (survives closing the file)
set undodir=~/.local/state/nvim/undo
set noswapfile               " No swap files (yadm manages your files)
set updatetime=250           " Faster CursorHold events (useful for plugins later)
set splitright               " New vertical splits open to the right
set splitbelow               " New horizontal splits open below
set wildmenu                 " Enhanced command-line completion
set wildmode=longest:full,full

" ───── Key Mappings ─────
" Set leader key to space (most popular choice)
let mapleader = " "

" jk to escape insert mode (faster than reaching for Esc)
inoremap jk <Esc>

" Clear search highlighting with leader + h
nnoremap <leader>h :nohlsearch<CR>

" Save with leader + w
nnoremap <leader>w :w<CR>

" Quit with leader + q
nnoremap <leader>q :q<CR>

" Better window navigation (Ctrl + h/j/k/l to move between splits)
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Move selected lines up/down in visual mode
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Keep cursor centered when scrolling
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Keep cursor centered when searching
nnoremap n nzzzv
nnoremap N Nzzzv

" ───── Status Line (built-in, no plugin needed) ─────
set laststatus=2
set statusline=
set statusline+=\ %f               " File path
set statusline+=\ %m               " Modified flag
set statusline+=%=                  " Right-align the rest
set statusline+=\ %y               " File type
set statusline+=\ %l:%c            " Line:Column
set statusline+=\ %p%%\            " Percentage through file

" ───── Netrw (built-in file explorer) ─────
" Open with :Ex or :Vex (vertical split)
let g:netrw_banner = 0           " Hide the banner
let g:netrw_liststyle = 3        " Tree view
let g:netrw_winsize = 25         " 25% width
nnoremap <leader>e :Ex<CR>

" ───── Auto Commands ─────
" Remove trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

" Return to last edit position when opening files
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif
