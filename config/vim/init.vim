
" Autoload everything in our custom autoload folders
function! s:auto_load( files )
	for script in a:files
		exec 'source ' . script
	endfor
endfunction

call s:auto_load( globpath('$XDG_CONFIG_HOME/vim/autoload', '*', 1, 1) )
call s:auto_load( globpath('$XDG_CACHE_HOME/vim/autoload', '*', 1, 1) )


set rtp+=$XDG_CONFIG_HOME/vim
set rtp+=$XDG_CACHE_HOME/vim

let g:_config_path = "$XDG_CONFIG_HOME/vim"
function! g:_source( file )
	exec 'source ' . g:_config_path . a:file
endfunction

" Sourcing our custom scripts
if executable('git') " If we don't have git, then there's absolutely no point in plugin-ing
	call g:_source( '/scripts/plugins.vim' )
endif
call g:_source( '/scripts/autocmds.vim' )
call g:_source( '/scripts/options.vim' )

