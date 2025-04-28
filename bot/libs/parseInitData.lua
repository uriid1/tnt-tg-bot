--- https://core.telegram.org/bots/webapps#validating-data-received-via-the-mini-app
-- @module bot.libs.parseInitData
local openssl_hmac = require('openssl.hmac')
local json = require('json')

local function parse_query(query)
  local parsed = {}
  for key, value in query:gmatch("([^&=]+)=([^&]*)") do
    parsed[key] = value
  end

  return parsed
end

local function url_decode(str)
  return (str:gsub("%%([0-9a-fA-F][0-9a-fA-F])", function(hex)
    return string.char(tonumber(hex, 16))
  end))
end

-- Validating data received via the mini app
--- @param init_data (string)
--- @param bot_token (string)
local function parseInitData(init_data, bot_token)
  -- Парсинг исходной строки
  local parsed = parse_query(init_data)
  local received_hash = parsed.hash or ""
  parsed.hash = nil

  -- Если поле user существует, попробуем распарсить JSON
  local userData
  if parsed.user then
    local user = url_decode(parsed.user)
    userData = json.decode(user)
  end

  -- Сортировка ключей
  local keys = {}
  for k in pairs(parsed) do
    table.insert(keys, k)
  end
  table.sort(keys)

  -- Формирование data_check_string: ключ=значение, разделённых \n
  local parts = {}
  for _, key in ipairs(keys) do
    table.insert(parts, key .. "=" .. url_decode(parsed[key]))
  end
  local data_check_string = table.concat(parts, "\n")

  -- Вычисление секретного ключа: HMAC_SHA256(bot_token, "WebAppData")
  local secret_hmac = openssl_hmac.new("WebAppData", "sha256")
  secret_hmac:update(bot_token)
  local secret_key = secret_hmac:final()  -- бинарная строка

  -- Вычисление HMAC от data_check_string с ключом secret_key
  local hmac_obj = openssl_hmac.new(secret_key, "sha256")
  hmac_obj:update(data_check_string)
  local calc_hash_bin = hmac_obj:final()  -- бинарная строка

  -- Преобразование бинарного хэша в шестнадцатеричное представление (нижний регистр)
  local expected_hash = calc_hash_bin:gsub('.', function(c)
    return string.format('%02x', string.byte(c))
  end)

  return {
    valid = (expected_hash == string.lower(received_hash)),
    userData = userData,
  }
end

return parseInitData
