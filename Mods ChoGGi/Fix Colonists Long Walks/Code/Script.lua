-- See LICENSE for terms

local mod_EnableMod

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local dome_walk_dist = const.ColonistMaxDomeWalkDist

local ChoOrig_AreDomesConnectedWithPassage = AreDomesConnectedWithPassage
function AreDomesConnectedWithPassage(d1, d2, ...)
	if not mod_EnableMod then
		return ChoOrig_AreDomesConnectedWithPassage(d1, d2, ...)
	end

	return ChoOrig_AreDomesConnectedWithPassage(d1, d2, ...)
		-- If orig func returns true then check if domes are within walking dist
		-- "d1 == d2" is from orig func (no need to check dist if both domes are the same)
		and (d1 == d2 or d1:GetDist2D(d2) <= dome_walk_dist)
end


--~ local ChoOrig_Colonist_Goto = Colonist.Goto
--~ function Colonist:Goto(pos, ...)

--~ 	if not mod_EnableMod then
--~ 		return ChoOrig_Colonist_Goto(self, pos, ...)
--~ 	end

--~   local curr_pos = self:GetVisualPos()
--~ 	if curr_pos:Dist2D(pos) > dome_walk_dist then
--~ 		ex(self)
--~ 			UICity:SetGameSpeed(0)
--~ 			UISpeedState = "pause"

--~ 		self:SetCommand("Idle")
--~ 		return
--~ 	end

--~ 	return ChoOrig_Colonist_Goto(self, pos, ...)
--~ end
