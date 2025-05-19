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
 VERSION 1.0.0 RELEASE
"

readonly C_RESET="\033[0m"
readonly C_ERROR="\033[1;31m"
readonly C_INFO="\033[1;32m"
readonly C_INSTALL="\033[4;34m"
readonly C_WARNING="\033[1;33m"

error() {
  printf "Error: ${1} ${C_ERROR}Not found${C_RESET}\n"
}

info() {
  printf "Done: ${1} ${C_INFO}Found${C_RESET}\n"
}

warning() {
  printf "Warning: ${C_WARNING}${1}${C_RESET}\n"
}

install() {
  printf "Install ${C_INSTALL}${1}${C_RESET}...\n"
}

basic_programs=(tarantool luarocks unzip lua git gcc)
optional_programs=(ldoc luacheck curl openssl)
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

  if [ "$(which -a $programm . 2>/dev/null)" ]; then
    info "${programm} (optional)"
  else
    echo "Warning: ${programm} not found"
  fi
done

#
# Install all rocks
#
echo
install "http"
luarocks install --local --tree=$PWD/.rocks --server=https://rocks.tarantool.org/ http

install "lua-multipart-post"
luarocks install --local --tree=$PWD/.rocks --lua-version 5.1 lua-multipart-post 1.0-0

install "luaosll"
luarocks install --local --tree=$PWD/.rocks --lua-version 5.1 luaossl

while [[ $# -gt 0 ]]; do
  case "$1" in
    -o | --optional)
      install "pimp"
      luarocks install pimp
      shift 1
    ;;
  esac
done
