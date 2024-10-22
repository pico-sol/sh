#!/bin/bash
solana-validator -l /mnt/ledger set-identity --require-tower /home/solv/mainnet-validator-keypair.json
ln -sf /home/solv/mainnet-validator-keypair.json /home/solv/identity.json