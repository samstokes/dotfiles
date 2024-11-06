# unbreak psql for CRDB (and others?) - https://github.com/cockroachdb/cockroach/issues/37129#issuecomment-600115995
export PGCLIENTENCODING=utf-8

export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

eval "$(/opt/homebrew/bin/brew shellenv)"
