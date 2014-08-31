local function hideElements(name)
	if name == "CHudHealth" or name == "CHudBattery" or name == "CHudSuitPower" or name == "CHudCrosshair" then
		return false
	end
end
hook.Add("HUDShouldDraw", "hideElements", hideElements)