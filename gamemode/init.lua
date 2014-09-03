AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_spawnmenu.lua")
AddCSLuaFile("cl_legmod.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_suppr.lua")
AddCSLuaFile("sh_team.lua")

resource.AddFile("materials/insurgent.png")
resource.AddFile("materials/security.png")

include("shared.lua")

function GM:PlayerSetModel(ply)
    if (ply:Team() == 1) then
        ply:SetModel("models/player/kuma/alqaeda_commando.mdl") // Addon n°208348503
    else
        ply:SetModel("models/minson97/bo2/seal.mdl") // Addon n°? Non definitif
    end
end

function GiveWeapons(ply)
    ply:StripWeapons()
    if (ply:Team() != 1001) then
        if(ply:Team() == 1) then
            ply:Give("fas2_ak47")
        else
            ply:Give("fas2_mp5a5")
        end
    end
    --ply:Say("Mon équipe est: "..ply:Team().." soit: "..team.GetName(ply:Team()))
end
hook.Add("PlayerSpawn", "GiveWeponsSpawn", GiveWeapons)

util.AddNetworkString("InitialSpawnMenu")

function spawnInitialMenu(ply)
	net.Start("InitialSpawnMenu")
        net.WriteString(ply:Name())
    net.Send(ply)
    ply:SetRunSpeed(265)
    ply:SetWalkSpeed(170)
    ply:SetHealth(50)
end
hook.Add("PlayerInitialSpawn", "InitialSpawnMenu", spawnInitialMenu)

util.AddNetworkString("ChooseTeamMenu")

net.Receive("ChooseTeamMenu", function(len, ply)
    local equipe = net.ReadString()
    -- print("L'equipe c'est:"..equipe)
    -- print(ply:Name())
    
    if (equipe == "insurgent") then
        ply:SetTeam(1)
        ply:Spawn()
        ply:SetPos(Vector(-2022, -1540, 106))
    else
        ply:SetTeam(2)
        ply:Spawn()
        ply:SetPos(Vector(-1180, 1360, 103))
    end
end)

function spawnTP(ply)
    if (ply:Team() == 1) then
        ply:SetPos(Vector(-2022, -1540, 106))
    else
        ply:SetPos(Vector(-1180, 1360, 103))
    end
    ply:SetRunSpeed(265)
    ply:SetWalkSpeed(170)
    ply:SetHealth(50)
end
hook.Add("PlayerSpawn", "SpawnTP", spawnTP)

-- hook.Add("EntityTakeDamage", "AntiTeamKill", function(ent, dmginfo)
    -- if ent:IsPlayer() then
        -- local Inflictor = dmginfo:GetInflictor()
        -- if Inflictor:IsPlayer() then
            -- print(Inflictor:Nick().." vient de tirer sur "..ent:Nick().." avec "..dmginfo:GetDamage().." points de dégats")
        -- end
    -- end
-- end)

function OutOfGUI(ply)
	umsg.Start("ToggleClicker", ply)
	umsg.End()
end
hook.Add("ShowSpare1", "OutOfGUIHook", OutOfGUI)