#!/usr/bin/env bash

source src/api/embed.sh

embed_file module_name ./tests/fixtures/module.sh > ./tests/temp/embed_file.sh

source ./tests/temp/embed_file.sh

module_name