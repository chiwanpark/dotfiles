#!/usr/bin/env bash
set -euo pipefail

TREE_SITTER_MIN_VERSION=0.26.1
BIN_DIR=$HOME/.local/bin
PROVIDER_DIR=${XDG_DATA_HOME:-$HOME/.local/share}/nvim/providers
export PATH="$BIN_DIR:$PATH"

if ! command -v nvim >/dev/null; then
  echo "Skipping Vim setup: nvim is not found."
  exit 0
fi

version_ge() {
  [[ $(printf '%s\n' "$1" "$2" | sort -V | head -n 1) == "$2" ]]
}

install_tree_sitter() {
  local os arch
  case $(uname -s) in
    Linux) os=linux ;;
    Darwin) os=macos ;;
    *) echo "Skipping tree-sitter-cli: unsupported OS $(uname -s)."; return ;;
  esac
  case $(uname -m) in
    x86_64 | amd64) arch=x64 ;;
    aarch64 | arm64) arch=arm64 ;;
    *) echo "Skipping tree-sitter-cli: unsupported architecture $(uname -m)."; return ;;
  esac

  echo "Installing tree-sitter-cli to $BIN_DIR..."
  mkdir -p "$BIN_DIR"
  tmp=$(mktemp "$BIN_DIR/.tree-sitter.XXXXXX")
  trap 'rm -f "$tmp"' EXIT
  curl -fsSL "https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-$os-$arch.gz" | gunzip >"$tmp"
  chmod +x "$tmp"
  mv "$tmp" "$BIN_DIR/tree-sitter"
}

install_python_provider() {
  local venv=$PROVIDER_DIR/python
  echo "Installing Neovim Python provider to $venv..."
  if [[ ! -x "$venv/bin/python" ]]; then
    if command -v uv >/dev/null; then
      uv venv --quiet --python "$(command -v python3)" "$venv" || return
    else
      python3 -m venv "$venv" || return
    fi
  fi
  if [[ -x "$venv/bin/pip" ]]; then
    "$venv/bin/pip" install --quiet --upgrade pynvim
  else
    uv pip install --quiet --python "$venv/bin/python" --upgrade pynvim
  fi
}

install_node_provider() {
  local dir=$PROVIDER_DIR/node
  echo "Installing Neovim Node.js provider to $dir..."
  mkdir -p "$dir" && npm install --silent --no-fund --no-audit --prefix "$dir" neovim@latest
}

install_ruby_provider() {
  local dir=$PROVIDER_DIR/ruby
  echo "Installing Neovim Ruby provider to $dir..."
  GEM_HOME=$dir GEM_PATH=$dir gem install --silent --no-document neovim || return
  printf '#!/bin/sh\nexport GEM_HOME="%s" GEM_PATH="%s"\nexec "%s/bin/neovim-ruby-host" "$@"\n' "$dir" "$dir" "$dir" >"$dir/neovim-ruby-host" &&
    chmod +x "$dir/neovim-ruby-host"
}

current=$(tree-sitter --version 2>/dev/null | awk '{print $2}' || true)
if [[ -z "$current" ]] || ! version_ge "$current" "$TREE_SITTER_MIN_VERSION"; then
  install_tree_sitter
fi

if command -v python3 >/dev/null; then
  install_python_provider || echo "Failed to install Neovim Python provider."
fi
if command -v node >/dev/null && command -v npm >/dev/null; then
  install_node_provider || echo "Failed to install Neovim Node.js provider."
fi
if command -v ruby >/dev/null && command -v gem >/dev/null; then
  install_ruby_provider || echo "Failed to install Neovim Ruby provider."
fi

nvim --headless -c 'q'
