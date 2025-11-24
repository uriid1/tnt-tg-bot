-- Example of send image 2
--
local bot = require('bot')
local log = require('bot.libs.logger')
local parse_mode = require('bot.enums.parse_mode')
local processCommand = require('bot.processes.processCommand')

bot:cfg({
  token = os.getenv('BOT_TOKEN'),
  parse_mode = parse_mode.HTML
})

-- Command: get_image
bot.commands['/get_image'] = function(ctx)
  local _, err = bot.sendImage({
    filepath = 'examples/img/animation.gif',
    caption = 'Image from disk!',
    chat_id = ctx:getChatId()
  })

  if err then
    log.error(err)
  end
end

function bot.events.onGetUpdate(ctx)
  local isCallCommand = processCommand(ctx)
  if isCallCommand then
    return
  end

  -- Another events
  -- if ctx.edited_message then
  -- bot.events.onEditedMesasage(ctx)
end

bot:startLongPolling()
