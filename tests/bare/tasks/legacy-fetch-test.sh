#!/usr/bin/env bash

source src/console.sh
source src/tasks/legacy_fetch.sh
source src/tasks/manifest_lookup.sh

rm -fr target/dist

exec_manifest_lookup
exec_legacy_fetch target/dist
