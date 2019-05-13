local function SetTableValue(tab, id, id_name, item, value)
	local idx = table.find(tab, id, id_name)
	if idx then
		tab[idx][item] = value
		return tab[idx]
	end
end

local hud = XTemplates.HUD[1]
local idx = table.find(hud, "Id", "idBottom")
if idx then
	hud = hud[idx]
	local xt = SetTableValue(hud, "Id", "idMiddle", "HAlign", "left")
	if xt then
--~ 			xt.Image = "UI/CommonNew/options.tga"
--~ 			xt.Padding_ChoGGi = xt.Padding
		xt.Padding = box(10, 0, 120, 0)
	end
	xt = SetTableValue(hud, "Id", "idLeft", "HAlign", "center")
	if xt then
		xt.Image = "UI/CommonNew/Hud.tga"
	end
end
