#!/bin/sh

. src/tasks/install.sh

MUSH_BINARIES="
name=mush,path=target/release/mush
name=legacy,path=target/debug/legacy/legacy.sh
"

exec_install_binaries
