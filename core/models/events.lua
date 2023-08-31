local log = require('log')

local event = {}

event.enum = {
  -- Update
  onChosenInlineResult = true;
  ShippingQuery = true;
  PreCheckoutQuery = true;
  onPoll = true;
  onPollAnswer = true;
  onMyChatMember = true;
  onChatMember = true;
  onChatJoinRequest = true;
  onChannelPost = true;
  onEditedChannelPost = true;

  onEditedMessage = true;
  onGetMessage = true;
  onGetMessageText = true;
  onInlineQuery = true;

  -- CallBack
  onCallbackQuery = true;

  -- Chat
  onSenderChat = true;
  onNewChatTitle = true;
  onNewChatPhoto = true;
  onDeleteChatPhoto = true;
  onGroupChatCreated = true;
  onSupergroupChatCreated = true;
  onChannelChatCreated = true;
  onMigrateToChatId = true;
  onMigrateFromChatId = true;
  onNewChatMember = true;
  onLeftChatMember = true;

  -- Payment
  onInvoice = true;
  onSuccessfulPayment = true;

  -- Passport
  onPassportData = true;

  -- Video Chat
  onVideoChatScheduled = true;
  onVideoChatStarted = true;
  onVideoChatEnded = true;
  onVideoChatParticipantsInvited = true;

  -- Forward
  onForwardFrom = true;
  onForwardFromChat = true;

  -- Via bot
  onViaBot = true;

  -- Media
  onGetPhoto = true;
  onGetVideo = true;
  onGetAnimation = true;
  onGetDocument = true;
  onGetLocation = true;
  onGetPoll = true;
  onGetAudio = true;
  onGetContact = true;
  onGetDice = true;
  onGetGame = true;
  onGetVideoNote = true;
  onGetSticker = true;
  onGetVoice = true;

  -- Entities
  onGetEntities = true;

  -- Error Handling
  onCommandErrorHandle = true;
  onEventErrorHandle = true;

  -- Request error hl
  onRequestErr = true;

  -- Other
  onInformSpammer = true;
  onUnknownUpdate = true; 
}

local function init_check(event_name)
  return function()
    log.error(' The called event \'%s\' does not exist', event_name)
    return nil
  end
end

function event:init()
  for event_name,_ in pairs(event.enum) do
    event[event_name] = init_check(event_name)
  end

  return self
end

return event
