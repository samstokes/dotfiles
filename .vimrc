set nocompatible                " I think this is redundant, but just in case

filetype off    " load order issue with pathogen.vim


" Use camel-case / snake-case aware word motions by default (CamelCaseMotion)
" Must appear before CamelCaseMotion plugin is sourced, i.e. before Pathogen
map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e
sunmap w
sunmap b
sunmap e
omap <silent> iw <Plug>CamelCaseMotion_iw
xmap <silent> iw <Plug>CamelCaseMotion_iw
omap <silent> ib <Plug>CamelCaseMotion_ib
xmap <silent> ib <Plug>CamelCaseMotion_ib
omap <silent> ie <Plug>CamelCaseMotion_ie
xmap <silent> ie <Plug>CamelCaseMotion_ie


call pathogen#runtime_append_all_bundles()

syntax on                       " syntax highlighting
filetype plugin indent on       " enable per-filetype plugins and indenters

set background=dark

set showmode                    " show mode in status bar (on by default?)
set showcmd                     " show partially typed commands (default?)
set mouse=a                     " mouse enabled always
set ruler
set pastetoggle=<F2>            " toggle paste mode with F2 key

set shiftwidth=2                " indents of 2 spaces
set tabstop=2                   " and tab stops of 2
" set softtabstop=2               " 'feel like' tabs are 2
set shiftround                  " round shift to n*shiftwidth when indenting
set expandtab                   " expand tabs to spaces
set smarttab                    " backspace deletes a tab's worth of spaces
set so=6                        " leave 6 lines of scope when scrolling

set ignorecase                  " searches are case-insensitive
set smartcase                   " ... unless they contain uppercase letters
set nohlsearch                  " don't leave search phrases highlighted
nnoremap <Leader>hs :set invhlsearch<CR>
set incsearch                   " show best-match-so-far

set title                       " set xterm title when in terminal mode

set showmatch                   " blink matching brackets

set backspace=eol,start,indent  " BkSp works properly

set exrc                        " local .vimrc files
set secure                      " ... with fewer security risks

" make tab-completion of commands and files behave like Bash's
set wildmode=longest,list

" ignore directories we probably never want to edit directly
set wildignore+=.*.sw?
set wildignore+=coverage/*
set wildignore+=pkg/*
set wildignore+=*.class
set wildignore+=*.o
set wildignore+=*.hi
set wildignore+=target
set wildignore+=.git

" visually wrap lines at word boundaries (without changing the text)
set wrap lbr

set list listchars=tab:>-,trail:·

set display=uhex                " more obvious display of binary files

augroup filetype
  autocmd BufNewFile,BufRead *.ypp set filetype=yacc    " recognise ypp ext
  autocmd BufNewFile,BufRead *.y++ set filetype=yacc    " recognise y++ ext
  autocmd BufNewFile,BufRead *.hbs set filetype=html    " recognise Handlebars
augroup END

" easy quit if all files saved
" by analogy with ZQ
nnoremap ZA :qa<CR>

let mapleader = ','
let maplocalleader = ';'

" make rejustifying easier
noremap Q gqap

" by analogy with D
nnoremap Y y$

nnoremap - Vyp:s/./-/g<RETURN>o<ESC>
nnoremap # 18I#<ESC>a This line is precisely 80 characters long. <ESC>18a#<ESC>

" reboot syntax highlighting in case it gets confused
nnoremap <Leader>ss :syntax off\|syntax on<CR>

" stuff for editing prose

" start new paragraph
nmap <C-o> O<CR>

" with wrapped long lines, have up and down motions move as they look like
" they should 
nnoremap j           gj
nnoremap k           gk
inoremap <Down> <C-o>gj
inoremap <Up>   <C-o>gk
inoremap <Home> <C-o>g^
inoremap <End>  <C-o>g$

" blog-specific stuff
vmap <C-n> s<pre>gvs<code>gvs<noscript>3Jgv<Esc>2k3Jk

" markdown preview
autocmd FileType mkd nmap <Leader>rp :silent w !markdown \| bcat<CR>

" don't text wrap emails, mail client will do it too and conflict
autocmd FileType mail set textwidth=0

" don't break makefiles
autocmd FileType make set noexpandtab shiftwidth=8 tabstop=8

set autoindent " want this most of the time
" indentation is annoying when trying to write text...
" and C-indentation for C-like languages
autocmd FileType sh,c,cpp,java,php,javascript set cindent
" kill autoindent for text-like languages
autocmd FileType tex,html,xhtml,xml,mail set noautoindent
" enable actual text wrap for these file types only
autocmd FileType tex,html,xhtml,xml set textwidth=79
" 2-space indents for *ml files
autocmd FileType html,xhtml,xml,sgml,xslt set shiftwidth=2 tabstop=2

" 4-space indent for Javascript and Handlebars (Rapportive coding standard)
autocmd FileType java,javascript,html set shiftwidth=4 tabstop=4

autocmd FileType xml set equalprg=xmllint\ --format\ -

" some helpful abbrevs for LaTeX documents
autocmd FileType tex iab  naive na\"\i ve
autocmd FileType tex iab  Naive Na\"\i ve
autocmd FileType tex iab latexme \author{Sam Stokes {\tt <ss496>}}
autocmd FileType tex iab <ul> \begin{itemize}<CR><TAB>\item<CR><BS>\end{itemize}<UP>
autocmd FileType tex iab <ol> \begin{enumerate}<CR><TAB>\item<CR><BS>\end{enumerate}<UP>
autocmd FileType tex iab <img> \begin{figure}[hbp]<CR><TAB>\begin{center}<CR><TAB>\includegraphics{}<CR><BS>\end{center}<CR><BS>\end{figure}<UP><UP><END><LEFT>

" work around rails.vim bug (see
" http://www.vim.org/scripts/script.php?script_id=1567)
silent! ruby nil
" set up do...end replacement for surround plugin
autocmd FileType ruby let b:surround_100 = "do \r end"
" Remap word deletion: Ctrl-w is a risky habit to get into...
imap <C-BS> <C-w>
" Actually unmapping C-w breaks C-BS as well :(
" inoremap <C-w> <C-o>:echo 'Please use Ctrl-Backspace to delete previous word!'<CR>

" make current file executable
nnoremap <M-x> :!chmod +x %<CR><CR>

" Tell snipMate.vim who I am
let g:snips_author = 'Sam Stokes <me@samstokes.co.uk>'

" Easier browsing of search results
nnoremap <C-DOWN> :cnext<CR>
nnoremap <C-UP> :cprevious<CR>

" ignore whitespace in diffs
nnoremap <Leader>dw :set diffopt+=iwhite<CR>

" stop diffing current buffer
nnoremap <Leader>do :diffoff<CR>

" diff current buffer
nnoremap <Leader>dt :diffthis<CR>

" update diff with fewer keystrokes
nnoremap <Leader>du :diffupdate<CR>

" Help with fat fingers near Escape
noremap <F1> <ESC>
inoremap <F1> <ESC>

function! s:toggleDiff()
    if &diff
        :diffoff
    else
        :diffthis
    endif
endfunction
nnoremap <Leader>dd :call <SID>toggleDiff()<CR>

if &diff
  autocmd BufNewFile,BufRead * SyntasticDisable

  " Handy shortcuts for three-way diffing (e.g. as git mergetool)

  " Diff center window against just the left-hand window
  nnoremap <C-Left> 2<C-w>l:diffo<CR>2<C-w>h:difft<CR>
  " Diff center window against just the right-hand window
  nnoremap <C-Right> 2<C-w>h:diffo<CR>2<C-w>l:difft<CR>
  " Diff center window against both windows
  nnoremap <C-Space> 2<C-w>h:difft<CR>2<C-w>l:difft<CR><C-w>h

  " 'Merge Local' - pick the local version of a merge conflict
  nnoremap <Leader>ml />>>><CR>V?====<CR>d?<<<<<CR>dd

  " 'Merge Remote' - pick the remote version of a merge conflict
  nnoremap <Leader>mr ?<<<<<CR>V/====<CR>d/>>>><CR>dd
endif

" fewer keystrokes for a.vim
nnoremap <Leader>a :AV<CR>

" Taglist plugin
map <Leader>ll :TlistToggle<CR>

" easy project grep
nmap <Leader>/ :grep 
" use ack if available
call system('type ack >/dev/null 2>&1')
if !v:shell_error
  set grepprg=ack
endif

" include git branch in statusline via Fugitive
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

" fugitive shortcuts
nnoremap <Leader>gst :Gstatus<CR>
nnoremap <Leader>gci :Gcommit<CR>
nnoremap <Leader>gdf :Gdiff<CR>
nnoremap <Leader>gad :Git add %<CR>

" edit .vimrc in split window
nnoremap <Leader>vv :vs $HOME/.vimrc<CR>

" shortcut for :windo
nnoremap <C-w>: :windo 

" after posting a gist (using gist.vim), open it in browser
let g:gist_open_browser_after_post = 1

" When editing XMonad config, ,q to check config
autocmd BufNewFile,BufRead .xmonad/xmonad.hs nnoremap <Leader>q :!check-xmonad-config.sh<CR>

" Haskellise SLIME
autocmd FileType haskell,lhaskell nnoremap <C-c><C-c> :call Send_to_Screen(":l " . @% . "\n")<CR>

" scion (Haskell IDE)
let g:scion_connection_setting = [ 'scion', '/home/sam/.cabal/bin/scion-server' ]
set runtimepath+=/home/sam/.cabal/share/scion-0.1.0.2/vim_runtime_path/
autocmd FileType haskell,lhaskell nnoremap <Leader>sl :LoadComponentScion<CR>
autocmd FileType haskell,lhaskell nnoremap <Leader>sc :BackgroundTypecheckFileScion<CR>
autocmd FileType haskell,lhaskell nnoremap <Leader>st :ThingAtPointScion<CR>
autocmd FileType haskell,lhaskell inoremap <C-c> <ESC>:ThingAtPointScion<CR>
"autocmd FileType haskell,lhaskell :LoadComponentScion " dies on new files
"autocmd FileType haskell,lhaskell :BackgroundTypecheckFileScion " dies on new files
autocmd FileType haskell,lhaskell nnoremap <Leader>r :!runhaskell %<CR>
autocmd FileType haskell,lhaskell set keywordprg=hoogle\ --count=10

" gitv
let g:Gitv_PromptToDeleteMergeBranch = 1
let g:Gitv_TruncateCommitSubjects = 1
nmap <leader>gv :Gitv --all<cr>
nmap <leader>gV :Gitv! --all<cr>
vmap <leader>gV :Gitv! --all<cr>

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=1

" Ctrl-P
let g:ctrlp_extensions = ['tag', 'buffertag']


autocmd FileType git,gitv set keywordprg=github


nnoremap [t :tabprevious<CR>
nnoremap ]t :tabnext<CR>


nnoremap <leader>' :Switch<CR>
