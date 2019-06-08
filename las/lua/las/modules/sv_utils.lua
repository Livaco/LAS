--[[
--  Chat Moderation Module.
]]--



--[[
--  Initialization
]]--

-- Register the Module.
Las.Modules.RegisterModule("Utilities", Color(255, 150, 0), "The Utilities module is designed to give admins commands to manage player's items, names and others.")

-- Register the permission nodes.
Las.Groups.RegisterPermissionNode("las.utils.hp", "Health Command", "Allows access to the Health command.")
Las.Groups.RegisterPermissionNode("las.utils.armor", "Armor Command", "Allows access to the Armor command.")



--[[
--  Health Command
]]--

Las.Modules.RegisterCommand("health", "Set a player's health.", function(ply, args, cmdTable)
    if(!args[1]) then
        Las.Modules.SendMessage("Utilities", ply, "Please specify a player.")
        Las.Modules.SendMessage("Utilities", ply, "Help: " .. cmdTable.help)
        return
    end
    local target = Las.Modules.GetPlayer(args[1], ply)
    if(!target) then
        Las.Modules.SendMessage("Utilities", ply, "Player was not found.")
        Las.Modules.SendMessage("Utilities", ply, "Help: " .. cmdTable.help)
        return
    end
    if(!args[2]) then
        Las.Modules.SendMessage("Utilities", ply, "Please specify a health value.")
        Las.Modules.SendMessage("Utilities", ply, "Help: " .. cmdTable.help)
        return
    end

    if(string.sub(args[2], 1, 1) == "+") then
        local amount = string.sub(args[2], 2, #args[2])
        if(!tonumber(amount)) then
            Las.Modules.SendMessage("Utilities", ply, "Invalid amount of health to add.")
            Las.Modules.SendMessage("Utilities", ply, "Help: " .. cmdTable.help)
        end
        target:SetHealth(target:Health() + tonumber(amount))
        Las.Modules.Log("Utilities", ply, " added ", Color(255, 165, 0), args[2], Color(255, 255, 255, 255), " to the health of ", target, ".")
        return
    end
    if(string.sub(args[2], 1, 1) == "-") then
        local amount = string.sub(args[2], 2, #args[2])
        if(!tonumber(amount)) then
            Las.Modules.SendMessage("Utilities", ply, "Invalid amount of health to remove.")
            Las.Modules.SendMessage("Utilities", ply, "Help: " .. cmdTable.help)
        end
        if(target:Health() - tonumber(amount) <= 0) then
            Las.Modules.SendMessage("Utilities", ply, "Cannot remove that much health. Value would result in below 0.")
            return
        end
        target:SetHealth(target:Health() - tonumber(amount))
        Las.Modules.Log("Utilities", ply, " removed ", Color(255, 165, 0), args[2], Color(255, 255, 255, 255), " from the health of ", target, ".")
        return
    end
    if(tonumber(args[2])) then
        target:SetHealth(tonumber(args[2]))
        Las.Modules.Log("Utilities", ply, " set the health of ", target, " to ", Color(255, 165, 0), args[2], Color(255, 255, 255, 255), ".")
        return
    end

    Las.Modules.SendMessage("Utilities", ply, "Invalid health value.")
    Las.Modules.SendMessage("Utilities", ply, "Help: " .. cmdTable.help)
end, "Utilities", "las.utils.hp", "!health <player> <arthmetic operator>")

Las.Modules.RegisterCommand("hp", "Alias of !health", Las.RegisteredCommands["health"].callback, "Utilities", "las.utils.hp", "!hp <player> <arthmetic operator>")


--[[
--  Armor Command
]]--

Las.Modules.RegisterCommand("armor", "Set a player's armor.", function(ply, args, cmdTable)
    if(!args[1]) then
        Las.Modules.SendMessage("Utilities", ply, "Please specify a player.")
        Las.Modules.SendMessage("Utilities", ply, "Help: " .. cmdTable.help)
        return
    end
    if(!args[2]) then
        Las.Modules.SendMessage("Utilities", ply, "Please specify a armor value.")
        Las.Modules.SendMessage("Utilities", ply, "Help: " .. cmdTable.help)
        return
    end

    local target = Las.Modules.GetPlayer(args[1], ply)
    if(!target) then
        Las.Modules.SendMessage("Utilities", ply, "Player was not found.")
        Las.Modules.SendMessage("Utilities", ply, "Help: " .. cmdTable.help)
        return
    end
    if(string.sub(args[2], 1, 1) == "+") then
        local amount = string.sub(args[2], 2, #args[2])
        if(!tonumber(amount)) then
            Las.Modules.SendMessage("Utilities", ply, "Invalid amount of armor to add.")
            Las.Modules.SendMessage("Utilities", ply, "Help: " .. cmdTable.help)
        end
        target:SetArmor(target:Armor() + tonumber(amount))
        Las.Modules.Log("Utilities", ply, " added ", Color(255, 165, 0), args[2], Color(255, 255, 255, 255), " to the armor of ", target, ".")
        return
    end
    if(string.sub(args[2], 1, 1) == "-") then
        local amount = string.sub(args[2], 2, #args[2])
        if(!tonumber(amount)) then
            Las.Modules.SendMessage("Utilities", ply, "Invalid amount of armor to remove.")
            Las.Modules.SendMessage("Utilities", ply, "Help: " .. cmdTable.help)
        end
        if(target:Armor() - tonumber(amount) <= 0) then
            Las.Modules.SendMessage("Utilities", ply, "Cannot remove that much armor. Value would result in below 0.")
            return
        end
        target:SetArmor(target:Armor() - tonumber(amount))
        Las.Modules.Log("Utilities", ply, " removed ", Color(255, 165, 0), args[2], Color(255, 255, 255, 255), " from the armor of ", target, ".")
        return
    end
    if(tonumber(args[2])) then
        target:SetArmor(tonumber(args[2]))
        Las.Modules.Log("Utilities", ply, " set the armor of ", target, " to ", Color(255, 165, 0), args[2], Color(255, 255, 255, 255), ".")
        return
    end

    Las.Modules.SendMessage("Utilities", ply, "Invalid armor value.")
    Las.Modules.SendMessage("Utilities", ply, "Help: " .. cmdTable.help)
end, "Utilities", "las.utils.armor", "!armor <player> <arthmetic operator>")