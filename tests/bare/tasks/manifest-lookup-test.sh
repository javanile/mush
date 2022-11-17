#!/usr/bin/env bash

source src/console.sh
source src/tasks/manifest_lookup.sh

cd tests/fixtures/complex-app

exec_manifest_lookup

echo "MUSH_PACKAGE_NAME: $MUSH_PACKAGE_NAME"
