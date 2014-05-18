let s:save_cpo = &cpo
set cpo&vim

let s:hook = {'config': {'enable': 0}}

function! quickrun#hook#getpid#new()
  return deepcopy(s:hook)
endfunction

function! s:hook.on_output(session, context)
    " on_ready doesn't have the pid yet, and this seems to be called even with no output
    let b:quickrun_pid = a:session['_vimproc']['pid']
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
