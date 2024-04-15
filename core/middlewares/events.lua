---
-- Event handling module.
-- @module events
local log = require('log')
local events_list = require('core.enums.events_list')

local events = {}

---
-- Initialize the event module with event handlers.
-- @return The initialized event module.
for i = 1, #events_list do
  local name = events_list[i]

  events[name] = function()
    log.error('The called event \'%s\' does not exist', name)
  end
end

return events
