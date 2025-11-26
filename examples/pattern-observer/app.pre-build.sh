#!/usr/bin/env bash
set -euo pipefail

## ----------------- ##
# Install all rocks
## ----------------- ##
echo "
 By uriid1
 GitHub github.com/uriid1
"
echo "argp"
luarocks install --local --tree=$PWD/.rocks --lua-version 5.1 argp

echo "minilog"
luarocks install --local --tree=$PWD/.rocks --lua-version 5.1 minilog
