#!/usr/bin/env bash
set -e

echo "==> Build Mush"
cp target/dist/mush target/dist/mush.sh
bash target/dist/mush.sh build --target dist

echo "==> Commit Changes"
git add .
git commit -am "Minor changes"
git push

echo "==> Publish Mush"
bash target/dist/mush publish --allow-dirty
