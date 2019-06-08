-- The login details for your MySQL database are to be configured in las/core/sv_sql.lua
-- The Discord Webhook is configured in las/core/sv_discord.lua
-- It's in there so it can't be scripthooked. I know its a bit of a pain but it has to be that way for security.



-- This is a list of SteamID's that will always have full access to anything, regardless of usergroup. This is for security purposes, incase someone attempts to hijack your server or something else.
Las.Core.FullAccessUsers = {}
Las.Core.FullAccessUsers["STEAM_0:1:80376292"] = true
Las.Core.FullAccessUsers["STEAM:1:1111111111"] = true

-- And this is a list of SteamID's that are immune to everything.
Las.Core.ImmuneUsers = {}
Las.Core.ImmuneUsers["STEAM:1:1111111111"] = true


-- The rest of the configuration is done ingame. Use !las (by default) to access the menu.