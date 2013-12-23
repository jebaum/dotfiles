" File: cscope_quickfix.vim
" Author: kino
" Version: 0.1
" Last Modified: Dec. 30, 2003
"
" Overview
" ------------
" This script enables to use cscope with quickfix.
"
" Preparation
" ------------
" You must prepare cscope and cscope database (cscope.out file).
" cscope is a tag tool like ctags, but unlike ctags, it is a cross referencing
" tool.
" If you don't know about cscope, see:
" :help cscope
" http://cscope.sourceforge.net/
"
" This script adds a command ":Cscope", which is very similar to ":cscope find"
" command. But, this ":Cscope" command can be used with quickfix, and isn't
" needed cscope connection. So, you don't have to install vim with
" --enable-cscope.

" Function
" --------------
" RunCscope({type}, {pattern} [,{file}])
"
" Command
" --------------
" Cscope {type} {pattern} [{file}]
"
" Variables
" --------------
" g:Cscope_OpenQuickfixWindow
" g:Cscope_JumpError
" g:Cscope_Keymap
"
" Install
" -------------
" Copy cscope_quickfix.vim file to plugin directory.
" If you don't want to open quickfix window after :Cscope command, put a line
" in .vimrc like:
" let Cscope_OpenQuickfixWindow = 0
" If you don't want to jump first item after :Cscope command, put a line
" in .vimrc like:
" let Cscope_JumpError = 0
" If you don't want to use keymap for :Cscope command, put a line in .vimrc
" like:
" let Cscope_Keymap = 0
"
if !exists("Cscope_OpenQuickfixWindow")
  let Cscope_OpenQuickfixWindow = 1
endif

if !exists("Cscope_JumpError")
  let Cscope_JumpError = 0
endif

if !exists("Cscope_Keymap")
  let Cscope_Keymap = 1
endif

" RunCscope()
" Run the cscope command using the supplied option and pattern
function! s:RunCscope(...)
  let usage = "Usage: Cscope {type} {pattern} [{file}]."
  let usage = usage . " {type} is [sgdctefi01234678]."
  if !exists("a:1") || !exists("a:2")
    echohl WarningMsg | echomsg usage | echohl None
    return
  endif
  let cscope_opt = a:1
  let pattern = a:2
  let openwin = g:Cscope_OpenQuickfixWindow
  let jumperr =  g:Cscope_JumpError
  if cscope_opt == '0' || cscope_opt == 's'
    let cmd = "cscope -L -0 " . pattern
  elseif cscope_opt == '1' || cscope_opt == 'g'
    let cmd = "cscope -L -1 " . pattern
  elseif cscope_opt == '2' || cscope_opt == 'd'
    let cmd = "cscope -L -2 " . pattern
  elseif cscope_opt == '3' || cscope_opt == 'c'
    let cmd = "cscope -L -3 " . pattern
  elseif cscope_opt == '4' || cscope_opt == 't'
    let cmd = "cscope -L -4 " . pattern
  elseif cscope_opt == '6' || cscope_opt == 'e'
    let cmd = "cscope -L -6 " . pattern
  elseif cscope_opt == '7' || cscope_opt == 'f'
    let cmd = "cscope -L -7 " . pattern
    let openwin = 0
    let jumperr = 1
  elseif cscope_opt == '8' || cscope_opt == 'i'
    let cmd = "cscope -L -8 " . pattern
  else
    echohl WarningMsg | echomsg usage | echohl None
    return
  endif
  if exists("a:3")
    let cmd = cmd . " " . a:3
  endif
  let cmd_output = system(cmd)

  if cmd_output == ""
    echohl WarningMsg |
    \ echomsg "Error: Pattern " . pattern . " not found" |
    \ echohl None
    return
  endif

  let tmpfile = tempname()
  let curfile = expand("%")

  if &modified && (!&autowrite || curfile == "")
    let jumperr = 0
  endif

  exe "redir! > " . tmpfile
  if curfile != ""
    silent echon curfile . " dummy " . line(".") . " " . getline(".") . "\n"
    silent let ccn = 2
  else
    silent let ccn = 1
  endif
  silent echon cmd_output
  redir END

  " If one item is matched, window will not be opened.
" let cmd = "wc -l < " . tmpfile
" let cmd_output = system(cmd)
" exe "let lines =" . cmd_output
" if lines == 2
"   let openwin = 0
" endif

  let old_efm = &efm
  set efm=%f\ %*[^\ ]\ %l\ %m

  exe "silent! cfile " . tmpfile
  let &efm = old_efm

  " Open the cscope output window
  if openwin == 1
    botright copen
  endif

  " Jump to the first error
  if jumperr == 1
    exe "cc " . ccn
  endif

  call delete(tmpfile)
endfunction

" Define the set of Cscope commands
command! -nargs=* Cscope call s:RunCscope(<f-args>)


nnoremap <C-\>s :Cscope s <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>g :Cscope g <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>d :Cscope d <C-R>=expand("<cword>")<CR> <C-R>=expand("%")<CR><CR>
nnoremap <C-\>c :Cscope c <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>t :Cscope t <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>e :Cscope e <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>f :Cscope f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <C-\>i :Cscope i ^<C-R>=expand("<cfile>")<CR>$<CR>

nnoremap <C-w><C-\>s :split<CR>:Cscope s <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-w><C-\>g :split<CR>:Cscope g <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-w><C-\>d :split<CR>:Cscope d <C-R>=expand("<cword>")<CR> <C-R>=expand("%")<CR><CR>
nnoremap <C-w><C-\>c :split<CR>:Cscope c <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-w><C-\>t :split<CR>:Cscope t <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-w><C-\>e :split<CR>:Cscope e <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-w><C-\>f :split<CR>:Cscope f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <C-w><C-\>i :split<CR>:Cscope i ^<C-R>=expand("<cfile>")<CR>$<CR>

nnoremap <C-w><C-w><C-\>s :vert split<CR>:Cscope s <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-w><C-w><C-\>g :vert split<CR>:Cscope g <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-w><C-w><C-\>d :vert split<CR>:Cscope d <C-R>=expand("<cword>")<CR> <C-R>=expand("%")<CR><CR>
nnoremap <C-w><C-w><C-\>c :vert split<CR>:Cscope c <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-w><C-w><C-\>t :vert split<CR>:Cscope t <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-w><C-w><C-\>e :vert split<CR>:Cscope e <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-w><C-w><C-\>f :vert split<CR>:Cscope f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <C-w><C-w><C-\>i :vert split<CR>:Cscope i ^<C-R>=expand("<cfile>")<CR>$<CR>
