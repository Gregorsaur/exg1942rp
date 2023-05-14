-- developed for gmod.store
-- from incredible-gmod.ru with love <3

AddCSLuaFile()

ENT.Base 		= "base_gmodentity"
ENT.PrintName 	= "Polaroid"
ENT.Author 		= "Beelzebub"
ENT.Spawnable 	= true
ENT.Category  	= "Incredible GMod"

function ENT:SpawnFunction(ply)
	ply:ConCommand("gm_spawnswep polaroid")
end