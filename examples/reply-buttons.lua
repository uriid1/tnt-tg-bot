-- Example of reply buttons
--
local log = require('log')
local bot = require('bot')
local parse_mode = require('bot.enums.parse_mode')
local methods = require('bot.enums.methods')
local ReplyKeyboardMarkup = require('bot.types.ReplyKeyboardMarkup')
local processCommand = require('bot.processes.processCommand')

bot:cfg({
  token = os.getenv('BOT_TOKEN'),
  parse_mode = parse_mode.HTML
})

-- Command: /send_reply_buttons
bot.commands['/send_reply_buttons'] = function(ctx)
  local _, err = bot.call(methods.sendMessage, {
    text = 'Reply keyboard buttons test 1',
    chat_id = ctx:getChatId(),

    -- Apple | Banana
    -- Orange
    reply_markup = ReplyKeyboardMarkup({
      keyboard = {
        { { text = 'Apple 🍎' }, { text = 'Banana 🍌' } },
        { { text = 'Orange 🍊' } },
      },

      one_time_keyboard = true
    })
  })

  if err then
    log.error(err)
  end
end

function bot.events.onGetUpdate(ctx)
  if processCommand(ctx) then
    return
  end

  -- Another events
  -- if ctx.edited_message then
  -- bot.events.onEditedMesasage(ctx)
end

bot:startLongPolling()
