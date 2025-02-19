#!/bin/bash
set -e

# .configファイルの読み込み
source /home/solv/sh/.config

# -----------------------------
# メインノード：inactiveへの切替
# -----------------------------
echo "メインノードをinactiveモードに切替中…"
agave-validator -l /mnt/ledger wait-for-restart-window --min-idle-time 2 --skip-new-snapshot-check
agave-validator -l /mnt/ledger set-identity /home/solv/unstaked-identity.json
ln -sf /home/solv/unstaked-identity.json /home/solv/identity.json

# -----------------------------
# towerファイルの転送
# -----------------------------
echo "towerファイルをサブノードへ転送中…"
TOWER_FILE="/mnt/ledger/tower-1_9-$(solana-keygen pubkey /home/solv/mainnet-validator-keypair.json).bin"
scp "$TOWER_FILE" solv@"$REMOTE_IP":/mnt/ledger
echo "towerファイルの転送が完了しました。"

# -----------------------------
# サブノード：activeへの切替（SSHでリモート実行）
# -----------------------------
echo "サブノードをactiveモードに切替中…"
ssh solv@"$REMOTE_IP" << 'EOF'
  set -e
  agave-validator -l /mnt/ledger set-identity --require-tower /home/solv/mainnet-validator-keypair.json
  ln -sf /home/solv/mainnet-validator-keypair.json /home/solv/identity.json
EOF

echo "バリデータのスイッチが完了しました。"