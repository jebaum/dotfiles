if exists('g:loaded_neocomplete')
  let g:neocomplete#enable_at_startup                 = 1
  let g:neocomplete#enable_smart_case                 = 1
  let g:neocomplete#enable_auto_select                = 0
  let g:neocomplete#enable_refresh_always             = 0  " default is zero, heavy feature
  let g:neocomplete#sources#syntax#min_keyword_length = 3
  let g:neocomplete#lock_buffer_name_pattern          = '\*ku\*'

  " use words with at least 7 letters from google-10000 for completion in .txt files
  let g:neocomplete#sources#dictionary#dictionaries = {'_':'/home/james/dotfiles/vim/7mydict'}

  " Define keyword.
  if !exists('g:neocomplete#keyword_patterns')
      let g:neocomplete#keyword_patterns = {}
  endif
  let g:neocomplete#keyword_patterns['default'] = '\h\w*'

  " Plugin key-mappings.
  " inoremap <expr> <C-k>    neocomplete#undo_completion()
  inoremap <expr> <C-f>    neocomplete#complete_common_string()
  inoremap <expr> <TAB>    pumvisible() ? "\<C-n>" : "\<TAB>"
  inoremap <expr> <CR>     pumvisible() ? neocomplete#close_popup() : "\<CR>"
  inoremap <expr> <C-h>    neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr> <BS>     neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr> <C-d>    neocomplete#cancel_popup()

  " Enable omni completion.
  autocmd FileType css            setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown  setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript     setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python         setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml            setlocal omnifunc=xmlcomplete#CompleteTags

  " Enable heavy omni completion.
  if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
  endif
  "let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
  "let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
  "let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'


  NeoCompleteEnable
endif
