if exists(':AcpEnable')
  augroup AutocomplPop
  " complete keywords with dashes, but keep them as word separators in normal mode
    autocmd InsertEnter * set iskeyword+=-
    autocmd InsertLeave * set iskeyword-=- " won't get executed when doing C-c
  
    " turn off autocomplpop in unite windows
    autocmd BufLeave * if &filetype == 'unite' | silent! AcpUnlock
    autocmd FileType unite silent! AcpLock
  augroup END
endif
