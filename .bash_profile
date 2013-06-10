# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$HOME/bin:$PATH

if [ -x /usr/bin/keychain ] ; then
	MYNAME=`/usr/bin/whoami`
	if [ -f ~/.ssh/${MYNAME}_at_linkedin.com_dsa_key ] ; then
	      /usr/bin/keychain ~/.ssh/${MYNAME}_at_linkedin.com_dsa_key ~/.ssh/id_rsa
      	      . ~/.keychain/`hostname`-sh
	fi
fi

export NETREPO=svn+ssh://svn.corp.linkedin.com/netrepo/network
export LIREPO=svn+ssh://svn.corp.linkedin.com/lirepo
export VENREPO=svn+ssh://svn.corp.linkedin.com/vendor

export JAVA_HOME=/export/apps/jdk/JDK-1_6_0_27
export JDK_HOME=/export/apps/jdk/JDK-1_6_0_27
export NLS_LANG=American_America.UTF8

export M2_HOME=/local/maven
export M2=$M2_HOME/bin

export PATH=$PATH:$JAVA_HOME/bin:/usr/local/bin:/usr/local/mysql/bin:/usr/local/linkedin/bin

export GHC_HOME=/home/sstokes/opt/ghc
export HASKELL_PLATFORM_HOME=/home/sstokes/opt/haskell-platform
export PATH=$HOME/.cabal/bin:$GHC_HOME/bin:$HASKELL_PLATFORM_HOME/bin:$PATH

GIT_HOME="$HOME"/opt/git
if [ -d "$GIT_HOME" ]; then
  export GIT_HOME
  export PATH="$GIT_HOME/bin:$PATH"
  export MANPATH="$GIT_HOME/share/man:$MANPATH"
fi

[ -d /opt/vagrant ] && export PATH=/opt/vagrant/bin:$PATH

if [ -d "$HOME/.rvm" ]; then
  [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
elif [ -d "$HOME/.rbenv" ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi
