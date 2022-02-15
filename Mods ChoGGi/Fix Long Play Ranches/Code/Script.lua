-- See LICENSE for terms

if not g_AvailableDlc.shepard then
	print(CurrentModDef.title, ": Project Laika DLC not installed!")
	return
end

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

local ChoOrig_Pasture_ScaleAnimals = Pasture.ScaleAnimals
function Pasture:ScaleAnimals(...)
	if not mod_EnableMod then
		return ChoOrig_Pasture_ScaleAnimals(self, ...)
	end

  local scale = 85 + MulDivRound(self.current_herd_max_lifetime - self.current_herd_lifetime, 30, self.current_herd_max_lifetime)

	-- [LUA ERROR] Scale value exceeds its limits!
	-- Mars/Dlc/shepard/Code/Animals.lua(619): method ScaleAnimals
	-- it was trying to set them to around -35000 on Sol 2983
	if scale < 85 then
		scale = 85
		self.current_herd_lifetime = self.current_herd_max_lifetime
	end
	--

  for i = 1, #self.current_herd do
    self.current_herd[i]:SetScale(scale)
  end
end
