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
alias gap="git add -p"
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
alias msai="monitor sudo apt install"
alias msau="monitor sudo apt update"
alias mpi="monitor pip install"

alias mmake="monitor make"

# "bundle exec" is long
alias mbi="monitor bundle install"
alias bun="bundle exec"
alias mun="monitor bundle exec"
alias mbun="monitor bundle exec"
alias bake="bundle exec rake"
alias mbake="monitor bundle exec rake"

alias mw="monitor wget"

# "heroku" is hard to type
alias heorku=heroku
alias herpli=heroku
alias h=heroku
alias hl='heroku logs'

# "docker-compose" is hard to type
alias d=docker
alias dl='docker logs'
alias dps='docker ps'
alias dc=docker-compose
alias dcps='docker-compose ps'
alias dcl='docker-compose logs'
