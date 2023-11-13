#!/usr/bin/env bash

source src/console.sh
source src/tasks/build_releasesh

build_file=$(mktemp /tmp/build_file_XXXXXX)

build_releaseparse "src/main.sh" "${build_file}"
