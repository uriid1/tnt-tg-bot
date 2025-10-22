-- Example of send media group
--
local log = require('log')
local bot = require('bot')
local parse_mode = require('bot.enums.parse_mode')
local processCommand = require('bot.processes.processCommand')
local InputMedia = require('bot.types.InputMedia')

bot:cfg({
  token = os.getenv('BOT_TOKEN'),
  parse_mode = parse_mode.HTML
})

-- Command: get_image
bot.commands['/get_media_group'] = function(ctx)
  -- @see https://core.telegram.org/bots/api#sendmediagroup
  local _, err = bot:sendMediaGroup({
    chat_id = ctx:getChatId(),
    media = InputMedia {
      {
        type = 'photo',
        media = 'https://niko-bot.ru/images/gaming.gif',
        caption = 'Img gaming.gif'
      },
      {
        type = 'photo',
        media = 'https://niko-bot.ru/images/moderator.gif',
        caption = 'Img moderator.gif'
      }
    }
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
