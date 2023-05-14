PLUGIN.name = "Communication"
PLUGIN.desc = "Telephone!"
PLUGIN.author = "Barata"
resource.AddFile("sound/telephone/phonering.wav")

if (SERVER) then
    function GetAllPhoneNumbers()
        local nums = {}

        for k, v in pairs(ents.FindByClass("telephone")) do
            nums[v:getNetVar("number")] = v
        end

        return nums
    end

    function GetAllPhoneNumbersCL()
        local nums = {}

        for k, v in pairs(ents.FindByClass("telephone")) do
            nums[v:getNetVar("number")] = v:EntIndex()
        end

        return nums
    end
	
	function PLUGIN:PlayerInitialSpawn(client)
		netstream.Start(ply, "sendPhoneNumbers", GetAllPhoneNumbersCL())
	end
else
    GetAllPhoneNumbersCache = GetAllPhoneNumbersCache or {}

    function GetAllPhoneNumbers()
        return GetAllPhoneNumbersCache
    end

    netstream.Hook("sendPhoneNumbers", function(tbl)
        GetAllPhoneNumbersCache = tbl
    end)
end

if SERVER then
    --Net stuff
    netstream.Hook("startPhoneCall", function(ply, ephone, num)
        local e = GetAllPhoneNumbers()[num]

        if not e:getNetVar("ringing", false) then
            e:RingStart(ply, ephone:getNetVar("number"))
            e:setNetVar("caller", ply)
            netstream.Start(ply, "startPhoneCallResponse", "started")
        else
            ply:notify("The number is already in use, please retry later.", 3)
            netstream.Start(ply, "startPhoneCallResponse", "busy")
        end
    end)

    netstream.Hook("respondPhoneCall", function(ply, ephone)
        local caller = ephone:getNetVar("caller")
        if not caller then return end

        --Update caller
        netstream.Start(caller, "updateCallListener", {
            update = "respond"
        })

        --Connecting the 2 players
        caller:setNetVar("talkingTo", ply)
        ply:setNetVar("talkingTo", caller)
    end)

    netstream.Hook("updateCallCaller", function(ply, data)
        if data.update == "hangup" then
            local caller = data.caller or (data.num and GetAllPhoneNumbers()[data.num]:getNetVar("caller")) or (data.numUser and GetAllPhoneNumbers()[data.numUser]:getNetVar("user"))

            --Updating caller
            netstream.Start(caller, "updateCallListener", {
                update = "hangup"
            })

            --Resetting netvar
            ply:setNetVar("talkingTo", nil)
            caller:setNetVar("talkingTo", nil)
        end
    end)

    netstream.Hook("stopPhoneRinging", function(ply, phone)
        local phoneEnt = GetAllPhoneNumbers()[phone]

        if (phoneEnt:getNetVar("ringing") and phoneEnt:getNetVar("caller") == ply) then
            phoneEnt:RingStop()
        end
    end)

    function PLUGIN:SaveData()
        local data = {}

        for k, v in pairs(ents.FindByClass("telephone")) do
            data[#data + 1] = duplicator.CopyEntTable(v)
        end

        self:setData(data)
    end

    function PLUGIN:LoadData()
        local pasteData = self:getData() or {}
        duplicator.Paste(nil, pasteData, {})
    end
end

--Handles who can hear who
hook.Add("PlayerCanHearPlayersVoice", "phoneCallings", function(listener, talker)
    if talker:getNetVar("talkingTo", nil) and talker:getNetVar("talkingTo") == listener then
        if listener:getNetVar("talkingTo", nil) and listener:getNetVar("talkingTo") == talker then return true end
    end
end)

--Adds to ability to create circles ;)
if CLIENT then
    function draw.Circle(x, y, radius, seg)
        local cir = {}

        table.insert(cir, {
            x = x,
            y = y,
            u = 0.5,
            v = 0.5
        })

        for i = 0, seg do
            local a = math.rad((i / seg) * -360)

            table.insert(cir, {
                x = x + math.sin(a) * radius,
                y = y + math.cos(a) * radius,
                u = math.sin(a) / 2 + 0.5,
                v = math.cos(a) / 2 + 0.5
            })
        end

        local a = math.rad(0) -- This is needed for non absolute segment counts

        table.insert(cir, {
            x = x + math.sin(a) * radius,
            y = y + math.cos(a) * radius,
            u = math.sin(a) / 2 + 0.5,
            v = math.cos(a) / 2 + 0.5
        })

        surface.DrawPoly(cir)
    end
end