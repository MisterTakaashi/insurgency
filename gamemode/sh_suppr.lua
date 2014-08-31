AddCSLuaFile()

local MaxSuppression = 0.03 -- maximum suppression value
local SuppressionIncreaseHighDamage = 75 -- used for calculating additional suppression based on bullet damage, higher values means higher damage on bullet required for more suppression increase
local SuppressionIncreaseDamageRelation = 0.01 -- multiplier for additional suppression based on bullet damage
local SuppressionIncrease = 0.03 -- base suppression increase from shots
local SuppressionIncreaseOnHurt = 0.005 -- base suppression increase from taking damage
local SuppressionToSpread = 0.5 -- suppression multiplier for spread modifier 
local SuppressionHoldTime = 3 -- time in seconds to hold the suppression for when a bullet hits a nearby position
local SuppressionHoldTimeOnHurt = 5 -- time in seconds to hold the suppression for when a bullet hits a player
local ClientSprintBlur = true -- add blur when sprinting?

local reg = debug.getregistry()
local GetShootPos = reg.Player.GetShootPos
local GetCurrentCommand = reg.Player.GetCurrentCommand
local CommandNumber = reg.CUserCmd.CommandNumber
local Alive = reg.Player.Alive

local function Suppression_InitPostEntity()
	-- Expertise implementation
	
	if Expertise then
		local exp = {}
		exp.name = "steelnerves"
		exp.reqs = {initial = 100, inc = 0.3}
		exp.xpincmul = 1
		exp.desc = {h = "Steel nerves", desc = {[1] = {t = "Your ability to operate under high stress.", c = Color(255, 255, 255, 255)},
			[2] = {t = "Decreases suppression duration by 2% every 10 points.", c = Color(197, 255, 153, 255)},
			[3] = {t = "Decreases suppression increase speed by 2% every 10 points.", c = Color(197, 255, 153, 255)}}
		}
		
		Expertise.AddNewSkill(exp)
	end
end

hook.Add("InitPostEntity", "Suppression_InitPostEntity", Suppression_InitPostEntity)

local mul

if SERVER then
	umsg.PoolString("IncSuppression")
	
	local function Suppression_PlayerInitialSpawn(ply)
		ply.Suppression = 0
		ply.SuppressionHold = 0
	end
	
	hook.Add("PlayerInitialSpawn", "Suppression_PlayerInitialSpawn", Suppression_PlayerInitialSpawn)
	
	local function Suppression_PlayerSpawn(ply)
		ply.Suppression = 0
		ply.SuppressionHold = 0
	end
	
	hook.Add("PlayerSpawn", "Suppression_PlayerSpawn", Suppression_PlayerSpawn)
	
	local function Suppression_EntityFireBullets(ent, d)
		if IsValid(ent) then
			if ent:IsPlayer() then
				math.randomseed(CurTime())
				
				d.Dir.x = d.Dir.x + math.Rand(-ent.Suppression, ent.Suppression) * SuppressionToSpread
				d.Dir.y = d.Dir.y + math.Rand(-ent.Suppression, ent.Suppression) * SuppressionToSpread
				d.Dir.z = d.Dir.z + math.Rand(-ent.Suppression, ent.Suppression) * SuppressionToSpread
			end
			
			local old = d.Callback
			
			d.Callback = function(a, b, c)
				local CT = CurTime()
				
				for k, v in pairs(ents.FindInSphere(b.HitPos, 192)) do
					if v:IsPlayer() then
						if v != ent then
							mul = 1
							
							if v.Expertise then
								mul = 1 - v.Expertise["steelnerves"].val * 0.002
								
								v:ProgressStat("steelnerves", 5 + d.Damage * 0.25)
							end
							
							v.Suppression = math.Clamp(v.Suppression + SuppressionIncrease + math.Clamp(d.Damage / SuppressionIncreaseHighDamage, 0, 1) * SuppressionIncreaseDamageRelation * mul, 0, MaxSuppression)
							
							if CT > v.SuppressionHold - SuppressionHoldTime then
								v.SuppressionHold = CurTime() + (SuppressionHoldTime * mul)
							end
							
							umsg.Start("IncSuppression", v)
								umsg.Float(v.Suppression)
							umsg.End()
						end
					end
				end
				
				if old then
					old(a, b, c)
				end
			end
			
			return true
		end
	end
	
	hook.Add("EntityFireBullets", "Suppression_EntityFireBullets", Suppression_EntityFireBullets)
	
	local function Suppression_Think()
		local CT = CurTime()
		local FT = FrameTime()
		
		for k, v in pairs(player.GetAll()) do
			if Alive(v) then
				if v.Suppression > 0 then
					if CT > v.SuppressionHold then
						v.Suppression = math.Clamp(v.Suppression - FT * 0.02, 0, MaxSuppression)
					end
				end
			end
		end
	end
	
	hook.Add("Think", "Suppression_Think", Suppression_Think)
	
	local function Suppression_EntityTakeDamage(vic, d)
		if vic:IsPlayer() then
			local dmg = d:GetDamageType()
			
			if dmg == DMG_BULLET or dmg == DMG_BLAST then
				local att = d:GetAttacker()
				
				if att:IsPlayer() or att:IsNPC() then
					vic.Suppression = math.Clamp(vic.Suppression + SuppressionIncreaseOnHurt, 0, MaxSuppression)
					vic.SuppressionHold = CurTime() + SuppressionHoldTimeOnHurt
				end
			end
		end
	end
	
	hook.Add("EntityTakeDamage", "Suppression_EntityTakeDamage", Suppression_EntityTakeDamage)
end

if CLIENT then
	local spr = Vector(0, 0, 0)
	local blur, blurhold = 0, 0
	
	local function Suppression_EntityFireBullets(ent, d)
		if IsValid(ent) then
			local ply = LocalPlayer()
			if ent == ply then
				if IsFirstTimePredicted() then
					math.randomseed(CurTime())
					
					d.Dir.x = d.Dir.x + math.Rand(-blur, blur) * SuppressionToSpread
					d.Dir.y = d.Dir.y + math.Rand(-blur, blur) * SuppressionToSpread
					d.Dir.z = d.Dir.z + math.Rand(-blur, blur) * SuppressionToSpread
				end
			end
			
			return true
		end
	end
	
	hook.Add("EntityFireBullets", "Suppression_EntityFireBullets", Suppression_EntityFireBullets)
	
	local target, speed = 0, 0
	
	local GetVelocity = reg.Entity.GetVelocity
	local Length = reg.Vector.Length
	
	local function Suppression_GetMotionBlurValues(h, v, f, r)
		local ply = LocalPlayer()
		local FT = FrameTime()
		local CT = CurTime()
		
		if ClientSprintBlur and Alive(ply) and ply:KeyDown(IN_SPEED) and ply:OnGround() and Length(GetVelocity(ply)) >= ply:GetWalkSpeed() * 1.2 then
			target = math.Approach(target, 0.0125, FT * 0.05)
			speed = 0.03
		else
			target = math.Approach(target, 0, FT * 0.05)
			speed = 0.02
		end
		
		if CT > blurhold then
			blur = math.Clamp(blur - FT * speed, target, 0.03)
		end
		
		f = f + (blur / MaxSuppression) * 0.03
		
		return h, v, f, r
	end
	
	hook.Add("GetMotionBlurValues", "Suppression_GetMotionBlurValues", Suppression_GetMotionBlurValues)
	
	gameevent.Listen("player_hurt")
	
	local function Suppression_player_hurt(hp, a, b, c)
		if hp.attacker != 0 then
			local ply = LocalPlayer()
			
			if ply:UserID() == hp.userid then
				mul = 1
				
				if ply.Expertise then
					mul = 1 - ply.Expertise["steelnerves"].val * 0.002
				end
				
				blur = math.Clamp(blur + SuppressionIncreaseOnHurt * mul, 0, MaxSuppression)
				blurhold = CurTime() + (SuppressionHoldTimeOnHurt * mul)
			end
		end
	end
	
	hook.Add("player_hurt", "Suppression_player_hurt", Suppression_player_hurt)
	
	local function IncSuppression(um)
		local supp = um:ReadFloat()
		blur = supp
		local CT = CurTime()
		
		if CT > blurhold - SuppressionHoldTime then
			local ply = LocalPlayer()
			
			mul = 1
			
			if ply.Expertise then
				mul = 1 - ply.Expertise["steelnerves"].val * 0.002
			end
			
			blurhold = CT + (SuppressionHoldTime * mul)
		end
	end
	
	usermessage.Hook("IncSuppression", IncSuppression)
	
	local PS2 = render.SupportsPixelShaders_2_0()
	
	local function Suppression_RenderScreenspaceEffects()
		if not PS2 then
			return
		end
		
		if GetConVarNumber("mat_motion_blur_enabled") >= 1 then
			return
		end
		
		local CT, FT = CurTime(), FrameTime()
	
		target = math.Approach(target, 0, FT * 0.05)
		speed = 0.02
	
		if CT > blurhold then
			blur = math.Clamp(blur - FT * speed, target, 0.03)
		end

		DrawToyTown(blur / 0.03 * 5, ScrH() * blur * 20)
	end
	
	hook.Add("RenderScreenspaceEffects", "Suppression_RenderScreenspaceEffects", Suppression_RenderScreenspaceEffects)
end