# Local alias
# alias seeks='~/bin/seeks'

# export XDG_CONFIG_HOME="$HOME/.config"
# export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Maven
export M3_HOME="/usr/local/Cellar/maven/3.9.8"
export M3="$M3_HOME/bin"
export PATH=$M3:$PATH

# Oracle environment variables
export http_proxy=http://www-proxy.us.oracle.com:80
export https_proxy=http://www-proxy.us.oracle.com:80
export no_proxy='localhost,127.0.0.1,.oracle.com,.oraclecorp.com,.grungy.us,.oraclecloud.com,oracle.zoom.us'

# Oneview
alias quickbuild='mvn clean install -DskipTests=true -Dfindbugs.skip=false -Dpmd.skip=false -Dmaven.javadoc.skip=true -Dcheckstyle.skip=false'
alias fastbuild='mvn clean install -DskipTests=true -Dfindbugs.skip=true -Dpmd.skip=true -Dmaven.javadoc.skip=true -Dcheckstyle.skip=true'

export ORACLE_HOME="/opt/oracle/instantclient_23_3"
export NLS_LANG=AMERICAN_AMERICA.UTF8

export LD_LIBRARY_PATH=$ORACLE_HOME
export DYLD_LIBRARY_PATH=$ORACLE_HOME

export PATH=$PATH:$ORACLE_HOME:"$HOME/Documents/dbaas/local/tools/shepherd-cli"

# OLLAMA in VPN
# export OLLAMA_HOST=127.0.0.1
# export no_proxy=localhost,127.0.0.1,.us.oracle.com,.oraclecorp.com

# Java
# export JAVA_HOME="$(jenv prefix)"
# export JAVA_HOME="$HOME/.jenv/versions/17"
export JAVA_HOME=$(/usr/libexec/java_home -v 17)

# seeks
alias seeks="$HOME/Documents/dbaas/local/seeks/venv/bin/seeks"

# Set CDPATH to include commonly accessed directories
export CDPATH=".:~:$HOME/Documents/dbaas/repositories"
. "$HOME/.cargo/env"


# Adding OCI curl for Terminal
export TENANCY_OCID="ocid1.tenancy.region1..aaaaaaaa6gqokctiy6pncv6jooomauqibkkhduaohvikdrwi6ze2n5o5v3kq"
export USER_OCID=""
export USER_FINGERPRINT="cf:0c:be:d0:70:49:60:15:c5:87:b5:b2:53:49:3a:e5"
export USER_PRIVATEKEY_PATH="/Users/lumedina/.oci/sessions/region1.ssh/oci_api_key.pem"
 
alias oci-curl='~/oci-curl/oci-curl.sh $1 $2 $3 $4'

# VS Code 
alias v="open $1 -a \"Visual Studio Code\""

# SCM 
alias scm-ssh-add='SSH_AUTH_SOCK=~/.ssh/scm-agent.sock ssh-add'
