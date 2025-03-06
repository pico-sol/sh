#!/bin/bash
set -e

# .configファイルの読み込み
source /home/solv/sh/.config

case "$CLIENT" in
  "firedancer")
    sudo systemctl disable solv
    sudo systemctl enable firedancer
    sudo systemctl start firedancer
    ;;
  "agave"|"jito"|"paladin")
    sudo systemctl disable firedancer 2>/dev/null || true
    sudo systemctl enable solv
    sudo systemctl start solv
    ;;
  *)
    echo "Error: Unknown CLIENT value: $CLIENT"
    exit 1
    ;;
esac
