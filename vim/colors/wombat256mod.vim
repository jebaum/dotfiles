" Vim color file
" Original Maintainer:  Lars H. Nielsen (dengmao@gmail.com)
" Last Change:  2010-07-23
"
" Modified version of wombat for 256-color terminals by
"   David Liang (bmdavll@gmail.com)
" based on version by
"   Danila Bespalov (danila.bespalov@gmail.com)

set background=dark

if version > 580
  hi clear
  if exists("syntax_on")
    syntax reset
  endif
endif

let colors_name = "wombat256mod"


" General colors
hi Cursor       ctermfg=234   ctermbg=228    cterm=none   guifg=#1c1c1c   guibg=#ffff87   gui=none
hi ErrorMsg     ctermfg=196   ctermbg=232    cterm=bold   guifg=#ff0000   guibg=#000000   gui=bold
hi Folded       ctermfg=103   ctermbg=237    cterm=none   guifg=#8787af   guibg=#3a3a3a   gui=none
hi IncSearch    ctermfg=196   ctermbg=231    cterm=none
hi LineNr       ctermfg=33    ctermbg=232    cterm=none   guifg=#0087ff   guibg=#000000   gui=none
hi Normal       ctermfg=231   ctermbg=none   cterm=none   guifg=#ffffff   guibg=#000000   gui=none
hi Search       ctermfg=231   ctermbg=88     cterm=none
hi SpecialKey   ctermfg=241   ctermbg=235    cterm=none   guifg=#626262   guibg=#262626   gui=none
hi StatusLine   ctermfg=230   ctermbg=238    cterm=none   guifg=#ffffd7   guibg=#444444   gui=italic
hi StatusLineNC ctermfg=241   ctermbg=238    cterm=none   guifg=#626262   guibg=#444444   gui=none
hi TabLine      ctermfg=246   ctermbg=16     cterm=none
hi TabLineFill  ctermfg=234
hi TabLineSel   ctermfg=231   ctermbg=24     cterm=bold
hi Title        ctermfg=230   ctermbg=none   cterm=bold   guifg=#ffffd7                   gui=bold
hi VertSplit    ctermfg=238   ctermbg=238    cterm=none   guifg=#444444   guibg=#444444   gui=none
hi Visual       ctermfg=251   ctermbg=239    cterm=none   guifg=#c6c6c6   guibg=#4e4e4e   gui=none
hi VisualNOS    ctermfg=251   ctermbg=236    cterm=none   guifg=#c6c6c6   guibg=#303030   gui=none
hi WarningMsg   ctermfg=203                               guifg=#ff5f55

" Vim >= 7.0 specific colors
if version >= 700
hi CursorLine   ctermfg=none  ctermbg=16     cterm=none                   guibg=#000000
hi CursorLineNR ctermfg=226   ctermbg=232    cterm=none                   guibg=#000000
hi MatchParen   ctermfg=196   ctermbg=16     cterm=bold   guifg=#eae788   guibg=#857b6f   gui=bold
hi Pmenu        ctermfg=230   ctermbg=238                 guifg=#ffffd7   guibg=#444444
hi PmenuSel     ctermfg=232   ctermbg=192                 guifg=#080808   guibg=#cae982
endif

" Diff Highlighting
hi DiffText           ctermfg=none ctermbg=53    cterm=none
hi DiffAdd            ctermfg=119   ctermbg=none  cterm=bold
hi DiffChange         ctermfg=220   ctermbg=none  cterm=bold
hi DiffDelete         ctermfg=167   ctermbg=none  cterm=bold
hi SignifyLineAdd     ctermfg=119   ctermbg=none  cterm=bold
hi SignifyLineChange  ctermfg=227   ctermbg=none  cterm=bold
hi SignifyLineDelete  ctermfg=167   ctermbg=none  cterm=bold
hi SignifySignAdd     ctermfg=119   ctermbg=237   cterm=bold
hi SignifySignChange  ctermfg=227   ctermbg=237   cterm=bold
hi SignifySignDelete  ctermfg=167   ctermbg=237   cterm=bold

" Showmarks Hilighting
hi ShowMarksHLl       ctermfg=45    ctermbg=none
hi ShowMarksHLm       ctermfg=202   ctermbg=none

" Multiple Cursor Hilighting
hi multiple_cursors_cursor    ctermfg=231   ctermbg=88
hi link multiple_cursors_visual Visual

" Easymotion Hilighting
hi EasyMotionShade  ctermfg=240   ctermbg=none
hi EasyMotionTarget ctermfg=196   ctermbg=none



" Syntax highlighting. cterm options are bold, underline, reverse, italic, none
hi Comment      ctermfg=244   ctermbg=none   cterm=none   guifg=#808080                   gui=none
hi Constant     ctermfg=226   ctermbg=none   cterm=none   guifg=#ffff00                   gui=none
hi Function     ctermfg=51    ctermbg=none   cterm=none   guifg=#00ffff                   gui=none
hi Identifier   ctermfg=51    ctermbg=none   cterm=none   guifg=#00ffff                   gui=none
hi Keyword      ctermfg=201   cterm=none    guifg=#ff00ff gui=none
hi Number       ctermfg=201   ctermbg=none   cterm=bold   guifg=#ff00ff                   gui=none
hi PreProc      ctermfg=171   ctermbg=none   cterm=none   guifg=#d75fff                   gui=none
hi Special      ctermfg=229   ctermbg=none   cterm=none   guifg=#ffffaf                   gui=none
hi Statement    ctermfg=202   ctermbg=none   cterm=bold   guifg=#ff5f00                   gui=none
hi String       ctermfg=208   ctermbg=none   cterm=none   guifg=#ff8700                   gui=none
hi Todo         ctermfg=232   ctermbg=196    cterm=bold   guifg=#000000   guibg=#ff0000   gui=bold
hi Type         ctermfg=46    ctermbg=none   cterm=none   guifg=#00ff00                   gui=none
hi cCustomFunc  ctermfg=117   ctermbg=none   cterm=none   guifg=#87d7ff
hi cCustomClass ctermfg=77    ctermbg=none   cterm=none   guifg=#5fd75f

" syntastic, error = spellbad, warning = spellcap, bar on left = signcolumn
hi SignColumn           ctermfg=none  ctermbg=233
hi SpellBad             ctermfg=226   ctermbg=52    cterm=bold
hi SpellCap             ctermfg=196   ctermbg=232   cterm=bold
hi SyntasticErrorLine   ctermfg=none  ctermbg=234
hi SyntasticErrorSign   ctermfg=226   ctermbg=88    cterm=bold
hi SyntasticWarningLine ctermfg=none  ctermbg=16
hi SyntasticWarningSign ctermfg=196   ctermbg=16    cterm=none

hi! link CursorColumn CursorLine
hi! link FoldColumn   Folded
hi! link NonText      LineNr
