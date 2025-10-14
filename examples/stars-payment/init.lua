-- Example of stars payment
--
local log = require('log')
local bot = require('bot')
local parse_mode = require('bot.enums.parse_mode')
local processCommand = require('bot.processes.processCommand')
local hdec = require('bot.ext.hdec')

bot:cfg({
  token = os.getenv('BOT_TOKEN'),
  parse_mode = parse_mode.HTML
})

-- Command: buy
bot.commands['/buy'] = function(ctx)
  --
  -- https://core.telegram.org/bots/api#sendinvoice
  --
  bot:sendInvoice {
    title = '🍎 Awesome fuit! 🍎',
    description = 'You are buying to buy 1 apple.',
    chat_id = ctx:getChatId(),
    payload = 'apple_1',
    currency = 'XTR',
    prices = {
      { label = 'apple',  amount = 1 }
    }
  }
end

-- Command: refund
-- Example: /refund 1234567890 stxMyTqYQE0Ys45vJlANkNiepY369ceWxasmbPLXhxPLOwg32sVPGM5
bot.commands['/refund'] = function(ctx)
  -- arguments[1] self command
  -- arguments[2] user id
  -- arguments[3] payment id
  local arguments = ctx:getArguments({ count = 3 })
  local userId = arguments[2]
  local paymentId = arguments[3]

  local _, err = bot:refundStarPayment {
    user_id = tonumber(userId),
    telegram_payment_charge_id = paymentId
  }

  if err then
    log.error(err)
  end
end

function bot.events.preCheckoutQuery(ctx)
  -- local invoicePayload = ctx:getInvoicePayload()
  -- local currency = ctx:getCurrency()
  -- local userFrom = ctx:getUserFrom()
  -- local totalAmount = ctx:getTotalAmount()
  local id = ctx:getId()

  local _, err = bot:answerPreCheckoutQuery {
    pre_checkout_query_id = id,
    ok = true
  }

  if err then
    log.error(err)
  end
end

function bot.events.successfulPayment(ctx)
  local payment = ctx:getSuccessfulPayment()
  local invoicePayload = payment:getInvoicePayload()
  local totalAmount = payment:getTotalAmount()
  local PaymentChargeId = payment.telegram_payment_charge_id

  local _, err = bot:sendMessage {
    chat_id = ctx:getChatId(),
    text = 'Successful Payment!'
    .. '\n' .. 'Date: ' .. hdec.mono(os.date())
    .. '\n' .. 'Payload: ' .. hdec.mono(invoicePayload)
    .. '\n' .. 'Total amount: ' .. hdec.mono(totalAmount)
    .. '\n' .. 'Payment ID: ' .. hdec.mono(PaymentChargeId)
  }

  if err then
    log.error(err)
  end
end

function bot.events.onGetUpdate(ctx)
  if processCommand(ctx) then
    return
  end

  if ctx.pre_checkout_query then
    --
    -- https://core.telegram.org/bots/api#precheckoutquery
    --
    return bot.events.preCheckoutQuery(ctx)

  elseif ctx.message.successful_payment then
    --
    -- https://core.telegram.org/bots/api#answerprecheckoutquery
    --
    return bot.events.successfulPayment(ctx)
  end

  -- Another events
  -- if ctx.edited_message then
  -- bot.events.onEditedMesasage(ctx)
  --
end

bot:startLongPolling({
  allowed_updates = {
    "message",
    "callback_query",
    "pre_checkout_query"
  }
})
