AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function GM:PlayerSetModel(ply)
    ply:SetModel("models/player/odessa.mdl")
end