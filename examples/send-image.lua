-- Example of send image
--
local log = require('log')
local bot = require('bot')
local parse_mode = require('bot.enums.parse_mode')
local methods = require('bot.enums.methods')
local processCommand = require('bot.processes.processCommand')
local InputFile = require('bot.types.InputFile')

bot:cfg({
  token = os.getenv('BOT_TOKEN'),
  parse_mode = parse_mode.HTML
})

-- Command: get_image
bot.commands['/get_image'] = function(ctx)
  -- https://core.telegram.org/bots/api#sendphoto
  local _, err = bot.call(methods.sendPhoto, {
    photo = InputFile('examples/img/image.jpg'),
    caption = 'Image from disk TEST-1!',
    chat_id = ctx:getChatId(),
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
