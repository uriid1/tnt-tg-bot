--- Default tnt bot logger
--
local json = require('bot.libs.json')
local colors = require('bot.ext.colors')

local function colorize(color, text)
  if colors.xterm256color == false then
    return text
  end
  return color .. text .. colors.reset
end

local logger = {}

-- luacheck: ignore unpack
-- luacheck: ignore table
local unpack = table.unpack or unpack
local function wrapArgs(...)
  local t = {}
  for _,value in ipairs({...}) do
    table.insert(t, colorize(colors.brightWhite, tostring(value)))
  end
  return unpack(t)
end

function logger.info(text, ...)
  local isTable = type(text) == 'table'

  if ... then
    print(
      (colorize(colors.brightGreen, isTable and json.encode(text) or text)):format(wrapArgs(...)))
  else
    print(colorize(colors.brightGreen, isTable and json.encode(text) or text))
  end
end

function logger.verbose(text, ...)
  local isTable = type(text) == 'table'

  if ... then
    print(
      (colorize(colors.brightBlue, isTable and json.encode(text) or text)):format(wrapArgs(...)))
  else
    print(colorize(colors.brightBlue, isTable and json.encode(text) or text))
  end
end

function logger.warn(text, ...)
  local isTable = type(text) == 'table'

  if ... then
    print(
      (colorize(colors.brightOrange, isTable and json.encode(text) or text)):format(wrapArgs(...)))
  else
    print(colorize(colors.brightOrange, isTable and json.encode(text) or text))
  end
end

function logger.error(text, ...)
  local isTable = type(text) == 'table'

  if ... then
    print(
      (colorize(colors.brightRed, isTable and json.encode(text) or text)):format(wrapArgs(...)))
  else
    print(colorize(colors.brightRed, isTable and json.encode(text) or text))
  end
end

-- Test
-- logger.info("[info] %s | %s", 'GET', '200')
-- logger.info({ message = 'Hello from logger' })
-- logger.verbose("[verbose] %s | %s", 'command', '/start')
-- logger.warn("[warn] %s | %s", 'event', 'user 1234 not found')
-- logger.error("[error] %s | %s", 'fatal', 'function foo.bar, line 123')

return logger
