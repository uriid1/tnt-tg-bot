--- Event handling module
-- @module middlewares.events
local log = require('log')
local events_list = require('core.enums.events_list')

local events = {}

-- Initialize the event module with event handlers
for i = 1, #events_list do
  local name = events_list[i]

  events[name] = function()
    log.debug('The called event \'%s\' does not exist', name)
  end
end

return events
