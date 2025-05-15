
###############################
# EXPORT ENVIRONMENT VARIABLE #
###############################

# XDG
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$XDG_CONFIG_HOME/local/share
export XDG_CACHE_HOME=$XDG_CONFIG_HOME/cache

# ZSH
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Man pages
# export MANPAGER='nvim +Man!'

# ─────────────────────────
# WORK CONFIGURATION
# ───────────────────────── 

# Oracle environment variables
export http_proxy=http://www-proxy.us.oracle.com:80
export https_proxy=http://www-proxy.us.oracle.com:80
export no_proxy='localhost,127.0.0.1,.oracle.com,.oraclecorp.com,.grungy.us,.oraclecloud.com,oracle.zoom.us'

# Oneview
alias quickbuild='mvn clean install -DskipTests=true -Dfindbugs.skip=false -Dpmd.skip=false -Dmaven.javadoc.skip=true -Dcheckstyle.skip=false'
alias fastbuild='mvn clean install -DskipTests=true -Dfindbugs.skip=true -Dpmd.skip=true -Dmaven.javadoc.skip=true -Dcheckstyle.skip=true'

# Seeks
# $HOME/Documents/Code/Work/seeks/venv/bin/seeks

# SCM 
alias scm-ssh-add='SSH_AUTH_SOCK=~/.ssh/scm-agent.sock ssh-add'

# Start SCM agent socket if not running
[[ ! -a ~/.ssh/scm-agent.sock ]] && ssh-agent -a ~/.ssh/scm-agent.sock

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/lumedina/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
