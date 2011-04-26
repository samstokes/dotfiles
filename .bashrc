# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
# RVM doesn't like this...
# [ -z "$PS1" ] && return

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
    PROMPT_COMMAND='PS1="\033]0;\u@\h: \w\007$([[ $? == 0 ]] && echo -e "\[\033[01;32m\]✓\[\033[00m\]" || echo -e "\[\033[01;31m\]✗\[\033[00m\]") ${debian_chroot:+($debian_chroot)}\[\033[01;36m\]$(~/.rvm/bin/rvm-prompt)\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]:\[\033[01;31m\]$(__git_ps1 "%s")\[\033[00m\]\n\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ "'
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
export EDITOR="gvim -f"

# Add git-bits to PATH
[[ -d "$HOME/projects/git-bits" ]] && export PATH="$HOME/projects/git-bits/bin":"$PATH"

# Add custom Python libs
[[ -d "$HOME/lib/python" ]] && export PYTHONPATH="$HOME/lib/python":"$PYTHONPATH"

# Add cabal binaries to PATH
export PATH=/home/sam/.cabal/bin:"$PATH"

# Add custom ghc version and Haskell Platform to PATH
export PATH=/home/sam/packages/ghc/bin:/home/sam/packages/haskell-platform/bin:"$PATH"

# Ibus for input methods
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

# for AWS EC2 API tools
export EC2_HOME=$HOME/packages/ec2-api-tools
export JAVA_HOME=/usr/lib/jvm/java-6-openjdk/jre
export PATH="$EC2_HOME"/bin:"$PATH"

# for AWS Elastic Load Balancer tools
export AWS_ELB_HOME=$HOME/packages/ElasticLoadBalancing
export PATH="$AWS_ELB_HOME"/bin:"$PATH"

# tarsnap
export PATH="$HOME/packages/tarsnap-1.0/bin":"$PATH"
export MANPATH="$HOME/packages/tarsnap-1.0/share/man":"$MANPATH"

# RVM - Ruby Version Manager
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
