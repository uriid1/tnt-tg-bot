-- https://core.telegram.org/bots/api#replykeyboardmarkup
--
local json = require 'json'

function InlineKeyboardMarkup(data)
  if data and type(data) ~= 'table' then
    return nil
  end

  local obj = {}

  -- Array of button rows,
  -- each represented by an Array of InlineKeyboardButton objects
  if data and type(data) == 'table' then
    -- If table inline_keyboard exists
    if type(data.inline_keyboard) == 'table' then
      return json.encode(data)
    end
  else
    obj.inline_keyboard = {}
  end

  local keyboard = {}
  keyboard.__index = keyboard

  function keyboard:toJson()
    return json.encode(self)
  end

  setmetatable(obj, keyboard)

  return obj
end

return InlineKeyboardMarkup
