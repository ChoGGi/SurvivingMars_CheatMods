-- See LICENSE for terms

local table = table

function OnMsg.ConstructionComplete(obj)
	-- check if building has more than one skin
	local skins, palettes = obj:GetSkins()
	if skins and #skins > 1 then
		-- pick and apply a random skin
		local skin, idx = table.rand(skins)
		obj:ChangeSkin(skin, palettes[idx])
	end
end
