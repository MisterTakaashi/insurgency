AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function GM:PlayerSetModel(ply)
    ply:SetModel("models/player/odessa.mdl")
end

function GiveWeapons(ply)
    ply:Give("fas2_ak47")
    ply:Say("Mon équipe est: "..ply:Team().." soit: "..team.GetName(ply:Team()))
end
hook.Add("PlayerSpawn", "GiveWeponsSpawn", GiveWeapons)