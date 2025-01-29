---
-- Event switching module.
-- @module switch
local processMessage = require('core.middlewares.processMessage')

local switch = {}

---
-- Initialize the event module.
-- @return The initialized event module.
function switch:init(bot)
  self.bot = bot

  return self
end

-- Call events
-- luacheck: ignore
function switch:call_event(result)
  local bot = self.bot

  -- Process current message
  local data = processMessage(result)

  if result.inline_query then
    -- https://core.telegram.org/bots/api#inlinequery
    return bot.events.onInlineQuery(data)
  elseif result.callback_query then
    -- https://core.telegram.org/bots/api#callbackquery
    return bot.events.onCallbackQuery(data)
  elseif result.my_chat_member then
    -- https://core.telegram.org/bots/api#chatmemberupdated
    return bot.events.onMyChatMember(data)
  elseif result.chat_member then
    -- https://core.telegram.org/bots/api#chatmemberupdated
    return bot.events.onChatMember(data)
  end

  -- Message events
  --
  -- https://core.telegram.org/bots/api#message
  bot.events.onGetMessage(data)
  --

  --
  -- Media
  --
  -- https://core.telegram.org/bots/api#dice
  if result.message.dice then
    return bot.events.onGetDice(data)
  end

  --
  -- Chat
  --
  -- https://core.telegram.org/bots/api#message
  if result.message.left_chat_member then
    return bot.events.onLeftChatMember(data)

  elseif result.message.new_chat_member then
    return bot.events.onNewChatMember(data)

  elseif result.message.new_chat_title then
    return bot.events.onNewChatTitle(data)

  elseif result.message.group_chat_created then
    return bot.events.onGroupChatCreated(data)

  elseif result.message.supergroup_chat_created then
    return bot.events.onSupergroupChatCreated(data)

  elseif result.message.channel_chat_created then
    return bot.events.onChannelChatCreated(data)

  elseif result.message.migrate_to_chat_id then
    return bot.events.onMigrateToChatId(data)

  elseif result.message.migrate_from_chat_id then
    return bot.events.onMigrateFromChatId(data)
  end
  --
end

return switch
