-- See LICENSE for terms

local mod_SkipDelete

-- fired when settings are changed/init
local function ModOptions()
	mod_SkipDelete = CurrentModOptions:GetProperty("SkipDelete")
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
