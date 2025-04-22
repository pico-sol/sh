#!/bin/bash
set -e

# .configファイルの読み込み
source /home/solv/sh/.config

# CLIENTの値が正しくない場合はエラー終了
if [[ "$CLIENT" != "firedancer" && "$CLIENT" != "agave" && "$CLIENT" != "jito" && "$CLIENT" != "paladin" ]]; then
  echo "Error: Unknown CLIENT value: $CLIENT"
  exit 1
fi

# -----------------------------
# メインノード：inactiveへの切替
# -----------------------------
echo "メインノードをinactiveモードに切替中…"
case "$CLIENT" in
  "firedancer")
    fdctl set-identity --config /home/solv/firedancer/config.toml /home/solv/unstaked-identity.json
    ln -sf /home/solv/unstaked-identity.json /home/solv/identity.json
    ;;
  "agave"|"jito"|"paladin")
    agave-validator -l /mnt/ledger wait-for-restart-window --min-idle-time 2 --skip-new-snapshot-check
    agave-validator -l /mnt/ledger set-identity /home/solv/unstaked-identity.json
    ln -sf /home/solv/unstaked-identity.json /home/solv/identity.json
    ;;
esac

# -----------------------------
# towerファイルの転送
# -----------------------------
echo "towerファイルをサブノードへ転送中…"
TOWER_FILE="/mnt/ledger/tower-1_9-$(solana-keygen pubkey /home/solv/$CLUSTER-validator-keypair.json).bin"
scp "$TOWER_FILE" solv@"$REMOTE_IP":/mnt/ledger
echo "towerファイルの転送が完了しました。"

# -----------------------------
# サブノード：activeへの切替（SSHでリモート実行）
# -----------------------------
echo "サブノードをactiveモードに切替中…"
case "$REMOTE_CLIENT" in
  "firedancer")
    ssh solv@"$REMOTE_IP" << EOF
      fdctl set-identity --config /home/solv/firedancer/config.toml /home/solv/${CLUSTER}-validator-keypair.json
      ln -sf /home/solv/${CLUSTER}-validator-keypair.json /home/solv/identity.json
    EOF
    ;;
  "agave"|"jito"|"paladin")
    ssh solv@"$REMOTE_IP" << EOF
      set -e
      agave-validator -l /mnt/ledger set-identity --require-tower /home/solv/${CLUSTER}-validator-keypair.json
      ln -sf /home/solv/${CLUSTER}-validator-keypair.json /home/solv/identity.json
    EOF
    ;;
esac

echo "バリデータのスイッチが完了しました。"