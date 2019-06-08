-- The Discord Webhook configuration.
-- This is placed in a seperate file to prevent it being Scripthooked.

-- If this is true, it will attempt to use Discord Webhooks.
Las.Discord.Enabled = true

-- The URL to the proxy PHP script provided.
Las.Discord.Webhook = "http://www.example.com/discord_webhook.php"

-- The Password you specified. This needs to be the same as the one provided in the discord_webhook.php you uploaded to your website.
Las.Discord.Password = "super_secret_password"

-- Don't touch ANY of the rest of this file.






-- https://gameon365.net/topic/1886-lua-convert-rgb-colors-to-hex/ - Thanks.
local function RGBToHex(clr)
	return string.format("%.2X%.2X%.2X", clr.r, clr.g, clr.b)
end


function Las.Discord.SendMessage(moduleName, moduleColor, content)
    if(Las.Discord.Enabled == true) then
        http.Post(Las.Discord.Webhook, {password = Las.Discord.Password,
            module = moduleName,
            message = content,
            override_color = RGBToHex(moduleColor),
        }, function(r)
            print(r)
        end, function(f)
            Las.Core.Error("Could not connect to Discord Webhook Proxy. Check the URL given.")
        end)
    end
end

function Las.Discord.FormatPlayer(ply)
    return "[" .. ply:Name() .. " (" .. ply:SteamID() .. ")](https://steamcommunity.com/profiles/" .. ply:SteamID64() .. ")"
end