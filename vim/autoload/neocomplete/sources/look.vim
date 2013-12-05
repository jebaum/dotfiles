" source: https://github.com/ujihisa/neco-look
let s:source = {
      \ 'name': 'look',
      \ 'kind': 'plugin',
      \ 'mark': '[dict]',
      \ 'max_candidates': 5,
      \ 'min_pattern_length' : 5,
      \ 'is_volatile' : 1,
      \ }

function! s:source.gather_candidates(context)
  if !(neocomplete#is_text_mode() || neocomplete#within_comment())
        \ || a:context.complete_str !~ '^[[:alpha:]]\+$'
    return []
  endif

  let list = split(neocomplete#util#system(
        \ 'look ' . a:context.complete_str .
        \ '| head -n ' . self.max_candidates), "\n")
  if neocomplete#util#get_last_status()
    return []
  endif

  return list
endfunction

function! neocomplete#sources#look#define()
  return executable('look') ? s:source : {}
endfunction
