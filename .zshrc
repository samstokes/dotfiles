# sourced for interactive shells, after .zshenv (and .zprofile for login shells)

cdpath=~/projects

# bun completions
[ -s "/Users/sam/.bun/_bun" ] && source "/Users/sam/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
