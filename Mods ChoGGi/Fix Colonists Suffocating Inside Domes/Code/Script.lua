-- See LICENSE for terms

local GetDomeAtPoint = GetDomeAtPoint

function OnMsg.LoadGame()
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
