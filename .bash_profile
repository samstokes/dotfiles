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
export ORACLE_HOME=/local/instantclient_10_2
export TNS_ADMIN=/local/instantclient_10_2
export NLS_LANG=American_America.UTF8

export LD_LIBRARY_PATH=/local/instantclient_10_2

export ORACLE_SID=DB
export PATH=$JAVA_HOME/bin:/usr/local/bin:$PATH:/usr/local/mysql/bin:$ORACLE_HOME/bin

export M2_HOME=/local/maven
export M2=$M2_HOME/bin

export ANT_HOME=/local/apache-ant-1.7.1
export ANT_OPTS="-Xms512m -Xmx2500m -XX:PermSize=256m -XX:MaxPermSize=1024m"

export GRADLE_HOME=/local/gradle-1.0-milestone-3

export PATH=$HOME/opt/hadoop/bin:$PATH

export GHC_HOME=/home/sstokes/opt/ghc
export HASKELL_PLATFORM_HOME=/home/sstokes/opt/haskell-platform
export PATH=$GHC_HOME/bin:$HASKELL_PLATFORM_HOME/bin:$HOME/.cabal/bin:$PATH

export PATH=$ORACLE_HOME:$ANT_HOME/bin:$GRADLE_HOME/bin:/usr/local/linkedin/bin:$PATH

export PATH=/opt/vagrant/bin:$PATH
