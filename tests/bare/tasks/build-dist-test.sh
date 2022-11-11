#!/usr/bin/env bash

source src/console.sh
source src/tasks/build_dist.sh

build_file=$(mktemp /tmp/build_file_XXXXXX)

build_dist_parse "src/main.sh" "${build_file}"
