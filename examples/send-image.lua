-- Example of send image
--
local log = require('log')
local bot = require('bot')
local parse_mode = require('bot.enums.parse_mode')
local processCommand = require('bot.processes.processCommand')
local inputFile = require('bot.libs.inputFile')

bot:cfg({
  token = os.getenv('BOT_TOKEN'),
  parse_mode = parse_mode.HTML
})

-- Command: get_image
bot.commands['/get_image'] = function(ctx)
  -- @see https://core.telegram.org/bots/api#sendphoto
  local _, err = bot:sendPhoto({
    photo = inputFile('examples/img/image.jpg'),
    caption = 'Image from disk TEST-1!',
    chat_id = ctx:getChatId()
  }, { multipart_post = true })

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
