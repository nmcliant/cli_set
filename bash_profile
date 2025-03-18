if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
case "$(uname)" in
  Darwin)
    # macOSの場合
    if [ -x /opt/homebrew/bin/brew ]; then
      # Apple Siliconの場合
      eval "$(/opt/homebrew/bin/brew shellenv)"
      export PATH="/opt/homebrew/bin:$PATH"
    elif [ -x /usr/local/bin/brew ]; then
      # Intel Macの場合
      eval "$(/usr/local/bin/brew shellenv)"
      export PATH="/usr/local/bin:$PATH"
    fi
    ;;
  Linux)
esac

alias ll='ls -alF'
alias la='ls -A'
alias l="ls -CF"
