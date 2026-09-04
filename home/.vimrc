" If you've got no colouration here - you're probably using a VERY minimal version of vim and may want to install a better version from your package manager

" Keymaps
nmap <C-left> :tabprev<CR>
nmap <C-right> :tabnext<CR>

" Saving
nmap <C-s> :w<CR>
inoremap <C-s> <C-o>:w<CR>

function! s:multi_noremap( modes, from, to )
	for mode in a:modes
		exec mode . 'noremap ' . a:from . ' ' . a:to
	endfor	
endfunction

nmap qq :q<CR>
nmap qa :qa<CR>

nnoremap <Space>wq :qa<CR>
nnoremap r :redo<CR>

" Jumping around
call s:multi_noremap( 'nv', 'gh', '0' ) " Jump to start of line 
call s:multi_noremap( 'nv', 'gl', '$' ) " Jump to end of line
" call s:multi_noremap( 'nv', 'ge', '::$<CR>' ) " Jump to end of file
nnoremap ge ::$<CR>

nnoremap <down> gj
nnoremap <up> gk

" Settings
set tabstop=4
set noexpandtab

" https://www.vimfromscratch.com/articles/vim-folding
set foldmethod=indent
nnoremap ff za

set signcolumn=yes
set wildignorecase
set smartindent
set number
set incsearch
set ignorecase
set whichwrap=b,s,<,>,[,]
set mouse=a
set termguicolors
colorscheme catppuccin

set completeopt="menu,menuone,popup,noselect,fuzzy,preview"
set omnifunc=syntaxcomplete#Complete

set hidden " Don't ask about changing buffers if we've edited the current buffer

" Splits
nnoremap <Space>ws :split<CR>
nnoremap <Space>w<down> <c-w>j
nnoremap <Space>w<up> <c-w>k
nnoremap <Space>w<left> <c-w>h
nnoremap <Space>w<right> <c-w>l

" Tabs 
nnoremap W :bd<CR>

" Auto-reload .vimrc if edited i
" https://www.reddit.com/r/vim/comments/t9lm4x/comment/hzywqf3/
augroup reload_vimrc " {
	autocmd!
	autocmd BufWritePost ~/.vimrc source ~/.vimrc
augroup END } "

" On enter open all buffers as tabs
augroup tab_friends " {
	autocmd VimEnter * tab ball
	" autocmd BufAdd * tab ball
	" autocmd BufCreate
augroup END } "

source ~/.config/vim/init.vim
