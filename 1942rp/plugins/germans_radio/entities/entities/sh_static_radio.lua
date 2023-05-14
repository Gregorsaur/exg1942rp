-- "gamemodes\\1942rp\\plugins\\germans_radio\\entities\\entities\\sh_static_radio.lua"
-- Retrieved by https://github.com/c4fe/glua-steal
ENT.Type = "anim"
ENT.PrintName = "Static Radio"
ENT.Category = "NutScript"
ENT.Spawnable = true
ENT.AdminOnly = true

function ENT:Initialize()
  if SERVER then
    self:SetModel("models/props_lab/citizenradio.mdl")
    self:SetUseType(SIMPLE_USE)
    self:PhysicsInit(SOLID_VPHYSICS)
  	self:SetMoveType(MOVETYPE_VPHYSICS)
  	self:SetSolid(SOLID_VPHYSICS)
  end
end

function ENT:Use(client)
  for _,t in pairs(RADIO.can_use_teams) do
    if client:Team() == t then
      netstream.Start(client, "type_radio_message", {
        ent = self
      })
      return
    else
      client:notify("You can't use that.")
      return
    end
  end
end


