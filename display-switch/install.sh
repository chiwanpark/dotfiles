#!/usr/bin/env bash
set -euo pipefail

VERSION=1.4.1
ARCHIVE=display_switch-v${VERSION}-linux-amd64.zip
SHA256=0de34d3e8799188834a9a2758a5c47e99d7ffa6a52961c0c9f10334c54eee5a7
URL=https://github.com/haimgel/display-switch/releases/download/${VERSION}/${ARCHIVE}
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
BIN_DIR=${HOME}/.local/bin
BIN_PATH=${BIN_DIR}/display_switch

if [[ ${EUID} -eq 0 ]]; then
    echo "Run this installer as the desktop user, not root." >&2
    exit 1
fi

if [[ $(uname -s) != Linux || $(uname -m) != x86_64 ]]; then
    echo "display-switch installer supports Linux x86_64 only." >&2
    exit 1
fi

for path in "$HOME/.config/display-switch/display-switch.ini" "$HOME/.config/systemd/user/display-switch.service" "$HOME/.local/bin/lg-input-switch"; do
    if [[ ! -f "$path" ]]; then
        echo "Missing managed file: $path. Run ./install.sh first." >&2
        exit 1
    fi
done
for command in curl install sha256sum sudo udevadm unzip; do
    if ! command -v "$command" >/dev/null; then
        echo "Required command not found: $command" >&2
        exit 1
    fi
done

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

curl --fail --location --proto '=https' --tlsv1.2 --output "$tmpdir/$ARCHIVE" "$URL"
printf '%s  %s\n' "$SHA256" "$tmpdir/$ARCHIVE" | sha256sum --check --status
unzip -q "$tmpdir/$ARCHIVE" -d "$tmpdir"
mkdir -p "$BIN_DIR"
install -m 0755 "$tmpdir/display_switch" "$BIN_PATH"

sudo groupadd --force i2c
sudo install -o root -g root -m 0644 "$SCRIPT_DIR/10-local_i2c_group.rules" /etc/udev/rules.d/10-local_i2c_group.rules
sudo usermod -aG i2c "$USER"
sudo udevadm control --reload-rules
sudo udevadm trigger --subsystem-match=i2c-dev

systemctl --user daemon-reload
systemctl --user enable --now display-switch.service

echo "Installed display_switch ${VERSION} to ${BIN_PATH}."
echo "Log out and back in before relying on i2c group membership."
