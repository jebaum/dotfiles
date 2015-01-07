set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let colors_name = "guimiromod"

" General colors
hi ColorColumn                ctermbg=16                                guibg=#000000
hi Cursor       ctermfg=234   ctermbg=228    cterm=none  guifg=#1C1C1C  guibg=#FFFF87  gui=none
hi Error        ctermfg=226   ctermbg=234    cterm=none  guifg=#FFFF00  guibg=#1C1C1C  gui=none
hi ErrorMsg     ctermfg=196   ctermbg=232    cterm=bold  guifg=#FF0000  guibg=#080808  gui=bold
hi Folded       ctermfg=248   ctermbg=16     cterm=none  guifg=#A8A8A8  guibg=#000000  gui=none
hi LineNr       ctermfg=246   ctermbg=16     cterm=none  guifg=#949494  guibg=#000000  gui=none
hi ModeMsg      ctermfg=231   ctermbg=none   cterm=bold  guifg=#FFFFFF  guibg=#000000  gui=bold
hi NonText      ctermfg=48    ctermbg=8      cterm=none  guifg=#00FF87  guibg=#181818  gui=none
hi Normal       ctermfg=231   ctermbg=8      cterm=none  guifg=#FFFFFF  guibg=#181818  gui=none
hi SpecialKey   ctermfg=241   ctermbg=235    cterm=none  guifg=#626262  guibg=#262626  gui=none
hi StatusLine   ctermfg=230   ctermbg=238    cterm=none  guifg=#FFFFD7  guibg=#444444  gui=none
hi StatusLineNC ctermfg=241   ctermbg=238    cterm=none  guifg=#626262  guibg=#444444  gui=none
hi TabLine      ctermfg=246   ctermbg=16     cterm=none  guifg=#949494  guibg=#000000  gui=none
hi TabLineFill  ctermfg=234   ctermbg=234    cterm=none  guifg=#1C1C1C  guibg=#1C1C1C  gui=none
hi TabLineSel   ctermfg=231   ctermbg=24     cterm=bold  guifg=#FFFFFF  guibg=#005F87  gui=bold
hi Title        ctermfg=230   ctermbg=none   cterm=bold  guifg=#FFFFD7  guibg=NONE     gui=bold
hi VertSplit    ctermfg=242   ctermbg=242    cterm=none  guifg=#6C6C6C  guibg=#6C6C6C  gui=none
hi Visual       ctermfg=231   ctermbg=54     cterm=none  guifg=#FFFFFF  guibg=#5F0087  gui=none
hi VisualNOS    ctermfg=251   ctermbg=236    cterm=none  guifg=#C6C6C6  guibg=#303030  gui=none
hi WarningMsg   ctermfg=203   ctermbg=none   cterm=none  guifg=#FF5F5F  guibg=#000000  gui=none
hi WarningMsg   ctermfg=226   ctermbg=16     cterm=none  guifg=#FFFF00  guibg=#000000  gui=none
hi! link FoldColumn   Folded

" Search colors
hi ObliqueCurrentIncSearch ctermfg=16   ctermbg=254  cterm=none  guifg=#000000  guibg=#E4E4E4  gui=none
hi ObliqueCurrentMatch     ctermfg=16   ctermbg=254  cterm=none  guifg=#000000  guibg=#E4E4E4  gui=none
hi IncSearch               ctermfg=231  ctermbg=52   cterm=none  guifg=#FFFFFF  guibg=#AF0000  gui=bold
hi Search                  ctermfg=231  ctermbg=52   cterm=none  guifg=#FFFFFF  guibg=#5F0000  gui=none

if version >= 700
hi CursorLine   ctermfg=NONE ctermbg=16      cterm=none  guifg=NONE     guibg=#000000  gui=none
hi! link CursorColumn CursorLine
hi CursorLineNr ctermfg=226  ctermbg=237     cterm=none  guifg=#FFFF00  guibg=#3A3A3A  gui=none
hi MatchParen   ctermfg=231  ctermbg=124     cterm=bold  guifg=#FFFFFF  guibg=#AF0000  gui=bold
hi Pmenu        ctermfg=251  ctermbg=235     cterm=none  guifg=#C6C6C6  guibg=#262626  gui=none
" PmenuSel deprecated, cursorline is used now
hi PmenuSel     ctermfg=233  ctermbg=73      cterm=none  guifg=#121212  guibg=#5FAFAF  gui=none
hi PmenuSbar    ctermfg=NONE ctermbg=240     cterm=none  guifg=NONE     guibg=#585858  gui=none
hi PmenuThumb   ctermfg=66   ctermbg=66      cterm=none  guifg=#5F8787  guibg=#5F8787  gui=none
hi UniteSel     ctermfg=16   ctermbg=73      cterm=none  guifg=#000000  guibg=#5FAFAF  gui=none
endif

hi DiffText           ctermfg=226   ctermbg=16    cterm=bold  guifg=#FFFF00  guibg=#000000  gui=bold
hi DiffChange         ctermfg=none  ctermbg=237   cterm=none  guifg=NONE     guibg=#3A3A3A  gui=none
hi DiffAdd            ctermfg=231   ctermbg=22    cterm=bold  guifg=#FFFFFF  guibg=#005F00  gui=bold
hi DiffDelete         ctermfg=231   ctermbg=52    cterm=bold  guifg=#FFFFFF  guibg=#5F0000  gui=bold

hi diffAdded          ctermfg=40    ctermbg=none  cterm=none  guifg=#00D700  guibg=NONE  gui=none
hi diffRemoved        ctermfg=160   ctermbg=none  cterm=none  guifg=#D70000  guibg=NONE  gui=none
hi diffNewFile        ctermfg=172   ctermbg=none  cterm=none  guifg=#D78700  guibg=NONE  gui=none
hi diffFile           ctermfg=172   ctermbg=none  cterm=none  guifg=#D78700  guibg=NONE  gui=none

hi SignifyLineAdd     ctermfg=119   ctermbg=none  cterm=bold  guifg=#87FF5F  guibg=#000000  gui=bold
hi SignifyLineChange  ctermfg=227   ctermbg=none  cterm=bold  guifg=#FFFF5F  guibg=#000000  gui=bold
hi SignifyLineDelete  ctermfg=167   ctermbg=none  cterm=bold  guifg=#D75F5F  guibg=#000000  gui=bold
hi SignifySignAdd     ctermfg=119   ctermbg=237   cterm=bold  guifg=#87FF5F  guibg=#3A3A3A  gui=bold
hi SignifySignChange  ctermfg=227   ctermbg=237   cterm=bold  guifg=#FFFF5F  guibg=#3A3A3A  gui=bold
hi SignifySignDelete  ctermfg=167   ctermbg=237   cterm=bold  guifg=#D75F5F  guibg=#3A3A3A  gui=bold

" Showmarks Hilighting
hi ShowMarksHLl       ctermfg=none  ctermbg=234   cterm=none  guifg=#00D7FF  guibg=#000000  gui=none
hi ShowMarksHLm       ctermfg=202   ctermbg=234   cterm=none  guifg=#FF5F00  guibg=#000000  gui=none

" Multiple Cursor Hilighting
hi multiple_cursors_cursor    ctermfg=196  ctermbg=250  cterm=none  guifg=#FF0000  guibg=#BCBCBC  gui=none
hi link multiple_cursors_visual Visual

" Easymotion Hilighting
hi EasyMotionShade  ctermfg=240   ctermbg=16  cterm=none  guifg=#585858  guibg=#000000  gui=none
hi EasyMotionTarget ctermfg=196   ctermbg=16  cterm=none  guifg=#FF0000  guibg=#000000  gui=none

" Sneak hilighting
hi SneakPluginTarget  ctermfg=16    ctermbg=244 guifg=#000000  guibg=#808080
hi SneakPluginScope   ctermfg=231   ctermbg=19  guifg=#FFFFFF  guibg=#0000AF

" Syntax highlighting. cterm options are bold, underline, reverse, italic, none
" 0, 7, 14, 15 are unused
hi Boolean        ctermfg=161                           guifg=#D7005F
hi cCustomClass   ctermfg=166                           guifg=#D75F00
hi Character      ctermfg=77                            guifg=#5FD75F
hi Comment        ctermfg=244  ctermbg=none cterm=none  guifg=#808080  guibg=NONE     gui=none
hi Conditional    ctermfg=197                           guifg=#FF005F
hi Constant       ctermfg=35                            guifg=#00AF5F
hi cRepeat        ctermfg=197                           guifg=#FF005F
hi javaRepeat     ctermfg=197                           guifg=#FF005F
hi Debug          ctermfg=1                             guifg=#DC322F
hi Define         ctermfg=2                             guifg=#859900
hi Delimiter      ctermfg=12                            guifg=#6699FF
hi Directory      ctermfg=6                             guifg=#33CC99
hi ErrorMsg       ctermfg=196  ctermbg=232  cterm=bold  guifg=#FF0000  guibg=#080808  gui=bold
hi Exception      ctermfg=1                             guifg=#DC322F
hi Float          ctermfg=201                           guifg=#FF00FF
hi Function       ctermfg=11                            guifg=#E1AA5D
hi Identifier     ctermfg=13                cterm=none  guifg=#FF66FF                 gui=none
hi Ignore         ctermfg=8                             guifg=#555753
hi Include        ctermfg=5                             guifg=#FF33CC
hi Keyword        ctermfg=9                             guifg=#E84F4F
hi Label          ctermfg=13                            guifg=#FF66FF
hi Macro          ctermfg=13                            guifg=#FF66FF
hi ModeMsg        ctermfg=13                            guifg=#FF66FF
hi MoreMsg        ctermfg=13                            guifg=#FF66FF
hi Number         ctermfg=1                             guifg=#DC322F
hi Operator       ctermfg=3                             guifg=#FD971F
hi PreCondit      ctermfg=13                            guifg=#FF66FF
hi Question       ctermfg=10                            guifg=#99FF66
hi Repeat         ctermfg=9                             guifg=#E84F4F
hi SpecialChar    ctermfg=9                             guifg=#E84F4F
hi Special        ctermfg=10                            guifg=#99FF66
hi SpecialKey     ctermfg=11                            guifg=#E1AA5D
hi Statement      ctermfg=44                            guifg=#00D7D7                 gui=none
hi StorageClass   ctermfg=11                            guifg=#E1AA5D
hi String         ctermfg=172  ctermbg=none cterm=none  guifg=#D78700  guibg=NONE     gui=none
hi Structure      ctermfg=34                            guifg=#00AF00
hi Tag            ctermfg=11                            guifg=#E1AA5D
hi Title          ctermfg=3                             guifg=#FD971F
hi Todo           ctermfg=231  ctermbg=196  cterm=bold  guifg=#FFFFFF  guibg=#FF0000  gui=bold
hi Type           ctermfg=40                            guifg=#1ABB1A                 gui=none
hi Typedef        ctermfg=6                             guifg=#33CC99
hi Underlined     ctermfg=4                             guifg=#268BD2
hi WildMenu       ctermfg=16   ctermbg=11               guifg=#000000  guibg=#E1AA5D
hi cSpecialCharacter     ctermfg=77                     guifg=#5FD75F

" Special for HTML ---
hi htmlTag        ctermfg=6   guifg=#33CC99
hi htmlEndTag     ctermfg=6   guifg=#33CC99
hi htmlTagName    ctermfg=11  guifg=#E1AA5D

" Specific for vimrc / help files
hi vimVar            ctermfg=231  cterm=none  guifg=#FFFFFF  gui=none
hi vimSet            ctermfg=136  cterm=none  guifg=#AF8700  gui=none
hi vimOption         ctermfg=136  cterm=none  guifg=#AF8700  gui=none
hi vimHiNmbr         ctermfg=165              guifg=#D700FF
hi vimHiGuiRgb       ctermfg=165              guifg=#D700FF
hi helpHyperTextJump ctermfg=11               guifg=#E1AA5D

" syntastic, error = spellbad, warning = spellcap, bar on left = signcolumn
hi SignColumn           ctermfg=none  ctermbg=16    cterm=none  guifg=NONE     guibg=#000000  gui=none
hi SpellBad             ctermfg=226   ctermbg=52    cterm=bold  guifg=#FFFF00  guibg=#5F0000  gui=bold
hi SpellCap             ctermfg=196   ctermbg=232   cterm=bold  guifg=#FF0000  guibg=#080808  gui=bold
hi SyntasticErrorLine   ctermfg=none  ctermbg=52    cterm=none  guifg=NONE     guibg=#3A0000  gui=none
hi SyntasticErrorSign   ctermfg=226   ctermbg=88    cterm=bold  guifg=#FFFF00  guibg=#870000  gui=bold
hi SyntasticWarningLine ctermfg=none  ctermbg=238   cterm=none  guifg=NONE     guibg=#303000  gui=none
hi SyntasticWarningSign ctermfg=196   ctermbg=16    cterm=none  guifg=#FF0000  guibg=#000000  gui=none

hi MatchTarget ctermfg=16   ctermbg=46  cterm=bold  guifg=#000000  guibg=#00FF00  gui=bold

" taghighlight
hi! link DefinedName        NONE
hi! link EnumerationValue   NONE
hi! link GlobalVariable     NONE
hi DefinedName      ctermfg=228  guifg=#FFFF87  gui=italic
hi EnumerationValue ctermfg=228  guifg=#FFFF87  gui=italic
hi GlobalVariable   ctermfg=228  guifg=#FFFF87  gui=italic


hi GreenBar term=reverse ctermfg=black ctermbg=green guifg=black guibg=green
hi RedBar   term=reverse ctermfg=black ctermbg=red   guifg=black guibg=red3
