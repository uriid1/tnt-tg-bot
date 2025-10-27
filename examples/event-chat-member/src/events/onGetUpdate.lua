--- Событие получения обновление (сообщений) от телеграма
--
local function onGetUpdate(ctx)
  if ctx.chat_member then
    -- https://core.telegram.org/bots/api#chatmemberupdated
    return bot.events.onChatMember(ctx)
  end
end

return onGetUpdate
