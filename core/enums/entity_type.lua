--[[
    ####--------------------------------####
    #--# Author:   by uriid1            #--#
    #--# License:  GNU GPLv3            #--#
    #--# Telegram: @main_moderator      #--#
    #--# E-mail:   appdurov@gmail.com   #--#
    ####--------------------------------####
--]]

-- https://core.telegram.org/bots/api#messageentity
local entity_type = {
	MENTION = 'mention';
	HASHTAG = 'hashtag';
	CASHTAG = 'cashtag';
	BOT_COMMAND = 'bot_command';
	URL = 'url';
	EMAIL = 'email';
	PHONE_NUMBER = 'phone_number';
	BOLD = 'bold';
	ITALIC = 'italic';
	UNDERLINE = 'underline';
	STRIKETHROUGH = 'strikethrough';
	SPOILER = 'spoiler';
	CODE = 'code';
	PRE = 'pre';
	TEXT_LINK = 'text_link';
	TEXT_MENTION = 'text_mention';
	CUSTOM_EMOJI = 'custom_emoji';
}

return entity_type
