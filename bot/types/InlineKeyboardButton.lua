--- Inline Keyboard Button
  -- https://core.telegram.org/bots/api#inlinekeyboardbutton
  --
-- @module bot.types.inlineKeyboardButton
local log = require('log')

local function inlineKeyboardButton(keyboard, data)
  if type(data) ~= 'table' then
    return nil
  end

  if keyboard and type(keyboard) ~= 'table' then
    return nil
  end

  local button = {}

  -- Label text on the button
  if data.text then
    button.text = tostring(data.text)
  end

  -- Optional. HTTP or tg:// URL to be opened when the button is pressed
  if data.url then
    button.url = tostring(data.url)
  end

  -- Optional. Data to be sent in a callback query to the bot when button is pressed, 1-64 bytes
  if data.callback_data then
    button.callback_data = tostring(data.callback_data)
  elseif data.callback then
    button.callback_data = tostring(data.callback)
  end

  if button.callback_data and string.len(button.callback_data) > 64 then
    log.error('Callback data > 64 bytes, data: %s', button.callback_data)
  end

  -- Optional. Description of the Web App that will be launched when the user presses the button
  if data.web_app then
    button.web_app = data.web_app
  end

  -- Optional. An HTTPS URL used to automatically authorize the user
  if data.login_url then
    button.login_url = data.login_url
  end

  -- Optional. If set, pressing the button will prompt the user to select one of their chats,
  -- open that chat and insert the bot's username and the specified inline query in the input field.
  -- May be empty, in which case just the bot's username will be inserted.
  if data.switch_inline_query then
    button.switch_inline_query = tostring(data.switch_inline_query)
  end

  -- Optional. If set, pressing the button will insert the bot's username and
  -- the specified inline query in the current chat's input field. May be empty,
  -- in which case only the bot's username will be inserted.
  if data.switch_inline_query_chosen_chat then
    button.switch_inline_query_chosen_chat = data.switch_inline_query_chosen_chat
  end

  -- Optional. Description of the game that will be launched when the user presses the button
  if data.callback_game then
    button.callback_game = data.callback_game
  end

  -- Optional. Specify True, to send a Pay button
  if data.pay then
    button.pay = data.pay
  end

  if keyboard then
    -- Add button to line
    if not keyboard["inline_keyboard"][data.row] then
      table.insert(keyboard["inline_keyboard"], { button })

      return button
    end

    -- Add button to row
    table.insert(keyboard["inline_keyboard"][data.row or 1], button)

    return button
  end

  return button
end

return inlineKeyboardButton
