-- Example simple callback button 2
--
local bot = require('bot')
local parse_mode = require('bot.enums.parse_mode')
local methods = require('bot.enums.methods')
local processCommand = require('bot.processes.processCommand')
local inlineKeyboard = require('bot.middlewares.inlineKeyboard')

bot:cfg({
  token = os.getenv('BOT_TOKEN'),
  parse_mode = parse_mode.HTML
})

local EAT_GIF = 'https://niko-bot.ru/images/moderator.gif'
local GAMING_GIF = 'https://niko-bot.ru/images/gaming.gif'

bot.commands['/test'] = function(ctx)
  local keyboard = inlineKeyboard({
    { text = 'Click to eat', callback = 'cb_change eat' },
  })

  bot.call(methods.sendAnimation, {
    animation = GAMING_GIF,
    caption = 'Eats',
    chat_id = ctx:getChatId(),
    reply_markup = keyboard
  })
end

bot.commands['cb_change'] = function(ctx)
  -- arguments[1] - Command cb_change
  -- arguments[2] - type
  local arguments = ctx:getArguments({ count = 2 })
  local changeType = arguments[2]

  local keyboard
  local media
  local caption

  if changeType == 'eat' then
    media = EAT_GIF
    caption = 'Eats'

    keyboard = inlineKeyboard({
      { text = 'Click to play', callback = 'cb_change play' },
    })
  elseif changeType == 'play' then
    media = GAMING_GIF
    caption = 'Is playing'

    keyboard = inlineKeyboard({
      { text = 'Click to eat', callback = 'cb_change eat' },
    })
  end

  local _, err = bot.call('editMessageMedia', {
    media = {
      type = 'animation',
      media = media,
      caption = caption,
      parse_mode = bot.parse_mode
    },
    chat_id = ctx:getChatId(),
    message_id = ctx:getMessageId(),
    reply_markup = keyboard
  })
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
