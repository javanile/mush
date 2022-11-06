#!/usr/bin/env bash
## 
set -e
source src/boot/debug_2022.sh
source target/debug/legacy/getoptions.sh
source src/commands/build_debug.sh
source src/commands/legacy_fetch.sh
source src/main.sh
main $@
