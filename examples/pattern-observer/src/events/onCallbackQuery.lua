--- Событие обработки кнопок с колбэком
--
local chat_type = require('bot.enums.chat_type')
local processCommand = require('src.processes.processCommand')

local function onCallbackQuery(ctx)
  local chatType = ctx:getChatType()

  if chatType ~= chat_type.PRIVATE then
    return
  end

  processCommand(ctx)
end

return onCallbackQuery
