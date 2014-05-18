" Example local .vimrc file to auto run python code and put its output in a
" variable sized buffer.
autocmd FileType python nnoremap <buffer><silent> <leader>w :w!<CR>:exe 'QuickRun python -outputter/buffer/split ''' . QuickRunSplit() . ''''<CR>
