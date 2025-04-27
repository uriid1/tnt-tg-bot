--- Callback class for handling callback queries
-- @module callback

local Message = require('bot.classes.Message')

local callback = {}
callback.__index = callback

--- Creates a new callback object
-- @param ctx (table) The callback query data
--   - update_id (number): The update ID
--   - callback_query (table): The callback query data
-- @return (callback) The callback object
function callback:new(ctx)
  local obj = {}

  obj.update_id = ctx.update_id
  obj.message = Message(ctx.callback_query.message, { direct = true })

  obj.callback_query = ctx.callback_query
  obj.is_callback_query = true

  return setmetatable(obj, self)
end

--- Gets the update ID
-- @return (number) The update ID
function callback:getUpdateId()
  if self.update_id then
    return self.update_id
  end
end

--- Gets the callback query ID
-- @return (string) The callback query ID
function callback:getQueryId()
  if self.callback_query then
    return self.callback_query.id
  end
end

--- Gets the associated message
-- @return (table) The associated message
function callback:getMessage()
  return self.message
end

--- Gets the arguments from the callback query data
-- @param opts (table) Options table
--   - separator (string, optional): The separator to split the data (default is ' ')
--   - count (number, optional): The maximum number of arguments to retrieve (default is 10)
-- @return (table) The arguments as a table
function callback:getArguments(opts)
  if self.callback_query then
    local separator = opts.separator or ' '
    local count = opts.count or 10
    return self.callback_query.data:split(separator, count)
  end
end

--- Gets the user data from the callback query
-- @return (table) The user data
function callback:getUserFrom()
  if self.callback_query and self.callback_query.from then
    return self.callback_query.from
  end
end

--- Gets the user ID from the callback query
-- @return (number) The user ID
function callback:getUserFromId()
  if self.callback_query and self.callback_query.from then
    return self.callback_query.from.id
  end
end

--- Gets the callback query data
-- @return (table) Callback query data
function callback:getQueryData()
  if self.callback_query
    and self.callback_query.data
  then
    return self.callback_query.data
  end
end

--- Trim command
-- @return[1] Trimed command
-- @return[2] count
function callback:trimCommand()
  if self.callback_query and self.callback_query.data and self.__command then
    local res, count = self.callback_query.data:gsub(self.__command..' ', '', 1)

    return res, count
  end
end

setmetatable(callback, {
  __call = callback.new
})

return callback
