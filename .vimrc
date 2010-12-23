set nocompatible                " I think this is redundant, but just in case

filetype off    " load order issue with pathogen.vim

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
set incsearch                   " show best-match-so-far

set title                       " set xterm title when in terminal mode

set showmatch                   " blink matching brackets

set backspace=eol,start,indent  " BkSp works properly

" make tab-completion of commands and files behave like Bash's
set wildmode=longest,list

" visually wrap lines at word boundaries (without changing the text)
set wrap lbr

set display=uhex                " more obvious display of binary files

augroup filetype
  autocmd BufNewFile,BufRead *.ypp set filetype=yacc    " recognise ypp ext
  autocmd BufNewFile,BufRead *.y++ set filetype=yacc    " recognise y++ ext
augroup END

" easy quit if all files saved
" by analogy with ZQ
nnoremap ZA :qa<CR>

let mapleader = ','

" make rejustifying easier
noremap Q gqap

" by analogy with D
nnoremap Y y$

nnoremap - Vyp:s/./-/g<RETURN>o<ESC>
nnoremap # 18I#<ESC>a This line is precisely 80 characters long. <ESC>18a#<ESC>

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

" 4-space indent for Javascript (Rapportive coding standard)
autocmd FileType javascript set shiftwidth=4 tabstop=4

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

" Easier navigation of split windows
nnoremap <C-h> <C-w><C-h>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>

" Expand window we move into
nnoremap <C-w>h <C-w>h<C-w>_
nnoremap <C-w>j <C-w>j<C-w>_
nnoremap <C-w>k <C-w>k<C-w>_
nnoremap <C-w>l <C-w>l<C-w>_

" ignore whitespace in diffs
nnoremap <Leader>dw :set diffopt+=iwhite<CR>

" stop diffing current buffer
nnoremap <Leader>do :diffoff<CR>

" diff current buffer
nnoremap <Leader>dt :diffthis<CR>

" update diff with fewer keystrokes
nnoremap <Leader>du :diffupdate<CR>

function! s:toggleDiff()
    if &diff
        :diffoff
    else
        :diffthis
    endif
endfunction
nnoremap <Leader>dd :call <SID>toggleDiff()<CR>

if &diff
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

" after posting a gist (using gist.vim), open it in browser
let g:gist_open_browser_after_post = 1

" autoCompletePop for snipMate snippets
let g:acp_behaviorSnipmateLength = 1

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
