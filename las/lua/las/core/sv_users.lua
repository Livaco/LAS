function Las.Users.RegisterUser(ent)
    if(Las.Users.GetUserInfo(ent:SteamID()) != nil) then return end
    Las.SQL.Query("INSERT INTO las_users(SteamID64, SteamID, Name, IP, UserGroup) VALUES(" .. Las.SQL.FormatString(ent:SteamID64()) .. ", " .. Las.SQL.FormatString(ent:SteamID()) .. ", " .. Las.SQL.FormatString(ent:Name()) .. ", " .. Las.SQL.FormatString(ent:IPAddress()) .. ", " .. Las.SQL.FormatString(Las.Settings.GetSetting("default_group")) .. ");")

    Las.Core.Print("Registered new user ", Las.Colors.PrintHighlight, ent:Name(), " (", ent:SteamID(), " | ", ent:IPAddress(), ")", Color(255, 255, 255, 255), " into the database.")
end

function Las.Users.GetUserInfo(sid)
    local sidtype = "64"
    if(!tonumber(sid)) then
        sidtype = "32"
    end
    if(sidtype == "32") then
        if(string.sub(sid, 1, 6) != "STEAM_") then
            Las.Core.Error("Unable to get user data. Invalid SteamID: ", Las.Colors.PrintHighlight, sid)
            return nil
        end
    end

    local q = "SELECT * FROM las_users WHERE"
    if(sidtype == "32") then
        q = q .. " SteamID = " .. Las.SQL.FormatString(sid)
    else
        q = q .. " SteamID64 = " .. Las.SQL.FormatString(sid)
    end

    local value = nil
    Las.SQL.Query(q, function(data)
        if(data != nil && data[1] != nil) then
            value = data[1]
        else
            value = nil
        end
    end)
    return value
end

function Las.Users.SetUserGroup(sid, id)
    if(!Las.Groups.GroupExists(id)) then
        Las.Core.Error("Unable to set steamid ", Las.Colors.PrintHighlight, sid, Color(255, 255, 255, 255), " to group ", Las.Colors.PrintHighlight, id, Color(255, 255, 255, 255), ". Group ID is not registered.")
        return
    end
    Las.SQL.Query("UPDATE las_users SET UserGroup = " .. Las.SQL.FormatString(sid) .. " WHERE SteamID64 = " .. Las.SQL.FormatString(sid) .. ";")
end

hook.Add("PlayerInitialSpawn", "las.core.registeruser", Las.Users.RegisterUser)