#!/bin/bash

# .configファイルの読み込み
source /home/solv/sh/.config

# 最新のイメージを取得
sudo docker pull c29r3/solana-snapshot-finder:latest

# $CLUSTERがtestnetの場合、-rオプションを設定
if [ "$CLUSTER" = "testnet" ]; then
    EXTRA_ARGS="-r https://api.testnet.solana.com"
fi

# dockerコンテナ実行
sudo docker run -it --rm \
  -v "$SNAPSHOT_PATH:/solana/snapshot" \
  --user "$(id -u):$(id -g)" \
  c29r3/solana-snapshot-finder:latest \
  --snapshot_path /solana/snapshot \
  $EXTRA_ARGS
