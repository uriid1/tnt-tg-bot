--- Module PreCheckoutQuery
-- @module bot.classes.PreCheckoutQuery

local PreCheckoutQuery = {}
PreCheckoutQuery.__index = PreCheckoutQuery

--- Creates a new PreCheckoutQuery object
-- @param ctx The data for initializing the object
-- @return The created PreCheckoutQuery object
function PreCheckoutQuery:new(ctx)
  local obj = {}
  obj.update_id = ctx.update_id
  obj.pre_checkout_query = ctx.pre_checkout_query

  return setmetatable(obj, self)
end

--- Gets the update ID
-- @return (number) The update ID
function PreCheckoutQuery:getUpdateId()
  if self.update_id then
    return self.update_id
  end
end

--- Bot-specified invoice payload
-- @return (string)
function PreCheckoutQuery:getInvoicePayload()
  if self.pre_checkout_query then
    return self.pre_checkout_query.invoice_payload
  end
end

--- Unique query identifier
-- @return (string)
function PreCheckoutQuery:getId()
  if self.pre_checkout_query then
    return self.pre_checkout_query.id
  end
end

--- Three-letter ISO 4217 currency code, or “XTR” for payments in Telegram Stars
-- @return (string)
function PreCheckoutQuery:getCurrency()
  if self.pre_checkout_query then
    return self.pre_checkout_query.currency
  end
end

--- User who sent the query
-- @return (User)
function PreCheckoutQuery:getUserFrom()
  if self.pre_checkout_query then
    return self.pre_checkout_query.from
  end
end

--- price in the smallest units of the currency (integer, not float/double)
-- @return (Integer)
function PreCheckoutQuery:getTotalAmount()
  if self.pre_checkout_query then
    return self.pre_checkout_query.total_amount
  end
end

setmetatable(PreCheckoutQuery, {
  __call = PreCheckoutQuery.new
})

return PreCheckoutQuery
