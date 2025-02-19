# .configファイルの読み込み
source /home/solv/sh/.config

sudo docker pull c29r3/solana-snapshot-finder:latest; \
sudo docker run -it --rm \
-v $SNAPSHOT_PATH:/solana/snapshot \
--user $(id -u):$(id -g) \
c29r3/solana-snapshot-finder:latest \
--snapshot_path /solana/snapshot