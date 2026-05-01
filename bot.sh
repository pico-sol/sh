#!/bin/bash
set -euo pipefail

cd ~/salsa/bot

suffix="${1:-}"                 # 例: 3
out="libbot${suffix}.so"        # 引数なしなら libbot.so
release_dir="/home/solv/salsa/target/release"
config="/home/solv/salsa/bot/config.json"

rm -f "${release_dir}"/libbot*.so
cargo build --release
# mv で原子的に差し替え（cp で既存ファイルを上書きすると mmap 中の場合 SIGBUS になる）
mv "${release_dir}/libbot.so" "${release_dir}/${out}"

# config.json の libpath を更新
# 例: .../libbot3.so or .../libbot.so
jq --arg p "${release_dir}/${out}" '.libpath = $p' "$config" > "${config}.tmp" \
  && mv "${config}.tmp" "$config"

echo "Updated libpath -> $(jq -r .libpath "$config")"

agave-validator --ledger /mnt/ledger plugin reload bot-plugin  "$config"