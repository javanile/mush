#!/usr/bin/env bash

source_name=getoptions
source_url=https://github.com/ko1nksm/getoptions/releases/download/v3.3.0/getoptions

bash target/dist/mush legacy-fetch --name $source_name $source_url
