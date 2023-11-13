#!/usr/bin/env bash

source src/console.sh
source src/tasks/legacy_build.sh
source src/tasks/legacy_fetch.sh
source src/tasks/manifest_lookup.sh

rm -fr target/release
exec_manifest_lookup
exec_legacy_fetch target/releaseexec_legacy_build target/release