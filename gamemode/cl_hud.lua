local function hideElements(name)
	if name == "CHudHealth" or name == "CHudBattery" or name == "CHudSuitPower" or name == "CHudCrosshair" or name == "CHudHintDisplay" or name == "CHudGMod" then
		return false
	end
end
hook.Add("HUDShouldDraw", "hideElements", hideElements)