if exists('g:loaded_youcompleteme')
  " YCM disables syntastic, this autocmd would reeanable it
  " but, eclim does its own error checking for java that is superior to syntastic
  " augroup YCMSyntasticJava
    " autocmd BufWritePost *.java SyntasticCheck
  " augroup END

    " line numbers and cursorline/column make youcompleteme's popup menu flicker
  function! YCMHackInsertLeave()
    execute 'set number relativenumber foldcolumn=0'
    execute 'hi nontext ctermfg=48'
    return
  endfunction

  function! YCMHackInsertEnter()
    " do some math here so that foldcolumn is the right width at all times to not shift the buffer
    let total = line("$")
    let g:foldcolumn_width = 4

    if &number " if only rnu is set, the number column will be 4 wide unless we have 1000+ lines on screen
      if total >= 1000
        let g:foldcolumn_width = 5
      elseif total >= 10000
        let g:foldcolumn_width = 6
      endif
    endif

    " TODO: remember previous state of cursorline/column, as well as numbers,
    " and restore them to their previous values in YCMHackInsertLeave()
    execute 'set nonumber norelativenumber nocursorline nocursorcolumn foldcolumn=' . g:foldcolumn_width
    execute 'hi nontext ctermfg=8'
  endfunction

  augroup MinimalInsert
    autocmd InsertEnter * call YCMHackInsertEnter()
    autocmd InsertLeave * call YCMHackInsertLeave()
  augroup END
endif
