YAWS.Language.Languages = YAWS.Language.Languages or {}

-- Only enable this if your testing translations. 
-- For more info: https://www.gmodstore.com/help/addon/yet-another-warning-system-yaws-user-warning-and-punishment-system/other-6/topics/become-a-translator-2
YAWS.Language.TRANSLATOR_MODE = false

if(CLIENT) then 
    YAWS.Language.PreparedJobs = {}
    YAWS.Language.Manifest = YAWS.Language.Manifest or {}
    YAWS.Language.WaitingForRequest = false

    hook.Add("InitPostEntity", "yaws.language.fetchshit", function()
        if(YAWS.Language.TRANSLATOR_MODE) then
            YAWS.Language.SelectLanguage()
            hook.Run("yaws.language.manifsetloaded")
        end 

        http.Fetch("https://raw.githubusercontent.com/LivacoNew/Addon-Translations/master/YAWS/versions.json", function(body, size, headers, code)
            -- just make it a bit easier to parse
            body = string.Replace(body, "\n", "")
            body = string.Replace(body, "  ", "")
            
            local data = util.JSONToTable(body)
            if(!data) then return end
            -- YAWS.Language.Languages['English'] = data

            local verString = YAWS.Version.Major .. "." .. YAWS.Version.Minor .. "." .. YAWS.Version.Patch
            if(!data[verString]) then
                -- Find the next last version's translation
                local curMajor = 0
                local curMinor = 0
                local curPatch = 0

                for k,v in pairs(data) do
                    local version = string.Explode(".", k)
                    version[1] = tonumber(version[1])
                    version[2] = tonumber(version[2])
                    version[3] = tonumber(version[3])

                    if(version[1] != curMajor) then
                        if(curMajor < version[1]) then
                            curMajor = version[1]
                        end
                    end
                    if(version[2] != curMinor) then
                        if(curMinor < version[2]) then
                            curMinor = version[2]
                        end
                    end
                    if(version[3] != curPatch) then
                        if(curPatch < version[3]) then
                            curPatch = version[3]
                        end
                    end
                end

                local verString = curMajor .. "." .. curMinor .. "." .. curPatch
                YAWS.Language.Manifest = data[verString]
                YAWS.Core.LogInfo("Couldn't find translation pack for current version.")
                YAWS.Core.LogInfo("Using last available one: ", verString, " - Current version ", YAWS.Version.Release, "")
                YAWS.Core.LogInfo("(In 99.999% of cases, this message is normal and can be ignored)")
            else 
                YAWS.Language.Manifest = data[verString]
            end 

            YAWS.Language.SelectLanguage()
            hook.Run("yaws.language.manifsetloaded")
        end, function(error)
            YAWS.Core.LogWarning("Can't find the Language Manifest. Resetting to English.")
        end)
    end)

    function YAWS.Language.GetTranslation(key)
        if(!YAWS.Language.Languages[YAWS.Language.Language or "English"]) then 
            if(YAWS.Language.WaitingForRequest) then 
                return "Loading new Language..."
            end

            YAWS.Core.LogWarning("Can't find the Language selected. Resorting to English.")
            YAWS.Language.SendRawMessage("Can't find the Language selected. Resorting to English.")
            YAWS.UserSettings.SetValue("selected_language", "English")
            YAWS.Language.Language = "English"
        end 
        if(!YAWS.Language.Languages[YAWS.Language.Language or "English"][key]) then 
            YAWS.Core.LogWarning("Can't find the requested translation. Assuming translation is incomplete for this version of YAWS, resorting to english.")
            YAWS.Core.LogWarning("Missing translation: " .. key)
            YAWS.Language.SendRawMessage("Can't find the requested translation. Assuming translation is incomplete for this version of YAWS, resorting to english.")
            YAWS.UserSettings.SetValue("selected_language", "English")
            YAWS.Language.Language = "English"
        end 
        return YAWS.Language.Languages[YAWS.Language.Language or "English"][key]
    end 
    -- This is here for the context menu, that can sometimes call it too early
    -- and cause errors
    function YAWS.Language.GetTranslationSafe(key)
        if(table.Count(YAWS.Language.Languages) <= 0) then return "" end
        if(!YAWS.Language.Languages[YAWS.Language.Language or "English"]) then return "" end
        
        return YAWS.Language.Languages[YAWS.Language.Language or "English"][key]
    end 
    function YAWS.Language.GetFormattedTranslation(key, ...)
        if(!YAWS.Language.Languages[YAWS.Language.Language]) then 
            if(YAWS.Language.WaitingForRequest) then 
                return "Loading new Language..."
            end 

            YAWS.Core.LogWarning("Can't find the Language selected. Resorting to English.")
            YAWS.Language.SendRawMessage("Can't find the Language selected. Resorting to English.")
            YAWS.UserSettings.SetValue("selected_language", "English")
            YAWS.Language.Language = "English"
        end 
        if(!YAWS.Language.Languages[YAWS.Language.Language][key]) then 
            YAWS.Core.LogWarning("Can't find the requested translation. Assuming translation is incomplete for this version of YAWS, resorting to english.")
            YAWS.Core.LogWarning("Missing translation: " .. key)
            YAWS.Language.SendRawMessage("Can't find the requested translation. Assuming translation is incomplete for this version of YAWS, resorting to english.")
            YAWS.UserSettings.SetValue("selected_language", "English")
            YAWS.Language.Language = "English"
        end 
        
        return string.format(YAWS.Language.GetTranslation(key), unpack({...}))
    end 
    
    function YAWS.Language.SelectLanguage()
        if(YAWS.Language.TRANSLATOR_MODE) then
            local json = file.Read("yaws_language_dev.json")
            if(!json) then 
                YAWS.Core.LogError("Warning: Loading development language failed (File not found)")
                YAWS.Core.LogError("Using the addon might produce errors!")
                YAWS.Language.SendRawMessage("Warning: Loading development language failed (File not found)")
                YAWS.Language.SendRawMessage("Using the addon might produce errors!")
                return
            end
            
            if(!pcall(util.JSONToTable, json)) then -- yes this means it runs twice but error checking is kinda needed here
                YAWS.Core.LogError("Warning: Loading development language failed (Invalid JSON)")
                YAWS.Core.LogError("Using the addon might produce errors!")
                YAWS.Language.SendRawMessage("Warning: Loading development language failed (Invalid JSON)")
                YAWS.Language.SendRawMessage("Using the addon might produce errors!")
                return
            end

            local data = util.JSONToTable(json)
            if(!data) then
                YAWS.Core.LogError("Warning: Loading development language failed (Invalid JSON)")
                YAWS.Core.LogError("Using the addon might produce errors!")
                YAWS.Language.SendRawMessage("Warning: Loading development language failed (Invalid JSON)")
                YAWS.Language.SendRawMessage("Using the addon might produce errors!")
                return
            end

            YAWS.Language.Languages["test_lang"] = data
            YAWS.Language.Language = "test_lang"

            YAWS.Core.LogInfo("Loaded test language.")
            YAWS.Language.SendRawMessage("Loaded test language.")

            return
        end 

        YAWS.Language.WaitingForRequest = true
        YAWS.Language.Language = YAWS.UserSettings.GetValue("selected_language")
        
        local needsReopening = false
        if(YAWS.UI.CurrentData) then 
            if(YAWS.UI.CurrentData.FrameCache) then 
                YAWS.UI.CurrentData.FrameCache:Remove()
                needsReopening = true
            end
        end
        if(YAWS.Language.Language == "English") then
            if(!YAWS.UI.CurrentData) then return end 
            if(needsReopening) then 
                YAWS.UI.CoreUI(true)
            end 
            return
        end

        -- https://raw.githubusercontent.com/LivacoNew/YAWS-Translations/master/en.json
        -- No, this isn't a backdoor. This is just the translation stuff being loaded in from the github. It's litreally json lol
        http.Fetch(YAWS.Language.Manifest[YAWS.Language.Language].file, function(body, size, headers, code)
            -- just make it a bit easier to parse
            body = string.Replace(body, "\n", "")
            body = string.Replace(body, "  ", "")
            
            if(!pcall(util.JSONToTable, body)) then -- yes this means it runs twice but error checking is kinda needed here
                YAWS.Core.LogWarning("Invalid JSON. Resorting to English.")
                YAWS.Language.SendRawMessage("Invalid JSON. Resorting to English.")
                YAWS.UserSettings.SetValue("selected_language", "English")
                YAWS.Language.Language = "English"
                YAWS.Language.WaitingForRequest = false
                return
            end

            local data = util.JSONToTable(body)
            if(!data) then
                YAWS.Core.LogWarning("Invalid JSON. Resorting to English.")
                YAWS.Language.SendRawMessage("Invalid JSON. Resorting to English.")
                YAWS.UserSettings.SetValue("selected_language", "English")
                YAWS.Language.Language = "English"
                YAWS.Language.WaitingForRequest = false
                return
            end
            -- YAWS.Language.Languages['English'] = data

            YAWS.Language.Languages[YAWS.Language.Language] = data
            if(needsReopening) then
                YAWS.UI.CoreUI(true)
            end

            YAWS.Core.LogInfo(YAWS.Language.Language, " Translation authored by:")
            for k,v in pairs(data.authors) do
                YAWS.Core.LogInfo(" - ", v)
            end

            YAWS.Language.WaitingForRequest = false
            hook.Run("yaws.language.updated")
        end, function(error)
            YAWS.Core.LogWarning("Can't find the Language selected. Resorting to English.")
            YAWS.Language.SendRawMessage("Can't find the Language selected. Resorting to English.")
            YAWS.UserSettings.SetValue("selected_language", "English")
            YAWS.Language.Language = "English"
        end)
    end 

    hook.Add("yaws.usersettings.updated", "yaws.languages.change", function(key, val)
        if(key != "selected_language") then return end 
        YAWS.Language.SelectLanguage()

        hook.Run("yaws.language.updated")
    end)
    -- hook.Add("yaws.usersettings.created", "yaws.languages.setup", function()
    --     YAWS.Language.SelectLanguage()
    -- end)

    hook.Add("yaws.config.clientready", "yaws.language.clientisready", function()
        if(!YAWS.Language.PreparedJobs) then return end 
        
        if(#YAWS.Language.PreparedJobs <= 0) then 
            YAWS.Language.PreparedJobs = nil -- micro-optimisations for the win
            return
        end 

        for _, job in pairs(YAWS.Language.PreparedJobs) do
            if(job.raw) then 
                YAWS.Language.SendRawMessage(job.message)
                continue
            end 

            YAWS.Language.SendMessage(job.key, unpack(job.options))
        end
        YAWS.Language.PreparedJobs = nil
    end)

    function YAWS.Language.SendMessage(key, ...)
        if(!YAWS.Config.ClientReady) then -- Pre-config is ready checks. Prevents prefix from being wrong on join.
            YAWS.Language.PreparedJobs[#YAWS.Language.PreparedJobs + 1] = {
                key = key,
                options = {...}
            }
            return
        end 
        
        local col = YAWS.Config.GetValue("prefix_color")
        chat.AddText(Color(col.r, col.g, col.b), YAWS.Config.GetValue("prefix"), " ", YAWS.Config.GetValue("chat_color"), YAWS.Language.GetFormattedTranslation(key, unpack({...})))
    end 
    function YAWS.Language.SendRawMessage(message)
        if(!YAWS.Config.ClientReady) then -- Pre-config is ready checks. Prevents prefix from being wrong on join.
            YAWS.Language.PreparedJobs[#YAWS.Language.PreparedJobs + 1] = {
                raw = true,
                message = message
            }
            return
        end 

        local col = YAWS.Config.GetValue("prefix_color")
        chat.AddText(Color(col.r, col.g, col.b), YAWS.Config.GetValue("prefix"), " ", YAWS.Config.GetValue("chat_color"), message)
    end 

    net.Receive("yaws.language.sendmessage", function(len)
        YAWS.Core.PayloadDebug("yaws.language.sendmessage", len)
        local key = net.ReadString()
        
        local args = {}
        local hasArgs = net.ReadBool()
        if(hasArgs) then 
            local length = net.ReadUInt(16)
            local data = net.ReadData(length)
            
            args = util.JSONToTable(util.Decompress(data))
        end 
        
        YAWS.Language.SendMessage(key, unpack(args))
    end)
    net.Receive("yaws.language.sendrawmessage", function(len)
        YAWS.Core.PayloadDebug("yaws.language.sendrawmessage", len)
        YAWS.Language.SendRawMessage(net.ReadString())
    end)

    if(YAWS.Language.TRANSLATOR_MODE) then 
        concommand.Add("yaws_resetlang", function(ply, cmd, args)
            if(!YAWS.Language.TRANSLATOR_MODE) then 
                YAWS.Core.LogWarning("Translator mode not activated.")
                return
            end 

            YAWS.Language.SelectLanguage()
        end)
    end 
else 
    util.AddNetworkString("yaws.language.sendmessage")
    util.AddNetworkString("yaws.language.sendrawmessage")

    function YAWS.Language.SendMessage(ply, key, ...)
        net.Start("yaws.language.sendmessage")
        net.WriteString(key)
        -- this is serverside so this is okay
        local args = {...}
        if(#args > 0) then
            net.WriteBool(true)

            local data = util.Compress(util.TableToJSON(args))

            net.WriteUInt(#data, 16)
            net.WriteData(data)
        else 
            net.WriteBool(false)
        end     
        net.Send(ply)
    end 
    function YAWS.Language.SendRawMessage(ply, message)
        net.Start("yaws.language.sendrawmessage")
        net.WriteString(message)
        net.Send(ply)
    end 
end