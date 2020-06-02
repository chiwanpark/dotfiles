config_fzf_Linux() {
  if [ -d "/usr/share/fzf" ]; then
    FZF_ROOT="/usr/share/fzf"
  elif [ -d "$HOME/.fzf" ]; then
    FZF_ROOT="$HOME/.fzf"
  fi
  
  if [ -d "$FZF_ROOT/shell" ]; then
    FZF_ROOT="$FZF_ROOT/shell"
  fi

  if [ -f "$FZF_ROOT/completion.zsh" ]; then
    source $FZF_ROOT/completion.zsh
  fi
  if [ -f "$FZF_ROOT/key-bindings.zsh" ]; then
    source $FZF_ROOT/key-bindings.zsh
  fi

  # fedora specific script load
  if [ -f "/usr/share/zsh/site-functions/fzf" ]; then
    source /usr/share/zsh/site-functions/fzf
  fi
}

config_fzf_macOS() {
  if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
    export PATH="$PATH:/usr/local/opt/fzf/bin"
  fi
  [[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null
  source "/usr/local/opt/fzf/shell/key-bindings.zsh"
}

case $( uname -s ) in
  Linux) config_fzf_Linux;;
  Darwin) config_fzf_macOS;;
esac
