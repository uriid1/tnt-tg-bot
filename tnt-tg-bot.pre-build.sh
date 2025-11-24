#!/usr/bin/env bash
set -euo pipefail

echo "
 _________ _       _________  _________ _______    ______   _______ _________
 \__   __/( (    /|\__   __/  \__   __/(  ____ \  (  ___ \ (  ___  )\__   __/
    ) (   |  \  ( |   ) (        ) (   | (    \/  | (   ) )| (   ) |   ) (
    | |   |   \ | |   | |        | |   | |        | (__/ / | |   | |   | |
    | |   | (\ \) |   | |        | |   | | ____   |  __ (  | |   | |   | |
    | |   | | \   |   | |        | |   | | \_  )  | (  \ \ | |   | |   | |
    | |   | )  \  |   | |        | |   | (___) |  | )___) )| (___) |   | |
    )_(   |/    )_)   )_(        )_(   (_______)  |/ \___/ (_______)   )_(

 By uriid1
 GitHub github.com/uriid1/tnt-tg-bot
"

__LUA_VERSION=$(lua -v 2>&1 | awk '{print $2}' | cut -d. -f1-2)

# Install all rocks
echo "Install: lua-multipart-post"
luarocks install --local --tree=$PWD/.rocks --lua-version ${__LUA_VERSION} lua-multipart-post 1.0-0

echo "Install: luasec"
luarocks install --local --tree=$PWD/.rocks --lua-version ${__LUA_VERSION} luasec
