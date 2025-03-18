export LANG=ja_JP.UTF-8
export PS1="\u@\h:\w\$ "
alias e='codium'
alias rm='rm -rf'
alias python='python3'
alias py='python3'
alias venv='source .venv/bin/activate'
alias piup='pip3 install --upgrade pip'
alias env='py -m venv .venv'
alias pip='pip3'
alias pi='pip3 install'
alias rc='source ~/.bashrc'
alias bi='brew install'
alias nn='nvim ~/.config/nvim/init.lua'
alias bpl='v ~/.bash_profile'
alias bpl='source ~/.bash_profile'
alias brc='v ~/.bashrc'
alias mdr='mkdir -p'
alias chd='chmod 777'
alias v='nvim'
alias gc='git clone'
alias gs='git status'
alias ga='git add'
alias gcm='git commit -m'
alias sv='pbpaste >> ~/memo.txt'
alias sai='sudo apt update && sudo apt install -y'


export PATH=$PATH:/Users/remember/.local/bin
export PATH="/opt/homebrew/opt/openssl@3.0/bin:$PATH"

[ -f "/Users/remember/.ghcup/env" ] && . "/Users/remember/.ghcup/env" 


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
