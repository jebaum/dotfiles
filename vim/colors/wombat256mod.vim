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
hi Normal		ctermfg=231		ctermbg=none	cterm=none		guifg=#ffffff	guibg=#000000		gui=none
hi Cursor		ctermfg=234		ctermbg=228		cterm=none		guifg=#1c1c1c	guibg=#ffff87	gui=none
hi Visual		ctermfg=251		ctermbg=239		cterm=none		guifg=#c6c6c6	guibg=#4e4e4e	gui=none
hi VisualNOS	ctermfg=251		ctermbg=236		cterm=none		guifg=#c6c6c6	guibg=#303030	gui=none
hi Search		ctermfg=231		ctermbg=88 		cterm=none		guifg=#d787ff	guibg=#626262	gui=none
hi IncSearch	ctermfg=196		ctermbg=231
hi Folded		ctermfg=103		ctermbg=237		cterm=none		guifg=#8787af	guibg=#3a3a3a	gui=none
hi Title		ctermfg=230						cterm=bold		guifg=#ffffd7					gui=bold
hi StatusLine	ctermfg=230		ctermbg=238		cterm=none		guifg=#ffffd7	guibg=#444444	gui=italic
hi VertSplit	ctermfg=238		ctermbg=238		cterm=none		guifg=#444444	guibg=#444444	gui=none
hi StatusLineNC	ctermfg=241		ctermbg=238		cterm=none		guifg=#626262	guibg=#444444	gui=none
hi LineNr		ctermfg=33 		ctermbg=232		cterm=none		guifg=#0087ff	guibg=#000000	gui=none
hi SpecialKey	ctermfg=241		ctermbg=235		cterm=none		guifg=#626262	guibg=#262626	gui=none
hi WarningMsg	ctermfg=203										guifg=#ff5f55
hi ErrorMsg		ctermfg=196		ctermbg=232		cterm=bold		guifg=#ff0000	guibg=#000000	gui=bold
hi TabLineFill  ctermfg=234
hi TabLine	    ctermfg=246		ctermbg=16		cterm=none
hi TabLineSel	ctermfg=231		ctermbg=24		cterm=bold

" Vim >= 7.0 specific colors
if version >= 700
hi CursorLine	ctermbg=232		cterm=none						guibg=#000000
hi MatchParen	ctermfg=196		ctermbg=16		cterm=bold		guifg=#eae788	guibg=#857b6f	gui=bold
hi Pmenu		ctermfg=230		ctermbg=238						guifg=#ffffd7	guibg=#444444
hi PmenuSel		ctermfg=232		ctermbg=192						guifg=#080808	guibg=#cae982
endif

" Diff highlighting
hi DiffAdd						ctermbg=17										guibg=#2a0d6a
hi DiffDelete	ctermfg=234		ctermbg=60		cterm=none		guifg=#242424	guibg=#3e3969	gui=none
hi DiffText						ctermbg=53		cterm=none						guibg=#73186e	gui=none
hi DiffChange					ctermbg=237										guibg=#382a37

" Multiple Cursor Hilighting
hi multiple_cursors_cursor	    ctermfg=231	    ctermbg=88
hi link multiple_cursors_visual Visual

"hi CursorIM
"hi Directory
"hi Menu
"hi ModeMsg
"hi MoreMsg
"hi PmenuSbar
"hi PmenuThumb
"hi Question
"hi Scrollbar
"hi SignColumn
"hi SpellBad
"hi SpellCap
"hi SpellLocal
"hi SpellRare
"hi Tooltip
"hi User1
"hi User9
"hi WildMenu
" Syntax highlighting. cterm options are bold, underline, reverse, italic, none
hi Keyword		ctermfg=201		cterm=none		guifg=#ff00ff	gui=none
" statement = return, for, if, switch, case, continue, etc
hi Statement	ctermfg=202		cterm=bold  	guifg=#ff5f00	gui=none
hi Constant		ctermfg=226		cterm=none		guifg=#ffff00	gui=none
hi Number		ctermfg=201		cterm=bold		guifg=#ff00ff	gui=none
hi PreProc		ctermfg=171		cterm=none		guifg=#d75fff	gui=none
hi Function		ctermfg=51		cterm=none		guifg=#00ffff	gui=none
hi Identifier	ctermfg=51		cterm=none		guifg=#00ffff	gui=none
hi Type			ctermfg=46		cterm=none		guifg=#00ff00	gui=none
hi Special		ctermfg=229		cterm=none		guifg=#ffffaf	gui=none
hi String		ctermfg=208		cterm=none		guifg=#ff8700	gui=none
hi Comment		ctermfg=244		cterm=none		guifg=#808080	gui=none
hi Todo			ctermfg=232  	ctermbg=196     cterm=bold		guifg=#000000 guibg=#ff0000	gui=bold
hi cCustomFunc  ctermfg=117		cterm=none		guifg=#87d7ff
hi cCustomClass ctermfg=77		cterm=none		guifg=#5fd75f
" syntastic, error = spellbad, warning = spellcap, bar on left = signcolumn
"these links are defined in ~/.vim/bundle/syntastic/plugin/syntastic.vim:91
hi SpellBad					ctermfg=226		ctermbg=52		cterm=bold
hi SpellCap					ctermfg=196		ctermbg=232		cterm=bold
hi SyntasticErrorSign		ctermfg=226		ctermbg=88		cterm=bold
hi SyntasticWarningSign		ctermfg=196		ctermbg=16		cterm=none
hi SyntasticErrorLine						ctermbg=234
hi SyntasticWarningLine						ctermbg=16
hi SignColumn								ctermbg=233
" Links
hi! link FoldColumn		Folded
hi! link CursorColumn	CursorLine
hi! link NonText		LineNr

" vim-gitgutter hilights	
hi GitGutterAdd					ctermfg=46
hi GitGutterChange				ctermfg=226
hi GitGutterDelete				ctermfg=196
hi GitGutterChangeDelete		ctermfg=201
hi GitGutterAddLine				ctermbg=23
hi GitGutterChangeLine			ctermbg=58
hi GitGutterDeleteLine			ctermbg=52
hi GitGutterChangeDeleteLine	ctermbg=53
" vim:set ts=4 sw=4 noet:
