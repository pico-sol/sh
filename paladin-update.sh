export TAG=2.0.22-paladin
echo "TAG: v$TAG"
TARGET="x86_64-unknown-linux-gnu"

cd /home/solv/paladin-solana
git fetch --tags
git checkout tags/"v$TAG" || { echo "Failed to checkout tag: v$TAG"; exit 1; }

git pull
git checkout tags/"v$TAG" || { echo "Failed to checkout tag: v$TAG"; exit 1; }
git submodule update --init --recursive
CI_COMMIT=$(git rev-parse HEAD)
scripts/cargo-install-all.sh --validator-only ~/.local/share/solana/install/releases/"$TAG"/solana-release
echo "CI_COMMIT: $CI_COMMIT"

cat <<EOL > ~/.local/share/solana/install/releases/"$TAG"/solana-release/version.yml
channel: v$TAG
commit: $CI_COMMIT
target: $TARGET
EOL

cd ~/.local/share/solana/install
# rm active_release
ln -sfn releases/"$TAG"/solana-release active_release
ls -l
