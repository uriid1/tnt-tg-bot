-- Test routes
--
local bot = require('bot')
local parse_mode = require('bot.enums.parse_mode')
-- Routes
local getPayments = require('routes/getPayments')
local setScore = require('routes/setScore')

bot:cfg({
  token = os.getenv('BOT_TOKEN'),
  parse_mode = parse_mode.HTML
})

--[[
curl -X GET 0.0.0.0:7081/v1/payments

curl -X POST -d '{ "score": 100 }' -H "application/json" 0.0.0.0:7081/v1/score
]]

bot:startWebHook({
  -- maintenance mode is needed for testing, it will not send data to telegram
  maintenance_mode = 'maint',
  -- https://core.telegram.org/bots/api#setwebhook
  drop_pending_updates = true,

  -- Server setup
  host = '0.0.0.0',
  port = 7081,
  -- Bot setup
  bot_url = '0.0.0.0/bot_location',
  allowed_updates = {
    "message",
    "chat_member",
    "my_chat_member",
    "callback_query",
    "pre_checkout_query"
  },

  -- Custom routes
  routes = {
    { path = '/v1/payments', method = 'GET',  callback = getPayments },
    { path = '/v1/score',    method = 'POST', callback = setScore }
  },
})
