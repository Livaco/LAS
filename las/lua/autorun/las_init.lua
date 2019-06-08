Las = {}
Las.Build = Las.Build or {}
Las.Core = Las.Core or {}
Las.Settings = Las.Settings or {}
Las.Groups = Las.Groups or {}
Las.Users = Las.Users or {}
Las.Colors = Las.Colors or {}
Las.SQL = Las.SQL or {}
Las.Discord = Las.Discord or {}
Las.UI = Las.UI or {}
Las.Modules = Las.Modules or {}
Las.RegisteredModules = Las.RegisteredModules or {}
Las.RegisteredCommands = Las.RegisteredCommands or {}
Las.RegisteredPermissionNodes = Las.RegisteredPermissionNodes or {}
Las.OnlineUsers = Las.OnlineUsers or {}

-- Wow thats alot of tables.

Las.Build.Version = "0.1.0"
Las.Build.Revision = "08/06/2019"

Las.Colors.PrintPrefix = Color(255, 255, 0)
Las.Colors.PrintHighlight = Color(255, 255, 100)

function Las.Core.Print(...)
    local args = {...}
    MsgC(Las.Colors.PrintPrefix, "[LAS] ")
    MsgC(Color(255, 255, 255, 255), unpack(args))
    MsgC("\n")
end

if(SERVER) then
    Las.Core.Print("Loading Livaco's Admin System.")
    Las.Core.Print("")

    hook.Remove("PlayerInitialSpawn", "PlayerAuthSpawn")

    Las.Core.Print("Loading core files.")

    local svFiles = file.Find("las/core/sv_*.lua", "LUA")
    Las.Core.Print("Found " .. #svFiles .. " serverside core files.")
    for k,v in pairs(svFiles) do
        Las.Core.Print("    " .. v)
        include("las/core/" .. v)
    end

    local shFiles = file.Find("las/core/sh_*.lua", "LUA")
    Las.Core.Print("Found " .. #shFiles .. " shared core files.")
    for k,v in pairs(shFiles) do
        Las.Core.Print("    " .. v)
        include("las/core/" .. v)
        AddCSLuaFile("las/core/" .. v)
    end

    local clFiles = file.Find("las/core/cl_*.lua", "LUA")
    Las.Core.Print("Found " .. #clFiles .. " clientside core files.")
    for k,v in pairs(clFiles) do
        Las.Core.Print("    " .. v)
        AddCSLuaFile("las/core/" .. v)
    end

    Las.Core.Print("")

    Las.Core.Print("Loading config file.")

    include("las/config/config.lua")

    Las.Core.Print("")

    Las.Core.Print("Allowing population of SQL Database.")
    hook.Run("las.core.sqlpopulate")
    Las.Core.Print("")

    Las.Core.Print("")
    Las.Core.Print("Loading module files.")

    local moduleFiles = file.Find("las/modules/*.lua", "LUA")
    Las.Core.Print("Found " .. #moduleFiles .. " module files.")
    for k,v in pairs(moduleFiles) do
        Las.Core.Print("    " .. v)
        include("las/modules/" .. v)
    end

    Las.Core.Print("")
    Las.Settings.SetSetting("first_run", "1")
    Las.Core.Print("Loaded Livaco's Admin System.")
else
    Las.Core.Print("Loading Livaco's Admin System.")
    Las.Core.Print("")

    Las.Core.Print("Loading cores files.")

    local shFiles = file.Find("las/core/sh_*.lua", "LUA")
    Las.Core.Print("Found " .. #shFiles .. " shared core files.")
    for k,v in pairs(shFiles) do
        Las.Core.Print("    " .. v)
        include("las/core/" .. v)
    end

    local clFiles = file.Find("las/core/cl_*.lua", "LUA")
    Las.Core.Print("Found " .. #clFiles .. " clientside core files.")
    for k,v in pairs(clFiles) do
        Las.Core.Print("    " .. v)
        include("las/core/" .. v)
    end

    Las.Core.Print("")
    Las.Core.Print("Loaded Livaco's Admin System.")
end