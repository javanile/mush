#!/usr/bin/env bash
set -e

## Build Mush
echo "====[ Build: mush ]======================================================="
cp target/release/mush target/release/mush.test.sh
bash target/release/mush.test.sh build --release

cd tests/fixtures/manifest-dependencies

MUSH="bash ../../../target/release/mush"

clean() {
  rm -fr lib target ~/.mush/bin/mush-demo
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
$MUSH build
test -f lib/name_convention

## ── Syntax 2: mush explicit branch ──────────────────────────────────────────
echo "====[ Test: mush explicit branch syntax ]================================="
clean
cat >> Manifest.toml <<'TOML'

[dev-dependencies]
mush-demo = "mush mush-demo main"
TOML
$MUSH build
test -f ~/.mush/bin/mush-demo

## ── Syntax 3: @branch shorthand ─────────────────────────────────────────────
echo "====[ Test: @branch shorthand syntax ]====================================="
clean
cat >> Manifest.toml <<'TOML'

[dev-dependencies]
mush-demo = "@develop"
TOML
$MUSH build
test -f ~/.mush/bin/mush-demo

## ── Syntax 4: wildcard (latest semver) ──────────────────────────────────────
echo "====[ Test: wildcard syntax ]============================================="
clean
cat >> Manifest.toml <<'TOML'

[dev-dependencies]
mush-demo = "*"
TOML
$MUSH build
test -f ~/.mush/bin/mush-demo

echo "====[ OK ]================================================================"
