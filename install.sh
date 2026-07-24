#!/usr/bin/env bash
# Bootstraps atf if missing, links this repo's dotfiles into $HOME, then
# runs `atf terraform`.

set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! which atf >/dev/null 2>&1; then
  echo "atf not found, installing..."
  git clone https://github.com/Vinicamilotti/atf "$HOME/atf"
  (cd "$HOME/atf" && sudo make install)
else
  echo "ok: atf already installed"
fi

"$SRC_DIR/set-links.sh"

atf terraform
