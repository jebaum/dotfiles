let g:MRUList = []
autocmd VimEnter * call MRUSetup()

function! MRUSetup()
    let g:MRUList = range(1, bufnr('$'))
    augroup MRU
        autocmd!
        autocmd BufEnter,BufNew      * call MRUPush(bufnr("%"))
        autocmd BufWipeout,BufDelete * call MRUPop(str2nr(expand("<abuf>")))
    augroup END
endfunction

function! MRUPop(bufnr)
    call filter(g:MRUList, 'v:val != ' . a:bufnr)
endfunction

function! MRUPush(bufnr)
    if empty(getbufvar(a:bufnr, "&buftype") == 0) || empty(bufname(a:bufnr)) == 1
        return
    endif
    call MRUPop(a:bufnr)
    call insert(g:MRUList, a:bufnr)
endfunction

function! MRUFzf()
    let MRUNames = map(copy(g:MRUList), 'bufname(v:val)')
    call fzf#run({'source': MRUNames})
endfunction
