-- https://core.telegram.org/bots/api#botcommandscope
local bot_command_scope = require('core.enums.bot_command_scope')

local function BotCommandScope(scope)
  if not scope then
    return { type = bot_command_scope.DEFAULT }
  end

  return {
    type = scope
  } 
end

return BotCommandScope
