if SERVER then
    AddCSLuaFile("shared.lua")
end

if CLIENT then
    SWEP.PrintName = "Administration Stick"
    SWEP.Slot = 0
    SWEP.SlotPos = 5
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = true
end

SWEP.Author = "Voska"
SWEP.Instructions = "Right click to bring up tools. Left click to perform selected action."
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.IsAlwaysRaised = true
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = Model("models/weapons/v_stunbaton.mdl")
SWEP.WorldModel = Model("models/weapons/w_stunbaton.mdl")
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
local AdminTools = {}

function SWEP:Initialize()
    self:SetWeaponHoldType("normal")
end

function SWEP:PrimaryAttack()
    self.Owner:SetAnimation(PLAYER_ATTACK1)
    self.Weapon:EmitSound(Sound("weapons/stunstick/stunstick_swing1.wav"))
    self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
    self.Weapon:SetNextPrimaryFire(CurTime() + 0.2)
    AccessAllowed = false

    if CH_AdminStick.Config.UseULX then
        if table.HasValue(CH_AdminStick.Config.ULXRanks, self.Owner:GetUserGroup()) then
            AccessAllowed = true
        end
    end

    if CH_AdminStick.Config.UseSteamIDs then
        if table.HasValue(CH_AdminStick.Config.SteamIDs, self.Owner:SteamID()) then
            AccessAllowed = true
        end
    end

    if self.Owner:Team() == FACTION_STAFF then
        AccessAllowed = true
    end

    if not AccessAllowed then
        if SERVER then
            self.Owner:Kick("Only administrators can use the administration stick!")

            return
        end
    end

    AdminTools[self.Owner:GetTable().CurGear or 1][4](self.Owner, self.Owner:GetEyeTrace())
end

if SERVER then
    util.AddNetworkString("ADMINSTICK_SelectTool")

    net.Receive("ADMINSTICK_SelectTool", function(length, ply)
        local CurrentGear = net.ReadDouble()
        local Message = net.ReadString()
        ply:GetTable().CurGear = tonumber(CurrentGear)

        if GAMEMODE.Name == "DarkRP" then
            DarkRP.notify(ply, 1, 5, Message)
        else
            ply:ChatPrint(Message)
        end
    end)
end

function SWEP:SecondaryAttack()
    if CLIENT then
        local MENU = DermaMenu()
        MENU:AddOption(LocalPlayer():Nick()):SetIcon("icon16/user.png")

        MENU:AddOption(LocalPlayer():SteamID(), function()
            LocalPlayer():ChatPrint("Your SteamID has been added to your clipboard")
            SetClipboardText(LocalPlayer():SteamID())
        end):SetIcon("icon16/information.png")

        MENU:AddSpacer()
        local CategoryAll = MENU:AddSubMenu("General Tools")
        local CategoryNutscript = MENU:AddSubMenu("Nutscript Tools")

        for k, v in pairs(AdminTools) do
            if string.find(v[1], "NUTSCRIPT") then
                CategoryNutscript:AddOption(v[1], function()
                    net.Start("ADMINSTICK_SelectTool")
                    net.WriteDouble(k)
                    net.WriteString(v[2])
                    net.SendToServer()
                end):SetIcon(v[3])
            else
                CategoryAll:AddOption(v[1], function()
                    net.Start("ADMINSTICK_SelectTool")
                    net.WriteDouble(k)
                    net.WriteString(v[2])
                    net.SendToServer()
                end):SetIcon(v[3])
            end
        end

        MENU:Open(100, 100)
        input.SetCursorPos(100, 100)
    end
end

local UA = {
    founder = true,
    communitymanager = true,
    superadmin = true,
    senioradmin = true,
    gamemaster = true,
    director = true,
    root = true
}

local NA = {
    admin = true,
    moderator = true,
    founder = true,
    director = true,
    superadmin = true,
    senioradmin = true,
    gamemaster = true,
    founder = true,
    root = true
}

local function AddTool(name, description, icon, func)
    table.insert(AdminTools, {name, description, icon, func})
end

AddTool("[ALL] Exit Vehicle", "Kick the driver out of their current vehicle.", "icon16/car.png", function(Player, Trace)
    if IsValid(Trace.Entity) and Trace.Entity:GetClass() == "prop_vehicle_jeep" then
        if Trace.Entity:IsVehicle() and IsValid(Trace.Entity.GetDriver and Trace.Entity:GetDriver()) then
            Trace.Entity:GetDriver():ExitVehicle()
            Trace.Entity:GetDriver():notify("An administrator has kicked you out of your vehicle!")
        end
    end
end)

AddTool("[ALL] Bring", "Aim at a player to bring them in front of you.", "icon16/cart_go.png", function(Player, Trace)
    if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
        Trace.Entity:SetPos(Player:GetPos() + ((Player:GetForward() * 45) + Vector(0, 0, 50)))
        Trace.Entity:notify("An administrator has brought you to them!")
    end
end)

AddTool("[ALL] Player Info", "Gives you a lot of information about the target.", "icon16/information.png", function(Player, Trace)
    if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
        Player:ChatPrint("Name: " .. Trace.Entity:Nick())
        Player:ChatPrint("SteamID: " .. Trace.Entity:SteamID())
        Player:ChatPrint("SteamID 64: " .. Trace.Entity:SteamID64())
        Player:ChatPrint("Kills: " .. Trace.Entity:Frags())
        Player:ChatPrint("Deaths: " .. Trace.Entity:Deaths())
        Player:ChatPrint("HP: " .. Trace.Entity:Health())
        Player:ChatPrint("Armor: " .. Trace.Entity:Armor())
    elseif IsValid(Trace.Entity) and Trace.Entity:IsVehicle() then
        if IsValid(Trace.Entity.GetDriver and Trace.Entity:GetDriver()) then
            Player:ChatPrint("Name: " .. Trace.Entity:GetDriver():Nick())
            Player:ChatPrint("SteamID: " .. Trace.Entity:GetDriver():SteamID())
            Player:ChatPrint("SteamID 64: " .. Trace.Entity:GetDriver():SteamID64())
            Player:ChatPrint("Kills: " .. Trace.Entity:GetDriver():Frags())
            Player:ChatPrint("Deaths: " .. Trace.Entity:GetDriver():Deaths())
            Player:ChatPrint("HP: " .. Trace.Entity:GetDriver():Health())
            Player:ChatPrint("Armor: " .. Trace.Entity:GetDriver():Armor())
        end
    end
end)

AddTool("[ALL] Extinguish (Prop)", "Aim at a burning entity to extinguish it.", "icon16/fire.png", function(Player, Trace)
    if IsValid(Trace.Entity) then
        Trace.Entity:Extinguish()
        Trace.Entity:SetColor(Color(255, 255, 255, 255))
        Player:notify("You've extinguished the target.")
    end
end)

AddTool("[ALL] Freeze/Unfreeze", "Target a player to change his freeze state.", "icon16/bug.png", function(Player, Trace)
    if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
        if Trace.Entity.IsFrozens then
            Trace.Entity:Freeze(false)
            Player:notify(Trace.Entity:Nick() .. " has been unfrozen.")
            Trace.Entity:ChatPrint("You have been unfrozen by an administrator.")
            Trace.Entity:EmitSound("npc/metropolice/vo/allrightyoucango.wav")
            Trace.Entity.IsFrozens = false
        else
            Trace.Entity.IsFrozens = true
            Trace.Entity:Freeze(true)
            Player:notify(Trace.Entity:Nick() .. " has been frozen.")
            Trace.Entity:EmitSound("npc/metropolice/vo/holdit.wav")
            Trace.Entity:ChatPrint("You have been frozen by an administrator.")
        end
    end
end)

AddTool("[ALL] Heal Player", "Aim at a player to heal them. Aim at the world to heal yourself.", "icon16/heart.png", function(Player, Trace)
    if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
        Trace.Entity:SetHealth(100)
        Trace.Entity:EmitSound("items/smallmedkit1.wav", 110, 100)
        Trace.Entity:notify("You have been healed by an administrator.")
    elseif Trace.Entity:IsWorld() then
        Player:SetHealth(100)
        Player:EmitSound("items/smallmedkit1.wav", 110, 100)
        Player:notify("You have healed yourself.")
    end
end)

AddTool("[ALL] God Mode", "Aim at a player to god/ungod them. Aim at the world to god/ungod yourself.", "icon16/shield.png", function(Player, Trace)
    if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
        if Trace.Entity:HasGodMode() then
            Trace.Entity:GodDisable()
            Trace.Entity:notify("Your godmode has been disabled by an administrator.")
        else
            Trace.Entity:GodEnable()
            Trace.Entity:notify("Your godmode has been enabled by an administrator.")
        end
    elseif Trace.Entity:IsWorld() then
        if Player:HasGodMode() then
            Player:GodDisable()
            Player:notify("Your godmode has been disabled.")
        else
            Player:GodEnable()
            Player:notify("Your godmode has been enabled.")
        end
    end
end)

AddTool("[ALL] Invisiblity", "Left click to go invisible. Left click again to become visible again.", "icon16/eye.png", function(Player, Trace)
    local c = Player:GetColor()
    local r, g, b, a = c.r, c.g, c.b, c.a

    if a == 255 then
        Player:notify("You are now invisible.")
        Player:SetColor(Color(255, 255, 255, 0))
        Player:SetNoDraw(true)
    else
        Player:notify("You are now visible again.")
        Player:SetColor(Color(255, 255, 255, 255))
        Player:SetNoDraw(false)
    end
end)

AddTool("[ALL] Kick Player", "Aim at a player to kick him.", "icon16/cancel.png", function(Player, Trace)
    if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
        Trace.Entity:Kick("You have been kicked by " .. Player:Nick())
        Trace.Entity:EmitSound("npc/metropolice/vo/finalverdictadministered.wav")
        Player:notify("You kicked " .. Trace.Entity:Nick())
    end
end)

AddTool("[ALL] Remover", "Aim at any object to remove it.", "icon16/wrench.png", function(Player, Trace)
    if Trace.Entity:IsPlayer() then
        Player:notify("You cannot remove players!")

        return
    end

    if IsValid(Trace.Entity) then
        --for k, v in pairs( ADMINSTICK_DisallowedEntities ) do
        --	print( v )
        Trace.Entity:Remove()
        --end
    end
end)

AddTool("[ALL] Kill Player", "Aim at a player to kill him.", "icon16/gun.png", function(Player, Trace)
    if Player:IsUserGroup("founder", "communitymanager", "superadmin") then
        if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
            Trace.Entity:ChatPrint(Player:Nick() .. " has killed you.")
            Trace.Entity:Kill()
            Player:notify("You killed " .. Trace.Entity:Nick())
        end
    else
        Player:notify("You are not the proper rank to use this tool.")
    end
end)

AddTool("[ALL] Teleport", "Teleports you to a targeted location.", "icon16/connect.png", function(Player, Trace)
    local EndPos = Player:GetEyeTrace().HitPos
    local CloserToUs = (Player:GetPos() - EndPos):Angle():Forward()
    Player:SetPos(EndPos + (CloserToUs * 20))
end)

AddTool("[ALL] Unfreeze (Prop)", "Aim at an entity to unfreeze it.", "icon16/attach.png", function(Player, Trace)
    if IsValid(Trace.Entity) then
        Trace.Entity:GetPhysicsObject():EnableMotion(true)
        Trace.Entity:GetPhysicsObject():Wake()
        Player:notify("You've unfrozen the prop.")
    end
end)

AddTool("[ALL] Burn", "Aim at an entity to set it on fire.", "icon16/fire.png", function(Player, Trace)
    if Trace.Entity:IsPlayer() or Trace.Entity:IsNPC() then
        Player:notify("You cannot ignite players/npcs.")

        return
    end

    if IsValid(Trace.Entity) then
        Trace.Entity:Ignite(600, 0)
    end
end)

AddTool("[ALL] Slap Player", "Aim at a player to slap him.", "icon16/joystick.png", function(Player, Trace)
    if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
        Trace.Entity:EmitSound("physics/body/body_medium_impact_hard1.wav")
        Trace.Entity:SetVelocity(Vector(math.random(5000) - 2500, math.random(5000) - 2500, math.random(5000) - (5000 / 4)))
    end
end)

AddTool("[ALL] Get Weapons", "Aim at a player to get his equipped weapons.", "icon16/find.png", function(Player, Trace)
    if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
        Player:notify("The target has the following weapons:")

        for k, v in pairs(Trace.Entity:GetWeapons()) do
            local wep = tostring(v)
            Player:notify(wep)
        end
    end
end)

AddTool("[ALL] Explode", "Aim at an entity to explode it.", "icon16/bomb.png", function(Player, Trace)
    local uniqueID = Player:GetUserGroup()

    if (not UA[uniqueID]) then
        Player:notify("Your rank is not high enough to use this command.")

        return false
    end

    if IsValid(Trace.Entity) then
        Trace.Entity:Ignite(10, 0)
        local eyetrace = Player:GetEyeTrace()
        local explode = ents.Create("env_explosion")
        explode:SetPos(eyetrace.HitPos)
        explode:Spawn()
        explode:SetKeyValue("iMagnitude", "75")
        explode:Fire("Explode", 0, 0)

        if Trace.Entity:IsPlayer() then
            Trace.Entity:Kill()
        end
    end
end)

AddTool("[NUTSCRIPT] Set PK Active", "Use on a player to set them PK Active.", "icon16/page_delete.png", function(Player, Trace)
    local ply = Player:GetEyeTrace().Entity
	if(!ply:IsPlayer()) then return false end
	
    local char = Player:GetEyeTrace().Entity:getChar()
    local uniqueID = Player:GetUserGroup()

    if (not UA[uniqueID]) then
        Player:notify("Your rank is not high enough to use this command.")

        return false
    end

    if (IsValid(ply) and ply:IsPlayer() and char) then
        if (char:getData("pkCom")) then
            char:setData("pkCom", false, false, player.GetAll())
        else
            char:setData("pkCom", true, false, player.GetAll())
        end

        Player:notify("Setting " .. (ply:getChar():getName()) .. "\'s PK status to " .. tostring(ply:getChar():getData("pkCom")))
    else
        Player:notify("That is not a player.")
    end
end)

AddTool("[NUTSCRIPT] Char Kick", "Use on a player to kick their character temporarily.", "icon16/bullet_go.png", function(Player, Trace)
    local ply = Player:GetEyeTrace().Entity
	if(!ply:IsPlayer()) then return false end
	
    local char = Player:GetEyeTrace().Entity:getChar()
    local uniqueID = Player:GetUserGroup()

    if (not NA[uniqueID]) then
        Player:notify("Your rank is not high enough to use this command.")

        return false
    end

	print(IsValid(ply), ply:IsPlayer(), char)

    if IsValid(ply) and ply:IsPlayer() and char then
        Player:ConCommand("say /charkick " .. ply:Name())
    else
        Player:notify("That is not a player.")
    end
end)

AddTool("[NUTSCRIPT] Perma Kill", "Use on a player to kill their character permanently (USE CAREFULLY).", "icon16/cancel.png", function(Player, Trace)
    local ply = Player:GetEyeTrace().Entity
	if(!ply:IsPlayer()) then return false end
	
    local char = Player:GetEyeTrace().Entity:getChar()
    local uniqueID = Player:GetUserGroup()

    if (not UA[uniqueID]) then
        Player:notify("Your rank is not high enough to use this command.")

        return false
    end

    if IsValid(ply) and ply:IsPlayer() and char then
        Player:ConCommand("say /charban " .. ply:Name())
    end
end)

AddTool("[NUTSCRIPT] Clear Inventory", "Use on a player to wipe their inventory (USE CAREFULLY).", "icon16/cancel.png", function(Player, Trace)
    local ply = Player:GetEyeTrace().Entity
	if(!ply:IsPlayer()) then return false end
	
    local char = Player:GetEyeTrace().Entity:getChar()
    local uniqueID = Player:GetUserGroup()

    if (not UA[uniqueID]) then
        Player:notify("Your rank is not high enough to use this command.")

        return false
    end

    if IsValid(ply) and ply:IsPlayer() and char then
        Player:notify(ply:Nick() .. " has had their inventory cleared.")
    else
        Player:notify("That is not a player.")
    end
end)

AddTool("[NUTSCRIPT] Check Money", "Use on a player to check their money.", "icon16/money.png", function(Player, Trace)
    local ply = Player:GetEyeTrace().Entity
	if(!ply:IsPlayer()) then return false end
	
    local char = Player:GetEyeTrace().Entity:getChar()
    local uniqueID = Player:GetUserGroup()

    if (not NA[uniqueID]) then
        Player:notify("Your rank is not high enough to use this command.")

        return false
    end

    if IsValid(ply) and ply:IsPlayer() and char then
        Player:ConCommand("say /checkmoney " .. ply:Name())
    else
        Player:notify("That is not a player.")
    end
end)

AddTool("[NUTSCRIPT] Check Flags", "Use on a player to check their flags.", "icon16/flag_blue.png", function(Player, Trace)
    local ply = Player:GetEyeTrace().Entity
	if(!ply:IsPlayer()) then return false end
	
	local char = Player:GetEyeTrace().Entity:getChar()
    local uniqueID = Player:GetUserGroup()

    if (not NA[uniqueID]) then
        Player:notify("Your rank is not high enough to use this command.")

        return false
    end

    if IsValid(ply) and ply:IsPlayer() and char then
        Player:ConCommand("say /checkflags " .. ply:Name())
    else
        Player:notify("That is not a player.")
    end
end)

AddTool("[NUTSCRIPT] Change Name", "Use on a player to change their name.", "icon16/tick.png", function(Player, Trace)
    local ply = Player:GetEyeTrace().Entity
	if(!ply:IsPlayer()) then return false end
	
    local char = Player:GetEyeTrace().Entity:getChar()
    local uniqueID = Player:GetUserGroup()

    if (not NA[uniqueID]) then
        Player:notify("Your rank is not high enough to use this command.")

        return false
    end

    if IsValid(ply) and ply:IsPlayer() and char then
        Player:ConCommand("say /charsetname " .. ply:Name())
    end
end)

AddTool("[NUTSCRIPT] Set Rank", "Use on a player to set their model and faction.", "icon16/group.png", function(Player, Trace)
    local ply = Player:GetEyeTrace().Entity
	if(!ply:IsPlayer()) then return false end
	
    local char = Player:GetEyeTrace().Entity:getChar()
    local uniqueID = Player:GetUserGroup()

    if (not NA[uniqueID]) then
        Player:notify("Your rank is not high enough to use this command.")

        return false
    end

    if IsValid(ply) and ply:IsPlayer() and char then
        Player:ConCommand("say /charsetrank " .. ply:Name())
    end
end)