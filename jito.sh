#!/bin/bash
set -euo pipefail

source /home/solv/sh/.config

rel="${1:-}"
if [[ -z "$rel" ]]; then
  echo "Usage: $0 <release-name>"
  echo "Example: $0 3.1.8-jito-pico"
  exit 1
fi

cd ~/jito-solana

CI_COMMIT="$(git rev-parse HEAD)" \
  scripts/cargo-install-all.sh --validator-only \
  "$HOME/.local/share/solana/install/releases/${rel}/solana-release"

cd ~/
