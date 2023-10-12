#!/usr/bin/env bash
set -e

compliance_top_score=1

mkdir -p tests/tmp
find docs -name '*.md' > tests/tmp/docs-compliance.txt

while read -r -u3 file; do
  compliance_score=$(sed -n 's/^compliance: \([0-9]*\)$/\1/p' "$file")
  [ -z "$compliance_score" ] && compliance_score=0

  #echo "- $file ($compliance_score)"
  if [ "$compliance_score" -lt "$compliance_top_score" ]; then
    echo "Error: The file '$file' has a compliance score of '$compliance_score', but the top score is '$compliance_top_score'."

    permalink=$(sed -n 's/^permalink: \(.*\)$/\1/p' "$file")
    [ -z "$permalink" ] && echo "Error: Permalink not found in '$file'" && exit 1

    echo
    echo "Open that page <http://localhost:4000$permalink>. Then, perform the following actions:"

    echo
    echo -n "  1. Seems page good?" && read -r -p " [Y/n] " yes
    echo -n "  1. Are there Rust or Cargo reference on page? (Use [Ctrl+F] to search on page)" && read -r -p " [Y/n] " yes

    echo
  fi
done 3< tests/tmp/docs-compliance.txt
