
" Auto commands

" https://learnvimscriptthehardway.stevelosh.com/chapters/12.html


" Event list
" https://vimdoc.sourceforge.net/htmldoc/autocmd.html#:~:text=autocmd%2Devents,-%2A%20%2AE215

" If no filetype is set, run filetype detect
" Modified from https://vi.stackexchange.com/a/25675
augroup file_types " {
	autocmd!
	" When entering/viewing a buffer, if no filetype, detect one
	autocmd BufEnter * if &ft ==# '' | filetype detect | endif
	" And also run once on first open
	autocmd VimEnter * if &ft ==# '' | filetype detect | endif
augroup END } "


