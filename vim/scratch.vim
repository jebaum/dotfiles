" various crap that I want to keep around but for whatever reason don't want
" in my vimrc anymore

" can't get this to play nice with is.vim
function! Nice_next(cmd)
  let view = winsaveview()
  execute "normal! " . a:cmd
  silent! foldopen!
  if view.topline != winsaveview().topline
    normal! zz
  endif
endfunction


" fugitive / GV git maps
" "0Gclog" loads commits affecting current file into quickfix, lets you go through full file at various commits
" "[range]Gclog" loads commits affecting range (e.g. from visual selection)
" "Glog -- %" loads commits affecting current file into quickfix, lets you go through the commit diffs
" "Glog! -- %" does the same, but doesn't load first commit into current buffer by default like the above does
" GV seems to allow all of the above, but possibly nicer
" ^ for going through commits and diffs, GV is nicer except for the 'visual mode see changes impacting these lines' use case, which it isn't quite as good at (loads accumulated diffs into single buffer)
" for going through old versions of the whole file, GV can't help. so better than Glog, but not a repacement for [range|0]Gclog


" iirc, this thing was designed for one specific eggert ocaml project and I
" never used it other than that
" Create maps to run buffer/visual selection through interpreter {{{
function! MapInterpreter(ftype, interpreter)
  execute 'nnoremap <leader>i :silent! bdelete /tmp/' . a:ftype . '<CR>:15split /tmp/' . a:ftype . ' \| %d \|setlocal ft=' . a:ftype . ' \| setlocal autowrite \| r!' . a:interpreter . ' < #<CR>:normal ggdd<CR>:silent w \| echo "did some ' . a:interpreter . '"<CR><C-w>p'

  execute 'vnoremap <leader>i y:silent! bdelete /tmp/' . a:ftype . '<CR>:15split /tmp/' . a:ftype . ' \| %d _ \| put \| write<CR>:normal! gg<CR>:setlocal ft=' . a:ftype . ' \| setlocal autowrite \| r!' . a:interpreter . ' < %<CR>:normal! jdGggdd<CR>:silent w \| echo "did some ' . a:interpreter . '"<CR><C-w>p'
endfunction
" }}}


" provided by vimple
" View command to capture ex command output {{{
function! ViewWrapper(command)
  redir => message
  silent! execute a:command
  redir END
  tabnew
  call append(0, a:command)
  silent! put=message
  normal! gg
  set nomodified
endfunction
command! -nargs=1 -bar View call ViewWrapper(<f-args>)
" }}}


" pretty sure these are buggy, never fully migrated them to neovim
" other people seem to be working on this same problem, I probably can
" leverage that by the time I ever need to do this again.
" Markdown functions {{{
" default values. spaces are only put at beginning of option value if needed
function! MarkdownConfigInitialize()
  let mybuf = bufname('%')
  if getbufvar(mybuf, 'md_engine', 'empty') == 'empty'       | let b:md_engine = '--latex-engine=xelatex' | endif
  if getbufvar(mybuf, 'md_margin', 'empty') == 'empty'       | let b:md_margin = '0.5in'                   | endif
  if getbufvar(mybuf, 'md_linebreak', 'empty') == 'empty'    | let b:md_linebreak = '+hard_line_breaks'    | endif
  if getbufvar(mybuf, 'md_highlight', 'empty') == 'empty'    | let b:md_highlight = '--no-highlight'      | endif
  if getbufvar(mybuf, 'md_presentation', 'empty') == 'empty' | let b:md_presentation = ''                  | endif
  if getbufvar(mybuf, 'md_doublespace', 'empty') == 'empty'  | let b:md_doublespace  = ''                  | endif
  if getbufvar(mybuf, 'md_mla', 'empty') == 'empty'          | let b:md_mla = ''                           | endif
endfunction

function! MarkdownMargin(margin)
  let b:md_margin    = a:margin . 'in'
  let b:md_linebreak = ''
  echo "changed margin to " . b:md_margin . ', turned off hard line breaks'
endfunction

function! MarkdownToggle(option, val, onmsg, blankmsg)
  let current_val = getbufvar(bufname("%"), a:option)
  if current_val == a:val
    call setbufvar(bufname("%"), a:option, '')
    echo a:blankmsg
  else
    call setbufvar(bufname("%"), a:option, a:val)
    if a:option == 'md_mla'
      let b:md_doublespace = ''
      let b:md_linebreak   = ''
    endif
    echo a:onmsg
  endif
endfunction

function! MarkdownArgsGenerate(action, output)
  call MarkdownConfigInitialize()
  let dir_fullpath  = expand('%:p:h')
  let dir_current   = expand('%:p:h:t')
  let base_name     = expand('%:p:t:r')
  let input_file    = expand('%:p')
  let pandoc_args   = [b:md_doublespace, b:md_mla, '-V', 'geometry:margin='.b:md_margin, b:md_engine, '-f', 'markdown'.b:md_linebreak, b:md_presentation, b:md_highlight]
  let b:md_msg      = a:action.' '.base_name.'.'.a:output
  let b:output_file = dir_fullpath.'/'.base_name.'.'.a:output

  if dir_current == "notes"
    let b:md_msg      = a:action.' '.a:output.'/'.base_name.'.'.a:output
    let b:output_file = shellescape(dir_fullpath.'/'.a:output.'/'.base_name.'.'.a:output)
    call system('mkdir '.shellescape(dir_fullpath.'/'.a:output))    " will run mkdir when not needed, but no big deal
  endif

  return extend(pandoc_args, [input_file, '-o', b:output_file])
endfunction

function! MarkdownJobHandler(job_id, data, event)
    echom "CALLED JOB HANDLER"
    if a:event == 'stdout'
        echom 'stdout happened:' . join(a:data, "\n")
    elseif a:event == 'stderr'
        echom 'there was a problem:' . join(a:data, "\n")
    else
        echom 'finished with status ' . a:data
        call system('killall -HUP mupdf')
    endif
endfunction

nnoremap ,nv :call MarkdownCommandRun('quickrun', 'built', 'pdf')<CR>
function! MarkdownCommandRun(method, action, output)
  let b:pandoc_args = MarkdownArgsGenerate(a:action, a:output)
  if a:action == 'built'

    if has('nvim')
        let callbacks = {'on_stdout': function('MarkdownJobHandler'), 'on_stderr': function('MarkdownJobHandler'), 'on_exit': function('MarkdownJobHandler')}
        call filter(b:pandoc_args, 'v:val != "" && v:val != " "')
        let arglist = extend(['pandoc'], b:pandoc_args)
        echo arglist

        " let buildjob = jobstart(['pandoc', b:pandoc_args], callbacks)
        let buildjob = jobstart(arglist, callbacks)
        echom "STARTED BUILD"
        return
    elseif a:method == 'quickrun'
      execute 'QuickRun pandoc -args "' . b:pandoc_args . '"'
    elseif a:method == 'vim'
      echom system('pandoc' . b:pandoc_args)
    elseif a:method == 'dispatch'
      execute 'Dispatch! pandoc' . b:pandoc_args
    endif

    if a:output == 'pdf'
      call system('killall -HUP mupdf')
    endif

  elseif a:action == 'removed'
    call system('rm '.b:output_file)
  elseif a:action == 'open'
    call system('mupdf ' . b:output_file . '&')
  endif
endfunction
" }}}



" misc stuff at end of vimrc I haven't gotten to yet
function! Open_current_file_dir(args)
  let [args, options] = unite#helper#parse_options_args(a:args)
  let path = expand('%:h')
  let options.path = path
  call unite#start(args, options)
endfunction
nnoremap <leader>F :call Open_current_file_dir('-no-split file')<cr>
" nmap <buffer> <bs> <Plug>(unite_delete_backward_path)
"
function! SystemListOutput(command)
  let output = systemlist(a:command)
  10new
  set buftype=nofile
  call append(line('$'), output)
endfunction
nnoremap <silent> <leader>h :call SystemListOutput('hub fork')<CR>

" vim motion to move up by an indent level
function! UpByIndent()
    norm! ^
    let start_col = col(".")
    let col = start_col
    while col >= start_col
        norm! k^
        if getline(".") =~# '^\s*$'
            let col = start_col
        elseif col(".") <= 1
            return
        else
            let col = col(".")
        endif
    endwhile
endfunction
" nnoremap <c-p> :call UpByIndent()<cr>

" show git branch with ctrl-g info
function! s:ctrl_g()
    redir => msg | silent exe "norm! 1\<c-g>" | redir END
    echo fugitive#head(7) msg[2:]
endfunction
nnoremap <C-g> :call <sid>ctrl_g()<cr>
" show the working directory and session
nnoremap <Esc>g :<C-u>echo fnamemodify(getcwd(), ":~")
\ (strlen(v:this_session) ? fnamemodify(v:this_session, ":~") : "[No session]")<cr>


if has('nvim')
    tnoremap <silent> <ESC><ESC> <C-\><C-n>G:call search(".", "b")<CR>$
endif

" "linewise partial staging in visual-mode.
" xnoremap <c-p> :diffput<CR>
" xnoremap <c-o> :diffget<CR>
" nnoremap <expr> dp &diff ? 'dp' : ':pclose<cr>'


" function! s:FilterQuickfixList(bang, pattern)
  " let cmp = a:bang ? '!~#' : '=~#'
  " call setqflist(filter(getqflist(), "bufname(v:val['bufnr']) " . cmp . " a:pattern"))
" endfunction
" command! -bang -nargs=1 -complete=file QFilter call s:FilterQuickfixList(<bang>0, <q-args>)
" " run with `:QFilter pattern` to only keep those that match, or `:Qfilter! pattern` to remove those that match

 " avoid sourcing stupid /usr/share/vim/vim74/menu.vim (saves ~100ms)
" let g:did_install_default_menus = 1


" " A massively simplified take on https://github.com/chreekat/vim-paren-crosshairs
" func! s:matchparen_cursorcolumn_setup()
" augroup matchparen_cursorcolumn
" autocmd!
" autocmd CursorMoved * if get(w:, "paren_hl_on", 0) | set cursorcolumn | else | set nocursorcolumn | endif
" autocmd InsertEnter * set nocursorcolumn
" augroup END
" endf
" if !&cursorcolumn
" augroup matchparen_cursorcolumn_setup
" autocmd!
" " - Add the event _only_ if matchparen is enabled.
" " - Event must be added _after_ matchparen loaded (so we can react to w:paren_hl_on).
" autocmd CursorMoved * if exists("#matchparen#CursorMoved") | call <sid>matchparen_cursorcolumn_setup() | endif
" \ | autocmd! matchparen_cursorcolumn_setup
" augroup END
" endif


" Plug 'jeetsukumaran/vim-markology', {'on': ['MarkologyEnable', 'MarkologyDisable', 'MarkologyToggle', 'MarkologyPlaceMarkToggle', 'MarkologyPlaceMark', 'MarkologyClearMark', 'MarkologyClearAll', 'MarkologyNextLocalMarkPos', 'MarkologyPrevLocalMarkPos', 'MarkologyNextLocalMarkByAlpha', 'MarkologyPrevLocalMarkByAlpha', 'MarkologyLocationList', 'MarkologyQuickFix']}
let g:markology_enable = 0

" Plug 'mbbill/undotree', {'on': ['UndotreeFocus', 'UndotreeHide', 'UndotreeShow', 'UndotreeToggle']}
" Plug 'kana/vim-textobj-user'
" Plug 'kana/vim-textobj-line' " TODO map conflict with 'in last' and 'around last' targets.vim objects
" Plug 'kana/vim-textobj-entire'
" https://github.com/glts/vim-textobj-comment
" Plug 'junegunn/vim-after-object'
" autocmd VimEnter * call after_object#enable(['>', '<'], '=', ':', '-', '#', ' ')

" Commands for editing wiki pages to Gitit
" command! -nargs=1 Wiki execute ":split $HOME/Dropbox/wikidata/" . fnameescape("<args>.page") | execute ":Gwrite"

" Plug 'dhruvasagar/vim-prosession'

" TODO look into this more, and remove other maps starting with " maybe
" Plug 'junegunn/vim-peekaboo'
" Plug 'michaeljsmith/vim-indent-object'  <- doesn't have any maps that overlap with targets.vim

https://github.com/dahu/VimRegexTutor
https://www.reddit.com/r/neovim/comments/3t6k8i/looking_for_a_nice_way_to_use_the_neovims/
https://www.reddit.com/r/vim/comments/3tbghl/canonical_way_of_searching_project_from_within_vim/
https://github.com/vimwiki/vimwiki
https://www.reddit.com/r/vim/comments/3ysfnn/how_to_quickly_view_changes_gitfugitive_workflow/
https://github.com/dhruvasagar/vim-dotoo
https://github.com/jceb/vim-orgmode
not sure what these two things are. second looks to just be fzf but in lua?
https://github.com/nvim-lua
https://github.com/nvim-telescope
https://github.com/hrsh7th/nvim-compe
nvim-compe guide: https://www.reddit.com/r/neovim/comments/ldetyp/linux_script_to_install_neovim_nightly_with_a/

search plugins:
https://github.com/henrik/vim-indexed-search

https://github.com/lfv89/vim-interestingwords " more featureful and english version of brightest?

these maps instead of vim move plugin thing
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '>-2<CR>gv=gv
