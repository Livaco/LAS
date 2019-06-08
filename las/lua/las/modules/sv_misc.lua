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