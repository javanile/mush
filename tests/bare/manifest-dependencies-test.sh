#!/usr/bin/env bash
set -e

## Build Mush
echo "====[ Build: mush ]======================================================="
cp target/release/mush target/release/mush.test.sh
bash target/release/mush.test.sh build --release

cd tests/fixtures/manifest-dependencies

MUSH="bash ../../../target/release/mush"

assert_dep_installed() {
  test -f lib/name_convention
}

clean() {
  rm -fr lib target
  cp /dev/stdin Manifest.toml <<'BASE'
[package]
name = "manifest_dependencies"
version = "0.1.0"
edition = "2022"
description = "Fixture for testing all dependency declaration syntaxes."
BASE
}

## ── Syntax 1: path ───────────────────────────────────────────────────────────
echo "====[ Test: path syntax ]================================================="
clean
cat >> Manifest.toml <<'TOML'

[dev-dependencies]
name_convention = "path ../../../packages/name_convention"
TOML
$MUSH fetch
assert_dep_installed

## ── Syntax 2: mush explicit branch ──────────────────────────────────────────
echo "====[ Test: mush explicit branch syntax ]================================="
clean
cat >> Manifest.toml <<'TOML'

[dev-dependencies]
name_convention = "mush name_convention develop"
TOML
$MUSH fetch
assert_dep_installed

## ── Syntax 3: @branch shorthand ─────────────────────────────────────────────
echo "====[ Test: @branch shorthand syntax ]====================================="
clean
cat >> Manifest.toml <<'TOML'

[dev-dependencies]
name_convention = "@develop"
TOML
$MUSH fetch
assert_dep_installed

## ── Syntax 4: wildcard (latest) ─────────────────────────────────────────────
echo "====[ Test: wildcard syntax ]============================================="
clean
cat >> Manifest.toml <<'TOML'

[dev-dependencies]
name_convention = "*"
TOML
$MUSH fetch
assert_dep_installed

echo "====[ OK ]================================================================"
