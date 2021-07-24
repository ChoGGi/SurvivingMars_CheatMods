-- See LICENSE for terms

local IsValid = IsValid
local Sleep = Sleep


local mod_SkipDelete
local mod_SalvageFullDepots

-- fired when settings are changed/init
local function ModOptions()
	mod_SkipDelete = CurrentModOptions:GetProperty("SkipDelete")
	mod_SalvageFullDepots = CurrentModOptions:GetProperty("SalvageFullDepots")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

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

local orig_MechanizedDepot_ToggleDemolish = MechanizedDepot.ToggleDemolish
function MechanizedDepot:ToggleDemolish(...)
	local orig_GetStored = self["GetStored_" .. self.resource]

	-- always "empty"
	self["GetStored_" .. self.resource] = function()
		return 0
	end

	orig_MechanizedDepot_ToggleDemolish(self, ...)

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

		self["GetStored_" .. self.resource] = orig_GetStored
	end)

end
