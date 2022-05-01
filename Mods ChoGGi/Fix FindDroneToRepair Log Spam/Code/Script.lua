-- See LICENSE for terms

local IsValid = IsValid
local table = table

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

function OnMsg.LoadGame()
	if not mod_EnableMod then
		return
	end

	local broke = g_BrokenDrones
  for i = #broke, 1, -1 do
    if not IsValid(broke[i]) then
      table.remove(broke, i)
    end
  end
end
