-- See LICENSE for terms

local IsValid = IsValid
local Sleep = Sleep

local mod_SkipDelete
local mod_SalvageFullDepots

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_SkipDelete = CurrentModOptions:GetProperty("SkipDelete")
	mod_SalvageFullDepots = CurrentModOptions:GetProperty("SalvageFullDepots")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

function OnMsg.ClassesPostprocess()

	-- list controlled buildings
	ChoGGi.ComFuncs.AddXTemplate("EmptyMechDepot", "sectionStorage", {
		__context_of_kind = "MechanizedDepot",
		Icon = "UI/Icons/Sections/storage.tga",
		Title = T(302535920000176, "Empty Mech Depot"),
		RolloverTitle = T(302535920000176, "Empty Mech Depot"),
		RolloverText = T(302535920000177, "Empties out selected/moused over mech depot into a small depot in front of it."),
		OnContextUpdate = function(self, context)
			if context.stockpiled_amount > 0 then
				self:SetVisible(true)
				self:SetMaxHeight()
			else
				self:SetVisible(false)
				self:SetMaxHeight(0)
			end
		end,
		func = function(_, context)
			ChoGGi.ComFuncs.EmptyMechDepot(context, mod_SkipDelete)
		end,
	}, true)

end

local ChoOrig_MechanizedDepot_ToggleDemolish = MechanizedDepot.ToggleDemolish
function MechanizedDepot:ToggleDemolish(...)
	local ChoOrig_GetStored = self["GetStored_" .. self.resource]

	-- always "empty"
	self["GetStored_" .. self.resource] = function()
		return 0
	end

	ChoOrig_MechanizedDepot_ToggleDemolish(self, ...)

	-- if user cancels demo then restore orig func
	CreateGameTimeThread(function()
		-- wait for it
		while not self.demolishing do
			Sleep(500)
		end
		-- wait some more
		while self.demolishing do
			Sleep(1000)
		end
		-- eh doesn't hurt to check...
    if IsValid(self) then
      self["GetStored_" .. self.resource] = ChoOrig_GetStored
    end
	end)

end
