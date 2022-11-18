#!/usr/bin/env bash
## 
set -e
source src/boot/debug_2022.sh
source target/debug/legacy/getoptions.sh
source src/commands/build.sh
source src/commands/legacy.sh
source src/main.sh
main $@
