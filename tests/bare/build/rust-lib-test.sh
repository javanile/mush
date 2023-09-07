#!/usr/bin/env bash
set -e

cd tests/fixtures/rust-lib

cargo build --release --lib
