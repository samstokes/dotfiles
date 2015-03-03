colorscheme solarized
set guifont=Ubuntu\ Mono:h15

call togglebg#map("<F5>")

let g:netrw_browse_split=1

" for gist.vim: open a browser instance after creating a gist
let g:gist_open_browser_after_post = 1

" hide scrollbars
set guioptions-=l
set guioptions-=L
set guioptions-=r

set guioptions-=m   " hide menu
set guioptions-=T   " hide toolbar
set guioptions+=c

set guioptions+=a   " autoselect to * register

set transparency=8
nnoremap <M-ScrollWheelUp> :silent! set transparency-=4<CR>
nnoremap <M-ScrollWheelDown> :silent! set transparency+=4<CR>
