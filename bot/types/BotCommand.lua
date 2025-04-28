--- https://core.telegram.org/bots/api#botcommand
-- @module bot.types.BotCommand
local function BotCommand(data)
  if not data then
    return nil
  end

  return {
    command = data.command or data[1],
    description = data.description or data[2] or 'command'
  }
end

return BotCommand
