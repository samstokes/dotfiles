# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# Add cabal binaries to PATH
export PATH="$HOME"/.cabal/bin:"$PATH"

# Add custom ghc version and Haskell Platform to PATH
export PATH="$HOME"/opt/ghc-7.0.4/bin:"$HOME"/opt/haskell-platform/bin:"$PATH"

# Java
export JAVA_HOME=/usr/lib/jvm/java-6-openjdk

# Maven
export PATH="$HOME"/opt/maven/bin:"$PATH"

# Hadoop
export PATH="$HOME"/opt/hadoop/bin:"$PATH"

# Vagrant
export PATH=/opt/vagrant/bin:"$PATH"

export LANGUAGE="en_GB:en"
export LC_MESSAGES="en_GB.UTF-8"
export LC_CTYPE="en_GB.UTF-8"
export LC_COLLATE="en_GB.UTF-8"
