#!/usr/bin/env bash

set -e
source "$(dirname "$0")/_conf.sh"

curl -v -k -X POST -H "Content-Type: application/json" -H "Cache-Control: no-cache"  -d '{
  "update_id":10000,
  "inline_query":{
    "id": 134567890097,
    "from":{
       "last_name":"Test Lastname",
       "type": "private",
       "id":1111111,
       "first_name":"Test Firstname",
       "username":"Testusername"
    },
    "query": "inline query",
    "offset": ""
  }
}' "${WEBHOOK_URL}"
