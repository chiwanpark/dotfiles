#!/usr/bin/env bash
set -euo pipefail

TREE_SITTER_MIN_VERSION=0.26.1
BIN_DIR=$HOME/.local/bin
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

current=$(tree-sitter --version 2>/dev/null | awk '{print $2}' || true)
if [[ -z "$current" ]] || ! version_ge "$current" "$TREE_SITTER_MIN_VERSION"; then
  install_tree_sitter
fi

nvim --headless -c 'q'
