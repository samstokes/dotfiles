#!/usr/bin/env bash

for i in gvim gview; do
  alias $i="$i -p"
  alias "${i}x"="$i -p -geom 9999x9999"
done

alias less="less -i"

alias gh="x git help"

alias gst="git status"
alias gci="git commit"
alias gco="git checkout"
alias gbr="git branch"
alias gad="git add"
alias gap="x git add -p"
alias gdf="git diff"

alias gciav="git commit -av"
alias gcim="git commit -m"

for i in grep fgrep egrep; do
  alias $i="$i --color=auto"
done
