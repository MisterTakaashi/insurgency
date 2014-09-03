include("shared.lua")
include("cl_hud.lua")
include("cl_spawnmenu.lua")
include("cl_legmod.lua")

function ToggleClicker()
	changementTeam()
end
usermessage.Hook("ToggleClicker", ToggleClicker)