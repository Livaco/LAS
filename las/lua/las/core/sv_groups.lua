function Las.Groups.RegisterUserGroup(name, permissions)
    local id = string.lower(string.Replace(name, " ", ""))
    if(Las.Groups.GroupExists(name)) then
        Las.Core.Error("Tried to add a group that already existed. Cancelling.")
    end
    Las.SQL.Query("INSERT OR IGNORE INTO las_groups(GroupID, GroupName, Permissions) VALUES(" .. Las.SQL.FormatString(id) .. ", " .. Las.SQL.FormatString(name) .. ", " .. Las.SQL.FormatString(util.TableToJSON(permissions)) .. ");")
end

function Las.Groups.GroupExists(id)
    local returnValue = false
    Las.SQL.Query("SELECT * FROM las_groups WHERE GroupID = " .. Las.SQL.FormatString(id) .. ";", function(data)
        if(data != nil && data[1] != nil) then
            returnValue = true
        else
            returnValue = false
        end
    end)
    return returnValue
end

function Las.Groups.GivePermission(id, node)
    if(Las.Groups.GroupExists(id)) then
        local permTable = "none"
        Las.SQL.Query("SELECT * FROM las_groups WHERE GroupID = " .. Las.SQL.FormatString(id) .. ";", function(data)
            if(data != nil && data[1] != nil) then
                permTable = util.JSONToTable(data[1].Permissions)
            end
        end)
        table.insert(permTable, node)
        Las.SQL.Query("UPDATE las_groups SET Permissions = " .. Las.SQL.FormatString(util.TableToJSON(perm_table)) .. " WHERE GroupID = " .. Las.SQL.FormatString(id) .. ";")
    end
end

function Las.Groups.RegisterPermissionNode(key, name, desc, defaultGroups)
    if(Las.RegisteredPermissionNodes[key]) then
        Las.Core.Error("Tried to register permission node " .. key .. ", but it was already registed.")
    end
    Las.RegisteredPermissionNodes[key] = {
        name = name,
        desc = desc
    }

    if(defaultGroups) then
        for k,v in pairs(defaultGroups) do
            if(Las.Groups.GroupExists(v)) then
                -- TODO: Add permission node to said group.
            end
        end
    end
end

function Las.Groups.SyncOnlineCL()
    net.Start("las.core.updateclonlinetable")
    net.WriteTable(Las.OnlineUsers)
    net.Broadcast()
end

hook.Add("las.core.sqlpopulate", "las.groups.setupdefaultgroups", function()
    if(Las.Settings.GetSetting("first_run") != "0") then return end
    Las.Groups.RegisterUserGroup("User", {
        "las.chat.adminchat",
    })
    Las.Groups.RegisterUserGroup("Admin", {
        "las.chat.adminchat",
        "las.chat.gag",
        "las.chat.mute",
        "las.chat.ungag",
        "las.chat.unmute",
        "las.chat.viewadminchat",
        "las.chat.mute",
        "las.darkrp.setname",
        "las.darkrp.wallet",
        "las.groups.getgroup",
        "las.misc.cloak",
        "las.misc.freeze",
        "las.misc.cleardecals",
        "las.misc.physgun",
        "las.misc.uncloak",
        "las.misc.unfreeze",
        "las.punishment.ban",
        "las.punishment.kick",
        "las.punishment.unban",
        "las.teleport.goto",
        "las.teleport.bring",
        "las.teleport.return",
        "las.utils.armor",
        "las.utils.hp",
        "las.utils.respawn"
    })
    Las.Groups.RegisterUserGroup("Super Admin", {
        "las.chat.adminchat",
        "las.chat.gag",
        "las.chat.mute",
        "las.chat.ungag",
        "las.chat.unmute",
        "las.chat.viewadminchat",
        "las.chat.mute",
        "las.core.seesilent",
        "las.darkrp.setname",
        "las.darkrp.wallet",
        "las.groups.getgroup",
        "las.groups.setgroup",
        "las.misc.cloak",
        "las.misc.freeze",
        "las.misc.cleardecals",
        "las.misc.physgun",
        "las.misc.uncloak",
        "las.misc.unfreeze",
        "las.punishment.ban",
        "las.punishment.kick",
        "las.punishment.unban",
        "las.teleport.goto",
        "las.teleport.bring",
        "las.teleport.return",
        "las.utils.armor",
        "las.utils.hp",
        "las.utils.respawn",
        "las.utils.strip"
    })
end)

local plymeta = FindMetaTable("Player")
function plymeta:SetUserGroup(group)
    if(!Las.Groups.GroupExists(group)) then
        Las.Core.Error("Tried to set a player to a unregistered or invalid usergroup.")
        return
    end
    Las.OnlineUsers[self:SteamID64()] = group
    Las.Groups.SyncOnlineCL()
    Las.SQL.Query("UPDATE las_users SET UserGroup = " .. Las.SQL.FormatString(group) .. " WHERE SteamID64 = " .. Las.SQL.FormatString(self:SteamID64()) .. ";")
    Las.Core.Message(self, "Your usergroup has been updated to ", Color(255, 165, 0), group, Color(255, 255, 255, 255), ".")
end

function plymeta:LasHasPermission(node)
    if(Las.Core.FullAccessUsers[self:SteamID()]) then
        return true
    end
    local perms = ""
    Las.SQL.Query("SELECT * FROM las_groups WHERE GroupID = " .. Las.SQL.FormatString(self:GetUserGroup()) .. ";", function(data)
        if(data != nil && data[1] != nil) then
            perms = util.JSONToTable(data[1].Permissions)
        else
            perms = "none"
        end
    end)
    if(perms == "none") then
        Las.Core.Error("User " .. self:Name() .. " has invalid/non-existent group. Discovered while checking nodes.")
        return false
    end

    return table.HasValue(perms, node)
end


-- Core permission nodes.
Las.Groups.RegisterPermissionNode("las.core.seesilent", "See Silent Logs", "Allows the user to see silent logs.")