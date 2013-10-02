" Vim syntax file
" stripped out everything from asciidoc except TODO markers and email

if exists("b:current_syntax")
  finish
endif

syn clear
syn sync fromstart
syn sync linebreaks=100

" Run :help syn-priority to review syntax matching priority.
syn keyword asciidocToDo TODO FIXME CHECK TEST XXX ZZZ DEPRECATED
syn match asciidocEmail /[\\.:]\@<!\(\<\|<\)\w\(\w\|[.-]\)*@\(\w\|[.-]\)*\w>\?[0-9A-Za-z_]\@!/

hi def link asciidocEmail Macro
hi def link asciidocToDo Todo
let b:current_syntax = "text"

" vim: wrap et sw=2 sts=2:
