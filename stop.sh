#!/bin/bash

# .configファイルの読み込み
source /home/solv/sh/.config

case "$CLIENT" in
  "firedancer")
    sudo systemctl stop firedancer
    ;;
  "agave"|"jito"|"paladin")
    sudo systemctl stop solv
    ;;
  *)
    echo "Error: Unknown CLIENT value: $CLIENT"
    exit 1
    ;;
esac