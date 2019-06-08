--[[
--  Misc Module.
]]--



--[[
--  Initialization
]]--

-- Register the Module.
Las.Modules.RegisterModule("Groups", Color(255, 150, 0), "Commands for managing Groups.")

-- Register the permission nodes.
Las.Groups.RegisterPermissionNode("las.groups.setgroup", "Setgroup", "Access to the setgroup command.")
Las.Groups.RegisterPermissionNode("las.groups.getgroup", "Getgroup", "Access to the getgroup command.")



--[[
--  SetGroup Command
]]--

Las.Modules.RegisterCommand("setgroup", "Sets the players group.", function(ply, args, cmdTable)
    if(!args[1]) then
        Las.Modules.SendMessage("Groups", ply, "Please specify a player.")
        Las.Modules.SendMessage("Groups", ply, "Help: " .. cmdTable.help)
        return
    end
    local target = Las.Modules.GetPlayer(args[1], ply)
    if(!target) then
        Las.Modules.SendMessage("Groups", ply, "Player was not found.")
        Las.Modules.SendMessage("Groups", ply, "Help: " .. cmdTable.help)
        return
    end

    if(!args[2]) then
        Las.Modules.SendMessage("Groups", ply, "Please specify a usergroup.")
        Las.Modules.SendMessage("Groups", ply, "Help: " .. cmdTable.help)
        return
    end

    target:SetUserGroup(args[2])

    Las.Modules.Log("Groups", ply, " set the group of ", target, " to ", Color(255, 165, 0), args[2], Color(255, 255, 255, 255), ".")
end, "Groups", "las.groups.setgroup", "!setgroup <player> <groupname>")

Las.Modules.RegisterCommand("setaccess", "Alias of !setgroup", Las.RegisteredCommands["setgroup"].callback, "Groups", "las.groups.setgroup", "!setaccess <player> <groupname>")


--[[
--  GetGroup Command
]]--

Las.Modules.RegisterCommand("getgroup", "Gets the players group.", function(ply, args, cmdTable)
    if(!args[1]) then
        Las.Modules.SendMessage("Groups", ply, "Please specify a player.")
        Las.Modules.SendMessage("Groups", ply, "Help: " .. cmdTable.help)
        return
    end
    local target = Las.Modules.GetPlayer(args[1], ply)
    if(!target) then
        Las.Modules.SendMessage("Groups", ply, "Player was not found.")
        Las.Modules.SendMessage("Groups", ply, "Help: " .. cmdTable.help)
        return
    end

    Las.Modules.SendMessage("Groups", ply, "The usergroup of ", target, " is ", target:GetUserGroup(), ".")
end, "Groups", "las.groups.getgroup", "!getgroup <player>")

Las.Modules.RegisterCommand("getaccess", "Alias of !getgroup", Las.RegisteredCommands["getgroup"].callback, "Groups", "las.groups.getgroup", "!getaccess <player>")