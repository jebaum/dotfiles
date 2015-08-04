" TODO: try taking out the 'syntax on' and related stuff from vimrc, and doing
" this in there. also try setting this colorscheme and these customizations
" after call to plug#end(). might need to set a default colorscheme at the top
" of vimrc still, which seems to turn on some other important settings.
let g:gruvbox_invert_selection=0

highlight Normal ctermbg=8 guibg=#181818
" only works in neovim if the line is here twice? wtf?
highlight Normal ctermbg=8 guibg=#181818

highlight UniteSel     ctermfg=16   ctermbg=73      cterm=none  guifg=#000000  guibg=#5FAFAF  gui=none
highlight SpecialKey   ctermfg=243  ctermbg=237
highlight IncSearch                 ctermbg=254
