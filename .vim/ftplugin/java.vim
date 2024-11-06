nnoremap <silent> <buffer> K :JavaDocSearch -x declarations<CR>
nnoremap <silent> <buffer> <leader>i :JavaImport<CR>
inoremap <silent> <buffer> <leader><leader>i <C-o>:JavaImport<CR><Right>
nnoremap <silent> <buffer> <CR> :JavaSearchContext<CR>
nnoremap <silent> <buffer> <leader>f :JavaCorrect<CR>

nnoremap <silent> <buffer> <C-CR> :sign unplace *<CR>
