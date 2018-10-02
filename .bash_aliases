alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Useful aliases
alias bxlogin='bx login --apikey "$BLUEMIX_API_KEY" -o "$BLUEMIX_ORG" -s "$BLUEMIX_SPACE"'
alias kubeconsole='echo "Open your browser at http://$(docker port $CONTAINER_NAME 8001)/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/deployment?namespace=default" && kubectl proxy --accept-hosts='.*' --address='0.0.0.0''
alias freeconsole='echo Only do this on environment you trust && kubectl create -f /opt/support/kubernetes-dashboard-unlock.yaml'
alias showports="docker port $CONTAINER_NAME"
alias cf='bx cf'
alias wsk='bx wsk'
# split window with activation poll on top
alias tmuxwsk="tmux new-session \; send-keys 'wsk activation poll' C-m \; split-window -v \;"
