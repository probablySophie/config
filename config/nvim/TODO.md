
https://github.com/MeanderingProgrammer/render-markdown.nvim

## Config

* [ ] `gf` should open the file in a new tab
* [ ] `: e my_file.txt` should also open the file in a new tab

* [x] [Folding](https://neovim.io/doc/user/fold.html)
* [ ] Goto file `gf` should open in a new tab ideally (`:noremap <C-w>gf`)
* [ ] An auto-command that checks for multiple opened buffers (nvim file1.txt file2.txt) and opens them as tab-pages (nvim -p file1.txt file2.txt)
* [ ] Rebind some selection-y things to work the same as Helix (https://neovim.io/doc/user/motion.html)
	* [x] `gh` goto start of line
	* [x] `gl` goto end of line
	* [x] `ge` goto end of document
	* [x] `gg` goto start of document
	* [ ] Can we make surrounding things in visual mode work with `ms{char}`?
* [x] Change `shift+w` to be buffer close instead of quit?

## Plugins?

* [ ] Commenting & Block commenting code
* [x] Markdown inline previews
* [ ] Highlight todos & such
* [ ] Autocomplete characters `(` `[` `{` `\`` `"`  `'`

## Pickers/Popups

* [x] `ctrl+o` File picker
* [ ] Buffer Picker/Switcher
* [x] `space+b` Tab Picker/Switcher

## Auto Commands?

* [ ] Reddit: [Share your favourite auto-commands](https://www.reddit.com/r/neovim/comments/1i2xw2m/share_your_favorite_autocmds/)

