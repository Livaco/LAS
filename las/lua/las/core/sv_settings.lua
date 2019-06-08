function Las.Settings.AddSetting(key, value)
    Las.SQL.Query("INSERT OR IGNORE INTO las_settings(ConfigKey, ConfigValue) VALUES(" .. Las.SQL.FormatString(key) .. ", " .. Las.SQL.FormatString(value) .. ");")
end

function Las.Settings.Populate()
    Las.Settings.AddSetting("first_run", "0") -- Simply allows me to track when the addon is being ran for the first time or not.

    Las.Settings.AddSetting("chat_prefix", "[LAS]") -- Chat Prefix
    Las.Settings.AddSetting("chat_prefix_color", util.TableToJSON(Color(255, 100, 0, 255))) -- Chat Prefix Color
    Las.Settings.AddSetting("default_group", "user") -- Default Usergroup when players join.
    Las.Settings.AddSetting("command_prefix", "!") -- Command prefix.
    Las.Settings.AddSetting("adminchat_prefix", "@") -- Admin Chat prefix.
end

function Las.Settings.GetSetting(key)
    local returnValue = ""
    Las.SQL.Query("SELECT * FROM las_settings WHERE ConfigKey = " .. Las.SQL.FormatString(key) .. ";", function(data)
        if(data != nil && data[1] != nil) then
            returnValue = data[1].ConfigValue
        else
            returnValue = nil
        end
    end)
    return returnValue
end

function Las.Settings.SetSetting(key, value)
    Las.SQL.Query("UPDATE las_settings SET ConfigValue = " .. Las.SQL.FormatString(value) .. " WHERE ConfigKey = " .. Las.SQL.FormatString(key) .. ";")
end

hook.Add("las.core.sqlpopulate", "las.settings.populatehook", Las.Settings.Populate)