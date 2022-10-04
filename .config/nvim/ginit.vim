call togglebg#map("<Leader>bg")

au FocusGained * :checktime

if exists('g:GtkGuiLoaded')
  call rpcnotify(1, 'Gui', 'Font', 'Ubuntu Mono 14')
  nnoremap <Leader>gf :call rpcnotify(1, 'Gui', 'Font', 'Ubuntu Mono 12')<CR>
  nnoremap <Leader>gF :call rpcnotify(1, 'Gui', 'Font', 'Ubuntu Mono 14')<CR>
elseif exists('g:neovide')
  set guifont=Ubuntu\ Mono:h15
  nnoremap <Leader>gf :set guifont=Ubuntu\ Mono:h12<CR>
  nnoremap <Leader>gF :set guifont=Ubuntu\ Mono:h15<CR>

  let g:neovide_cursor_vfx_mode = 'railgun'
  let g:neovide_cursor_trail_size = 0.3 " chill a bit
endif
