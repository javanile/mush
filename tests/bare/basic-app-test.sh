#!/usr/bin/env bash
set -e

echo "Prepare system for testing..."
echo "------------------------------------------------------------------------------"

mush build -v --target releasesudo make install

echo "Start testing basic-app..."
echo "------------------------------------------------------------------------------"

mush build

