-- developed for gmod.store
-- from incredible-gmod.ru with love <3

ENT.Base 		= "base_gmodentity"
ENT.PrintName 	= "Polaroid Photo"
ENT.Author 		= "Beelzebub"
ENT.Spawnable 	= true
ENT.Category  	= "Incredible GMod"

ENT.IsPolaroidPhoto = true

ENT.DefaultImgRandom = true

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "ImgID")
	self:NetworkVar("String", 1, "Desc")
end

local format_url = "https://i.%s/%s.jpg"

function ENT:GetURL()
	return format_url:format(
		POLAROID_CONFIG.Host:match("://(.-)/"), self:GetImgID()
	)
end