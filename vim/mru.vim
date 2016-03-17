let g:MRUList = []

autocmd VimEnter * call MRUSetup()

function! MRUSetup()
    call MRUReset()
    augroup MRU
        autocmd!
        autocmd BufEnter,BufNew * call MRUActivateBuffer()
        autocmd BufWipeout,BufDelete * call MRUDeactivateBuffer()
    augroup END

endfunction

function! MRUReset()
    let g:MRUList = range(1, bufnr('$'))
endfunction


function! MRUActivateBuffer()
    call MRUPush(bufnr("%"))
endfunction

function! MRUDeactivateBuffer()
    call MRUPop(str2nr(expand("<abuf>")))
endfunction

function! MRUPop(bufnr)
    call filter(g:MRUList, 'v:val != ' . a:bufnr)
endfunction

function! MRUPush(bufnr)
    call filter(g:MRUList, 'v:val != ' . a:bufnr)

    if MRUIgnore(a:bufnr) == 1
        return
    endif
    call MRUPop(a:bufnr)
    call insert(g:MRUList, a:bufnr)
endfunction

function! MRUIgnore(bufnr)
    if empty(getbufvar(a:bufnr, "&buftype") == 0) || empty(bufname(a:bufnr)) == 1
        return 1
    endif
    return 0
endfunction




" condensed version
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
