#!/bin/bash

# active-to-inactive.sh
# example script of the above steps - change IP obviously
solana-validator -l /mnt/ledger wait-for-restart-window --min-idle-time 2 --skip-new-snapshot-check
solana-validator -l /mnt/ledger set-identity /home/solv/unstaked-identity.json
ln -sf /home/solv/unstaked-identity.json /home/solv/identity.json
scp /mnt/ledger/tower-1_9-$(solana-keygen pubkey /home/solv/mainnet-validator-keypair.json).bin solv@107.155.109.146:/mnt/ledger