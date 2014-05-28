" Vim syntax file

syn sync fromstart
syn sync linebreaks=100

" Run :help syn-priority to review syntax matching priority.
syn keyword asciidocToDo TODO TODO: FIXME XXX NOTE NOTE: MIDTERM MIDTERM: FINAL FINAL:
syn match asciidocEmail /[\\.:]\@<!\(\<\|<\)\w\(\w\|[.-]\)*@\(\w\|[.-]\)*\w>\?[0-9A-Za-z_]\@!/

hi def link asciidocEmail Macro
hi def link asciidocToDo Todo

" vim: wrap et sw=2 sts=2:
