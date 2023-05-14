local PLUGIN = PLUGIN

PLUGIN.name = "Type Writer"
PLUGIN.author = "Barata"
PLUGIN.desc = "Adds writer."
PLUGIN.class = "nut_type_writer"

function PLUGIN:getWriters()
    return ents.FindByClass("nut_type_writer")
end

function PLUGIN:getWriterById(id)
    for _, writer in pairs(self:getWriters()) do
        if writer:getNetVar("id", nil) == id then
            return writer
        end
    end

    return nil
end

if SERVER then
    function PLUGIN:saveWriter(writer)
        local data = self:getData()
        local id = writer:getNetVar("id", nil)

        data[id] = {}
        data[id].name = writer:getNetVar("name", "Unnamed")
        data[id].messages = writer:getNetVar("messages", {})
        data[id].pos = writer:GetPos()
        data[id].angles = writer:GetAngles()

        self:setData(data)
    end

    function PLUGIN:saveWriters()
        for _, writer in pairs(self:getWriters()) do
            if writer:getNetVar("id", nil) == nil then continue end

            self:saveWriter(writer)
        end
    end

    function PLUGIN:removeWriter(writer)
        local data = self:getData()
        local id = writer:getNetVar("id", nil)

        if not isnumber(id) then return end

        data[id] = nil

        self:setData(data)
    end

    function PLUGIN:SaveData()
        self:saveWriters()
    end

    function PLUGIN:loadWriter(writerData)
        local writer = ents.Create("nut_type_writer")
        writer:SetPos(writerData.pos)
        writer:SetAngles(writerData.angles)
        writer:Spawn()
        writer:setNetVar("name", writerData.name)
        writer:setNetVar("messages", writerData.messages)
    end

    function PLUGIN:loadWriters()
        local data = self:getData()

        for _, writer in pairs(data) do
            self:loadWriter(writer)
        end
    end

    function PLUGIN:LoadData()
        self:loadWriters()
    end

    function PLUGIN:WriterRemoved(writer)
        self:removeWriter(writer)
    end

    function PLUGIN:OnEntityCreated(entity)
        if not IsValid(entity) then return end
        if entity:GetClass() ~= self.class then return end

        entity:setNetVar("id", math.Round(#self:getWriters() + CurTime()))
    end

    netstream.Hook("nut_type_writer_send", function(client, senderWriter, targetWriter, message)
        if senderWriter == targetWriter then return end

        targetWriter = PLUGIN:getWriterById(targetWriter)

        if not targetWriter or not IsValid(targetWriter) then return end 
        if not istable(message) or not message.title or not message.contents then return end

        message.time = SysTime()

        local messages = targetWriter:getNetVar("messages", {})
        table.insert(messages, 1, message)
        targetWriter:setNetVar("messages", messages)

        PLUGIN:saveWriter(targetWriter)
    end)
else
    function PLUGIN:ReadMessages(typeWriterId)
        local messages = self:getWriterById(typeWriterId):getNetVar("messages", {})

        local panel = vgui.Create("nut.docs.list")
        panel:SetMessages(messages)
    end

    function PLUGIN:WriteMessage(typeWriterId)
        local panel = vgui.Create("nut.docs.edit")

        local send = vgui.Create("DButton", panel)
        send:Dock(TOP)
        send:SetText("Send")

        send.DoClick = function()
            local menu = vgui.Create("DMenu")
            menu:Open()

            for _, writer in pairs(self:getWriters()) do
                local id = writer:getNetVar("id", nil)

                if id == typeWriterId then continue end

                menu:AddOption(writer:getNetVar("name", "Unnamed")).DoClick = function(self)
                    local message = {}
                    message.title = string.Trim(panel:GetHeader())
                    message.contents = string.Trim(panel:GetContents())

                    netstream.Start("nut_type_writer_send", typeWriterId, id, message)

                    panel:Remove()

                    nut.util.notify("You sent a message properly!")
                end
            end
        end       
    end

    netstream.Hook("nut_type_writer_send", function(typeWriterId)
        Derma_Query("What do you want to do?", "", "Read", function()
            PLUGIN:ReadMessages(typeWriterId)
        end, "Write", function()
            PLUGIN:WriteMessage(typeWriterId)
        end)
    end)
end

properties.Add("nut_type_writer_set_name", {
    MenuLabel = "Set Name",
    Order = 10,
    MenuIcon = "icon16/tag_blue_edit.png",

    Filter = function(self, entity, client)
        if entity:GetClass() != PLUGIN.class then return false end
		-- if (!gamemode.Call("CanProperty", client, "nut_type_writer_set_name", entity)) then return false end
        if not client:IsAdmin() then return false end

		return true
    end,

    Action = function(self, entity)
        Derma_StringRequest("Set Name", "", "", function(text)
			self:MsgStart()
				net.WriteEntity(entity)
				net.WriteString(text)
			self:MsgEnd()
		end)
    end,

    Receive = function(self, length, client)
		local entity = net.ReadEntity()
        local name = net.ReadString()

        if not IsValid(entity) then return end
        if not self:Filter(entity, client) then return end

        entity:setNetVar("name", name)
        PLUGIN:saveWriter(entity)
	end
})