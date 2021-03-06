AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
	self:SetModel( "models/props_lab/hevplate.mdl" )
	if ( SERVER ) then self:PhysicsInit( SOLID_VPHYSICS ) end
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
  self:SetUseType(SIMPLE_USE)

  local phys = self:GetPhysicsObject()

	-- Set price of kiosk
	self:Setkiosk_price( 500 )

  if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use( activator, caller )
if (caller:Health() > 99 and caller:IsPlayer()) then
	caller:ChatPrint("You already have full health.")
	else
		if (caller:getDarkRPVar("money") >  500) then
			caller:addMoney(500)
			caller:SetHealth(100)
			self:Getowning_ent():addMoney(500)
			self:EmitSound("items/smallmedkit1.wav")
	else
			caller:ChatPrint("You don't have enough money.")
		end
	end
end

function ENT:Destruct()
	self:GetPos()
	util.Effect("Explosion", effectdata)
end

function ENT:Explode()
	local explosion = ents.Create( "env_explosion" ) // Creating our explosion
	explosion:SetKeyValue( "spawnflags", 144 ) //Setting the key values of the explosion
	explosion:SetKeyValue( "iMagnitude", 0 ) // Setting the damage done by the explosion
	explosion:SetKeyValue( "iRadiusOverride", 256 ) // Setting the radius of the explosion
	explosion:SetPos(self:GetPos()) // Placing the explosion where we are
	explosion:Spawn( ) // Spawning it
	explosion:Fire("explode","",0)
	self.Entity:Remove()
end

function ENT:OnTakeDamage(dmg)
	self.damage = (self.damage or 200) - dmg:GetDamage()
	if self.damage <= 0 then
		self:Explode()
		self:Remove()
	end
end

function ENT:Think()
end

function allowPickUp(ply, ent)
	if (ply:IsValid() and  (ent:GetClass() == "medic_kiosk")) then
		return true
	end
end
hook.Add("PhysgunPickup", "allowPickUp", allowPickUp)
