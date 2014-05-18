let s:save_cpo = &cpo
set cpo&vim

let s:hook = {'config': {'enable': 0}}

function! quickrun#hook#markdown#new()
  return deepcopy(s:hook)
endfunction

" function! s:hook.on_finish(session, context)
    " echom 'compile finished'
    " call system('killall -HUP mupdf')
" endfunction

function! s:hook.on_failure(session, context)
    echo 'err' . a:context['exit_code'] . '. compile failure, check quickfix'
endfunction

function! s:hook.on_success(session, context)
    echo 'compile finished'
    call system('killall -HUP mupdf')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
