# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTFILESIZE=9999  # default 500

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    GIT_PS1_SHOWDIRTYSTATE=true
    PROMPT_COMMAND='cmdstatus=$?; numtodo=$(todo -c | grep -v "^0 TODO"); [[ -n $numtodo ]] && numtodo=":$numtodo" || true; PS1="\033]0;\u@\h: \w\007$([[ $cmdstatus == 0 ]] && echo -e "\[\033[01;32m\]✓\[\033[00m\]" || echo -e "\[\033[01;31m\]✗\[\033[00m\]") ${debian_chroot:+($debian_chroot)}\[\033[01;34m\]\w\[\033[00m\]${numtodo}:\[\033[01;31m\]$(__git_ps1 "%s")\[\033[00m\]\n\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ "'
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w:$(__git_ps1 "%s")\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export SVNROOT=svn+ssh://jabberwock.vm.bytemark.co.uk/home/sam/svn/sam

if hash lvim 2>/dev/null; then
  EDITOR=lvim
elif hash nvim 2>/dev/null; then
  EDITOR=nvim
elif hash gvim 2>/dev/null; then
  EDITOR="gvim -f"
else
   EDITOR=vim
fi
export EDITOR

# Add git-bits to PATH
[[ -d "$HOME/projects/git-bits" ]] && export PATH="$HOME/projects/git-bits/bin":"$PATH"

# Add custom Python libs
[[ -d "$HOME/lib/python" ]] && export PYTHONPATH="$HOME/lib/python":"$PYTHONPATH"

# Haskell
export PATH="~/.cabal/bin:/opt/cabal/1.22/bin:/opt/ghc/7.8.4/bin:$PATH"

# Ruby
export PATH="$HOME/.rbenv/bin:$PATH"
if hash rbenv 2>/dev/null; then
  eval "$(rbenv init -)"
fi

# set up convenient cd
export CDPATH=".:~:$HOME/projects"

# Rust
[[ -d "$HOME"/.cargo/bin ]] && export PATH="$HOME/.cargo/bin:$PATH"

# Coursier, for Scala
export PATH="$PATH:/home/sam/.local/share/coursier/bin"

[[ -f "$HOME/.launchdarklyrc" ]] && source "$HOME/.launchdarklyrc"

[[ -d "$HOME/.tfenv" ]] && export PATH="$HOME/.tfenv/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
