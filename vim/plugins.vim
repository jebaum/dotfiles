" Plug 'dbakker/vim-projectroot' " there's also a thing called rooter that's more automatic

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
" https://github.com/glts/vim-textobj-comment
" Plug 'junegunn/vim-after-object'
" https://github.com/junegunn/vim-easy-align
" autocmd VimEnter * call after_object#enable(['>', '<'], '=', ':', '-', '#', ' ')

" Commands for editing wiki pages to Gitit
" command! -nargs=1 Wiki execute ":split $HOME/Dropbox/wikidata/" . fnameescape("<args>.page") | execute ":Gwrite"

" Plug 'dhruvasagar/vim-prosession'

" TODO look into this more, and remove other maps starting with " maybe
" Plug 'junegunn/vim-peekaboo'

" Plug 'pelodelfuego/vim-swoop' " TODO definite keeper, but needs maps and config

" Plug 'michaeljsmith/vim-indent-object'  <- doesn't have any maps that overlap with targets.vim

https://github.com/dahu/VimRegexTutor
https://www.reddit.com/r/neovim/comments/3t6k8i/looking_for_a_nice_way_to_use_the_neovims/
https://www.reddit.com/r/vim/comments/3tbghl/canonical_way_of_searching_project_from_within_vim/
https://github.com/vimwiki/vimwiki
https://www.reddit.com/r/vim/comments/3ysfnn/how_to_quickly_view_changes_gitfugitive_workflow/
https://github.com/junegunn/fzf.vim/issues/47
https://github.com/dhruvasagar/vim-dotoo
https://github.com/jceb/vim-orgmode

search plugins:
https://github.com/henrik/vim-indexed-search
https://github.com/osyo-manga/vim-anzu

https://github.com/Olical/vim-enmasse
https://github.com/lfv89/vim-interestingwords
https://github.com/xtal8/traces.vim
