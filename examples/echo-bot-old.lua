-- Example of echo bot
--
local log = require('log')
local bot = require('bot')
local parse_mode = require('bot.enums.parse_mode')
local methods = require('bot.enums.methods')

bot:cfg({
  token = os.getenv('BOT_TOKEN'),
  parse_mode = parse_mode.HTML
})

function bot.events.onGetUpdate(ctx)
  local text = ctx:getText()
  local chatId = ctx:getChatId()

  local _, err = bot.call(methods.sendMessage, {
    text = text,
    chat_id = chatId
  })

  if err then
    log.error({
      error = err
    })
  end
end

bot:startLongPolling()
