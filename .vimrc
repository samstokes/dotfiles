" $Id: .vimrc 124 2008-04-23 21:52:03Z sam $

set nocompatible                " I think this is redundant, but just in case

syntax on                       " syntax highlighting
filetype on                     " filetype detection (on by default?)
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
set so=6                        " leave 6 lines of scope when scrolling

set ignorecase                  " searches are case-insensitive
set smartcase                   " ... unless they contain uppercase letters
set nohlsearch                  " don't leave search phrases highlighted
set incsearch                   " show best-match-so-far

set showmatch                   " blink matching brackets

set backspace=eol,start,indent  " BkSp works properly

" visually wrap lines at word boundaries (without changing the text)
set wrap lbr

augroup filetype
  autocmd BufNewFile,BufRead *.ypp set filetype=yacc    " recognise ypp ext
  autocmd BufNewFile,BufRead *.y++ set filetype=yacc    " recognise y++ ext
augroup END

noremap Q gqap                  " make rejustifying easier

noremap - Vyp:s/./-/g<RETURN>o<ESC>
noremap # 18I#<ESC>a This line is precisely 80 characters long. <ESC>18a#<ESC>

" don't break makefiles
autocmd FileType make set noexpandtab shiftwidth=8 tabstop=8

" indentation is annoying when trying to write text...
" so enable it only for programming languages
autocmd FileType python,ruby,sh,make,tex,c,cpp,java,php,vim set autoindent
" and C-indentation for C-like languages
autocmd FileType sh,c,cpp,java,php set cindent
" enable actual text wrap for these file types only
autocmd FileType tex,html,xhtml,xml,mail set textwidth=79
" I like 1-space indents for *ml files
autocmd FileType html,xhtml,xml,sgml,xslt set shiftwidth=1 tabstop=1 expandtab

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

" Map Ctrl-F to Jamis Buck's TextMate-like fuzzy file finder
nnoremap <C-f> :FuzzyFinderTextMate<CR>
nnoremap <C-b> :FuzzyFinderBuffer<CR>

autocmd BufNewFile,BufRead COMMIT_EDITMSG set filetype=gitcommit

" make current file executable
nnoremap <M-x> :!chmod +x %<CR><CR>

" Easier browsing of search results
nnoremap <C-DOWN> :cnext<CR>
nnoremap <C-UP> :cprevious<CR>

if &diff
  " Handy shortcuts for three-way diffing (e.g. as git mergetool)

  " Diff center window against just the left-hand window
  nnoremap <C-Left> 2<C-w>l:diffo<CR>2<C-w>h:difft<CR>
  " Diff center window against just the right-hand window
  nnoremap <C-Right> 2<C-w>h:diffo<CR>2<C-w>l:difft<CR>
  " Diff center window against both windows
  nnoremap <C-Space> 2<C-w>h:difft<CR>2<C-w>l:difft<CR><C-w>h
endif
