#!/bin/sh

git submodule update --init --recursive --remote

tarantoolctl rocks install --server=https://luarocks.org lua-multipart-post 1.0-0
