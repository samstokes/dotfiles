# sourced first, for all zsh invocations

export PATH=/Users/sam/bin:"$PATH"

. "$HOME/.local/bin/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

. "$HOME/.cargo/env"
