#!/bin/bash

# Set up a Rails development environment, with a tabbed terminal and a gvim.

GNOME_TERMINAL_PROFILE=Default

error() { echo "$@" >&2; exit 1; }

parse_args() {
  dirname=${1:-.}     # default to current dir if not specified
  test -d "$dirname" || error "$dirname is not a directory"
  proj=$(basename $(cd "$dirname" && pwd))
}

launch_tabbed_terminal() {
  local opts="--tab-with-profile=$GNOME_TERMINAL_PROFILE --working-directory=$dirname"

  /usr/bin/gnome-terminal \
      $opts \
      $opts -t "$proj - specs" -e /usr/bin/autotest \

}

launch_gvim_browser() {
  { cd "$dirname" && gvim . ; }
}

parse_args "$@" || error "Bad arguments."
echo "Choo choo!  Launching a Rails development environment in $dirname..."
launch_tabbed_terminal || error "Failed to launch tabbed terminal."
launch_gvim_browser || error "Failed to launch gvim."
echo "You're good to go!  Feel free to close this terminal window."
