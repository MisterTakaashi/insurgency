AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function GM:PlayerSetModel(ply)
    if (ply:Team() == 1) then
        ply:SetModel("models/player/kuma/alqaeda_commando.mdl") // Addon n°208348503
    else
        ply:SetModel("models/minson97/bo2/seal.mdl") // Addon n°? Non definitif
    end
end

function GiveWeapons(ply)
    if (ply:Team() != 1001) then
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