--[[
--  Misc Module.
]]--



--[[
--  Initialization
]]--

-- Register the Module.
Las.Modules.RegisterModule("Misc", Color(255, 150, 0), "Misc commands.")

-- Register the permission nodes.
Las.Groups.RegisterPermissionNode("las.misc.cloak", "Cloak", "Access to the cloak command.")
Las.Groups.RegisterPermissionNode("las.misc.uncloak", "Uncloak", "Access to the uncloak command.")
Las.Groups.RegisterPermissionNode("las.misc.freeze", "Freeze", "Access to the freeze command.")
Las.Groups.RegisterPermissionNode("las.misc.unfreeze", "Unfreeze", "Access to the unfreeze command.")
Las.Groups.RegisterPermissionNode("las.misc.cleardecals", "Cleardecals", "Access to the cleardecals command.")
Las.Groups.RegisterPermissionNode("las.misc.physgun", "Physgun Players", "Allows the player to pick up players with their physgun.")



--[[
--  Cloak Command
]]--

Las.Modules.RegisterCommand("cloak", "Cloaks the player.", function(ply, args, cmdTable)
    if(!args[1]) then
        args[1] = "^"
    end
    local target = Las.Modules.GetPlayer(args[1], ply)
    if(!target) then
        Las.Modules.SendMessage("Misc", ply, "Player was not found.")
        Las.Modules.SendMessage("Misc", ply, "Help: " .. cmdTable.help)
        return
    end

    target:DrawShadow(false)
	target:SetMaterial("models/effects/vol_light001")
	target:SetRenderMode(RENDERMODE_TRANSALPHA)
    Las.Modules.Log("Misc", ply, " cloaked ", target, ".")
end, "Misc", "las.misc.cloak", "!cloak <player>")

Las.Modules.RegisterCommand("hide", "Alias of !cloak", Las.RegisteredCommands["cloak"].callback, "Misc", "las.misc.cloak", "!hide <player>")


--[[
--  Uncloak Command
]]--

Las.Modules.RegisterCommand("uncloak", "Uncloaks the player.", function(ply, args, cmdTable)
    if(!args[1]) then
        args[1] = "^"
    end
    local target = Las.Modules.GetPlayer(args[1], ply)
    if(!target) then
        Las.Modules.SendMessage("Misc", ply, "Player was not found.")
        Las.Modules.SendMessage("Misc", ply, "Help: " .. cmdTable.help)
        return
    end

    target:DrawShadow(true)
	target:SetMaterial("")
	target:SetRenderMode(RENDERMODE_NORMAL)
    Las.Modules.Log("Misc", ply, " uncloaked ", target, ".")
end, "Misc", "las.misc.uncloak", "!uncloak <player>")


--[[
--  Freeze Command
]]--

Las.Modules.RegisterCommand("freeze", "Freeze the player.", function(ply, args, cmdTable)
    if(!args[1]) then
        Las.Modules.SendMessage("Misc", ply, "Please specify a player.")
        Las.Modules.SendMessage("Misc", ply, "Help: " .. cmdTable.help)
        return
    end
    local target = Las.Modules.GetPlayer(args[1], ply)
    if(!target) then
        Las.Modules.SendMessage("Misc", ply, "Player was not found.")
        Las.Modules.SendMessage("Misc", ply, "Help: " .. cmdTable.help)
        return
    end
    if(target.LAS_Frozen == true) then
        Las.Modules.SendMessage("Misc", ply, "Player is already frozen.")
        return
    end

    target:Lock()
    target.LAS_Frozen = true
    Las.Modules.Log("Misc", ply, " froze ", target, ".")
end, "Misc", "las.misc.freeze", "!freeze <player>")


--[[
--  Unfreeze Command
]]--

Las.Modules.RegisterCommand("unfreeze", "Unfreeze the player.", function(ply, args, cmdTable)
    if(!args[1]) then
        Las.Modules.SendMessage("Misc", ply, "Please specify a player.")
        Las.Modules.SendMessage("Misc", ply, "Help: " .. cmdTable.help)
        return
    end
    local target = Las.Modules.GetPlayer(args[1], ply)
    if(!target) then
        Las.Modules.SendMessage("Misc", ply, "Player was not found.")
        Las.Modules.SendMessage("Misc", ply, "Help: " .. cmdTable.help)
        return
    end
    if(target.LAS_Frozen == false) then
        Las.Modules.SendMessage("Misc", ply, "Player is not frozen.")
        return
    end

    target:UnLock()
    target.LAS_Frozen = false
    Las.Modules.Log("Misc", ply, " unfroze ", target, ".")
end, "Misc", "las.misc.unfreeze", "!unfreeze <player>")


--[[
--  Cleardecals Command
]]--

Las.Modules.RegisterCommand("cleardecals", "Clears all decals.", function(ply, args, cmdTable)
    for k,v in pairs(player.GetAll()) do
        v:ConCommand("r_cleardecals")
    end
    Las.Modules.Log("Misc", ply, " cleared all decals.")
end, "Misc", "las.misc.cleardecals", "!cleardecals")


--[[
--  Steamid Command
]]--

Las.Modules.RegisterCommand("steamid", "Get the players steamid.", function(ply, args, cmdTable)
    if(!args[1]) then
        Las.Modules.SendMessage("Misc", ply, "Please specify a player.")
        Las.Modules.SendMessage("Misc", ply, "Help: " .. cmdTable.help)
        return
    end
    local target = Las.Modules.GetPlayer(args[1], ply)
    if(!target) then
        Las.Modules.SendMessage("Misc", ply, "Player was not found.")
        Las.Modules.SendMessage("Misc", ply, "Help: " .. cmdTable.help)
        return
    end

    Las.Modules.SendMessage("Misc", ply, "The SteamID of ", target, " is ", Color(255, 165, 0), target:SteamID(), Color(255, 255, 255, 255), ".")
end, "Misc", "las.misc.unfreeze", "!unfreeze <player>")


--[[
--  Physgun Pickup
]]--

hook.Add("PhysgunPickup", "las.misc.pickupplayers", function(ply, target)
    if(!target:IsPlayer()) then return end
    if(ply:LasHasPermission("las.misc.physgun") == true) then
        target:SetMoveType(MOVETYPE_NONE)
        return true
    end
end)

hook.Add("PhysgunDrop", "las.misc.dropplayers", function(ply, target)
    if(!target:IsPlayer()) then return end
    if(ply:LasHasPermission("las.misc.physgun") == true) then
        target:SetMoveType(MOVETYPE_WALK)
        target:SetLocalVelocity(Vector(0, 0, 0))
    end
end)