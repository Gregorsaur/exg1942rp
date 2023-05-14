-- developed for gmod.store
-- from incredible-gmod.ru with love <3

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local polaroid_photo = {polaroid_photo = true}
local format_url = "https://i.%s/%s.jpg"

concommand.Add("spawn_polaroidphoto", function(ply, _, args)
	if ply:IsSuperAdmin() == false then return end

	if args[1] then
		local hook_name = "spawn_polaroidphoto/".. ply:EntIndex()
		hook.Add("PlayerSpawnedSENT", hook_name, function(pl, ent)
			if IsValid(ply) == false then
				return hook.Remove("PlayerSpawnedSENT", hook_name)
			end

			if pl == ply then
				hook.Remove("PlayerSpawnedSENT", hook_name)

				if polaroid_photo[ent:GetClass()] then
					local url = format_url:format(
						POLAROID_CONFIG.Host:match("://(.-)/"), args[1]
					)

					http.Fetch(url, function(_, _, _, code)
						if code == 200 then
							ent:SetImgID(args[1])
							ply:ChatPrint("photo-id has been successfully setted!")
						else
							ply:ChatPrint("unknown photo-id. Please enter a valid photo-id intro 1st arg")
						end
					end, function()
						ply:ChatPrint("Failed to request ".. url)
					end)
				end
			end
		end)
	end

	Spawn_SENT(ply, "polaroid_photo")
end)

ENT.Model = "models/polaroid/photo.mdl"

ENT.InitPhys = true
ENT.NewPhys = {
	mins = -Vector(4, 8, 1),
	maxs = Vector(4, 8, 1)
}

util.AddNetworkString("incredible-gmod.ru/polaroid/entity")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	if self.InitPhys then self:PhysicsInitBox(self.NewPhys.mins, self.NewPhys.maxs) end

	self:PhysWake()

	self:SetUseType(SIMPLE_USE)

	if POLAROID_CONFIG.AutoRemovePhotos then
		timer.Simple(POLAROID_CONFIG.AutoRemovePhotosTime, function()
			if IsValid(self) then
				self:Remove()
			end
		end)
	end
end

function ENT:SpawnFunction(ply, tr, ClassName)
	if not tr.Hit then return end

	local pos = tr.HitPos + tr.HitNormal * 16

	local ent = ents.Create(ClassName)
	ent:SetPos(pos)
	ent:Spawn()
	ent:Activate()

	if ent.DefaultImgRandom then
		ent:RandomDefaultImage()
	end

	return ent
end

function ENT:Use(ply)
	if CPPI == nil or ply:IsSuperAdmin() or ent:CPPIGetOwner() == ply then
		net.Start("incredible-gmod.ru/polaroid/entity")
			net.WriteEntity(self)
		net.Send(ply)
	end
end

local NextNetUse = {}

net.Receive("incredible-gmod.ru/polaroid/entity", function(len, ply)
	local sid = ply:SteamID64()
	local CT = CurTime()
	if (NextNetUse[sid] or 0) > CT then return end
	NextNetUse[sid] = CT + 0.5


	local ent = net.ReadEntity()
	if IsValid(ent) and ent.SetDesc and ent.IsPolaroidPhoto then
		if net.ReadBool() then
			if CPPI == nil or ply:IsSuperAdmin() or ent:CPPIGetOwner() == ply then
				if ent.IsPolaroidPhotoFrame then
					ent:EmitSound("polaroid/drop.mp3")
					ent:DropPhotoFromFrame(ply)
				else
					ent:EmitSound("polaroid/tear.mp3")
					timer.Simple(0.4, function()
						ent:Remove()
					end)
				end
			end
		else
			ent:EmitSound("polaroid/pencil.mp3")
			ent:SetDesc(net.ReadString() or "")
		end
	end
end)

sql.Query("CREATE TABLE IF NOT EXISTS `polaroid` (`img_id` TEXT, `author_id` TEXT, `img_time` INT);")

function ENT:SetImage(ply, id)
	self:SetImgID(id)
	sql.Query(string.format("INSERT INTO `polaroid` (`img_id`, `author_id`, `img_time`) VALUES(%s, %s, %s);", sql.SQLStr(id), sql.SQLStr(ply:SteamID64()), os.time()))
end

local last_random
function ENT:RandomDefaultImage()
	local last10photos = sql.Query("SELECT `img_id` FROM `polaroid` ORDER BY `img_time` DESC LIMIT 10;")
	if not last10photos then return end

	local len = #last10photos
	if len < 1 then
		self:SetImgID("qabd")
		return
	end

	local random = math.random(1, len)
	if random == last_random then
		if random + 1 <= len then
			random = random + 1
		elseif len >= 2 then
			random = random - 1
		end
	end

	local photo = last10photos[random]
	if not photo then photo = {img_id = "qabd"} end

	self:SetImgID(photo.img_id)
	last_random = random
end