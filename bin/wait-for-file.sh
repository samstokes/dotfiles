#!/bin/bash
# waits for a file to be created, then waits for whatever created it to
# finish writing it, then returns.
# N.B. there's a race condition between the file being closed and us setting
# up the watch for close_write - so if the file is closed soon after being
# created this may never terminate.  Works better for large files.

. "$HOME"/lib/ss496-shutil/util.bash

towatch="${1:?filename as only argument}"
[[ $# -eq 1 ]] || ss496_die "Sorry, can't watch for more than one file"

created=""
while [[ "$created" != "`basename $towatch`" ]]
do
  created="$(inotifywait -q -e create --format %f "`dirname $towatch`" || ss496_die "waiting for '$towatch' failed, sorry")"
done

echo "'$towatch' created, now waiting for writing to finish..." >2

inotifywait -q -e close_write "$towatch"
