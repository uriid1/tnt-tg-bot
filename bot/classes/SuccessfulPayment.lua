--- Module SuccessfulPayment
-- @module bot.classes.SuccessfulPayment

local SuccessfulPayment = {}
SuccessfulPayment.__index = SuccessfulPayment

--- Creates a new SuccessfulPayment object
-- @param successful_payment The data for initializing the object
-- @return The created SuccessfulPayment object
function SuccessfulPayment:new(successful_payment)
  return setmetatable(successful_payment, self)
end

--- Returns SuccessfulPayment object
-- @treturn (table)
function SuccessfulPayment:getSelf()
  return self.successful_payment
end

--- Three-letter ISO 4217 currency code, or “XTR” for payments in Telegram Stars
-- @treturn (string)
function SuccessfulPayment:getCurrency()
  return self.currency
end

--- Get total amount
-- @treturn (number)
function SuccessfulPayment:getTotalAmount()
  return self.total_amount
end

--- Bot-specified invoice payload
-- @treturn (string)
function SuccessfulPayment:getInvoicePayload()
  return self.invoice_payload
end

--- Optional. Expiration date of the subscription, in Unix time; for recurring payments only
-- @treturn (number)
function SuccessfulPayment:getSubscriptionExpirationDate()
  return self.subscription_expiration_date
end

--- Optional. True, if the payment is a recurring payment for a subscription
-- @treturn (True)
function SuccessfulPayment:isRecurring()
  return self.is_recurring
end

--- Optional. True, if the payment is the first payment for a subscription
-- @treturn (True)
function SuccessfulPayment:isFirstRecurring()
  return self.is_first_recurring
end

--- Optional. Identifier of the shipping option chosen by the user
-- @return (string)
function SuccessfulPayment:getShippingOptionId()
  return self.shipping_option_id
end

--- Optional. Order information provided by the user
-- @return (OrderInfo)
function SuccessfulPayment:getOrderInfo()
  return self.order_info
end

--- Telegram payment identifier
-- @return (string)
function SuccessfulPayment:getTelegramPaymentChargeId()
  return self.telegram_payment_charge_id
end

--- Provider payment identifier
-- @return (string)
function SuccessfulPayment:getProviderPaymentChargeId()
  return self.provider_payment_charge_id
end

setmetatable(SuccessfulPayment, {
  __call = SuccessfulPayment.new
})

return SuccessfulPayment
