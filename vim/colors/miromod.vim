set background=dark
if version > 580
  hi clear
  if exists("syntax_on")
    syntax reset
  endif
endif
let colors_name = "miromod"


" General colors
hi Cursor       ctermfg=234   ctermbg=228    cterm=none   guifg=#1c1c1c   guibg=#ffff87   gui=none
hi ErrorMsg     ctermfg=196   ctermbg=232    cterm=bold   guifg=#ff0000   guibg=#000000   gui=bold
hi Folded       ctermfg=35    ctermbg=16     cterm=none   guifg=#00d7d7   guibg=#121212   gui=none
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
hi Visual       ctermfg=231   ctermbg=54     cterm=none   guifg=#ffffff   guibg=#4e4e4e   gui=none
hi VisualNOS    ctermfg=251   ctermbg=236    cterm=none   guifg=#c6c6c6   guibg=#303030   gui=none
hi WarningMsg   ctermfg=203   ctermbg=none   cterm=none   guifg=#ff5f5f   guibg=#000000   gui=none
hi WarningMsg     ctermfg=226  ctermbg=16   cterm=none
hi! link FoldColumn   Folded

if version >= 700
hi CursorLine   ctermfg=231   ctermbg=17     cterm=none   guifg=NONE      guibg=#101033   gui=none
hi CursorLineNR ctermfg=226   ctermbg=232    cterm=bold   guifg=#ffff00   guibg=#080808   gui=bold
hi MatchParen   ctermfg=231   ctermbg=124    cterm=bold
hi Pmenu        ctermfg=230   ctermbg=238    cterm=none   guifg=#ffffd7   guibg=#444444   gui=none
hi PmenuSel     ctermfg=232   ctermbg=192    cterm=none   guifg=#080808   guibg=#d7ff87   gui=none
endif

hi DiffText           ctermfg=none  ctermbg=53    cterm=none  guifg=NONE     guibg=#5f005f  gui=none
hi DiffAdd            ctermfg=119   ctermbg=none  cterm=bold  guifg=#87ff5f  guibg=#000000  gui=bold
hi DiffChange         ctermfg=220   ctermbg=none  cterm=bold  guifg=#ffd700  guibg=#000000  gui=bold
hi DiffDelete         ctermfg=167   ctermbg=none  cterm=bold  guifg=#d75f5f  guibg=#000000  gui=bold
" Diff lines alt
hi DiffLine       ctermbg=4
hi DiffText       ctermfg=16
hi DiffAdd        ctermfg=7    ctermbg=5
hi DiffChange     ctermfg=0    ctermbg=4
hi DiffDelete     ctermfg=0

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

" Sneak hilighting
hi SneakPluginTarget  ctermfg=231   ctermbg=17
hi SneakPluginScope   ctermfg=231   ctermbg=17

" Syntax highlighting. cterm options are bold, underline, reverse, italic, none
hi Boolean        ctermfg=161
hi cCustomClass   ctermfg=166
hi Character      ctermfg=77
hi Comment        ctermfg=244  ctermbg=none   cterm=none   guifg=#808080   guibg=#000000   gui=none
hi Conditional    ctermfg=197
hi Constant       ctermfg=35
hi cRepeat        ctermfg=197
hi CursorColumn   ctermfg=231  ctermbg=17
hi CursorLine     ctermfg=NONE ctermbg=16
hi CursorLineNr   ctermfg=11   ctermbg=232
hi Debug          ctermfg=1
hi Define         ctermfg=2
hi Delimiter      ctermfg=12
hi Directory      ctermfg=6
hi ErrorMsg       ctermfg=196  ctermbg=232  cterm=bold
hi Exception      ctermfg=1
hi Float          ctermfg=201
hi Function       ctermfg=11
hi Identifier     ctermfg=13   cterm=none
hi Ignore         ctermfg=8
hi Include        ctermfg=5
hi Keyword        ctermfg=9
hi Label          ctermfg=13
hi LineNr         ctermfg=8
hi Macro          ctermfg=13
hi ModeMsg        ctermfg=13
hi MoreMsg        ctermfg=13
hi NonText        ctermfg=6
hi Normal         ctermfg=15
hi Number         ctermfg=201
hi Operator       ctermfg=3
hi Pmenu          ctermfg=2    ctermbg=15
hi PmenuSel       ctermfg=NONE ctermbg=52
hi PreCondit      ctermfg=13
hi Question       ctermfg=10
hi Repeat         ctermfg=9
hi SpecialChar    ctermfg=9
hi Special        ctermfg=10
hi SpecialKey     ctermfg=11
hi Statement      ctermfg=44
hi StorageClass   ctermfg=11
hi String         ctermfg=208  ctermbg=none   cterm=none   guifg=#ff8700   guibg=#000000   gui=none
hi Structure      ctermfg=34
hi Tag            ctermfg=11
hi Title          ctermfg=3
hi Todo           ctermfg=231  ctermbg=196    cterm=bold   guifg=#000000   guibg=#ff0000   gui=none
hi Type           ctermfg=40
hi Typedef        ctermfg=6
hi Underlined     ctermfg=4
hi WildMenu       ctermfg=16   ctermbg=11
hi cSpecialCharacter     ctermfg=77

" Special for HTML ---
hi htmlTag        ctermfg=6
hi htmlEndTag     ctermfg=6
hi htmlTagName    ctermfg=11

" Specific for vimrc / help files
hi vimVar         ctermfg=231  cterm=none
hi vimSet         ctermfg=136  cterm=none
hi vimOption      ctermfg=136  cterm=none
hi helpHyperTextJump ctermfg=11

" syntastic, error = spellbad, warning = spellcap, bar on left = signcolumn
hi SignColumn           ctermfg=none  ctermbg=16    cterm=none  guifg=NONE     guibg=#000000   gui=none
hi SpellBad             ctermfg=226   ctermbg=52    cterm=bold  guifg=#ffff00  guibg=#5f0000   gui=none
hi SpellCap             ctermfg=196   ctermbg=232   cterm=bold  guifg=#ff0000  guibg=#080808   gui=none
hi SyntasticErrorLine   ctermfg=none  ctermbg=234   cterm=none  guifg=NONE     guibg=#1c1c1c   gui=none
hi SyntasticErrorSign   ctermfg=226   ctermbg=88    cterm=bold  guifg=#ffff00  guibg=#870000   gui=none
hi SyntasticWarningLine ctermfg=none  ctermbg=16    cterm=none  guifg=NONE     guibg=#000000   gui=none
hi SyntasticWarningSign ctermfg=196   ctermbg=16    cterm=none  guifg=#ff0000  guibg=#000000   gui=none

hi MatchTarget ctermfg=16   ctermbg=46  cterm=bold
