
" Always show the statusline
set laststatus=2

highlight StatusNOR cterm=bold term=bold ctermbg=blue ctermfg=black
highlight StatusINS cterm=bold term=bold ctermbg=green ctermfg=black
highlight StatusVIS cterm=bold term=bold ctermbg=147 ctermfg=black
highlight StatusCMD cterm=bold term=bold ctermbg=red ctermfg=black

set statusline=
set statusline+=%#StatusNOR#%{(mode()=='n')?'\ \ NOR\ ':''}
set statusline+=%#StatusINS#%{(mode()=='i')?'\ \ INS\ ':''}
set statusline+=%#StatusVIS#%{(mode()=='v')?'\ \ VIS\ ':''}
set statusline+=%#StatusCMD#%{(mode()=='c')?'\ \ CMD\ ':''}
" set statusline+=%{StatuslineMode()}
" Reset back to normal
set statusline+=%#StatusLineTerm#
set statusline+=\ %f%m\ %r
" Align right
set statusline+=%=
set statusline+=\ %3l:%c\ %2p%%\ %{&filetype}
