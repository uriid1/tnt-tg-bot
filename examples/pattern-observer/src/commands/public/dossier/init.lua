--- Команда /dossier
--
local bot = require('bot')
local log = require('bot.libs.logger')
local hdec = require('bot.ext.hdec')
local f = require('bot.ext.fstring')
local Command = require('src.classes.Command')
local command_type = require('src.enums.command_type')
local userService = require('src.services.users')
local getStatus = require('src.utils.getStatus')

local command = Command:new {
  commands = { '/dossier', 'досье' },
  type = command_type.PUBLIC
}

local TEMPLATE_PROFILE = f([[
🔫 Статус: <b>${status}</b>
${sep}
💰 Балик: <b>${balance}</b>
🔋 Энергия: <b>${energy}</b>
💊 Здоровье <b>${health}</b>%
🍽 Семки: <b>${eat}</b>
❤️ Уважений: <b>${likes}</b>
⌛️ Хулиганств: <b>${hooliganism}</b>
]], { sep = hdec.sep })

function command.call(ctx)
  local chatId = ctx:getChatId()
  local uFromId = ctx:getUserFromId()

  local user, err = userService.read(uFromId)
  if err then
    log.error(err)
    return
  end

  bot:sendMessage {
    text = f(TEMPLATE_PROFILE, {
      status = getStatus(user.balance),
      energy = user.energy,
      balance = user.balance,
      likes = user.likes,
      eat = user.eat,
      health = user.health,
      hooliganism = user.hooliganism
    }),

    chat_id = chatId,
    reply_to_message_id = ctx:getMessageId()
  }
end

return command
