--[[
    ####--------------------------------####
    #--# Author:   by uriid1            #--#
    #--# License:  GNU GPLv3            #--#
    #--# Telegram: @main_moderator      #--#
    #--# E-mail:   appdurov@gmail.com   #--#
    ####--------------------------------####
--]]

local event = {
    -- Update
    onChosenInlineResult = nil;
    ShippingQuery = nil;
    PreCheckoutQuery = nil;
    onPoll = nil;
    onPollAnswer = nil;
    onMyChatMember = nil;
    onChatMember = nil;
    onChatJoinRequest = nil;
    onChannelPost = nil;
    onEditedChannelPost = nil;

    onEditedMessage = nil;
    onGetMessage = nil;
    onGetMessageText = nil;
    onInlineQuery = nil;

    -- CallBack
    onCallbackQuery = nil;

    -- Chat
    onSenderChat = nil;
    onNewChatTitle = nil;
    onNewChatPhoto = nil;
    onDeleteChatPhoto = nil;
    onGroupChatCreated = nil;
    onSupergroupChatCreated = nil;
    onChannelChatCreated = nil;
    onMigrateToChatId = nil;
    onMigrateFromChatId = nil;
    onNewChatMember = nil;
    onLeftChatMember = nil;

    -- Payment
    onInvoice = nil;
    onSuccessfulPayment = nil;

    -- Passport
    onPassportData = nil;

    -- Video Chat
    onVideoChatScheduled = nil;
    onVideoChatStarted = nil;
    onVideoChatEnded = nil;
    onVideoChatParticipantsInvited = nil;

    -- Forward
    onForwardFrom = nil;
    onForwardFromChat = nil;

    -- Via bot
    onViaBot = nil;

    -- Media
    onGetPhoto = nil;
    onGetVideo = nil;
    onGetAnimation = nil;
    onGetDocument = nil;
    onGetLocation = nil;
    onGetPoll = nil;
    onGetAudio = nil;
    onGetContact = nil;
    onGetDice = nil;
    onGetGame = nil;
    onGetVideoNote = nil;
    onGetSticker = nil;
    onGetVoice = nil;

    -- Entities
    onGetEntities = nil;

    -- Error Handling
    onCommandErrorHandle = nil;
    onEventErrorHandle = nil;

    -- Request error hl
    onRequestErr = nil;

    -- Other
    onInformSpammer = nil;
    onUnknownUpdate = nil; 
}

return event
