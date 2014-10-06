let s:save_cpo = &cpo
set cpo&vim

let s:hook = {'config': {'enable': 0}}

function! quickrun#hook#echo_error#new()
  return deepcopy(s:hook)
endfunction

function! s:hook.on_failure(session, context)
    " echom 'process exited with status ' . a:context['exit_code']
    echo a:session
endfunction

function! s:hook.on_success(session, context)
    " echom 'build finished'
    echo a:session
endfunction

" function! s:hook.on_finish(session, context)
    " echom 'build finished'
    " echom a:session.exit_code
" endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
