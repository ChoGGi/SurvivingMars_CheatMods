-- See LICENSE for terms

local IsValid = IsValid
local IsKindOf = IsKindOf

local mod_EnableMod
local mod_CycleButton

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_CycleButton = CurrentModOptions:GetProperty("CycleButton")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local drones = {}
local function GetDrones(obj)
	if IsKindOf(obj, "DroneControl") then
		return obj.drones, #obj.drones
	end

	table.clear(drones)

	local c = 0
	local cc = obj.command_centers or ""
	for i = 1, #cc do
		local hub_drones = cc[i].drones or ""
		for j = 1, #hub_drones do
			local drone = hub_drones[j]
			if drone.target and IsValid(drone.target) then
				if drone.target.handle == obj.handle then
					c = c + 1
					drones[c] = drone
				else
					local parent = drone.target:GetParent()
					if parent and IsValid(parent)
						and parent.handle == obj.handle
					then
						c = c + 1
						drones[c] = drone
					end
				end
			end
		end
	end

	return drones, #drones
end

local viewed_drone
local function CycleDrones(building)
	local list, count = GetDrones(building)

	if count > 0 then
		-- dunno why they localed it, instead of making it InfobarObj:CycleObjects()...
		local idx = viewed_drone and table.find(list, viewed_drone) or 0
		idx = (idx % count) + 1
		local next_obj = list[idx]
		viewed_drone = next_obj

		ViewObjectMars(next_obj)
		XDestroyRolloverWindow()
	end
end

function OnMsg.SelectionAdded(obj)
	if not mod_EnableMod or IsKindOf(obj, "DroneControl") then
		return
	end

	SuspendPassEdits("ChoGGi.ShowDronesConstructionSite.OnSelected")
	local drones, count = GetDrones(obj)
	-- If no drones then skip this to not hide colonist arrows, if drones then probably not going to be any colonists...
	if count > 0 then
		SelectionArrowClearAll()
	end
	SelectionArrowAdd(drones)
	ResumePassEdits("ChoGGi.ShowDronesConstructionSite.OnSelected")
end

function OnMsg.ClassesPostprocess()

	local xtemplate = XTemplates.ipBuilding[1]

	-- Check for and remove existing template
	ChoGGi_Funcs.Common.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_CycleDrones_button", true)

	xtemplate[#xtemplate+1] = PlaceObj("XTemplateTemplate", {
		"Id" , "ChoGGi_Template_CycleDrones_button",
		-- No need to add this (I use it for my RemoveXTemplateSections func)
		"ChoGGi_Template_CycleDrones_button", true,
		-- The button only shows when the class object is selected
		"__context_of_kind", "CObject",
		-- Section button (see Source\Lua\XTemplates\Infopanel*.lua for more examples)
		"__template", "InfopanelActiveSection",
		-- Only show button when it meets the req
		"__condition", function(_, context)
			return mod_EnableMod and mod_CycleButton and IsValid(context)
		end,
		--
		"Title", T(0000, "Cycle Drones"),
		"RolloverTitle", T(0000, "Cycle Drones"),
		"RolloverText", T(0000, "Cycle through drones working on this building."),
		"Icon", "UI/Icons/Sections/drone.tga",
		}, {
		PlaceObj("XTemplateFunc", {
			"name", "OnActivate(self, context)",
			"parent", function(self)
				return self.parent
			end,
			"func", function(_, context)
				CycleDrones(context)
			end,
		}),
	})

end
