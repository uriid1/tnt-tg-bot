-- Example of ping command
--
-- Исправление для ванильной lua: bot.init -> bot
package.path = package.path .. ';?/init.lua'

local bot = require('bot')
local log = require('bot.libs.logger')
local parse_mode = require('bot.enums.parse_mode')
local entity_type = require('bot.enums.entity_type')
local methods = require('bot.enums.methods')

bot:cfg({
  token = os.getenv('BOT_TOKEN'),
  parse_mode = parse_mode.HTML
})

bot.commands['/ping'] = function(ctx)
  local _, err = bot.call(methods.sendMessage, {
    text = 'pong',
    chat_id = ctx:getChatId()
  })

  if err then
    log.error({
      error = err
    })
  end
end

function bot.events.onGetUpdate(ctx)
  local entities = ctx:getEntities()

  if entities then
    if entities[1].type == entity_type.BOT_COMMAND then
      local command, botUserName = bot.Command(ctx)

      if botUserName ~= '@myUserNameBot' then
        -- return
      end

      if command then
        command(ctx)
      end
    end
  end
end

bot:startLongPolling()
