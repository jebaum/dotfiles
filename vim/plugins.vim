" Plug 'tpope/vim-scriptease', {'on': ['Runtime', 'Scriptnames', 'Verbose', 'Time', 'Vedit', 'Vsplit', 'Vtabedit']}

" Plug 'terryma/vim-multiple-cursors'
" https://github.com/gregsexton/gitv
https://github.com/tpope/vim-commentary
" Plug 'osyo-manga/vim-brightest'  " maybe just use * and # instead?

Plug 'marijnh/tern_for_vim', {'for': 'javascript', 'do' : 'npm install'}
" autocmd FileType javascript setlocal omnifunc=tern#Complete

" Plug 'justinmk/vim-syntax-extra', {'for': ['c', 'lex', 'yacc']}
" Plug 'junegunn/goyo.vim', {'on': 'Goyo'}
https://github.com/junegunn/limelight.vim
" Plug 'wellle/tmux-complete.vim' " TODO make sure I can still use this with vimcompletesme or whatever

" Plug 'junkblocker/patchreview-vim'
" Plug 'codegram/vim-codereview'

Plug 'jelera/vim-javascript-syntax', {'for': 'javascript'}
Plug 'othree/javascript-libraries-syntax.vim', {'for': 'javascript'}


" hi! link javaScriptNumber Number

" Plug 'dbakker/vim-projectroot'
" Plug 'chrisbra/Colorizer', {'on': ['ColorClear', 'ColorToggle', 'ColorHighlight']}


" Plug 'Yggdroot/indentLine', {'on': ['IndentLinesEnable', 'IndentLinesDisable', 'IndentLinesReset', 'IndentLinesToggle']}
let g:indentLine_char='│'

" Plug 'coot/cmdalias_vim'



" Plug 'jeetsukumaran/vim-markology', {'on': ['MarkologyEnable', 'MarkologyDisable', 'MarkologyToggle', 'MarkologyPlaceMarkToggle', 'MarkologyPlaceMark', 'MarkologyClearMark', 'MarkologyClearAll', 'MarkologyNextLocalMarkPos', 'MarkologyPrevLocalMarkPos', 'MarkologyNextLocalMarkByAlpha', 'MarkologyPrevLocalMarkByAlpha', 'MarkologyLocationList', 'MarkologyQuickFix']}
let g:markology_enable = 0

" Plug 'mbbill/undotree', {'on': ['UndotreeFocus', 'UndotreeHide', 'UndotreeShow', 'UndotreeToggle']}



" Plug 'bruno-/vim-vertical-move', {'on': ['<Plug>(vertical_move_up)', '<Plug>(vertical_move_down)']}
" let g:vertical_move_default_mapping = 0
" TODO defaults are ]v and [v, maybe they're fine? maybe think of something else. + and -?
" nmap <silent> <leader>j <Plug>(vertical_move_down)
" nmap <silent> <leader>k <Plug>(vertical_move_up)
" xmap <silent> <leader>j <Plug>(vertical_move_down)
" xmap <silent> <leader>k <Plug>(vertical_move_up)

" Plug 'kana/vim-textobj-user'
" Plug 'kana/vim-textobj-line' " TODO map conflict with 'in last' and 'around last' targets.vim objects
" Plug 'kana/vim-textobj-entire'
" Plug 'junegunn/vim-after-object'
" https://github.com/junegunn/vim-easy-align
" autocmd VimEnter * call after_object#enable(['>', '<'], '=', ':', '-', '#', ' ')
" nnoremap >> >>
" nnoremap << <<


" Plug 'dahu/VimFindsMe', {'branch': 'overlay'} " mapping conflicts
" Plug 'dahu/vimple'

" Commands for editing wiki pages to Gitit
" command! -nargs=1 Wiki execute ":split $HOME/Dropbox/wikidata/" . fnameescape("<args>.page") | execute ":Gwrite"

" Plug 'tpope/vim-obsession'
" Plug 'dhruvasagar/vim-prosession'

" Plug 'int3/vim-extradite', {'on': 'Extradite'} " TODO map for this?

" nmap <silent> ], :set opfunc=ArgMovement<CR>g@Ina
" nmap <silent> [, :set opfunc=ArgMovement<CR>g@Ila
" function! ArgMovement(type, ...)
    " call feedkeys("`[", 'n')
" endfunction
" Plug 'PeterRincker/vim-argumentative'
" let g:argumentative_no_mappings = 1
" nmap <, <Plug>Argumentative_MoveLeft
" nmap >, <Plug>Argumentative_MoveRight

" Plug 'kopischke/vim-fetch'
" Plug 'kopischke/vim-stay'
" set viewoptions=cursor,folds,slash,unix

" Plug 'kana/vim-niceblock'
" this creates A and I mappings in visual mode, which targets.vim stomps over
" so instead, make our own
" vmap <leader>A <Plug>(niceblock-A)
" vmap <leader>I <Plug>(niceblock-I)

" TODO look into this more, and remove other maps starting with " maybe
" Plug 'junegunn/vim-peekaboo'

" Plug 'pelodelfuego/vim-swoop' " TODO definite keeper, but needs maps

" Plug 'michaeljsmith/vim-indent-object'

" inoremap <expr> <C-n> SCall('VimCompletesMe', 'vim_completes_me', [0])
" inoremap <expr> <C-p> SCall('VimCompletesMe', 'vim_completes_me', [1])

" Plug 'haya14busa/vim-lazy-lines'   " call lazylines#deletelines(2)
" Plug 'Lokaltog/vim-easymotion'


Plug 'FelikZ/ctrlp-py-matcher'
" let g:ctrlp_match_func = {'match' : 'pymatcher#PyMatch' }

https://github.com/dahu/VimRegexTutor
https://www.reddit.com/r/neovim/comments/3t6k8i/looking_for_a_nice_way_to_use_the_neovims/
https://www.reddit.com/r/vim/comments/3tbghl/canonical_way_of_searching_project_from_within_vim/
https://github.com/vimwiki/vimwiki
https://github.com/jeetsukumaran/vim-filebeagle
https://github.com/justinmk/vim-dirvish
" https://github.com/justinmk/vim-gtfo
https://github.com/gabesoft/vim-ags
https://www.reddit.com/r/vim/comments/3w45yx/ann_vimgrepper_10_release/
https://www.reddit.com/r/vim/comments/3ysfnn/how_to_quickly_view_changes_gitfugitive_workflow/
http://davidosomething.com/blog/vim-for-javascript/
https://github.com/junegunn/fzf.vim/issues/47
https://github.com/dhruvasagar/vim-dotoo
https://github.com/jceb/vim-orgmode

search plugins:
https://github.com/dahu/SearchParty
https://github.com/henrik/vim-indexed-search
https://github.com/junegunn/vim-oblique
https://github.com/ivyl/vim-bling
https://github.com/haya14busa/vim-asterisk
https://github.com/osyo-manga/vim-anzu
https://github.com/inside/vim-search-pulse
