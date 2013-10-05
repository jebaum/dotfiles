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
hi Folded       ctermfg=44    ctermbg=233    cterm=none   guifg=#00d7d7   guibg=#121212   gui=none
hi IncSearch    ctermfg=231   ctermbg=124    cterm=bold   guifg=#ffffff   guibg=#af0000   gui=bold
hi LineNr       ctermfg=110   ctermbg=16     cterm=none   guifg=#0087ff   guibg=#000000   gui=none
hi ModeMsg      ctermfg=231   ctermbg=none   cterm=bold   guifg=#ffffff   guibg=#000000   gui=bold
hi NonText      ctermfg=244   ctermbg=none   cterm=none   guifg=#808080   guibg=#000000   gui=none
hi Normal       ctermfg=231   ctermbg=none   cterm=none   guifg=#ffffff   guibg=#000000   gui=none
hi Search       ctermfg=231   ctermbg=52     cterm=none   guifg=#ffffff   guibg=#5f0000   gui=none
hi SpecialKey   ctermfg=241   ctermbg=235    cterm=none   guifg=#626262   guibg=#262626   gui=none
hi StatusLine   ctermfg=230   ctermbg=238    cterm=none   guifg=#ffffd7   guibg=#444444   gui=none
hi StatusLineNC ctermfg=241   ctermbg=238    cterm=none   guifg=#626262   guibg=#444444   gui=none
hi TabLine      ctermfg=246   ctermbg=16     cterm=none   guifg=#949494   guibg=#000000   gui=none
hi TabLineFill  ctermfg=234   ctermbg=234    cterm=none   guifg=#1c1c1c   guibg=#000000   gui=none
hi TabLineSel   ctermfg=231   ctermbg=24     cterm=bold   guifg=#ffffff   guibg=#005f87   gui=bold
hi Title        ctermfg=230   ctermbg=none   cterm=bold   guifg=#ffffd7   guibg=#000000   gui=bold
hi VertSplit    ctermfg=22    ctermbg=22     cterm=none   guifg=#444444   guibg=#444444   gui=none
hi Visual       ctermfg=251   ctermbg=54     cterm=none   guifg=#c6c6c6   guibg=#4e4e4e   gui=none
hi VisualNOS    ctermfg=251   ctermbg=236    cterm=none   guifg=#c6c6c6   guibg=#303030   gui=none
hi WarningMsg   ctermfg=203   ctermbg=none   cterm=none   guifg=#ff5f5f   guibg=#000000   gui=none

if version >= 700
hi CursorLine   ctermfg=none  ctermbg=16     cterm=none   guifg=NONE      guibg=#101033   gui=none
hi CursorLineNR ctermfg=226   ctermbg=232    cterm=bold   guifg=#ffff00   guibg=#080808   gui=bold
hi MatchParen   ctermfg=196   ctermbg=16     cterm=bold   guifg=#ff0000   guibg=#000000   gui=bold
hi Pmenu        ctermfg=230   ctermbg=238    cterm=none   guifg=#ffffd7   guibg=#444444   gui=none
hi PmenuSel     ctermfg=232   ctermbg=192    cterm=none   guifg=#080808   guibg=#d7ff87   gui=none
endif

hi DiffText           ctermfg=none  ctermbg=53    cterm=none  guifg=NONE     guibg=#5f005f  gui=none
hi DiffAdd            ctermfg=119   ctermbg=none  cterm=bold  guifg=#87ff5f  guibg=#000000  gui=bold
hi DiffChange         ctermfg=220   ctermbg=none  cterm=bold  guifg=#ffd700  guibg=#000000  gui=bold
hi DiffDelete         ctermfg=167   ctermbg=none  cterm=bold  guifg=#d75f5f  guibg=#000000  gui=bold
hi SignifyLineAdd     ctermfg=119   ctermbg=none  cterm=bold  guifg=#87ff5f  guibg=#000000  gui=bold
hi SignifyLineChange  ctermfg=227   ctermbg=none  cterm=bold  guifg=#ffff5f  guibg=#000000  gui=bold
hi SignifyLineDelete  ctermfg=167   ctermbg=none  cterm=bold  guifg=#d75f5f  guibg=#000000  gui=bold
hi SignifySignAdd     ctermfg=119   ctermbg=237   cterm=bold  guifg=#87ff5f  guibg=#3a3a3a  gui=bold
hi SignifySignChange  ctermfg=227   ctermbg=237   cterm=bold  guifg=#ffff5f  guibg=#3a3a3a  gui=bold
hi SignifySignDelete  ctermfg=167   ctermbg=237   cterm=bold  guifg=#d75f5f  guibg=#3a3a3a  gui=bold

" Showmarks Hilighting
hi ShowMarksHLl       ctermfg=45    ctermbg=none  cterm=none  guifg=#00d7ff  guibg=#000000  gui=none
hi ShowMarksHLm       ctermfg=202   ctermbg=none  cterm=none  guifg=#ff5f00  guibg=#000000  gui=none

" Multiple Cursor Hilighting
hi multiple_cursors_cursor    ctermfg=196  ctermbg=250  cterm=none  guifg=#ff0000  guibg=#bcbcbc  gui=none
hi link multiple_cursors_visual Visual

" Easymotion Hilighting
hi EasyMotionShade  ctermfg=240   ctermbg=16  cterm=none  guifg=#585858   guibg=#000000   gui=none
hi EasyMotionTarget ctermfg=196   ctermbg=16  cterm=none  guifg=#ff0000   guibg=#000000   gui=none



" Syntax highlighting. cterm options are bold, underline, reverse, italic, none
hi Comment      ctermfg=244   ctermbg=none   cterm=none   guifg=#808080   guibg=#000000   gui=none
hi Constant     ctermfg=226   ctermbg=none   cterm=none   guifg=#ffff00   guibg=#000000   gui=none
hi Function     ctermfg=51    ctermbg=none   cterm=none   guifg=#00ffff   guibg=#000000   gui=none
hi Identifier   ctermfg=51    ctermbg=none   cterm=none   guifg=#00ffff   guibg=#000000   gui=none
hi Keyword      ctermfg=201   ctermbg=none   cterm=none   guifg=#ff00ff   guibg=#000000   gui=none
hi Number       ctermfg=227   ctermbg=none   cterm=none   guifg=#ff00ff   guibg=#000000   gui=bold
hi PreProc      ctermfg=171   ctermbg=none   cterm=none   guifg=#d75fff   guibg=#000000   gui=none
hi Special      ctermfg=222   ctermbg=none   cterm=none   guifg=#ffffaf   guibg=#000000   gui=none
hi Statement    ctermfg=39    ctermbg=none   cterm=none   guifg=#ff5f00   guibg=#000000   gui=bold
hi String       ctermfg=208   ctermbg=none   cterm=none   guifg=#ff8700   guibg=#000000   gui=none
hi Todo         ctermfg=231   ctermbg=196    cterm=bold   guifg=#000000   guibg=#ff0000   gui=bold
hi Type         ctermfg=46    ctermbg=none   cterm=none   guifg=#00ff00   guibg=#000000   gui=none
hi cCustomFunc  ctermfg=117   ctermbg=none   cterm=none   guifg=#87d7ff   guibg=#000000   gui=none
hi cCustomClass ctermfg=77    ctermbg=none   cterm=none   guifg=#5fd75f   guibg=#000000   gui=none

" syntastic, error = spellbad, warning = spellcap, bar on left = signcolumn
hi SignColumn           ctermfg=none  ctermbg=16    cterm=none  guifg=NONE     guibg=#000000   gui=none
hi SpellBad             ctermfg=226   ctermbg=52    cterm=bold  guifg=#ffff00  guibg=#5f0000   gui=none
hi SpellCap             ctermfg=196   ctermbg=232   cterm=bold  guifg=#ff0000  guibg=#080808   gui=none
hi SyntasticErrorLine   ctermfg=none  ctermbg=234   cterm=none  guifg=NONE     guibg=#1c1c1c   gui=none
hi SyntasticErrorSign   ctermfg=226   ctermbg=88    cterm=bold  guifg=#ffff00  guibg=#870000   gui=none
hi SyntasticWarningLine ctermfg=none  ctermbg=16    cterm=none  guifg=NONE     guibg=#000000   gui=none
hi SyntasticWarningSign ctermfg=196   ctermbg=16    cterm=none  guifg=#ff0000  guibg=#000000   gui=none

hi! link CursorColumn CursorLine
hi! link FoldColumn   Folded
