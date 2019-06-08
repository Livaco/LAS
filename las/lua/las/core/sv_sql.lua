-- The MySQL/SQLite configuration.
-- This is placed in a seperate file to prevent it being Scripthooked.

-- TODO: MySQL IS NOT IMPLEMENTED YET. IT WILL BE SOON. DON"T TRY TO USE IT AS IT WON'T WORK.

-- If this is true, it will attempt to use a MySQL database.
Las.SQL.UseSQLoo = false

-- The details for your MySQL server.
Las.SQL.Details = {}
Las.SQL.Details["username"] = "root" -- Username
Las.SQL.Details["password"] = "" -- Password
Las.SQL.Details["host"] = "localhost" -- The host
Las.SQL.Details["dbname"] = "las_database" -- The database name you wish to use.

-- Don't touch ANY of the rest of this file.





function Las.SQL.StartupChecks()
    if(Las.SQL.UseSQLoo == true) then

    else
        Las.Core.Print("Starting SQLite checks.")

        Las.Core.Print("")
        Las.Core.Print("Table ", Las.Colors.PrintHighlight, "las_settings", Color(255, 255, 255, 255), ".")
        if(!sql.TableExists("las_settings")) then
            Las.SQL.Query("CREATE TABLE las_settings(ConfigKey TEXT PRIMARY KEY, ConfigValue TEXT);")
            Las.Core.Print("Table has been created.")
        end
        Las.Core.Print("")

        Las.Core.Print("")
        Las.Core.Print("Table ", Las.Colors.PrintHighlight, "las_groups", Color(255, 255, 255, 255), ".")
        if(!sql.TableExists("las_groups")) then
            Las.SQL.Query("CREATE TABLE las_groups(GroupID TEXT PRIMARY KEY, GroupName TEXT, Permissions TEXT);")
            Las.Core.Print("Table has been created.")
        end
        Las.Core.Print("")

        Las.Core.Print("")
        Las.Core.Print("Table ", Las.Colors.PrintHighlight, "las_users", Color(255, 255, 255, 255), ".")
        if(!sql.TableExists("las_users")) then
            Las.SQL.Query("CREATE TABLE las_users(SteamID64 TEXT PRIMARY KEY, SteamID TEXT, Name TEXT, IP TEXT, UserGroup TEXT);")
            Las.Core.Print("Table has been created.")
        end
        Las.Core.Print("")

        Las.Core.Print("")
        Las.Core.Print("Table ", Las.Colors.PrintHighlight, "las_bans", Color(255, 255, 255, 255), ".")
        if(!sql.TableExists("las_bans")) then
            Las.SQL.Query("CREATE TABLE las_bans(User TEXT, USteamID TEXT, Admin TEXT, ASteamID TEXT, Reason TEXT, StartStamp TEXT, EndStamp TEXT);")
            Las.Core.Print("Table has been created.")
        end
        Las.Core.Print("")

        Las.Core.Print("SQLite has been setup.")
    end
end

function Las.SQL.Query(q, callbackFunction)
    if(Las.SQL.UseSQLoo == true) then

    else
        local queryResult = sql.Query(q)
        if(queryResult == false) then
            Las.Core.Error("SQLite query returned false. SQL: ")
            Las.Core.Error(q)
            if(callbackFunction) then
                Las.Core.Error("Callback function may generate errors.")
            end
            return
        end
        if(callbackFunction) then
            callbackFunction(queryResult)
        end
    end
end

function Las.SQL.FormatString(string)
    if(Las.SQL.UseSQLoo == true) then

    else
        return sql.SQLStr(string)
    end
end


Las.SQL.StartupChecks()