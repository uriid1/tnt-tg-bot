--- Класс команд
--
local Command = {}
Command.__index = Command

function Command:new(opts)
  local _command = {}

  _command.type = opts.type
  _command.commands = opts.commands

  return setmetatable(_command, self)
end

return Command
