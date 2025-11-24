-- Example of echo bot
--
-- Исправление для ванильной lua: bot.init -> bot
package.path = package.path .. ';?/init.lua'

local bot = require('bot')
local log = require('bot.libs.logger')

bot:cfg({
  token = os.getenv('BOT_TOKEN')
})

function bot.events.onGetUpdate(ctx)
  local text = ctx:getText()
  local chatId = ctx:getChatId()

  local _, err = bot:sendMessage {
    text = text,
    chat_id = chatId
  }

  if err then
    log.error(err)
  end
end

bot:startLongPolling()
