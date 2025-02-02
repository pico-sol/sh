#4行目の/mnt/snapshotsは、設定によっては/mnt/ledgerに変える
sudo docker pull c29r3/solana-snapshot-finder:latest; \
sudo docker run -it --rm \
-v /mnt/accounts/snapshots:/solana/snapshot \
--user $(id -u):$(id -g) \
c29r3/solana-snapshot-finder:latest \
--snapshot_path /solana/snapshot