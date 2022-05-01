-- See LICENSE for terms

local CmpLower = CmpLower
local RetName = ChoGGi.ComFuncs.RetName

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
	ChoGGi.ComFuncs.RemoveXTemplateSections(template, params.id, true)

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
			---
			if context.ChoGGi_RocketsAutoLand_Allow then
				self:SetIcon(params.AllowIcon)
				self:SetTitle(T(302535920012016, "Allow Auto-Landing"))
				self:SetRolloverTitle(T(302535920012016, "Allow Auto-Landing"))
			else
				self:SetIcon(params.DisallowIcon)
				self:SetTitle(T(302535920012014, "No Auto-Landing"))
				self:SetRolloverTitle(T(302535920012014, "No Auto-Landing"))
			end
			---
		end,
	}, {
		PlaceObj("XTemplateFunc", {
			"name", "OnActivate(self, context)",
			"parent", function(self)
				return self.parent
			end,
			"func", function(self, context)
				---
				if IsMassUIModifierPressed() then
					local enable
					if not context.ChoGGi_RocketsAutoLand_Allow then
						enable = true
					end

					local objs = UICity.labels.LandingPad or ""
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
				---
			end,
		}),
	})
end

--~ function OnMsg.ClassesGenerate()
function OnMsg.ClassesPostprocess()
	-- no mod options in classes msgs

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
	-- abort if not autoland or duststorm
	if not mod_EnableMod
		or not self.ChoGGi_RocketsAutoLand_Allow
		or not self:IsFlightPermitted()
	then
		return ChoOrig_RocketBase_WaitInOrbit(self, ...)
	end

	local objs = UICity.labels.LandingPad or ""
	-- no pads, so wait in orbit?
	if #objs == 0 then
		return ChoOrig_RocketBase_WaitInOrbit(self, ...)
	end

	-- fire off what it needs to (or it tries to find BuildingTemplates.OrbitalProbe)
	CreateGameTimeThread(ChoOrig_RocketBase_WaitInOrbit, self, ...)

	-- change order of landing pads to match names of pads, so user has some sort of order to follow.
	table.sort(objs, function(a, b)
		return CmpLower(RetName(a), RetName(b))
	end)
	-- filter list for usable landing pads
	objs = table.ifilter(objs, function(_, obj)
		return obj.ChoGGi_RocketsAutoLand_Allow and not obj:HasRocket()
	end)
	-- no free pads so wait in orbit for user
	if #objs == 0 then
		return ChoOrig_RocketBase_WaitInOrbit(self, ...)
	end
	-- land rocket on landing site
	local landing_pad = objs[1]
	local landing_site = PlaceBuilding("RocketLandingSite")
	landing_site:SetPos(landing_pad:GetPos())
	landing_site:SetAngle(landing_pad:GetAngle())

	self:SetCommand("LandOnMars", landing_site)

end
