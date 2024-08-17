-- Enum events list
local events_list = {
  -- Update events
  'onChosenInlineResult',
  'ShippingQuery',
  'PreCheckoutQuery',
  'onPoll',
  'onPollAnswer',
  'onMyChatMember',
  'onChatMember',
  'onChatJoinRequest',
  'onChannelPost',
  'onEditedChannelPost',

  'onEditedMessage',
  'onGetMessage',
  'onGetMessageText',
  'onInlineQuery',

  -- Callback query event
  'onCallbackQuery',

  -- Chat events
  'onSenderChat',
  'onNewChatTitle',
  'onNewChatPhoto',
  'onDeleteChatPhoto',
  'onGroupChatCreated',
  'onSupergroupChatCreated',
  'onChannelChatCreated',
  'onMigrateToChatId',
  'onMigrateFromChatId',
  'onNewChatMember',
  'onLeftChatMember',

  -- Payment events
  'onInvoice',
  'onSuccessfulPayment',

  -- Passport events
  'onPassportData',

  -- Video Chat events
  'onVideoChatScheduled',
  'onVideoChatStarted',
  'onVideoChatEnded',
  'onVideoChatParticipantsInvited',

  -- Forward events
  'onForwardFrom',
  'onForwardFromChat',

  -- Via bot event
  'onViaBot',

  -- Media events
  'onGetPhoto',
  'onGetVideo',
  'onGetAnimation',
  'onGetDocument',
  'onGetLocation',
  'onGetPoll',
  'onGetAudio',
  'onGetContact',
  'onGetDice',
  'onGetGame',
  'onGetVideoNote',
  'onGetSticker',
  'onGetVoice',

  -- Entities events
  'onGetEntities',

  -- Error Handling events
  'onCommandErrorHandle',
  'onEventErrorHandle',

  -- Request error handling event
  'onRequestErr',

  -- Other events
  'onInformSpammer',
  'onUnknownUpdate',
}

return events_list
