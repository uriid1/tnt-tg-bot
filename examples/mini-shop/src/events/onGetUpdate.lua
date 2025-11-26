--- Событие получения обновление (сообщений) от телеграма
--
local bot = require('bot')

local function onGetUpdate(ctx)
  if ctx.callback_query then
    return bot.events.onCallbackQuery(ctx)
  end

  if ctx.message then
    if ctx.message.entities then
      return bot.events.onGetEntities(ctx)
    end
  end
end

return onGetUpdate
