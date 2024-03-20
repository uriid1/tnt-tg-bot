---
-- Event handling module.
-- @module event
local log = require('log')

local event = {}

event.enum = {
  -- Update events
  onChosenInlineResult = true,
  ShippingQuery = true,
  PreCheckoutQuery = true,
  onPoll = true,
  onPollAnswer = true,
  onMyChatMember = true,
  onChatMember = true,
  onChatJoinRequest = true,
  onChannelPost = true,
  onEditedChannelPost = true,

  onEditedMessage = true,
  onGetMessage = true,
  onGetMessageText = true,
  onInlineQuery = true,

  -- Callback query event
  onCallbackQuery = true,

  -- Chat events
  onSenderChat = true,
  onNewChatTitle = true,
  onNewChatPhoto = true,
  onDeleteChatPhoto = true,
  onGroupChatCreated = true,
  onSupergroupChatCreated = true,
  onChannelChatCreated = true,
  onMigrateToChatId = true,
  onMigrateFromChatId = true,
  onNewChatMember = true,
  onLeftChatMember = true,

  -- Payment events
  onInvoice = true,
  onSuccessfulPayment = true,

  -- Passport events
  onPassportData = true,

  -- Video Chat events
  onVideoChatScheduled = true,
  onVideoChatStarted = true,
  onVideoChatEnded = true,
  onVideoChatParticipantsInvited = true,

  -- Forward events
  onForwardFrom = true,
  onForwardFromChat = true,

  -- Via bot event
  onViaBot = true,

  -- Media events
  onGetPhoto = true,
  onGetVideo = true,
  onGetAnimation = true,
  onGetDocument = true,
  onGetLocation = true,
  onGetPoll = true,
  onGetAudio = true,
  onGetContact = true,
  onGetDice = true,
  onGetGame = true,
  onGetVideoNote = true,
  onGetSticker = true,
  onGetVoice = true,

  -- Entities events
  onGetEntities = true,

  -- Error Handling events
  onCommandErrorHandle = true,
  onEventErrorHandle = true,

  -- Request error handling event
  onRequestErr = true,

  -- Other events
  onInformSpammer = true,
  onUnknownUpdate = true,
}

-- Helper function to create event handlers for unsupported events.
local function init_check(event_name)
  return function()
    log.error('The called event \'%s\' does not exist', event_name)
    return nil
  end
end

---
-- Initialize the event module with event handlers.
-- @return The initialized event module.
function event:init()
  for event_name, _ in pairs(event.enum) do
    event[event_name] = init_check(event_name)
  end

  return self
end

return event
