local PLUGIN = PLUGIN
PLUGIN.name = "Admin Drawing"
PLUGIN.author = "CallowayIsWeird"
PLUGIN.desc = "Shows above the head if they are an admin or not using usergroups."
 
if (CLIENT) then
    local SUPERADMIN = Color(255, 209, 20)
    local MANAGEMENT = Color(255, 209, 20)
    local SENIORADMINISTRATOR = Color(255, 209, 20)
    local ADMIN = Color(255, 209, 20)
    local JUNIORADMINISTRATOR = Color(255, 209, 20)
    local SENIORMODERATOR = Color(255, 209, 20)
    local MODERATOR = Color(255, 209, 20)
    local JUNIORMODERATOR = Color(255, 209, 20)
  	local HEADGM = Color(255, 209, 20)
	local GAMEMASTER = Color(255, 209, 20)
	local HEADGAMEMASTER = Color(255, 209, 20)

    hook.Add( "DrawCharInfo", "DrawCharInfoStaff", function( client, character, info )
        if (client:Team() == FACTION_STAFF) then

            if (client:IsUserGroup("superadmin")) then
                info[#info + 1] = {"Management", SUPERADMIN}
            end

            if (client:IsUserGroup("management")) then
                info[#info + 1] = {"Management", SUPERADMIN}
            end

            if (client:IsUserGroup("senioradministrator")) then
                info[#info + 1] = {"Administrator", SENIORADMINISTRATOR}
            end

            if (client:IsUserGroup("admin")) then
                info[#info + 1] = {"Administrator", ADMINISTRATOR}
            end

            if (client:IsUserGroup("junioradministrator")) then
                info[#info + 1] = {"Junior Administrator", JUNIORADMINISTRATOR}
            end

            if (client:IsUserGroup("seniormoderator")) then
                info[#info + 1] = {"Senior Moderator", SENIORMODERATOR}
            end

            if (client:IsUserGroup("moderator")) then
                info[#info + 1] = {"Moderator", MODERATOR}
            end

            if (client:IsUserGroup("juniormoderator")) then
                info[#info + 1] = {"Junior Moderator", JUNIORMODERATOR}
            end
			
            if (client:IsUserGroup("gamemaster")) then
                info[#info + 1] = {"Gamemaster", GAMEMASTER}
            end
			
			if (client:IsUserGroup("headgm")) then
                info[#info + 1] = {"Helper", HEADGM}
            end
        end
    end )
end