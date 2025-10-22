-- Example of send document
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

-- Command: get_document
bot.commands['/get_document'] = function(ctx)
  --@see https://core.telegram.org/bots/api#senddocument
  local _, err = bot:sendDocument({
    document = inputFile('examples/img/image.jpg'),
    caption = 'Ducument from disk',
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
