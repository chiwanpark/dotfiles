#!/usr/bin/env bash
set -euo pipefail

PLUGIN_REPO=https://github.com/gambtho/herdr-devcontainer.git
PLUGIN_DIR=$HOME/.local/share/herdr-devcontainer
BUILD_IMAGE=rust:alpine

if [[ -f /.dockerenv || -f /run/.containerenv ]]; then
  echo "Skipping herdr setup inside a container."
  exit 0
fi

if ! command -v herdr >/dev/null; then
  curl -fsSL https://herdr.dev/install.sh | sh
fi
herdr=$(command -v herdr || echo "$HOME/.local/bin/herdr")

if [[ $(uname -s) != Linux ]]; then
  echo "Skipping herdr-devcontainer: it supports Linux only."
  exit 0
fi

docker=$(command -v docker-safe || command -v docker || true)
if [[ -z "$docker" ]]; then
  echo "Skipping herdr-devcontainer: docker is not found."
  exit 0
fi

if [[ -d "$PLUGIN_DIR/.git" ]]; then
  git -C "$PLUGIN_DIR" pull --ff-only --quiet || echo "Failed to update herdr-devcontainer; using the current checkout."
else
  git clone --quiet --branch main "$PLUGIN_REPO" "$PLUGIN_DIR"
fi

head=$(git -C "$PLUGIN_DIR" rev-parse HEAD)
stamp=$PLUGIN_DIR/target/.built-commit
if [[ ! -x "$PLUGIN_DIR/target/release/herdr-devc" || $(cat "$stamp" 2>/dev/null) != "$head" ]]; then
  echo "Building herdr-devcontainer ${head:0:7} with $BUILD_IMAGE..."
  "$docker" run --rm --user "$(id -u):$(id -g)" -e CARGO_HOME=/src/target/.cargo \
    -v "$PLUGIN_DIR":/src -w /src "$BUILD_IMAGE" cargo build --release --locked
  echo "$head" >"$stamp"
fi

info=$("$herdr" plugin list --plugin devcontainer --json 2>/dev/null || true)
if [[ $info != *"\"plugin_root\":\"$PLUGIN_DIR\""* ]]; then
  if [[ $info == *'"kind":"github"'* ]]; then
    "$herdr" plugin uninstall devcontainer
  elif [[ $info == *'"plugin_id":"devcontainer"'* ]]; then
    "$herdr" plugin unlink devcontainer
  fi
  "$herdr" plugin link "$PLUGIN_DIR" >/dev/null
  echo "Linked herdr-devcontainer: $PLUGIN_DIR"
fi
