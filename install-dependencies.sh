#!/usr/bin/env bash

echo "
 _________ _       _________  _________ _______    ______   _______ _________
 \__   __/( (    /|\__   __/  \__   __/(  ____ \  (  ___ \ (  ___  )\__   __/
    ) (   |  \  ( |   ) (        ) (   | (    \/  | (   ) )| (   ) |   ) (
    | |   |   \ | |   | |        | |   | |        | (__/ / | |   | |   | |
    | |   | (\ \) |   | |        | |   | | ____   |  __ (  | |   | |   | |
    | |   | | \   |   | |        | |   | | \_  )  | (  \ \ | |   | |   | |
    | |   | )  \  |   | |        | |   | (___) |  | )___) )| (___) |   | |
    )_(   |/    )_)   )_(        )_(   (_______)  |/ \___/ (_______)   )_(

 BY URIID1
 GITHUB github.com/uriid1/tnt-tg-bot
"

readonly C_RESET="\033[0m"
readonly C_ERROR="\033[1;31m"
readonly C_INFO="\033[1;32m"
readonly C_INSTALL="\033[4;34m"

error() {
  printf "Error: ${1} ${C_ERROR}Not found${C_RESET}\n"
}

info() {
  printf "Done: ${1} ${C_INFO}Found${C_RESET}\n"
}

install() {
  printf "Install ${C_INSTALL}${1}${C_RESET}...\n"
}

basic_programs=(tarantool unzip lua git gcc)
optional_programs=(ldoc luacheck luarocks)
errs=0

for ((i = 0; i < ${#basic_programs[*]}; ++i)); do
  programm="${basic_programs[$i]}"

  if ! [ "$(which -a $programm . 2>/dev/null)" ]; then
    error "${programm}"
    errs=$((errs+1))
  else
    info "${programm}"
  fi
done

if [ $errs -ge 1 ]; then
  exit 1
fi

for ((i = 0; i < ${#optional_programs[*]}; ++i)); do
  programm="${optional_programs[$i]}"

  if ! [ "$(which -a $programm . 2>/dev/null)" ]; then
    echo "Warning: ${programm} not found"
    errs=$((errs+1))
  else
    info "${programm} (optional)"
  fi
done

# Install all rocks
echo
install "http"
tarantoolctl rocks install --server=https://rocks.tarantool.org/ --local http
install "lua-multipart-post"
tarantoolctl rocks install --server=https://luarocks.org lua-multipart-post 1.0-0

while [[ $# -gt 0 ]]; do
  case "$1" in
    -o | --optional)
      install "pimp"
      tarantoolctl rocks install --server=https://luarocks.org pimp
      shift 1
    ;;

    -hp | --http-patch)
      install "escape"
      tarantoolctl rocks install --only-server=https://rocks.antibot.ru escape
      install "http-patch"
      tarantool scripts/http_patch.lua
      shift 1
    ;;
  esac
done

