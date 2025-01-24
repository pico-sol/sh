sudo docker pull c29r3/solana-snapshot-finder:latest; \
sudo docker run -it --rm \
-v /mnt/ledger:/solana/snapshot \
--user $(id -u):$(id -g) \
c29r3/solana-snapshot-finder:latest \
--snapshot_path /solana/snapshot