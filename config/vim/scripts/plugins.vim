" Vim Plugins
" https://github.com/junegunn/vim-plug

" INFO: Auto install vim.plug
" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
if empty(glob( "$XDG_CACHE_HOME/vim/autoload/plug.vim" ))
	echo "Installing plug.vim"
	if executable('curl')
		silent execute '!curl -fLo "$XDG_CACHE_HOME/vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
		autocmd VimEnter * PlugInstall --sync 
	endif
endif


let g:_plug_path = "$XDG_CACHE_HOME/vim/plugged" 

call plug#begin(g:_plug_path)

" Register vim-plug as a plugin so we get the :help pages for it
Plug 'junegunn/vim-plug'

if executable('fzf') " Only use the fzf plugins if fzf exists
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
endif

" https://github.com/rhysd/vim-healthcheck
if !has('nvim') | Plug 'rhysd/vim-healthcheck' | endif

" https://github.com/prabirshrestha/vim-lsp

" if executable('node')
" 	" LSPs? https://github.com/neoclide/coc.nvim
" 	Plug 'neoclide/coc.nvim', {'branch': 'release'}
" endif

call plug#end()

call g:_source( '/scripts/plugins/fzf.vim' )
