-- See LICENSE for terms

-- build list of traits/mod options
local mod_options = {}
local traits_list = {}
c = 0
local function AddColonists(list)
	for i = 1, #list do
		c = c + 1
		local id = list[i]
		traits_list[c] = id
		mod_options[id] = false
	end
end
local t = ChoGGi.Tables
AddColonists(t.ColonistAges)
AddColonists(t.NegativeTraits)
AddColonists(t.PositiveTraits)
AddColonists(t.OtherTraits)

-- call down the wrath of Zeus for miscreants
local IsValid = IsValid
local function UpdateMurderPods()
	local objs = UICity.labels.Colonist or ""
	for i = 1, c do
		local obj = objs[i]
		-- if colonist already has a pod after it then skip
		if not IsValid(obj.ChoGGi_MurderPod) then
			-- quicker to check age instead of looping all traits, so ageism rules
			if mod_options[obj.age_trait] then
				obj:ChoGGi_MP_LaunchPod()
			else
				-- loop through colonist traits for bad ones
				for id in pairs(obj.traits) do
					-- we found it, so stop checking rest of traits and on to next victim
					if mod_options[id] then
						obj:ChoGGi_MP_LaunchPod()
						break
					end
				end
			end
		end
	end
end

local options

-- fired when settings are changed/init
local function ModOptions()
	options = options or CurrentModOptions

	for i = 1, c do
		local id = traits_list[i]
		mod_options[id] = options:GetProperty("Trait_" .. id)
	end

	-- make sure we're not in menus
	if not GameState.gameplay then
		return
	end

	UpdateMurderPods()
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

OnMsg.NewHour = UpdateMurderPods
