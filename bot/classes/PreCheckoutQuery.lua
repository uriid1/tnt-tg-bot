--- Module PreCheckoutQuery
-- @module PreCheckoutQuery
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

function PreCheckoutQuery:getSelf()
  return self.pre_checkout_query
end

function PreCheckoutQuery:getInvoicePayload()
  if self.pre_checkout_query then
    return self.pre_checkout_query.invoice_payload
  end
end

function PreCheckoutQuery:getId()
  if self.pre_checkout_query then
    return self.pre_checkout_query.id
  end
end

function PreCheckoutQuery:getCurrency()
  if self.pre_checkout_query then
    return self.pre_checkout_query.currency
  end
end

function PreCheckoutQuery:getUserFrom()
  if self.pre_checkout_query then
    return self.pre_checkout_query.from
  end
end

function PreCheckoutQuery:getTotalAmount()
  if self.pre_checkout_query then
    return self.pre_checkout_query.total_amount
  end
end

setmetatable(PreCheckoutQuery, {
  __call = PreCheckoutQuery.new
})

return PreCheckoutQuery
