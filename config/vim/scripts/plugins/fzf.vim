" https://github.com/junegunn/fzf.vim

" if exists(':Files')
nnoremap <C-o> :Files<CR>
" endif
nnoremap <space>b :Buffers<CR>

nnoremap <space>F :exec 'Files ' . expand('%:p:h')<CR> 
