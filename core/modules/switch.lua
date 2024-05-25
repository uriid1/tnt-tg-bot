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
function switch:call_event(result)
  -- Set bot link
  local bot = self.bot

  -- Process current message
  local data = processMessage(result)

  --
  -- Another events
  --
  -- https://core.telegram.org/bots/api#message
  if result.edited_message then
    return bot.events.onEditedMessage(data)

  -- https://core.telegram.org/bots/api#message
  elseif result.channel_post then
    return bot.events.onChannelPost(data)

  -- https://core.telegram.org/bots/api#message
  elseif result.edited_channel_post then
    return bot.events.onEditedChannelPost(data)

  -- https://core.telegram.org/bots/api#inlinequery
  elseif result.inline_query then
    return bot.events.onInlineQuery(data)

  -- https://core.telegram.org/bots/api#choseninlineresult
  elseif result.chosen_inline_result then
    return bot.events.onChosenInlineResult(result)

  -- https://core.telegram.org/bots/api#callbackquery
  elseif result.callback_query then
    return bot.events.onCallbackQuery(data)

  -- https://core.telegram.org/bots/api#shippingquery
  elseif result.shipping_query then
    return bot.events.ShippingQuery(data)

  -- https://core.telegram.org/bots/api#precheckoutquery
  elseif result.pre_checkout_query then
    return bot.events.PreCheckoutQuery(data)

  -- https://core.telegram.org/bots/api#poll
  elseif result.poll then
    return bot.events.onPoll(data)

  -- https://core.telegram.org/bots/api#pollanswer
  elseif result.poll_answer then
    return bot.events.onPollAnswer(data)

  -- https://core.telegram.org/bots/api#chatmemberupdated
  elseif result.my_chat_member then
    return bot.events.onMyChatMember(data)

  -- https://core.telegram.org/bots/api#chatmemberupdated
  elseif result.chat_member then
    return bot.events.onChatMember(data)

  -- https://core.telegram.org/bots/api#chatjoinrequest
  elseif result.chat_join_request then
    return bot.events.onChatJoinRequest(data)
  end
  --

  --
  -- Message events
  --
  -- https://core.telegram.org/bots/api#message
  bot.events.onGetMessage(data)
  --

  -- Sender Chat
  -- https://core.telegram.org/bots/api#chat
  if result.message.sender_chat then
    return bot.events.onSenderChat(data)
  end

  --
  -- Forward
  --
  -- https://core.telegram.org/bots/api#user
  if result.message.forward_from then
    return bot.events.onForwardFrom(data)

  -- https://core.telegram.org/bots/api#chat
  elseif result.message.forward_from_chat then
    return bot.events.onForwardFromChat(data)
  end
  --

  --
  -- Via bot
  --
  -- https://core.telegram.org/bots/api#user
  if result.message.via_bot then
    return bot.events.onViaBot(data)
  end
  --

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

  elseif result.message.new_chat_photo then
    return bot.events.onNewChatPhoto(data)

  elseif result.message.delete_chat_photo then
    return bot.events.onDeleteChatPhoto(data)

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

  --
  -- Payment
  --
  -- https://core.telegram.org/bots/api#invoice
  if result.message.invoice then
    return bot.events.onInvoice(data)

  -- https://core.telegram.org/bots/api#successfulpayment
  elseif result.message.successful_payment then
    return bot.events.onSuccessfulPayment(data)
  end
  --

  --
  -- Passport
  --
  -- https://core.telegram.org/bots/api#passportdata
  if result.message.passport_data then
    return bot.events.onPassportData(data)
  end

  --
  -- Video Chat
  --
  -- https://core.telegram.org/bots/api#videochatscheduled
  if result.message.video_chat_scheduled then
    return bot.events.onVideoChatScheduled(data)

  -- https://core.telegram.org/bots/api#videochatstarted
  elseif result.message.video_chat_started then
     return bot.events.onVideoChatStarted(data)

  -- https://core.telegram.org/bots/api#videochatended
  elseif result.message.video_chat_ended then
    return bot.events.onVideoChatEnded(data)

  -- https://core.telegram.org/bots/api#videochatparticipantsinvited
  elseif result.message.video_chat_participants_invited then
    return bot.events.onVideoChatParticipantsInvited(data)
  end
  --

  --
  -- Media
  --
  -- https://core.telegram.org/bots/api#photosize
  if result.message.photo then
    return bot.events.onGetPhoto(data)

  -- https://core.telegram.org/bots/api#video
  elseif result.message.video then
    return bot.events.onGetVideo(data)

  -- https://core.telegram.org/bots/api#animation
  elseif result.message.animation then
    return bot.events.onGetAnimation(data)

  -- https://core.telegram.org/bots/api#document
  elseif result.message.document then
    return bot.events.onGetDocument(data)

  -- https://core.telegram.org/bots/api#location
  elseif result.message.location then
    return bot.events.onGetLocation(data)

  -- https://core.telegram.org/bots/api#poll
  elseif result.message.poll then
    return bot.events.onGetPoll(data)

  -- https://core.telegram.org/bots/api#audio
  elseif result.message.audio then
    return bot.events.onGetAudio(data)

  -- https://core.telegram.org/bots/api#contact
  elseif result.message.contact then
    return bot.events.onGetContact(data)

  -- https://core.telegram.org/bots/api#dice
  elseif result.message.dice then
    return bot.events.onGetDice(data)

  -- https://core.telegram.org/bots/api#game
  elseif result.message.game then
    return bot.events.onGetGame(data)

  -- https://core.telegram.org/bots/api#videonote
  elseif result.message.video_note then
    return bot.events.onGetVideoNote(data)

  -- https://core.telegram.org/bots/api#voice
  elseif result.message.voice then
    return bot.events.onGetVoice(data)

  -- https://core.telegram.org/bots/api#sticker
  elseif result.message.sticker then
    return bot.events.onGetSticker(data)
  end
  --

  --
  -- Entities
  --
  -- https://core.telegram.org/bots/api#messageentity
  if result.message.entities then
    return bot.events.onGetEntities(data)
  end
  --

  --
  -- Message text
  --
  if result.message.text then
    return bot.events.onGetMessageText(data)
  end
  --

  return bot.events.onUnknownUpdate(data)
end

return switch
