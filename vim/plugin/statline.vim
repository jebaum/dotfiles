" file info {{{
" ============================================================================
" File:        statline.vim
" Maintainer:  Miller Medeiros <http://blog.millermedeiros.com/>
" Description: Add useful info to the statusline and basic error checking.
" Last Change: 2011-11-10
" License:     This program is free software. It comes without any warranty,
"              to the extent permitted by applicable law. You can redistribute
"              it and/or modify it under the terms of the Do What The Fuck You
"              Want To Public License, Version 2, as published by Sam Hocevar.
"              See http://sam.zoy.org/wtfpl/COPYING for more details.
" ============================================================================
" }}}
" basic settings {{{
if exists("g:loaded_statline_plugin")
    finish
endif
let g:loaded_statline_plugin = 1
let g:statline_show_charcode = 1

" always display statusline (iss #3)
set laststatus=2
" }}}
" Colors {{{
" using link instead of named highlight group inside the statusline to make it
" easier to customize, reseting the User[n] highlight will remove the link.
" Another benefit is that colors will adapt to colorscheme.

"buffer
hi User1 ctermfg=white ctermbg=black guifg=#ffffff
"filename
hi User2 ctermfg=green cterm=bold ctermbg=black guifg=#22cc22 gui=bold
"flags/errors
hi User3 ctermfg=red   cterm=bold ctermbg=black guifg=#cc2222 gui=bold
"file type
hi User4 ctermfg=172 ctermbg=black guifg=#d78700
"encoding
hi User5 ctermfg=111 ctermbg=black guifg=#87afff
"empty space, 16 is pure black
hi User6 ctermfg=green ctermbg=232 guifg=#5fff00
" mode message
hi User7 ctermfg=255 ctermbg=black guifg=#eeeeee
"scroll percent
hi User8 ctermfg=184 ctermbg=black guifg=#d7d700
"current byte
hi User9 ctermfg=207 ctermbg=black guifg=#ff5fff
" }}}
" show nice mode name and colors {{{
" pretty mode display - converts the one letter status notifiers to words
function! Mode()
    let l:mode = mode()

    if     mode ==# "n"  | return "NORMAL"
    elseif mode ==# "i"  | return "INSERT"
    elseif mode ==# "R"  | return "REPLACE"
    elseif mode ==# "v"  | return "VISUAL"
    elseif mode ==# "V"  | return "V-LINE"
    elseif mode ==# "^V" | return "V-BLOCK"
    else                 | return l:mode
    endif
endfunc

" Change the values for User1 color preset depending on mode
function! ModeChanged(mode)
    if     a:mode ==# "n"
      hi User7 ctermfg=255 ctermbg=0 cterm=NONE
      hi User6 ctermfg=green ctermbg=232
    elseif a:mode ==# "i"
      hi User7 ctermfg=15 ctermbg=124 cterm=bold
      hi User6 ctermfg=green ctermbg=235
    elseif a:mode ==# "r"
      hi User7 ctermfg=255 ctermbg=57 cterm=bold
      hi User6 ctermfg=green ctermbg=235
    else
      hi User1 ctermfg=15 ctermbg=53 cterm=NONE
      hi User6 ctermfg=green ctermbg=232
    endif
endfunc
au InsertEnter * call ModeChanged(v:insertmode)
au InsertChange * call ModeChanged(v:insertmode)
au InsertLeave * call ModeChanged(mode())
" }}}
" number of buffers : buffer number {{{
function! StatlineBufCount()
    if !exists("s:statline_n_buffers")
        let s:statline_n_buffers = len(filter(range(1,bufnr('$')), 'buflisted(v:val)'))
    endif
    return s:statline_n_buffers
endfunction


if !exists('g:statline_show_n_buffers')
    let g:statline_show_n_buffers = 1
endif

if g:statline_show_n_buffers
    set statusline+=%1*[%{StatlineBufCount()}\:%n]\ %<
    " only calculate buffers after adding/removing buffers
    augroup statline_nbuf
        autocmd!
        autocmd BufAdd,BufDelete * unlet! s:statline_n_buffers
    augroup END
else
    set statusline+=[%n]\ %<
endif

let &stl.="%7*\ %{Mode()} %0*"
" }}}
"filename (relative or tail) {{{

if exists('g:statline_filename_relative')
    set statusline+=%2*[%f]%*
else
    set statusline+=%2*[%t]%*
endif
" }}}
" flags {{{
" (h:help:[help], w:window:[Preview], m:modified:[+][-], r:readonly:[RO])
set statusline+=%3*%h%w%m%r%*
" }}}
" filetype {{{
set statusline+=%4*\ %y%*
" }}}
" Fugitive {{{
" put current git branch to left of space
set statusline+=%8*%{exists('g:loaded_fugitive')?fugitive#statusline():''}%*

"if !exists('g:statline_fugitive')
"    let g:statline_fugitive = 0
"endif
"if g:statline_fugitive
"    set statusline+=%4*%{exists('g:loaded_fugitive')?fugitive#statusline():''}%*
"endif
" }}}

" separation between left/right aligned items
set statusline+=%6*%=%*

" Syntastic errors {{{
" put syntax error notice immediately before line/column number
if !exists('g:statline_syntastic')
    let g:statline_syntastic = 1
endif
if g:statline_syntastic
    set statusline+=\%3*%-{exists('g:loaded_syntastic_plugin')?SyntasticStatuslineFlag():''}%*
endif
" }}}

" show current function in statusline. optional 'p' parameter says to display full prototype with arguments
" set statusline+=%8*%{tagbar#currenttag('[%s]\ ','','p')}%*

" file format → file encoding {{{

if &encoding == 'utf-8'
    let g:statline_encoding_separator = '→'
else
    let g:statline_encoding_separator = ':'
endif

if !exists('g:statline_show_encoding')
    let g:statline_show_encoding = 1
endif
if !exists('g:statline_no_encoding_string')
    let g:statline_no_encoding_string = 'No Encoding'
endif
if g:statline_show_encoding
    set statusline+=%5*[%{&ff}%{g:statline_encoding_separator}%{strlen(&fenc)?&fenc:g:statline_no_encoding_string}]%*
endif
" }}}
" current line and column and scroll percent  {{{
" (-:left align, 14:minwid, l:line, L:nLines, c:column)
set statusline+=%8*%-14(\ L%l/%L:C%c%)%*

" scroll percent
set statusline+=%8*%P%*
" }}}
" code of character under cursor {{{
if !exists('g:statline_show_charcode')
    let g:statline_show_charcode = 0
endif
if g:statline_show_charcode
    " (b:num, B:hex)
    set statusline+=%9*%9(\ \%b/0x\%B%)
endif
" }}}

" ====== custom errors ======
" based on @scrooloose whitespace flags
" http://got-ravings.blogspot.com/2008/10/vim-pr0n-statusline-whitespace-flags.html
" mixed indenting {{{
if !exists('g:statline_mixed_indent')
    let g:statline_mixed_indent = 1
endif

if !exists('g:statline_mixed_indent_string')
    let g:statline_mixed_indent_string = '[mix]'
endif

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatlineTabWarning()
    if !exists("b:statline_indent_warning")
        let b:statline_indent_warning = ''

        if !&modifiable
            return b:statline_indent_warning
        endif

        let tabs = search('^\t', 'nw') != 0

        "find spaces that arent used as alignment in the first indent column
        let spaces = search('^ \{' . &ts . ',}[^\t]', 'nw') != 0

        if tabs && spaces
            let b:statline_indent_warning = g:statline_mixed_indent_string
        elseif (spaces && !&et) || (tabs && &et)
            let b:statline_indent_warning = '[&et]'
        endif
    endif
    return b:statline_indent_warning
endfunction

if g:statline_mixed_indent
    set statusline+=%3*%{StatlineTabWarning()}%*

    " recalculate when idle and after writing
    augroup statline_indent
        autocmd!
        autocmd cursorhold,bufwritepost * unlet! b:statline_indent_warning
    augroup END
endif
" }}}
" trailing white space {{{
if !exists('g:statline_trailing_space')
    let g:statline_trailing_space = 1
endif

function! StatlineTrailingSpaceWarning()
    if !exists("b:statline_trailing_space_warning")
        if search('\s\+$', 'nw') != 0
            let b:statline_trailing_space_warning = '[\s]'
        else
            let b:statline_trailing_space_warning = ''
        endif
    endif
    return b:statline_trailing_space_warning
endfunction

if g:statline_trailing_space
    set statusline+=%3*%{StatlineTrailingSpaceWarning()}%*

    " recalculate when idle, and after saving
    augroup statline_trail
        autocmd!
        autocmd cursorhold,bufwritepost * unlet! b:statline_trailing_space_warning
    augroup END
endif
" }}}
" vim: foldmethod=marker foldlevel=0 textwidth=0
