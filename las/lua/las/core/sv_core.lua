util.AddNetworkString("las.core.message")
util.AddNetworkString("las.core.openui")
util.AddNetworkString("las.core.updateclonlinetable")

function Las.Core.Error(...)
    local args = {...}
    table.insert(args, 1, Color(255, 0, 0, 255))
    table.insert(args, 2, "[Error] ")
    table.insert(args, 3, Color(255, 255, 255, 255))

    Las.Core.Print(unpack(args))
end

function Las.Core.Message(ply, ...)
    local args = {...}
    local color = util.JSONToTable(Las.Settings.GetSetting("chat_prefix_color"))
    table.insert(args, 1, Color(color.r, color.g, color.b, 255))
    table.insert(args, 2, Las.Settings.GetSetting("chat_prefix") .. " ")
    table.insert(args, 3, Color(255, 255, 255, 255))

    net.Start("las.core.message")
    net.WriteTable(args)
    net.Send(ply)
end

local RunLasVersionCheck = false
hook.Add("PlayerInitialSpawn", "las.core.versioncheck", function() -- Done on first player join to avoid ISteamHTTP Not Available error.
    Las.Core.Print("Running version check.")
    http.Post("https://api.livaco.dev/version_checker.php", {addon="las", version=Las.Build.Version}, function(r)
        Las.Core.Print(r)
    end)
    RunLasVersionCheck = true
end)

hook.Add("PlayerSay", "las.core.uicommand", function(ply, text, team)
    if(string.lower(string.sub(text, 1, 4)) == "!las") then
        net.Start("las.core.openui")
        net.Send(ply)
        Las.Core.Message(ply, "Loading...")
    end
end)

hook.Add("PlayerInitialSpawn", "las.core.regiseruseronline", function(ply)
    if(Las.Users.GetUserInfo(ply:SteamID()) == nil) then
        Las.OnlineUsers[ply:SteamID64()] = Las.Settings.GetSetting("default_group")
        return
    end
    Las.OnlineUsers[ply:SteamID64()] = Las.Users.GetUserInfo(ply:SteamID()).UserGroup
end)

hook.Add("PlayerDisconnected", "las.core.regiseruseroffline", function(ply)
    Las.OnlineUsers[ply:SteamID64()] = nil
end)

function Las.Core.SecondsToTotal(seconds)
    if(seconds >= 31540000) then
        local years = math.floor(seconds / 31540000)
        if(years > 1) then
            return years .. " years"
        else
            return years .. " year"
        end
    end
    if(seconds >= 2628000) then
        local months = math.floor(seconds / 2628000)
        if(months > 1) then
            return months .. " months"
        else
            return months .. " month"
        end
    end
    if(seconds >= 604800) then
        local weeks = math.floor(seconds / 604800)
        if(weeks > 1) then
            return weeks .. " weeks"
        else
            return weeks .. " week"
        end
    end
    if(seconds >= 86400) then
        local days = math.floor(seconds / 86400)
        if(days > 1) then
            return days .. " days"
        else
            return days .. " day"
        end
    end
    if(seconds >= 3600) then
        local hours = math.floor(seconds / 3600)
        if(hours > 1) then
            return hours .. " hours"
        else
            return hours .. " hour"
        end
    end
    if(seconds >= 60) then
        local minutes = math.floor(seconds / 60)
        if(minutes > 1) then
            return minutes .. " minutes"
        else
            return minutes .. " minute"
        end
    end

    if(seconds > 1) then
        return seconds .. " seconds"
    else
        return seconds .. " second"
    end

    return nil
end

concommand.Add("las", function(ply, cmd, args, argsS)
    local console = false
    if(!IsValid(ply)) then
        console = true
    end
    if(!args[1]) then
        if(console == false) then
            Las.Core.Message(ply, "Livaco's Admin System (LAS) - " .. Las.Build.Version .. " (" .. Las.Build.Revision .. ")")
            Las.Core.Message(ply, "Use 'las help' to learn about LAS.")
        else
            Las.Core.Print("Livaco's Admin System (LAS) - " .. Las.Build.Version .. " (" .. Las.Build.Revision .. ")")
            Las.Core.Print("Use 'las help' to learn about LAS.")
        end
    end

    if(args[1] == "help") then
        if(console == false) then
            Las.Core.Message(ply, "---- >>   LAS Help   << -----")
            Las.Core.Message(ply, "")
            Las.Core.Message(ply, "------ >>   General   << ------")
            Las.Core.Message(ply, "debug - Shows debug commands.")
            Las.Core.Message(ply, "help - Shows the Help menu.")
            Las.Core.Message(ply, "")
            Las.Core.Message(ply, "------ >>   Commands   << -----")
            for k,v in pairs(Las.RegisteredCommands) do
                Las.Core.Message(ply, k, " - ", v.desc)
            end
        else
            Las.Core.Print("----- >> LAS Help Page << -----")
            Las.Core.Print("")
            Las.Core.Print("------ >>   General   << ------")
            Las.Core.Print("debug - Shows debug commands.")
            Las.Core.Print("help - Shows the Help menu.")
            Las.Core.Print("")
            Las.Core.Print("------ >>   Commands   << -----")
            for k,v in pairs(Las.RegisteredCommands) do
                Las.Core.Print(k, " - ", v.desc)
            end
        end
    end

    if(args[1] == "setgroup") then
        if(!args[2]) then
            if(console == false) then
                Las.Core.Message(ply, "Specify a username.")
            else
                Las.Core.Print("Specify a username.")
            end
        else
            local target = Las.Modules.GetPlayer(args[2])
            if(!target) then
                if(console == false) then
                    Las.Core.Message(ply, "That player cannot be found.")
                else
                    Las.Core.Print("That player cannot be found.")
                end
            else
                if(!args[3]) then
                    if(console == false) then
                        Las.Core.Message(ply, "Specify a usergroup id.")
                    else
                        Las.Core.Print("Specify a usergroup id.")
                    end
                end
                target:SetUserGroup(args[3])
                if(console == false) then
                    Las.Core.Message(ply, "Set the user " .. args[2] .. " to " .. args[3])
                else
                    Las.Core.Print("Set the user " .. args[2] .. " to " .. args[3])
                end
            end
        end
    end

    local cmd = Las.Modules.GetCommand(args[1])
    if(cmd) then
        table.remove(args, 1)
        cmd.callback(ply, args, cmd)
    end
end)