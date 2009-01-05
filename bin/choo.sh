#!/bin/bash

# Set up a Rails development environment, with a tabbed terminal and a gvim.

GNOME_TERMINAL_PROFILE=Default
SERVER_PORT=3000

error() { echo "$@" >&2; exit 1; }

parse_args() {
  dirname=${1:-.}     # default to current dir if not specified
  test -d "$dirname" || error "$dirname is not a directory"
  proj=$(basename $(cd "$dirname" && pwd))
}

launch_tabbed_terminal() {
  local opts="--tab-with-profile=$GNOME_TERMINAL_PROFILE --working-directory=$dirname"
  local server_opts="-p $SERVER_PORT --debugger"

  /usr/bin/gnome-terminal \
      $opts \
      $opts -t "$proj - console" -e "/usr/bin/ruby ./script/console" \
      $opts -t "$proj - specs" -e /usr/bin/autotest \
      $opts -t "$proj - server" -e "/usr/bin/ruby ./script/server $server_opts" \

}

launch_gvim_browser() {
  { cd "$dirname" && gvim . ; }
}

launch_web_browser() {
  local sleepytime=5
  echo -n "Waiting $sleepytime seconds for server to start up... "
  sleep $sleepytime
  echo "done."
  /usr/bin/x-www-browser http://localhost:$SERVER_PORT
}

parse_args "$@" || error "Bad arguments."
echo "Choo choo!  Launching a Rails development environment in $dirname..."
launch_tabbed_terminal || error "Failed to launch tabbed terminal."
launch_gvim_browser || error "Failed to launch gvim."
launch_web_browser || error "Failed to launch web browser."
echo "You're good to go!  Feel free to close this terminal window."
