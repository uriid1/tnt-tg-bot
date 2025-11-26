--- Событие получения обновление (сообщений) от телеграма
--
local bot = require('bot')

local function onGetUpdate(ctx)
  -- Any events
  --
  if ctx.callback_query then
    return bot.events.onCallbackQuery(ctx)

  elseif ctx.my_chat_member then
    -- https://core.telegram.org/bots/api#chatmemberupdated
    return bot.events.onMyChatMember(ctx)

  elseif ctx.chat_member then
    -- https://core.telegram.org/bots/api#chatmemberupdated
    return bot.events.onChatMember(ctx)
  end

  -- Message events
  --
  if ctx.message then
    if ctx.message.entities then
      return bot.events.onGetEntities(ctx)

    elseif ctx.message.text then
      return bot.events.onGetMessageText(ctx)
    end
  end
end

return onGetUpdate
