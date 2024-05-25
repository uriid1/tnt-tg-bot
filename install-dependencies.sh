#!/bin/sh

# Install all rocks
tarantoolctl rocks install --server=https://rocks.tarantool.org/ --local http
tarantoolctl rocks install --server=https://luarocks.org lua-multipart-post 1.0-0

# Optional
tarantoolctl rocks install --server=https://luarocks.org pimp 1.7-0
