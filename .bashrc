# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

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

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
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
    if hash rbenv 2>/dev/null; then
      RBENV_PROMPT='\[\033[01;36m\]$(rbenv version-name)\[\033[00m\]:'
    fi
    GIT_PS1_SHOWDIRTYSTATE=true
    PROMPT_COMMAND='PS1="\033]0;\u@\h: \w\007$([[ $? == 0 ]] && echo -e "\[\033[01;32m\]✓\[\033[00m\]" || echo -e "\[\033[01;31m\]✗\[\033[00m\]") '"$RBENV_PROMPT"'${debian_chroot:+($debian_chroot)}\[\033[01;34m\]\w\[\033[00m\]:\[\033[01;31m\]$(__git_ps1 "%s")\[\033[00m\]\n\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ "'
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

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable color support of ls
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

export SVNROOT=svn+ssh://jabberwock.vm.bytemark.co.uk/home/sam/svn/sam

hash gvim 2>/dev/null && EDITOR="gvim -f" || EDITOR=vim
export EDITOR

# custom build of vim
[[ -d "$HOME/opt/vim" ]] && export PATH="$HOME/opt/vim/bin":"$PATH"

# Add git-bits to PATH
[[ -d "$HOME/projects/git-bits" ]] && export PATH="$HOME/projects/git-bits/bin":"$PATH"

# Add custom Python libs
[[ -d "$HOME/lib/python" ]] && export PYTHONPATH="$HOME/lib/python":"$PYTHONPATH"

[ -d $HOME/.rvm ] && export PATH="$HOME/.rvm/bin":$PATH # Add RVM to PATH for scripting

# Heroku Toolbelt
[ -d /usr/local/heroku ] && export PATH=/usr/local/heroku:$PATH

# Newer ant than LNKD-apache-ant
export ANT_HOME="$HOME/opt/apache-ant"
[ -d "$ANT_HOME" ] && export PATH="$ANT_HOME/bin:$PATH"

# Android Developer Tools
export ANDROID_HOME="$HOME/opt/adt/sdk"
[ -d "$ANDROID_HOME" ] && export PATH="$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH"

# Node
[ -d $HOME/opt/node/bin ] && export "PATH=$HOME/opt/node/bin:$PATH"

true # ensure we exit nicely
