--[[
--  DarkRP Module.
]]--



--[[
--  Initialization
]]--

-- Register the Module.
Las.Modules.RegisterModule("DarkRP", Color(255, 150, 0), "Simply allows admins to edit users DarkRP stats or settings.")

-- Register the permission nodes.
Las.Groups.RegisterPermissionNode("las.darkrp.wallet", "Set Money", "Access to the money command.")
Las.Groups.RegisterPermissionNode("las.darkrp.setname", "Set Job", "Access to the setjob command.")



--[[
--  Wallet Command
]]--

Las.Modules.RegisterCommand("wallet", "Set a players DarkRP Money.", function(ply, args, cmdTable)
    -- Just make sure we are actually running DarkRP. If we aren't then return end.
    if(!DarkRP) then return end

    if(!args[1]) then
        Las.Modules.SendMessage("DarkRP", ply, "Please specify a player.")
        Las.Modules.SendMessage("DarkRP", ply, "Help: " .. cmdTable.help)
        return
    end
    local target = Las.Modules.GetPlayer(args[1], ply)
    if(!target) then
        Las.Modules.SendMessage("DarkRP", ply, "Player was not found.")
        Las.Modules.SendMessage("DarkRP", ply, "Help: " .. cmdTable.help)
        return
    end

    if(!args[2]) then
        Las.Modules.SendMessage("Utilities", ply, "Please specify a money value.")
        Las.Modules.SendMessage("Utilities", ply, "Help: " .. cmdTable.help)
        return
    end

    if(string.sub(args[2], 1, 1) == "+") then
        local amount = string.sub(args[2], 2, #args[2])
        if(!tonumber(amount)) then
            Las.Modules.SendMessage("DarkRP", ply, "Invalid amount of money to add.")
            Las.Modules.SendMessage("DarkRP", ply, "Help: " .. cmdTable.help)
        end
        target:addMoney(tonumber(amount))
        Las.Modules.Log("DarkRP", ply, " added ", Color(255, 165, 0), "$", args[2], Color(255, 255, 255, 255), " to the wallet of ", target, ".")
        return
    end
    if(string.sub(args[2], 1, 1) == "-") then
        local amount = string.sub(args[2], 2, #args[2])
        if(!tonumber(amount)) then
            Las.Modules.SendMessage("DarkRP", ply, "Invalid amount of money to remove.")
            Las.Modules.SendMessage("DarkRP", ply, "Help: " .. cmdTable.help)
        end
        if(target:getDarkRPVar("money") - tonumber(amount) <= 0) then
            Las.Modules.SendMessage("DarkRP", ply, "Cannot remove that much money. Value would result in below 0.")
            return
        end
        target:addMoney(tonumber(args[2]))
        Las.Modules.Log("DarkRP", ply, " removed ", Color(255, 165, 0), "$", args[2], Color(255, 255, 255, 255), " from the wallet of ", target, ".")
        return
    end
    if(tonumber(args[2])) then
        target:addMoney(-target:getDarkRPVar("money") + tonumber(args[2]))
        Las.Modules.Log("DarkRP", ply, " set the wallet of ", target, " to ", Color(255, 165, 0), "$", args[2], Color(255, 255, 255, 255), ".")
        return
    end

    Las.Modules.SendMessage("DarkRP", ply, "Invalid money value.")
    Las.Modules.SendMessage("DarkRP", ply, "Help: " .. cmdTable.help)
end, "DarkRP", "las.darkrp.wallet", "!wallet <player> <arthmetic operator>")

Las.Modules.RegisterCommand("setmoney", "Alias of !wallet", Las.RegisteredCommands["wallet"].callback, "DarkRP", "las.darkrp.wallet", "!setmoney <player> <arthmetic operator>")


--[[
--  Set Name Command
]]--

Las.Modules.RegisterCommand("setname", "Set a players RPName.", function(ply, args, cmdTable)
    -- Just make sure we are actually running DarkRP. If we aren't then return end.
    if(!DarkRP) then return end

    if(!args[1]) then
        Las.Modules.SendMessage("DarkRP", ply, "Please specify a player.")
        Las.Modules.SendMessage("DarkRP", ply, "Help: " .. cmdTable.help)
        return
    end
    local target = Las.Modules.GetPlayer(args[1], ply)
    if(!target) then
        Las.Modules.SendMessage("DarkRP", ply, "Player was not found.")
        Las.Modules.SendMessage("DarkRP", ply, "Help: " .. cmdTable.help)
        return
    end

    if(!args[2]) then
        Las.Modules.SendMessage("Utilities", ply, "Please specify a name.")
        Las.Modules.SendMessage("Utilities", ply, "Help: " .. cmdTable.help)
        return
    end

    local totalName = ""
    for i=1,#args do
        if(i >= 2) then
            totalName = totalName .. args[k]
        end
    end

    ply:setRPName(totalName)
    Las.Modules.Log("DarkRP", ply .. " set the name of ", target, " to ", Color(255, 165, 0), totalName, Color(255, 255, 255, 255) ".")
end, "DarkRP", "las.darkrp.setname", "!setname <player> <new name>")

Las.Modules.RegisterCommand("setalias", "Alias of !setname", Las.RegisteredCommands["setname"].callback, "DarkRP", "las.darkrp.setname", "!setalias <player> <new name>")
Las.Modules.RegisterCommand("setrpname", "Alias of !setname", Las.RegisteredCommands["setname"].callback, "DarkRP", "las.darkrp.setname", "!setrpname <player> <new name>")