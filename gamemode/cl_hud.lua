local function hideElements(name)
	if name == "CHudHealth" or name == "CHudBattery" or name == "CHudSuitPower" then
		return false
	end
end
hook.Add("HUDShouldDraw", "hideElements", hideElements)