-- Example of async timer
--
local fiber = require('fiber')
local log = require('log')
local bot = require('bot')
local parse_mode = require('bot.enums.parse_mode')
local methods = require('bot.enums.methods')
local processCommand = require('bot.processes.processCommand')

bot:cfg({
  token = os.getenv('BOT_TOKEN'),
  parse_mode = parse_mode.HTML
})

bot.commands['/timer'] = function(ctx)
  for i = 1, 3 do
    local _, err = bot.call(methods.sendMessage, {
      text = 'timeout: ' .. i,
      chat_id = ctx:getChatId()
    })

    if err then
      log.error(err)
    end

    fiber.sleep(1)
  end
end

function bot.events.onGetUpdate(ctx)
  if processCommand(ctx) then
    return
  end
end

bot:startLongPolling()
