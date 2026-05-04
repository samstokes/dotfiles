# sourced for interactive shells, after .zshenv (and .zprofile for login shells)

cdpath=~/projects

# bun completions
[ -s "/Users/sam/.bun/_bun" ] && source "/Users/sam/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

. "$HOME/.zsh_aliases"

# restore emacs-mode bindings lost in vi mode
bindkey -M viins '\e.' insert-last-word
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '\e[H' beginning-of-line
bindkey -M viins '\e[F' end-of-line

eval "$(starship init zsh)"
