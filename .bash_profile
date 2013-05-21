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
	      /usr/bin/keychain ~/.ssh/${MYNAME}_at_linkedin.com_dsa_key
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

export PATH=/opt/vagrant/bin:$PATH

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
