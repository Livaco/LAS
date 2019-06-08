function Las.Modules.RegisterModule(name, color, desc)
    if(!name) then
        Las.Core.Error("Invalid Module (unknown). Attempted to create module without a name.")
        return
    end
    if(!color) then
        Las.Core.Error("Invalid Module (" .. name .. "). Attempted to create module without a color.")
        return
    end
    if(!desc) then
        Las.Core.Error("Invalid Module (" .. name .. "). Attempted to create module without a description.")
        return
    end

    Las.RegisteredModules[name] = {
        color = color,
        desc = desc
    }
end

function Las.Modules.Log(moduleName, ...)
    if(!moduleName or Las.RegisteredModules[moduleName] == nil) then
        Las.Core.Error("Invalid Module (unknown). Attempted to create config option without valid module.")
        return
    end

    local args = {...}
    Las.Core.Print(Las.Colors.PrintHighlight, "[", moduleName, "] ", Color(255, 255, 255, 255), unpack(args))

    local discordString = ""
    for k,v in pairs(args) do
        if(type(v) == "string") then
            discordString = discordString .. v
        end
        if(type(v) == "Player") then
            discordString = discordString .. Las.Discord.FormatPlayer(v)
        end
    end
    Las.Discord.SendMessage(moduleName, Las.RegisteredModules[moduleName].color, discordString)
    for k,v in pairs(player.GetAll()) do
        Las.Modules.SendMessage(moduleName, v, unpack(args))
    end
end

function Las.Modules.SendMessage(moduleName, ply, ...)
    if(!moduleName or Las.RegisteredModules[moduleName] == nil) then
        Las.Core.Error("Invalid Module (unknown). Attempted to send message without specifying a Module Name.")
        return
    end

    local args = {...}
    local color = util.JSONToTable(Las.Settings.GetSetting("chat_prefix_color"))
    table.insert(args, 1, Color(color.r, color.g, color.b, 255))
    table.insert(args, 2, "[" .. moduleName .. "] ")
    table.insert(args, 3, Color(255, 255, 255, 255))
    Las.Core.Message(ply, unpack(args))
end

function Las.Modules.RegisterCommand(name, desc, callback, module, node, help)
    if(!module or Las.RegisteredModules[module] == nil) then
        Las.Core.Error("Invalid Module (unknown). Attempted to create command without valid module.")
        return
    end
    if(!name) then
        Las.Core.Error("Invalid Module (" .. module .. "). Attempted to create command without valid name.")
        return
    end
    if(!desc) then
        Las.Core.Error("Invalid Module (" .. module .. "). Attempted to create command without valid description.")
        return
    end
    if(!callback) then
        Las.Core.Error("Invalid Module (" .. module .. "). Attempted to create command without valid callback.")
        return
    end
    if(!node or Las.RegisteredPermissionNodes[node] == nil) then
        Las.Core.Error("Invalid Module (" .. module .. "). Attempted to create command without valid permission node.")
        return
    end
    if(!help) then
        Las.Core.Error("Invalid Module (" .. module .. "). Attempted to create command without valid help message.")
        return
    end
    if(Las.RegisteredCommands[name]) then
        Las.Core.Error("Invalid Module (" .. module .. "). Attempted to create command that already existed.")
        return
    end

    Las.RegisteredCommands[name] = {
        desc = desc,
        callback = callback,
        module = module,
        node = node,
        help = help
    }
end

function Las.Modules.GetCommand(name)
    return Las.RegisteredCommands[name] or nil
end

function Las.Modules.GetPlayer(hint, admin)
    if(!hint) then
        return nil
    end
    if(admin) then
        if(hint == "^") then -- Self
            return admin
        end
        if(hint == "@") then -- Looking at
            local target = admin:GetEyeTrace().Entity
            if(target:IsPlayer()) then
                return target
            else
                return nil
            end
        end
    end
    if(hint == "$") then -- Random Person
        return player.GetAll()[math.random(#player.GetAll())]
    end

    -- I've not added SID64 support as it's simply almost impossible to detect if it's a sid64 or someone with a all number username or some shit.
    if(string.sub(hint, 1, 6) == "STEAM_") then
        local sid = util.SteamIDTo64(hint)
        return player.GetBySteamID64(sid)
    end

    for k,v in pairs(player.GetAll()) do
		if(string.find(string.lower(v:Name()), string.lower(hint))) then
			return v
		end
	end

    return nil
end

-- Stole this from Owain's xAdmin and motified to make consistent looking code. https://github.com/OwjoTheGreat/xadmin/blob/master/lua/xadmin/core/sv_core.lua#L116
-- Sorry Owain <3
function Las.Modules.FormatArguments(args)
	local start,cEnd = nil,nil

	for k, v in pairs(args) do
		if (string.sub(v, 1, 1) == "\"") then
			start = k
		elseif start and (string.sub(v, string.len(v), string.len(v)) == "\"") then
			cEnd = k
			break
		end
	end

	if(start and cEnd) then
		args[start] = string.Trim(table.concat(args, " ", start, cEnd), "\"")

		for i = 1, (cEnd - start) do
			table.remove(args, start + 1)
		end

		args = Las.Modules.FormatArguments(args)
	end

	return args
end

hook.Add("PlayerSay", "las.core.commands", function(ply, text)
    if(string.sub(text, 1, 1) == Las.Settings.GetSetting("command_prefix")) then
        local args = Las.Modules.FormatArguments(string.Explode(" ", text))
        local cmd = Las.Modules.GetCommand(string.sub(args[1], 2, #args[1]))
        if(cmd) then
            if(ply:LasHasPermission(cmd.node) == false) then
                Las.Core.Message(ply, "You do not have the permission node '", Color(255, 165, 0), cmd.node, Color(255, 255, 255, 255), "' required to run this command.")
            else
                table.remove(args, 1)
                cmd.callback(ply, args, cmd)
            end
        end
    end
end)