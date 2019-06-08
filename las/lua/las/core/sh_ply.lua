local meta = FindMetaTable("Player")

function meta:GetUserGroup()
    return Las.OnlineUsers[self:SteamID64()]
end

function meta:IsAdmin()
    if(Las.OnlineUsers[self:SteamID64()] == "admin") then
        return true
    else
        return false
    end
end

function meta:IsSuperAdmin()
    if(Las.OnlineUsers[self:SteamID64()] == "superadmin") then
        return true
    else
        return false
    end
end

function meta:IsUserGroup(group)
    if(Las.OnlineUsers[self:SteamID64()] == group) then
        return true
    else
        return false
    end
end
