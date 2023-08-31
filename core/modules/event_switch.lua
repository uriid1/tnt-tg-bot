-- Event switch
--
local processMessage = require('core.models.processMessage')
local log = require('log')
local bot

-- Event handler
local call_event = function(event, data)
  if event then
    return event(processMessage(data))
  end
end

local function event_switch(result)
  -- Empty result
  if not result then
    log.error("[Error] Empty result")
    return
  end

  -- Not table
  if type(result) ~= "table" or not next(result) then
    log.error("[Error] Result is not a table", result)
    return
  end

  -- Another events
  --
  -- https://core.telegram.org/bots/api#message
  if result.edited_message then
    return call_event(bot.event.onEditedMessage, result)

  -- https://core.telegram.org/bots/api#message
  elseif result.channel_post then
    return call_event(bot.event.onChannelPost, result)

  -- https://core.telegram.org/bots/api#message
  elseif result.edited_channel_post then
    return call_event(bot.event.onEditedChannelPost, result)

  -- https://core.telegram.org/bots/api#inlinequery
  elseif result.inline_query then
    return call_event(bot.event.onInlineQuery, result)

  -- https://core.telegram.org/bots/api#choseninlineresult
  elseif result.chosen_inline_result then
    return call_event(bot.event.onChosenInlineResult, result)

  -- https://core.telegram.org/bots/api#callbackquery
  elseif result.callback_query then
    return call_event(bot.event.onCallbackQuery, result)

  -- https://core.telegram.org/bots/api#shippingquery
  elseif result.shipping_query then
    return call_event(bot.event.ShippingQuery, result)

  -- https://core.telegram.org/bots/api#precheckoutquery
  elseif result.pre_checkout_query then
    return call_event(bot.event.PreCheckoutQuery, result)

  -- https://core.telegram.org/bots/api#poll
  elseif result.poll then
    return call_event(bot.event.onPoll, result)

  -- https://core.telegram.org/bots/api#pollanswer
  elseif result.poll_answer then
    return call_event(bot.event.onPollAnswer, result)

  -- https://core.telegram.org/bots/api#chatmemberupdated
  elseif result.my_chat_member then
    return call_event(bot.event.onMyChatMember, result)

  -- https://core.telegram.org/bots/api#chatmemberupdated
  elseif result.chat_member then
    return call_event(bot.event.onChatMember, result)

  -- https://core.telegram.org/bots/api#chatjoinrequest
  elseif result.chat_join_request then
    return call_event(bot.event.onChatJoinRequest, result)
  end

  -- Message events
  --
  -- https://core.telegram.org/bots/api#message
  --
  -- Get msg (useful when debugging)
  call_event(bot.event.onGetMessage, result)

  -- Sender Chat
  -- https://core.telegram.org/bots/api#chat
  if result.message.sender_chat then
    return call_event(bot.event.onSenderChat, result)
  end

  -- Forward
  -- https://core.telegram.org/bots/api#user
  if result.message.forward_from then
    return call_event(bot.event.onForwardFrom, result)

  -- https://core.telegram.org/bots/api#chat
  elseif result.message.forward_from_chat then
    return call_event(bot.event.onForwardFromChat, result)
  end

  -- Via bot
  -- https://core.telegram.org/bots/api#user
  if result.message.via_bot then
    return call_event(bot.event.onViaBot, result)
  end

  -- Chat
  -- https://core.telegram.org/bots/api#message
  if result.message.left_chat_member then
    return call_event(bot.event.onLeftChatMember, result)

  elseif result.message.new_chat_member then
    return call_event(bot.event.onNewChatMember, result)

  elseif result.message.new_chat_title then
    return call_event(bot.event.onNewChatTitle, result)

  elseif result.message.new_chat_photo then
    return call_event(bot.event.onNewChatPhoto, result)

  elseif result.message.delete_chat_photo then
    return call_event(bot.event.onDeleteChatPhoto, result)

  elseif result.message.group_chat_created then
    return call_event(bot.event.onGroupChatCreated, result)

  elseif result.message.supergroup_chat_created then
    return call_event(bot.event.onSupergroupChatCreated, result)

  elseif result.message.channel_chat_created then
    return call_event(bot.event.onChannelChatCreated, result)

  elseif result.message.migrate_to_chat_id then
    return call_event(bot.event.onMigrateToChatId, result)

  elseif result.message.migrate_from_chat_id then
    return call_event(bot.event.onMigrateFromChatId, result)

  end

  -- Payment
  -- https://core.telegram.org/bots/api#invoice
  if result.message.invoice then
    return call_event(bot.event.onInvoice, result)

  -- https://core.telegram.org/bots/api#successfulpayment
  elseif result.message.successful_payment then
    return call_event(bot.event.onSuccessfulPayment, result)
  end

  -- Passport
  -- https://core.telegram.org/bots/api#passportdata
  if result.message.passport_data then
    return call_event(bot.event.onPassportData, result)
  end

  -- Video Chat
  -- https://core.telegram.org/bots/api#videochatscheduled
  if result.message.video_chat_scheduled then
    return call_event(bot.event.onVideoChatScheduled, result)

  -- https://core.telegram.org/bots/api#videochatstarted
  elseif result.message.video_chat_started then
     return call_event(bot.event.onVideoChatStarted, result)

  -- https://core.telegram.org/bots/api#videochatended
  elseif result.message.video_chat_ended then
    return call_event(bot.event.onVideoChatEnded, result)

  -- https://core.telegram.org/bots/api#videochatparticipantsinvited
  elseif result.message.video_chat_participants_invited then
    return call_event(bot.event.onVideoChatParticipantsInvited, result)
  end

  -- Media
  -- https://core.telegram.org/bots/api#photosize
  if result.message.photo then
    return call_event(bot.event.onGetPhoto, result)

  -- https://core.telegram.org/bots/api#video
  elseif result.message.video then
    return call_event(bot.event.onGetVideo, result)

  -- https://core.telegram.org/bots/api#animation
  elseif result.message.animation then
    return call_event(bot.event.onGetAnimation, result)

  -- https://core.telegram.org/bots/api#document
  elseif result.message.document then
    return call_event(bot.event.onGetDocument, result)

  -- https://core.telegram.org/bots/api#location
  elseif result.message.location then
    return call_event(bot.event.onGetLocation, result)

  -- https://core.telegram.org/bots/api#poll
  elseif result.message.poll then
    return call_event(bot.event.onGetPoll, result)

  -- https://core.telegram.org/bots/api#audio
  elseif result.message.audio then
    return call_event(bot.event.onGetAudio, result)

  -- https://core.telegram.org/bots/api#contact
  elseif result.message.contact then
    return call_event(bot.event.onGetContact, result)

  -- https://core.telegram.org/bots/api#dice
  elseif result.message.dice then
    return call_event(bot.event.onGetDice, result)

  -- https://core.telegram.org/bots/api#game
  elseif result.message.game then
    return call_event(bot.event.onGetGame, result)

  -- https://core.telegram.org/bots/api#videonote
  elseif result.message.video_note then
    return call_event(bot.event.onGetVideoNote, result)

  -- https://core.telegram.org/bots/api#voice
  elseif result.message.voice then
    return call_event(bot.event.onGetVoice, result)

  -- https://core.telegram.org/bots/api#sticker
  elseif result.message.sticker then
    return call_event(bot.event.onGetSticker, result)
  end

  -- Entities
  -- https://core.telegram.org/bots/api#messageentity
  if result.message.entities then
    return call_event(bot.event.onGetEntities, result)
  end

  -- Text
  if result.message.text then
    return call_event(bot.event.onGetMessageText, result)
  end

  return call_event(bot.event.onUnknownUpdate, result)
end

local function init(_bot)
  bot = _bot
  return event_switch
end

return init
