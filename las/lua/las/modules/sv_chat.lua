--[[
--  Chat Moderation Module.
]]--



--[[
--  Initialization
]]--

-- Register the Module.
Las.Modules.RegisterModule("Chat Moderation", Color(255, 150, 0), "The Chat Moderation module is designed to allow admins to moderate the chat, while also blocking unwanted words and more.")

-- Register the permission nodes.
Las.Groups.RegisterPermissionNode("las.chat.mute", "Mute", "Allows the mute command.")
Las.Groups.RegisterPermissionNode("las.chat.unmute", "Unmute", "Allows the unmute command.")
Las.Groups.RegisterPermissionNode("las.chat.gag", "Gag", "Allows the gag command.")
Las.Groups.RegisterPermissionNode("las.chat.ungag", "Ungag", "Allows the ungag command.")
Las.Groups.RegisterPermissionNode("las.chat.adminchat", "Admin Chat", "Allow the user to send messages to the Admin Chat.")
Las.Groups.RegisterPermissionNode("las.chat.viewadminchat", "View Admin Chat", "Allow the user to view messages from the Admin Chat.")


--[[
--  Mute Command
]]--

Las.Modules.RegisterCommand("mute", "Mute a player.", function(ply, args, cmdTable)
    if(!args[1]) then
        Las.Modules.SendMessage("Chat Moderation", ply, "Please specify a player.")
        Las.Modules.SendMessage("Chat Moderation", ply, "Help: " .. cmdTable.help)
        return
    end
    local target = Las.Modules.GetPlayer(args[1], ply)

    if(!target) then
        Las.Modules.SendMessage("Chat Moderation", ply, "Player was not found.")
        Las.Modules.SendMessage("Chat Moderation", ply, "Help: " .. cmdTable.help)
        return
    end

    target.LAS_Muted = true
    Las.Modules.Log("Chat Moderation", ply, " muted ", target, ".")
end, "Chat Moderation", "las.chat.mute", "!mute <player>")

Las.Modules.RegisterCommand("unmute", "Unmute a player.", function(ply, args, cmdTable)
    if(!args[1]) then
        Las.Modules.SendMessage("Chat Moderation", ply, "Please specify a player.")
        Las.Modules.SendMessage("Chat Moderation", ply, "Help: " .. cmdTable.help)
        return
    end
    local target = Las.Modules.GetPlayer(args[1], ply)

    if(!target) then
        Las.Modules.SendMessage("Chat Moderation", ply, "Player was not found.")
        Las.Modules.SendMessage("Chat Moderation", ply, "Help: " .. cmdTable.help)
        return
    end

    target.LAS_Muted = false
    Las.Modules.Log("Chat Moderation", ply, " unmuted ", target, ".")
end, "Chat Moderation", "las.chat.unmute", "!unmute <player>")

-- Hook
hook.Add("PlayerSay", "las.chat.mutecheck", function(ply, text)
    if(ply.LAS_Muted == true) then
        return ""
    end
end)


--[[
--  Gag Command
]]--

Las.Modules.RegisterCommand("gag", "Gag a player.", function(ply, args, cmdTable)
    if(!args[1]) then
        Las.Modules.SendMessage("Chat Moderation", ply, "Please specify a player.")
        Las.Modules.SendMessage("Chat Moderation", ply, "Help: " .. cmdTable.help)
        return
    end
    local target = Las.Modules.GetPlayer(args[1], ply)

    if(!target) then
        Las.Modules.SendMessage("Chat Moderation", ply, "Player was not found.")
        Las.Modules.SendMessage("Chat Moderation", ply, "Help: " .. cmdTable.help)
        return
    end

    target.LAS_Gagged = true
    Las.Modules.Log("Chat Moderation", ply, " gagged ", target, ".")
end, "Chat Moderation", "las.chat.gag", "!gag <player>")

Las.Modules.RegisterCommand("ungag", "Ungag a player.", function(ply, args, cmdTable)
    if(!args[1]) then
        Las.Modules.SendMessage("Chat Moderation", ply, "Please specify a player.")
        Las.Modules.SendMessage("Chat Moderation", ply, "Help: " .. cmdTable.help)
        return
    end
    local target = Las.Modules.GetPlayer(args[1], ply)

    if(!target) then
        Las.Modules.SendMessage("Chat Moderation", ply, "Player was not found.")
        Las.Modules.SendMessage("Chat Moderation", ply, "Help: " .. cmdTable.help)
        return
    end

    target.LAS_Gagged = false
    Las.Modules.Log("Chat Moderation", ply, " ungagged ", target, ".")
end, "Chat Moderation", "las.chat.ungag", "!ungag <player>")

-- Hook
hook.Add("PlayerCanHearPlayersVoice", "las.chat.gagcheck", function(listener, talker)
    if(talker.LAS_Gagged == true) then
        return false
    end
end)


--[[
--  Admin Chat Stuff
]]--

hook.Add("PlayerSay", "las.chat.adminchat", function(ply, text)
    -- las.chat.adminchat
    -- las.chat.viewadminchat
    if(string.sub(text, 1, 1) == Las.Settings.GetSetting("adminchat_prefix")) then
        if(ply:LasHasPermission("las.chat.adminchat") == true) then
            local color = util.JSONToTable(Las.Settings.GetSetting("chat_prefix_color"))
            for k,v in pairs(player.GetAll()) do
                if(v:LasHasPermission("las.chat.viewadminchat") == true) then
                    Las.Modules.SendMessage("Chat Moderation", v, Color(color.r, color.g, color.b, 255), "[Admin Chat] ", Color(255, 255, 255, 255), ply, ": ", string.sub(text, 2, #text))
                end
            end
            if(ply:LasHasPermission("las.chat.viewadminchat") == false) then
                Las.Modules.SendMessage("Chat Moderation", ply, Color(color.r, color.g, color.b, 255), "[Admin Chat] ", Color(255, 255, 255, 255), ply, ": ", string.sub(text, 2, #text))
            end
        else
            Las.Modules.SendMessage("Chat Moderation", ply, "You cannot post in the admin chat.")
        end
        return ""
    end
end)