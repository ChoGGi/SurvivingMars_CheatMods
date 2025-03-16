-- See LICENSE for terms

local IsKindOf = IsKindOf
local CmpLower = CmpLower
local RetName = ChoGGi_Funcs.Common.RetName

local mod_EnableMod

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
OnMsg.ModsReloaded = ModOptions
OnMsg.ApplyModOptions = ModOptions

local function AddTemplate(template, params)
	-- check for and remove existing template
	ChoGGi_Funcs.Common.RemoveXTemplateSections(template, params.id, true)

	template[#template+1] = PlaceObj('XTemplateTemplate', {
		params.id, true,
		"Id", params.id,
		"__template", "InfopanelActiveSection",
		"__context_of_kind", params.__context_of_kind,
		"__condition", function()
			return mod_EnableMod
		end,
		"Icon", params.DisallowIcon,
		"Title", T(302535920012014, "No Auto-Landing"),
		"RolloverTitle", T(302535920012014, "No Auto-Landing"),
		"RolloverText", params.RolloverText,
		"RolloverHint", T(302535920012015, "<left_click> Toggle, <em>Ctrl+<left_click></em> Toggle All"),
		"OnContextUpdate", function(self, context)
			--
			if context.ChoGGi_RocketsAutoLand_Allow then
				self:SetIcon(params.AllowIcon)
				self:SetTitle(T(302535920012016, "Allow Auto-Landing"))
				self:SetRolloverTitle(T(302535920012016, "Allow Auto-Landing"))
			else
				self:SetIcon(params.DisallowIcon)
				self:SetTitle(T(302535920012014, "No Auto-Landing"))
				self:SetRolloverTitle(T(302535920012014, "No Auto-Landing"))
			end
			--
		end,
	}, {
		PlaceObj("XTemplateFunc", {
			"name", "OnActivate(self, context)",
			"parent", function(self)
				return self.parent
			end,
			"func", function(self, context)
				--
				if IsMassUIModifierPressed() then
					local enable
					if not context.ChoGGi_RocketsAutoLand_Allow then
						enable = true
					end

					local objs = UIColony:GetCityLabels("LandingPad")
					for i = 1, #objs do
						objs[i].ChoGGi_RocketsAutoLand_Allow = enable
					end

				else
					if context.ChoGGi_RocketsAutoLand_Allow then
						context.ChoGGi_RocketsAutoLand_Allow = nil
					else
						context.ChoGGi_RocketsAutoLand_Allow = true
					end
				end

				ObjModified(context)
				--
			end,
		}),
	})
end

function OnMsg.ClassesPostprocess()
	local template = XTemplates.ipBuilding[1]
	AddTemplate(template, {
		id = "ChoGGi_Template_RocketsAutoLand_PadToggle",
		__context_of_kind = "LandingPad",
		RolloverText = T(302535920012017, "Toggle allowing auto-land rockets to land here."),
		AllowIcon = "UI/Icons/ColonyControlCenter/rocket_g.tga",
		DisallowIcon = "UI/Icons/ColonyControlCenter/rocket_r.tga",
	})

	AddTemplate(template, {
		id = "ChoGGi_Template_RocketsAutoLand_RocketToggle",
		__context_of_kind = "RocketBase",
		RolloverText = T(302535920012018, "Toggle allowing this rocket to auto-land."),
		AllowIcon = "UI/Icons/Sections/work_in_connected_domes_on.tga",
		DisallowIcon = "UI/Icons/Sections/work_in_connected_domes_off.tga",
	})
end

local ChoOrig_RocketBase_WaitInOrbit = RocketBase.WaitInOrbit
function RocketBase:WaitInOrbit(...)
	-- Abort if not autoland or dust storm
	if not mod_EnableMod
		or not self.ChoGGi_RocketsAutoLand_Allow
		or not self:IsFlightPermitted()
		or self.expedition
	then
		return ChoOrig_RocketBase_WaitInOrbit(self, ...)
	end

	local map_id = self:GetMapID() or MainCity.map_id

	local landing_pads = Cities[map_id].labels.LandingPad or ""
	-- No pads, so wait in orbit?
	if #landing_pads == 0 then
		return ChoOrig_RocketBase_WaitInOrbit(self, ...)
	end

	-- Fire off what it needs to (or it tries to find BuildingTemplates.OrbitalProbe)
--~ 	CreateGameTimeThread(ChoOrig_RocketBase_WaitInOrbit, self, ...)

	-- Change order of landing pads to match names of pads, so user has some sort of order to follow.
	table.sort(landing_pads, function(a, b)
		return CmpLower(RetName(a), RetName(b))
	end)
	-- Filter list for usable landing pads
	landing_pads = table.ifilter(landing_pads, function(_, pad)
		return pad.ChoGGi_RocketsAutoLand_Allow and not pad:HasRocket()
	end)
	if #landing_pads == 0 then
		-- No free pads so wait in orbit for user
		return ChoOrig_RocketBase_WaitInOrbit(self, ...)
	end
	-- Land rocket on landing site
	local landing_pad = landing_pads[1]
	local landing_site = PlaceBuildingIn(self.landing_site_class, map_id) -- "RocketLandingSite"
	landing_site:SetPos(landing_pad:GetPos())
	landing_site:SetAngle(landing_pad:GetAngle())

	-- lua\RocketBase.lua RocketBase:OnPinClicked()
	local cargo = self.cargo or ""
	local passengers, drones
	for i = 1, #cargo do
		local cls = cargo[i].class
		if cls == "Passengers" then
			passengers = true
		elseif IsKindOf(g_Classes[cls], "Drone") and cargo[i].amount > 0 then
			drones = true
		end
	end
	landing_site.amount = 0
	landing_site.passengers = passengers
	landing_site.drones = drones
	landing_site.stockpiles_obstruct = true
	landing_site.override_palette = self:GetRocketPalette()
	landing_site.rocket = self

	self.landing_site = landing_site
	--~ 	-- use 	IsLandAutomated from ChoOrig_RocketBase_WaitInOrbit
--~ 	return self.auto_export and IsValid(self.landing_site)
	local orig_auto_export = self.auto_export
	self.auto_export = true
--~ 	return ChoOrig_RocketBase_WaitInOrbit(self, ...)
	CreateGameTimeThread(ChoOrig_RocketBase_WaitInOrbit, self, ...)
	self.auto_export = orig_auto_export

--~ 	self:SetCommand("LandOnMars", landing_site)
--~ 	self:UpdateStatus("landing")
end
