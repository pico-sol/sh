#!/bin/bash
set -e
source /home/solv/sh/.config

# CLIENTチェック
if [[ "$CLIENT" != firedancer && "$CLIENT" != agave && "$CLIENT" != jito && "$CLIENT" != paladin ]]; then
  echo "Error: Unknown CLIENT value: $CLIENT"
  exit 1
fi

echo "メインノードをinactiveモードに切替中…"
case "$CLIENT" in
  firedancer)
    fdctl set-identity --config /home/solv/firedancer/config.toml /home/solv/unstaked-identity.json
    ln -sf /home/solv/unstaked-identity.json /home/solv/identity.json
    ;;
  agave|jito|paladin)
    agave-validator -l /mnt/ledger wait-for-restart-window --min-idle-time 2 --skip-new-snapshot-check
    agave-validator -l /mnt/ledger set-identity /home/solv/unstaked-identity.json
    ln -sf /home/solv/unstaked-identity.json /home/solv/identity.json
    ;;
esac

echo "towerファイルをサブノードへ転送中…"
TOWER_FILE="/mnt/ledger/tower-1_9-$(solana-keygen pubkey /home/solv/$CLUSTER-validator-keypair.json).bin"
scp "$TOWER_FILE" solv@"$REMOTE_IP":/mnt/ledger
echo "towerファイルの転送が完了しました。"

echo "サブノードをactiveモードに切替中…"
ssh solv@"$REMOTE_IP" << EOF
  set -e
  agave-validator -l /mnt/ledger set-identity --require-tower /home/solv/${CLUSTER}-validator-keypair.json
  ln -sf /home/solv/${CLUSTER}-validator-keypair.json /home/solv/identity.json
EOF

echo "バリデータのスイッチが完了しました。"
