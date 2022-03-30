" Enable Mouse
set mouse=a

set guifont=FiraCode\ Nerd\ Font\ Mono:h12
" Set Editor Font
if exists(':GuiFont')
    " Use GuiFont! to ignore font errors
    GuiFont "Fira Code:h12"
endif

" Disable GUI Tabline
if exists(':GuiTabline')
    GuiTabline 0
endif

" Enable GUI ScrollBar
if exists(':GuiScrollBar')
    GuiScrollBar 1
endif

" Right Click Context Menu (Copy-Cut-Paste)
nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
xnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
snoremap <silent><RightMouse> <C-G>:call GuiShowContextMenu()<CR>gv
cmap <S-Insert> <C-R>+
cmap <C-v> <C-R>*
inoremap <D-v> <C-\><C-n>"+p
nnoremap <D-v> <C-\><C-n>"+p
tnoremap <D-v> <C-\><C-n>"+pi
cnoremap <D-v> <C-r>+
inoremap <silent><D-s> :w<CR>
nnoremap <silent><D-s> :w<CR>
vnoremap <silent><D-s> :w<CR>
tnoremap <silent><D-s> :w<CR>
inoremap <silent><D-c> "+y
nnoremap <silent><D-c> "+y
vnoremap <silent><D-c> "+y
tnoremap <silent><D-c> "+y

if exists('g:fvim_loaded')
    " good old 'set guifont' compatibility with HiDPI hints...
      
    " Ctrl-ScrollWheel for zooming in/out
    nnoremap <silent> <C-ScrollWheelUp> :set guifont=+<CR>
    nnoremap <silent> <C-ScrollWheelDown> :set guifont=-<CR>
    nnoremap <A-CR> :FVimToggleFullScreen<CR>
    " FVimBackgroundComposition 'transparent'   " 'none', 'transparent', 'blur' or 'acrylic'
    " FVimBackgroundOpacity 0.85
endif

" let g:neovide_transparency=0.92
" let g:neovide_no_idle=v:true
" let g:neovide_input_use_logo=v:true
" let g:neovide_cursor_vfx_mode = "ripple"

