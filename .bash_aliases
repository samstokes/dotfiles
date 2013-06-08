#!/usr/bin/env bash

# vim

for i in gvim gview gvimdiff; do
  alias $i="$i -O"
  alias "${i}x"="$i -O -geom 9999x9999"
done


# less

alias less="less -i"
alias lessf="less -i +F"


# git

alias gh="x git help"

alias gst="git status"
alias gci="git commit"
alias gco="git checkout"
alias gbr="git branch"
alias gad="git add"
alias gap="x git add -p"
alias gdf="git diff"
alias gpk="git cherry-pick"
alias grs="git russet"
alias grsh="git russet --hard"
alias gwbr="git wbr"
alias grup="git rup"
alias glogg="git logg"
alias glogga="git logg --all"

# I keep mistyping this, and I never actually want to run 'gs' (== GhostScript)
alias gs="git status"

alias gspop="git stash apply && git stash clear"

for i in v av m am; do
  alias gci$i="git commit -$i"
done

for i in b p; do
  alias gco$i="git checkout -$i"
done

alias gdfc="git diff --cached"


# grep

for i in grep fgrep egrep; do
  alias $i="$i --color=auto"
done


# install software easierly

alias mgi="monitor gem install"
alias msgi="monitor sudo gem install"
alias msai="monitor sudo apt-get install"


# "bundle exec" is long
alias mbi="monitor bundle install"
alias bun="bundle exec"
alias bake="bundle exec rake"
