config_fzf_Linux() {
  source /usr/share/fzf/completion.zsh
  source /usr/share/fzf/key-bindings.zsh
}

config_fzf_macOS() {
  if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
    export PATH="$PATH:/usr/local/opt/fzf/bin"
  fi
  [[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null
  source "/usr/local/opt/fzf/shell/key-bindings.zsh"
}

case $( uname -s ) in
  Linux) config_fzf_linux;;
  Darwin) config_fzf_macOS;;
esac
