#!/usr/bin/env bash
set -e

curl -s https://get.javanile.org/mush | sh

export PATH="${HOME}/.mush/bin:${PATH}"

mush --help

mush install mush-demo || true

echo "------------------------------------------------------------"
tree -a "${HOME}"
