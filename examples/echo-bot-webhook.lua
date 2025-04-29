-- Example of echo bot via webhook
--
local log = require('log')
local bot = require('bot')
local parse_mode = require('bot.enums.parse_mode')
local methods = require('bot.enums.methods')

bot:cfg({
  token = os.getenv('BOT_TOKEN'),
  parse_mode = parse_mode.HTML
})

function bot.events.onGetUpdate(ctx)
  local text = ctx:getText()
  local chatId = ctx:getChatId()

  local _, err = bot.call(methods.sendMessage, {
    text = text,
    chat_id = chatId
  })

  if err then
    log.error({
      error = err
    })
  end
end

bot:startWebHook({
  -- Server setup
  host = '0.0.0.0',
  port = 8077,

  -- Bot setup
  drop_pending_updates = true,
  allowed_updates = {
    "message",
    "chat_member", "my_chat_member",
    "callback_query",
    "pre_checkout_query"
  },

  bot_url = 'https://sitename.io/bots/mybot'

  -- If you don't have a domain name
  -- you will need to use a self-signed certificate
  -- https://core.telegram.org/bots/self-signed
  --
  --
  -- bot_url = 'https://180.10.120.240/bots/mybot',
  -- path to custom certificate
  -- certificate = '/etc/www/cert/public.pem'
})
