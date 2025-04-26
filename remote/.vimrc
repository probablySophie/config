syntax on   " Syntax highlighting
set mouse=a " Mouse mode!

set background=dark
colo retrobox

set encoding=utf-8
set laststatus=1

set number        " Show line numbers
set linebreak     " wrap text
set showmatch     " highlight matching brackets
set visualbell    " flash if bell (and don't beep)
set hlsearch      " highlights all search matches
set smartcase     " fancy case searching
set gdefault      " all matches in line
set ignorecase    " Ignore case in searches
set incsearch     " Searches as you type?
set autoindent    " Auto... indent...
set smartindent   " ...?
set shiftwidth    " tabwidth
set noexpandtab   " ...
set softtabstop=4 " tab

set ruler
set undolevels=1000
set backspace=indent,eol,start
set lazyredraw
set wildmenu

" Normal mode Redo & Undo
map r :redo<cr>

" Select all
map % ggVG

" Ctrl+s Saving
map! <C-s> <cmd>:w<cr>
map  <C-s>      :w<cr>

" Reload the config
map <C-r> :so %<cr>

" Tabs!  So many tabs!
map <C-Right> :tabnext<cr>
map <C-Left> :tabprevious<cr>
nnoremap <Tab>n :tabnew<cr>
nnoremap W :tabclose<cr>

" Quick swap between tabs
nnoremap <Tab>1 1gt
nnoremap <Tab>2 2gt
nnoremap <Tab>3 3gt
nnoremap <Tab>4 4gt
nnoremap <Tab>5 5gt
nnoremap <Tab>6 6gt
nnoremap <Tab>7 7gt
nnoremap <Tab>8 8gt
nnoremap <Tab>9 9gt

" Folding!
set foldenable                               " Yes pls
set foldlevelstart=10                        " Mostly unfolded at start
set foldnestmax=10                           " Allow lots of folding
set foldmethod=syntax                        " Fold based on indentation pls

map ff :fold<cr>
map fo :foldopen<cr>
map fc :foldclose<cr>

" Autocompletion?!
set omnifunc=syntaxcomplete#Complete
set completeopt=menuone,preview,noselect,noinsert

" Always open multiple files in tabs instead of buffers :)
:tab all
