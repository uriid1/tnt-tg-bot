--- Module SuccessfulPayment
-- @module SuccessfulPayment
local SuccessfulPayment = {}
SuccessfulPayment.__index = SuccessfulPayment

--- Creates a new SuccessfulPayment object
-- @param successful_payment The data for initializing the object
-- @return The created SuccessfulPayment object
function SuccessfulPayment:new(successful_payment)
  return setmetatable(successful_payment, self)
end

function SuccessfulPayment:getSelf()
  return self.successful_payment
end

function SuccessfulPayment:getCurrency()
  return self.currency
end

function SuccessfulPayment:getTotalAmount()
  return self.total_amount
end

function SuccessfulPayment:getInvoicePayload()
  return self.invoice_payload
end

function SuccessfulPayment:getInvoicePayload()
  return self.invoice_payload
end

function SuccessfulPayment:getSubscriptionXxpirationDate()
  return self.subscription_expiration_date
end

function SuccessfulPayment:isRecurring()
  return self.is_recurring
end

function SuccessfulPayment:isFirstRecurring()
  return self.is_first_recurring
end

function SuccessfulPayment:getShippingOptionId()
  return self.shipping_option_id
end

function SuccessfulPayment:getOrderInfo()
  return self.order_info
end

function SuccessfulPayment:getTelegramPaymentChargeId()
  return self.telegram_payment_charge_id
end

function SuccessfulPayment:getProviderPaymentChargeId()
  return self.provider_payment_charge_id
end

setmetatable(SuccessfulPayment, {
  __call = SuccessfulPayment.new
})

return SuccessfulPayment
