--[[
--  Teleport Module.
]]--



--[[
--  Initialization
]]--

-- Register the Module.
Las.Modules.RegisterModule("Teleport", Color(255, 150, 0), "Commands for moving players.")

-- Register the permission nodes.
Las.Groups.RegisterPermissionNode("las.teleport.goto", "Goto", "Access to the goto command.")
Las.Groups.RegisterPermissionNode("las.teleport.bring", "Bring", "Access to the bring command.")
Las.Groups.RegisterPermissionNode("las.teleport.return", "Bring", "Access to the bring command.")



--[[
--  Goto Command
]]--

Las.Modules.RegisterCommand("goto", "Teleports to the player.", function(ply, args, cmdTable)
    if(!args[1]) then
        Las.Modules.SendMessage("Teleport", ply, "Please specify a player.")
        Las.Modules.SendMessage("Teleport", ply, "Help: " .. cmdTable.help)
        return
    end
    local target = Las.Modules.GetPlayer(args[1], ply)
    if(!target) then
        Las.Modules.SendMessage("Teleport", ply, "Player was not found.")
        Las.Modules.SendMessage("Teleport", ply, "Help: " .. cmdTable.help)
        return
    end

    if(ply:InVehicle()) then
        ply:ExitVehicle()
    end

    ply.LAS_ReturnPos = ply:GetPos()
    ply.LAS_ReturnAng = ply:EyeAngles()
    ply:SetPos(target:GetPos() + (target:GetForward() * -50))
    ply:SetEyeAngles(target:EyeAngles())

    Las.Modules.Log("Teleport", ply, " teleported to ", target, ".")
end, "Teleport", "las.teleport.goto", "!goto <player>")


--[[
--  Bring Command
]]--

Las.Modules.RegisterCommand("bring", "Brings the player.", function(ply, args, cmdTable)
    if(!args[1]) then
        Las.Modules.SendMessage("Teleport", ply, "Please specify a player.")
        Las.Modules.SendMessage("Teleport", ply, "Help: " .. cmdTable.help)
        return
    end
    local target = Las.Modules.GetPlayer(args[1], ply)
    if(!target) then
        Las.Modules.SendMessage("Teleport", ply, "Player was not found.")
        Las.Modules.SendMessage("Teleport", ply, "Help: " .. cmdTable.help)
        return
    end

    if(target:InVehicle()) then
        target:ExitVehicle()
    end

    target.LAS_ReturnPos = target:GetPos()
    target.LAS_ReturnAng = target:EyeAngles()
    target:SetPos(ply:GetPos() + (ply:GetForward() * 50))
    target:SetEyeAngles(ply:EyeAngles())

    Las.Modules.Log("Teleport", ply, " teleported ", target, " to them.")
end, "Teleport", "las.teleport.bring", "!bring <player>")


--[[
--  Return Command
]]--

Las.Modules.RegisterCommand("return", "Returns the player.", function(ply, args, cmdTable)
    if(!args[1]) then
        Las.Modules.SendMessage("Teleport", ply, "Please specify a player.")
        Las.Modules.SendMessage("Teleport", ply, "Help: " .. cmdTable.help)
        return
    end
    local target = Las.Modules.GetPlayer(args[1], ply)
    if(!target) then
        Las.Modules.SendMessage("Teleport", ply, "Player was not found.")
        Las.Modules.SendMessage("Teleport", ply, "Help: " .. cmdTable.help)
        return
    end

    if(target.LAS_ReturnPos == nil) then
        Las.Modules.SendMessage("Teleport", ply, "Player does not have a previous location.")
        Las.Modules.SendMessage("Teleport", ply, "Help: " .. cmdTable.help)
        return
    end

    if(target:InVehicle()) then
        target:ExitVehicle()
    end

    target:SetPos(target.LAS_ReturnPos)
    if(target.LAS_ReturnAng != false) then
        target:SetEyeAngles(target.LAS_ReturnAng)
    end
    target.LAS_ReturnPos = nil
    target.LAS_ReturnAng = nil

    Las.Modules.Log("Teleport", ply, " returned ", target, " to their original location.")
end, "Teleport", "las.teleport.return", "!return <player>")