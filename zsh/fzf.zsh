config_fzf_Linux() {
  if [ -d "$HOME/.fzf" ]; then
    source $HOME/.fzf/shell/completion.zsh
    source $HOME/.fzf/shell/key-bindings.zsh
  fi

  if [ -d "/usr/share/fzf" ]; then
    source /usr/share/fzf/completion.zsh
    source /usr/share/fzf/key-bindings.zsh
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
