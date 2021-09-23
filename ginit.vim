" Enable Mouse
set mouse=a

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
