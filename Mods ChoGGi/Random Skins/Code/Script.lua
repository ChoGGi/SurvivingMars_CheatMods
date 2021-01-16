-- See LICENSE for terms

local table_rand = table.rand

function OnMsg.ConstructionComplete(obj)
	-- check if building has more than one skin
	local skins, palettes = obj:GetSkins()
	if skins and #skins > 1 then
		-- pick and apply a random skin
		local skin, idx = table_rand(skins)
		obj:ChangeSkin(skin, palettes[idx])
	end
end
