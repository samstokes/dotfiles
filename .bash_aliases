#!/usr/bin/env bash

for i in gvim gview; do
  alias $i="$i -p"
done

alias less="less -i"

alias gh="x git help"

alias gst="git status"
alias gci="git commit"
alias gco="git checkout"
alias gbr="git branch"
alias gad="git add"
alias gdf="git diff"

alias gciav="git commit -av"
alias gcim="git commit -m"

for i in grep fgrep egrep; do
  alias $i="$i --color=auto"
done
