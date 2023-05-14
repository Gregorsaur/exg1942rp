PLUGIN.name = "Pretender"
PLUGIN.author = "Barata"
PLUGIN.desc = "This plugin prevents other characters to recognize you when you wear the mask"
 
--[[
    How to make recognition hider work
    1. add category in this table.
    2. add ITEM.isMask = true
    3. delete nutscript
]]
PLUGIN.maskPartList = {
    mask = true,
    hat = true,
}
 
function PLUGIN:IsPlayerRecognized(client)
    local char = client:getChar()
 
    if (IsValid(client)) then
        if (char) then
            local parts = client.getParts and client:getParts()
           
            if (parts) then
                for k, v in pairs(parts) do
                    local itemTable = nut.item.list[k]
 
                    if (itemTable) then
                        if (itemTable.isMask) then return false end
 
                        if (self.maskPartList[itemTable.outfitCategory]) then
                            return false
                        end
                    end
                end
            end
        end
       
    end
   
end
 
CHAT_RECOGNIZED = CHAT_RECOGNIZED or {}
CHAT_RECOGNIZED["ic"] = true
CHAT_RECOGNIZED["y"] = true
CHAT_RECOGNIZED["w"] = true
CHAT_RECOGNIZED["me"] = true
 
function PLUGIN:IsRecognizedChatType(chatType)
    return CHAT_RECOGNIZED[chatType]
end
 
function PLUGIN:GetDisplayedName(client, chatType)
    if (true or client != LocalPlayer()) then
        local character = client:getChar()
        local ourCharacter = LocalPlayer():getChar()
 
        local recog = hook.Run("IsPlayerRecognized", client)
        if (ourCharacter and character and recog == false) then
            if (chatType and hook.Run("IsRecognizedChatType", chatType)) then
                local description = character:getDesc()
 
                if (#description > 40) then
                    description = description:utf8sub(1, 37).."..."
                end
 
                return "["..description.."]"
            elseif (!chatType) then
                return L"unknown"
            end
        end
    end
end
 
function PLUGIN:ShouldAllowScoreboardOverride()
    return true
end