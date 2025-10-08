-- Example of send media group
--
local log = require('log')
local bot = require('bot')
local parse_mode = require('bot.enums.parse_mode')
local methods = require('bot.enums.methods')
local processCommand = require('bot.processes.processCommand')
local InputMedia = require('bot.types.InputMedia')
local InputMediaPhoto = require('bot.types.InputMediaPhoto')

bot:cfg({
  token = os.getenv('BOT_TOKEN'),
  parse_mode = parse_mode.HTML
})

--[[
data = {
  ["image.jpg"] = {
    data = "binary image data",
    filename = "image.jpg"
  },

  media = {
    [1] = {
      type = "photo",
      caption = "caption",
      media = "attach://image.jpg"
    },
    [2] = {
      type = "photo",
      caption = "caption",
      media = "https://foovbar.baz/image.jpg"
    }
  }
}
]]

-- Command: get_image
bot.commands['/get_media_group'] = function(ctx)
  -- @see https://core.telegram.org/bots/api#sendmediagroup
  local data = InputMedia({
    InputMediaPhoto({
      media = 'attach://examples/img/image.jpg',
      caption = 'Photo from disk'
    }),

    InputMediaPhoto({
      media = 'https://raw.githubusercontent.com/uriid1/scrfmp/main/perfect-arkanoid/arkanoid.png',
      caption = 'Photo from url'
    })
  })

  data.chat_id = ctx:getChatId()

  local _, err = bot.call(methods.sendMediaGroup,
    data,
    {
      multipart_post = true
    }
  )

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
