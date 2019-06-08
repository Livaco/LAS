--[[
--  DarkRP Module.
]]--



--[[
--  Initialization
]]--

-- Register the Module.
Las.Modules.RegisterModule("Punishment", Color(255, 150, 0), "Allow admins to punish users.")

-- Register the permission nodes.
Las.Groups.RegisterPermissionNode("las.punishment.kick", "Kick Users", "Access to the kick command.")
Las.Groups.RegisterPermissionNode("las.punishment.ban", "Ban Users", "Access to the ban command.")
Las.Groups.RegisterPermissionNode("las.punishment.unban", "Unban Users", "Access to the unban command.")

-- Kick message.
local kickMessage = "You have been kicked!\n\nAdmin: %s(%s)\nReason: %s"

-- Ban message.
local banMessage = "You have been banned!\n\nAdmin: %s(%s)\nReason: %s\nTime: %s\nExpires at: %s\n\nAppeal this ban at https://www.exampleserverwebsite.com/appeal/"



--[[
--  Kick Command
]]--

Las.Modules.RegisterCommand("kick", "Kick a player from the server.", function(ply, args, cmdTable)
    if(!args[1]) then
        Las.Modules.SendMessage("Punishment", ply, "Please specify a player.")
        Las.Modules.SendMessage("Punishment", ply, "Help: " .. cmdTable.help)
        return
    end
    local target = Las.Modules.GetPlayer(args[1], ply)
    if(!target) then
        Las.Modules.SendMessage("Punishment", ply, "Player was not found.")
        Las.Modules.SendMessage("Punishment", ply, "Help: " .. cmdTable.help)
        return
    end

    if(!args[2]) then
        Las.Modules.SendMessage("Punishment", ply, "Please specify a reason.")
        Las.Modules.SendMessage("Punishment", ply, "Help: " .. cmdTable.help)
        return
    end

    local totalReason = args[2]
    for i=1,#args do
        if(i >= 3) then
            totalReason = totalReason .. " " .. args[i]
        end
    end

    Las.Modules.Log("Punishment", ply, " kicked ", target, " for the reason: ", Color(255, 165, 0), totalReason, Color(255, 255, 255, 255), ".")
    target:Kick(string.format(kickMessage, ply:Name(), ply:SteamID(), totalReason))
end, "Punishment", "las.punishment.kick", "!kick <player> <reason>")


--[[
--  Ban Command
--- NOTE: SQL Table for Bans is made in sv_sql.lua. If you wanted to use a SQL Table for your own command, you will need to create it manually yourself.
]]--

Las.Modules.RegisterCommand("ban", "Ban a player from the server.", function(ply, args, cmdTable)
    if(!args[1]) then
        Las.Modules.SendMessage("Punishment", ply, "Please specify a player.")
        Las.Modules.SendMessage("Punishment", ply, "Help: " .. cmdTable.help)
        return
    end
    local target = Las.Modules.GetPlayer(args[1], ply)
    if(!target) then
        Las.Modules.SendMessage("Punishment", ply, "Player was not found.")
        Las.Modules.SendMessage("Punishment", ply, "Help: " .. cmdTable.help)
        return
    end

    if(!args[2]) then
        Las.Modules.SendMessage("Punishment", ply, "Please specify a time.")
        Las.Modules.SendMessage("Punishment", ply, "Help: " .. cmdTable.help)
        return
    end

    if(!args[3]) then
        Las.Modules.SendMessage("Punishment", ply, "Please specify a reason.")
        Las.Modules.SendMessage("Punishment", ply, "Help: " .. cmdTable.help)
        return
    end

    if(string.sub(tostring(tonumber(args[2])), 1, 1) == "-") then -- ugly af but it works
        Las.Modules.SendMessage("Punishment", ply, "Number cannot be negitive.")
        Las.Modules.SendMessage("Punishment", ply, "Help: " .. cmdTable.help)
        return
    end

    local endStamp = 0
    if(tonumber(args[2])) then
        if(tonumber(args[2]) == 0) then
            endStamp = 253402300799
        else
            endStamp = tonumber(args[2])
        end
    else
        local timeType = string.lower(string.sub(args[2], #args[2], #args[2]))
        local timeInt = tonumber(string.sub(args[2], 1, #args[2] - 1))
        local secTime = 0
        if(timeType == "d") then
            secTime = timeInt * 60 * 60 * 24
        end
        if(timeType == "h") then
            secTime = timeInt * 60 * 60
        end
        if(timeType == "m") then
            secTime = timeInt * 60
        end
        endStamp = os.time() + secTime
    end

    local totalReason = args[3]
    for i=1,#args do
        if(i >= 4) then
            totalReason = totalReason .. " " .. args[i]
        end
    end

    Las.SQL.Query("INSERT INTO las_bans(User, USteamID, Admin, ASteamID, Reason, StartStamp, EndStamp) VALUES(" .. Las.SQL.FormatString(target:Name()) .. ", " .. Las.SQL.FormatString(target:SteamID()) .. ", " .. Las.SQL.FormatString(ply:Name()) .. ", " .. Las.SQL.FormatString(ply:SteamID()) .. ", " .. Las.SQL.FormatString(totalReason) .. ", " .. Las.SQL.FormatString(os.time()) .. ", " .. Las.SQL.FormatString(endStamp) .. ");")

    target:Kick(string.format(banMessage, ply:Name(), ply:SteamID(), totalReason, os.date("%H:%M:%S - %d/%m/%Y", os.time()), os.date("%H:%M:%S - %d/%m/%Y", endStamp)))
    if(endStamp != 253402300799) then
        Las.Modules.Log("Punishment", ply, " banned ", target, " for ", Color(255, 165, 0, 255), Las.Core.SecondsToTotal(os.difftime(endStamp, os.time())), Color(255, 255, 255, 255), " for the reason '", Color(255, 165, 0), totalReason, Color(255, 255, 255, 255), "'.")
    else
        Las.Modules.Log("Punishment", ply, " banned ", target, " permanently for the reason '", Color(255, 165, 0), totalReason, Color(255, 255, 255, 255), "'.")
    end
end, "Punishment", "las.punishment.ban", "!ban <player> <time> <reason>")

hook.Add("CheckPassword", "las.punishment.bancheck", function(sid64)
    local isBanned = false
    local banData = {}
    Las.SQL.Query("SELECT * FROM las_bans WHERE USteamID = " .. Las.SQL.FormatString(util.SteamIDFrom64(sid64)) .. ";", function(data)
        if(data != nil && data[1] != nil) then
            isBanned = true
            banData = data[1]
        end
    end)

    if(isBanned == true) then
        if(tonumber(banData.EndStamp) <= os.time()) then
            Las.SQL.Query("DELETE FROM las_bans WHERE USteamID = " .. Las.SQL.FormatString(util.SteamIDFrom64(sid64)) .. ";")
            return true
        else
            return false,string.format(banMessage, banData.Admin, banData.ASteamID, banData.Reason, os.date("%H:%M:%S - %d/%m/%Y", banData.StartStamp), os.date("%H:%M:%S - %d/%m/%Y", banData.EndStamp))
        end
    end
end)

-- TODO: Add BanID command.

--[[
--  Unban Command
--- NOTE: SQL Table for Bans is made in sv_sql.lua. If you wanted to use a SQL Table for your own command, you will need to create it manually yourself.
]]--

Las.Modules.RegisterCommand("unban", "Unban a player from the server.", function(ply, args, cmdTable)
    local SteamID = args[1]
    if(!args[1]) then
        Las.Modules.SendMessage("Punishment", ply, "Please specify a steamid.")
        Las.Modules.SendMessage("Punishment", ply, "Help: " .. cmdTable.help)
        return
    end
    local SteamID = args[1]
    if(args[5]) then
        SteamID = table.concat(args, "")
    end
    print(SteamID)

    local target = nil
    Las.SQL.Query("SELECT * FROM las_bans WHERE USteamID = " .. Las.SQL.FormatString(SteamID) .. ";", function(data)
        if(data != nil && data[1] != nil) then
            target = data[1].USteamID
        else
            target = nil
        end
    end)
    if(target == nil) then
        Las.Modules.SendMessage("Punishment", ply, "Player was not found.")
        Las.Modules.SendMessage("Punishment", ply, "Help: " .. cmdTable.help)
        return
    end

    Las.SQL.Query("DELETE FROM las_bans WHERE USteamID = " .. Las.SQL.FormatString(target) .. ";")
    Las.Modules.Log("Punishment", ply, " unbanned ", Color(255, 165, 0), target, Color(255, 255, 255, 255), ".")
end, "Punishment", "las.punishment.unban", "!unban <steamid>")