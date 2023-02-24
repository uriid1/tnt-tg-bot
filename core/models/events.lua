--[[
    ####--------------------------------####
    #--# Author:   by uriid1            #--#
    #--# License:  GNU GPLv3            #--#
    #--# Telegram: @main_moderator      #--#
    #--# E-mail:   appdurov@gmail.com   #--#
    ####--------------------------------####
--]]
local f = function() end

local event = {
    -- Update
    ["onChosenInlineResult"] = f;
    ["ShippingQuery"] = f;
    ["PreCheckoutQuery"] = f;
    ["onPoll"] = f;
    ["onPollAnswer"] = f;
    ["onMyChatMember"] = f;
    ["onChatMember"] = f;
    ["onChatJoinRequest"] = f;
    ["onChannelPost"] = f;
    ["onEditedChannelPost"] = f;

    ["onEditedMessage"] = f;
    ["onGetMessage"] = f;
    ["onGetMessageText"] = f;
    ["onInlineQuery"] = f;

    -- Chat
    ["onSenderChat"] = f;
    ["onNewChatTitle"] = f;
    ["onNewChatPhoto"] = f;
    ["onDeleteChatPhoto"] = f;
    ["onGroupChatCreated"] = f;
    ["onSupergroupChatCreated"] = f;
    ["onChannelChatCreated"] = f;
    ["onMigrateToChatId"] = f;
    ["onMigrateFromChatId"] = f;
    ["onNewChatMember"] = f;
    ["onLeftChatMember"] = f;

    -- Payment
    ["onInvoice"] = f;
    ["onSuccessfulPayment"] = f;

    -- Passport
    ["onPassportData"] = f;

    -- Video Chat
    ["onVideoChatScheduled"] = f;
    ["onVideoChatStarted"] = f;
    ["onVideoChatEnded"] = f;
    ["onVideoChatParticipantsInvited"] = f;

    -- Forward
    ["onForwardFrom"] = f;
    ["onForwardFromChat"] = f;

    -- Via bot
    ["onViaBot"] = f;

    -- Media
    ["onGetPhoto"] = f;
    ["onGetVideo"] = f;
    ["onGetAnimation"] = f;
    ["onGetDocument"] = f;
    ["onGetLocation"] = f;
    ["onGetPoll"] = f;
    ["onGetAudio"] = f;
    ["onGetContact"] = f;
    ["onGetDice"] = f;
    ["onGetGame"] = f;
    ["onGetVideoNote"] = f;
    ["onGetSticker"] = f;

    -- Entities
    ["onGetEntityMention"] = f;
    ["onGetEntityHashtag"] = f;
    ["onGetEntityCashtag"] = f;
    ["onGetEntityUrl"] = f;
    ["onGetEntityEmail"] = f;
    ["onGetEntityPhone"] = f;
    ["onGetEntityFormattedText"] = f;
    ["onGetVoice"] = f;

    -- Error Handling
    ["onCommandErrorHandle"] = f;
    ["onEventErrorHandle"] = f;

    -- Request error hl
    ["onRequestErrUnauthorized"] = f;
    ["onRequestErrTooManyRequests"] = f;
    ["onRequestErrMigrateToChat"] = f;

    -- Other
    ["onInformSpammer"] = f;
    ["onUnknownUpdate"] = f; 
}

return event
