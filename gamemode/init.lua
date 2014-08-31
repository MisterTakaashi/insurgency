AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function GM:PlayerSetModel(ply)
    ply:SetModel("models/player/odessa.mdl")
end

function GiveWeapons(ply)
    if(ply:Team() != 1001) then
        ply:Give("fas2_ak47")
    end
    ply:Say("Mon équipe est: "..ply:Team().." soit: "..team.GetName(ply:Team()))
end
hook.Add("PlayerSpawn", "GiveWeponsSpawn", GiveWeapons)

-- hook.Add("EntityTakeDamage", "AntiTeamKill", function(ent, dmginfo)
    -- if ent:IsPlayer() then
        -- local Inflictor = dmginfo:GetInflictor()
        -- if Inflictor:IsPlayer() then
            -- print(Inflictor:Nick().." vient de tirer sur "..ent:Nick().." avec "..dmginfo:GetDamage().." points de dégats")
        -- end
    -- end
-- end)