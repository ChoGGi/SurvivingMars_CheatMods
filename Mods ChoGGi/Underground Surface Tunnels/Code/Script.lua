-- See LICENSE for terms

if not g_AvailableDlc.picard then
	print(CurrentModDef.title, ": Below & Beyond DLC not installed! Abort!")
	return
end

local IsValid = IsValid
local ChoGGi_Funcs = ChoGGi_Funcs
local RetMapType = ChoGGi_Funcs.Common.RetMapType

local mod_EnableMod

-- Update mod options
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

DefineClass.ChoGGi_UndergroundTunnel = {
	__parents = {
		"Tunnel",
	},
}

local name_lookup = {
	surface = T(13858--[[Surface]]),
	underground = T(13605--[[Underground]]),
	asteroid = T(13859--[[Asteroid]]),
}

function ChoGGi_UndergroundTunnel:Init()
	-- Stop an error in logfile
	self.linked_obj = self

	-- Good enough
	self.name = name_lookup[RetMapType(nil, self:GetMapID())]
		.. " " .. T(889--[[Tunnel]]) .. " " .. os.time()

	-- Selection audio (doesn't work in DefineClass for whatever)
	self.fx_actor_class = "Tunnel"

end

-- Stop grids from connecting (haven't tested to see how buggy or not it is)
ChoGGi_UndergroundTunnel.MergeGrids = empty_func
ChoGGi_UndergroundTunnel.CreateElectricityElement = empty_func
ChoGGi_UndergroundTunnel.CreateLifeSupportElements = empty_func
ChoGGi_UndergroundTunnel.CleanTunnelMask = empty_func

-- Hide grid icons the lazy way
function OnMsg.SelectionAdded(obj)
	if IsKindOf(obj, "ChoGGi_UndergroundTunnel") then
		CreateRealTimeThread(function()
			Sleep(1)
			obj:DestroyAttaches("GridTileWater")
		end)
	end
end

-- Show list of tunnels and connect to one
function ChoGGi_UndergroundTunnel:ChooseAttachedTunnel()
	local item_list = {}
	local c = 0

	local objs = UIColony.city_labels.labels.ChoGGi_UndergroundTunnel or ""
	for i = 1, #objs do
		local obj = objs[i]
		c = c + 1
		item_list[c] = {
			text = obj.name,
			tunnel_obj = obj,
		}
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local new_tunnel = choice[1].tunnel_obj

		-- Disconnect connected tunnel(s), if any...
		if IsValid(self.linked_obj) then
			self:CleanUpTunnel()
		end
		if IsValid(new_tunnel.linked_obj) then
			new_tunnel:CleanUpTunnel()
		end

		-- Update tunnels with new pathing
		self.linked_obj = new_tunnel
		self:AddPFTunnel()

		new_tunnel.linked_obj = self
		new_tunnel:AddPFTunnel()

	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(0000, "Choose Attached Tunnel"),
		hint = T(0000, "Connect a tunnel to previously selected tunnel."),
	}
end

-- "The magic"
-- Tunnel:TraverseTunnel() calls this func
-- We can add a map transfer to it (and Traverse has already detached unit from map so no odd looking stuff)
local ChoOrig_Unit_SetHolder = Unit.SetHolder
function Unit:SetHolder(building, ...)
	if not mod_EnableMod then
		return ChoOrig_Unit_SetHolder(self, building, ...)
	end

	-- orig func doesn't check for valid so I doubt we need to but...
	if IsValid(building) and building:IsKindOf("ChoGGi_UndergroundTunnel") then
		self:TransferToMap(building:GetMapID())
	end

	return ChoOrig_Unit_SetHolder(self, building, ...)
end

function OnMsg.ClassesPostprocess()

	-- Add build menu entry
	if not BuildingTemplates.ChoGGi_UndergroundTunnel then
		local tunnel = BuildingTemplates.Tunnel
		PlaceObj("BuildingTemplate", {
			"Id", "ChoGGi_UndergroundTunnel",
			-- class name from DefineClass
			"template_class", "ChoGGi_UndergroundTunnel",

			"palette_color1", "inside_accent_food",
			"palette_color2", "outside_metal",
			"palette_color3", "outside_base",

			-- "Asteroid","Underground","Surface",
			-- defaults to surface only!
			-- use the below to remove realm limitation
			"disabled_in_environment1", "",
			"disabled_in_environment2", "",
			"disabled_in_environment3", "",
			"disabled_in_environment4", "",

			"dome_forbidden", true,
			"display_name", tunnel.display_name,
			"display_name_pl", tunnel.display_name_pl,
			"description", T(0000, "Connect single tunnels to each other, unlike regular tunnels this will not connect grids."),

			"display_icon", tunnel.display_icon,
			"entity", tunnel.entity,
			"build_category", "ChoGGi",
			"Group", "ChoGGi",
			"encyclopedia_exclude", true,

			"is_tall", true,
			"construction_cost_Concrete", tunnel.construction_cost_Concrete,
			"construction_cost_Metals", tunnel.construction_cost_Metals,
			"construction_cost_MachineParts", tunnel.construction_cost_MachineParts,
			"build_points", tunnel.build_points,
			"demolish_sinking", tunnel.demolish_sinking,
			"construction_mode", "construction",
			"on_off_button", tunnel.on_off_button,
			"prio_button", tunnel.prio_button,
		})
	end

	local xtemplate = XTemplates.ipBuilding[1]

	-- Fix "View Exit" button
	for i = 1, #xtemplate do
		local list = xtemplate[i]
		if #list > 40 then
			local idx = table.find(list, "Icon", "UI/Icons/IPButtons/tunnel.tga")
			list[idx].OnPress = function(self)
				local linked_obj = self.context.linked_obj
				local linked_obj_id = linked_obj:GetMapID()

				-- Move camera first then change map
				if IsValid(linked_obj) then
					CreateRealTimeThread(function()
						UpdateToMap(linked_obj_id)
					end)
				end

				if self.context:GetMapID() == linked_obj_id then
					ViewAndSelectObject(linked_obj)
				else
					CreateRealTimeThread(function()
						-- If not delayed then it'll be off in nowhere land (can't use thread from UpdateToMap or it'll never happen)
						Sleep(1000)
						ViewAndSelectObject(linked_obj)
					end)
				end

			end
			-- ABORT!
			break
		end
	end

	-- Check for and remove existing template
	ChoGGi_Funcs.Common.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_UndergroundTunnel_ChooseAttachedTunnel", true)
	-- Add choose tunnel button
	table.insert(xtemplate, 1,
		PlaceObj("XTemplateTemplate", {
			"Id" , "ChoGGi_Template_UndergroundTunnel_ChooseAttachedTunnel",
			-- No need to add this (I use it for my RemoveXTemplateSections func)
			"ChoGGi_Template_UndergroundTunnel_ChooseAttachedTunnel", true,
			-- The button only shows when the class object is selected
			"__context_of_kind", "ChoGGi_UndergroundTunnel",
			-- Main button
			"__template", "InfopanelButton",

			--
			"Title", T(0000, "Choose Tunnel"),
			"RolloverTitle", T(0000, "Choose Attached Tunnel"),
			"RolloverText", T(0000, "Choose other tunnel to connect to this tunnel (will disconnect any connected tunnel)."),
			"Icon", "UI/Icons/IPButtons/transport_route.tga",
			--
			"OnPress", function(self, gamepad)
				-- left click action (second arg is if ctrl is being held down)
				self.context:ChooseAttachedTunnel()
			end,
		})
	)

	ChoGGi_Funcs.Common.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_UndergroundTunnel_ShowAttachedTunnel", true)
	-- Add other tunnel info
	table.insert(xtemplate, 5,
		PlaceObj("XTemplateTemplate", {
			"Id" , "ChoGGi_Template_UndergroundTunnel_ShowAttachedTunnel",
			-- No need to add this (I use it for my RemoveXTemplateSections func)
			"ChoGGi_Template_UndergroundTunnel_ShowAttachedTunnel", true,
			-- The button only shows when the class object is selected
			"__context_of_kind", "ChoGGi_UndergroundTunnel",
			-- Section style
			"__template", "InfopanelActiveSection",
			-- It'll default to dome icon
			"Icon", "UI/Icons/Sections/grid.tga"
		}, {
			PlaceObj("XTemplateTemplate", {
				"__template", "InfopanelText",
				"Text", T(0000, "<UIStatus>"),
				-- function ChoGGi_UndergroundTunnel:GetUIStatus() returns text
			})
		})
	)
end

function ChoGGi_UndergroundTunnel:GetUIStatus()
	if IsValid(self.linked_obj) then
		return T{"Connected tunnel: <tunnel>",
			tunnel = self.linked_obj.name,
		}
	end

	return T{"Connected tunnel: <tunnel>",
		tunnel = T(720,"Nothing"),
	}
end

-- Change back linked_obj to self so it doesn't touch other tunnel
function ChoGGi_UndergroundTunnel:CleanUpTunnel(func, ...)
	self:RemovePFTunnel()
	self.linked_obj = self

	if func then
		return func(self, ...)
	end
end
function ChoGGi_UndergroundTunnel:OnSetDemolishing(...)
	return self:CleanUpTunnel(Tunnel.OnSetDemolishing, ...)
end
function ChoGGi_UndergroundTunnel:RebuildCancel(...)
	return self:CleanUpTunnel(Tunnel.RebuildCancel, ...)
end
function ChoGGi_UndergroundTunnel:Rebuild(...)
	return self:CleanUpTunnel(Tunnel.Rebuild, ...)
end
function ChoGGi_UndergroundTunnel:Done(...)
	return self:CleanUpTunnel(Tunnel.Done, ...)
end
function ChoGGi_UndergroundTunnel:Destroy(...)
	return self:CleanUpTunnel(Tunnel.Destroy, ...)
end
