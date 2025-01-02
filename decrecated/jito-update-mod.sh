#!/bin/bash

# 更新前バージョンと更新後バージョンを変数に設定
OLD_VERSION="v1.18.25-jito"
NEW_VERSION="v1.18.26-jito"
MOD="-mod"

# [リポジトリをクローンし、]ディレクトリに移動
# git clone https://github.com/pico-sol/jito-solana.git
cd /home/solv/jito-solana

# upstream リポジトリを追加してフェッチ
git remote add upstream https://github.com/jito-foundation/jito-solana.git
git fetch upstream

# 新しいバージョンにチェックアウト
git checkout $OLD_VERSION

# 古い修正バージョンから差分を取得して適用
git checkout $OLD_VERSION$MOD
git diff $OLD_VERSION > changes.diff
git checkout $NEW_VERSION
git apply changes.diff
rm changes.diff

# 変更をコミットし、新しい修正版のタグを作成してプッシュ
git add .
git commit -m "Apply modifications from $OLD_VERSION$MOD to $NEW_VERSION"
git tag $NEW_VERSION$MOD
git push origin $NEW_VERSION$MOD
