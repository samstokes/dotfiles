#!/bin/bash

# Set up a Rails development environment, with a tabbed terminal and a gvim.

error() { echo "$@" >&2; exit 1; }

dirname=${1:-.}     # default to current dir if not specified
test -d "$dirname" || error "$dirname is not a directory"
proj=$(basename $(cd "$dirname" && pwd))

gnome_terminal_opts="--tab-with-profile=Default --working-directory=$dirname"

/usr/bin/gnome-terminal \
    $gnome_terminal_opts \
    $gnome_terminal_opts -t "$proj - specs" -e /usr/bin/autotest \

{ cd "$dirname" && gvim . ; }
