-- See LICENSE for terms

local mod_EnableMod

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end


function OnMsg.LoadGame()
	if not mod_EnableMod then
		return
	end

	local GetDomeAtPoint = GetDomeAtPoint
	local colonists = UICity.labels.Colonist or ""
	for i = 1, #colonists do
		local colonist = colonists[i]
		local dome_at_pt = GetDomeAtPoint(colonist:GetVisualPos())
		-- check if lemming is currently in a dome while wearing a suit
		if colonist:GetEntity():find("Unit_Astronaut") and dome_at_pt then
			-- normally called when they go through the airlock
			colonist:OnEnterDome(dome_at_pt)
			-- the colonist will wait around for a bit till they start moving, this forces them to do something
			colonist:SetCommand("Idle")
		end
	end
end
