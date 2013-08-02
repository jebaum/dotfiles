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
hi Normal		ctermfg=231		ctermbg=none	cterm=none		guifg=#e3e0d7	guibg=#242424	gui=none
hi Cursor		ctermfg=234		ctermbg=228		cterm=none		guifg=#242424	guibg=#eae788	gui=none
hi Visual		ctermfg=251		ctermbg=239		cterm=none		guifg=#c3c6ca	guibg=#554d4b	gui=none
hi VisualNOS	ctermfg=251		ctermbg=236		cterm=none		guifg=#c3c6ca	guibg=#303030	gui=none
hi Search		ctermfg=177		ctermbg=241		cterm=none		guifg=#d787ff	guibg=#636066	gui=none
hi Folded		ctermfg=103		ctermbg=237		cterm=none		guifg=#a0a8b0	guibg=#3a4046	gui=none
hi Title		ctermfg=230						cterm=bold		guifg=#ffffd7					gui=bold
hi StatusLine	ctermfg=230		ctermbg=238		cterm=none		guifg=#ffffd7	guibg=#444444	gui=italic
hi VertSplit	ctermfg=238		ctermbg=238		cterm=none		guifg=#444444	guibg=#444444	gui=none
hi StatusLineNC	ctermfg=241		ctermbg=238		cterm=none		guifg=#857b6f	guibg=#444444	gui=none
hi LineNr		ctermfg=33 		ctermbg=232		cterm=none		guifg=#857b6f	guibg=#080808	gui=none
hi SpecialKey	ctermfg=241		ctermbg=235		cterm=none		guifg=#626262	guibg=#2b2b2b	gui=none
hi WarningMsg	ctermfg=203										guifg=#ff5f55
hi ErrorMsg		ctermfg=196		ctermbg=232		cterm=bold		guifg=#ff2026	guibg=#3a3a3a	gui=bold

" Vim >= 7.0 specific colors
if version >= 700
hi CursorLine	ctermbg=232		cterm=none						guibg=#32322f
hi MatchParen	ctermfg=196		ctermbg=16		cterm=bold		guifg=#eae788	guibg=#857b6f	gui=bold
hi Pmenu		ctermfg=230		ctermbg=238						guifg=#ffffd7	guibg=#444444
hi PmenuSel		ctermfg=232		ctermbg=192						guifg=#080808	guibg=#cae982
endif

" Diff highlighting
hi DiffAdd						ctermbg=17										guibg=#2a0d6a
hi DiffDelete	ctermfg=234		ctermbg=60		cterm=none		guifg=#242424	guibg=#3e3969	gui=none
hi DiffText						ctermbg=53		cterm=none						guibg=#73186e	gui=none
hi DiffChange					ctermbg=237										guibg=#382a37

"hi CursorIM
"hi Directory
"hi IncSearch
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
"hi TabLine
"hi TabLineFill
"hi TabLineSel
"hi Tooltip
"hi User1
"hi User9
"hi WildMenu

" Syntax highlighting. cterm options are bold, underline, reverse, italic, none
hi Keyword		ctermfg=201		cterm=none		guifg=#88b8f6	gui=none
" statement = return, for, if, switch, case, continue, etc
hi Statement	ctermfg=202		cterm=bold  	guifg=#88b8f6	gui=none
hi Constant		ctermfg=226		cterm=none		guifg=#e5786d	gui=none
hi Number		ctermfg=201		cterm=bold		guifg=#e5786d	gui=none
hi PreProc		ctermfg=171		cterm=none		guifg=#e5786d	gui=none
hi Function		ctermfg=51		cterm=none		guifg=#cae982	gui=none
hi Identifier	ctermfg=51		cterm=none		guifg=#cae982	gui=none
hi Type			ctermfg=46		cterm=none		guifg=#d4d987	gui=none
hi Special		ctermfg=229		cterm=none		guifg=#eadead	gui=none
hi String		ctermfg=208		cterm=none		guifg=#95e454	gui=italic
hi Comment		ctermfg=244		cterm=none		guifg=#9c998e	gui=italic
hi Todo			ctermfg=16  	ctermbg=red     cterm=none		guifg=#857b6f	gui=italic
hi cCustomFunc  ctermfg=117		cterm=none
hi cCustomClass ctermfg=77		cterm=none
" syntastic, error = spellbad, warning = spellcap, bar on left = signcolumn
" these links are defined in ~/.vim/bundle/syntastic/plugin/syntastic.vim:91
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

" vim:set ts=4 sw=4 noet:
