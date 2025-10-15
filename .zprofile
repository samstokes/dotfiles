# sourced for login shells, after .zshenv

[ -s ~/.github_token_env ] && source ~/.github_token_env

[ -s ~/.launchdarklyrc ] && source ~/.launchdarklyrc

export EDITOR=nvim

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# added by Snowflake SnowSQL installer v1.2
export PATH=/Users/sstokes/Applications/SnowSQL.app/Contents/MacOS:$PATH
