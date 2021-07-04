-- See LICENSE for terms

local IsValid = IsValid
local table = table

local mod_EnableMod

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

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
