AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function GM:PlayerSetModel(ply)
    if (ply:Team() == 1) then
        ply:SetModel("models/player/odessa.mdl")
    else
        ply:SetModel("models/player/breen.mdl")
    end
end
