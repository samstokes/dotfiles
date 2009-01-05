#!/usr/bin/env bash
for i in `cd app; find * -type f`; do test -f spec/${i%.rb}_spec.rb || echo $i; done
