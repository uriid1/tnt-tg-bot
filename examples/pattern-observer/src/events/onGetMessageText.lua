---
--
local utf8 = require('utf8')
local bot = require('bot')
local processCommand = require('src.processes.processCommand')

local function onGetMessageText(ctx)
  -- Скип пересланных сообщений
  if ctx.message.forward_from then
    return
  elseif ctx.message.forward_from_chat then
    return
  elseif ctx.message.forward_from_message_id then
    return
  elseif ctx.message.forward_signature then
    return
  elseif ctx.message.forward_sender_name then
    return
  end

  local commandName = utf8.lower(ctx.message.text:match('(%S+)'))
  if not bot.commands[commandName] then
    return
  end

  return processCommand(ctx, {
    is_text_command = true,
    command = bot.commands[commandName]
  })
end

return onGetMessageText
