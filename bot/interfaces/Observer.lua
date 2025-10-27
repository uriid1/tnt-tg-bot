--- Observer
--
local log = require('bot.libs.logger')

local Observer = {}
Observer.__index = Observer

function Observer:new()
  local obj = {}
  obj.handlers = {}

  setmetatable(obj, self)
  return obj
end

function Observer:on(event, fn)
  log.info('[Observer] init event: %-40s | fn %s', event, fn)

  self.handlers[event] = fn
end

function Observer:update(event, ctx)
  local handler = self.handlers[event]
  if handler then handler(ctx) end
end

return Observer
