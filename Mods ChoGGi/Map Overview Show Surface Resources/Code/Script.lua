-- See LICENSE for terms

local options
local mod_ShowPolymers
local mod_ShowMetals
local mod_TextOpacity

-- fired when settings are changed/init
local function ModOptions()
	mod_ShowPolymers = options.ShowPolymers
	mod_ShowMetals = options.ShowMetals
	mod_TextOpacity = options.TextOpacity
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= "ChoGGi_MapOverviewShowSurfaceResources" then
		return
	end

	ModOptions()
end

DefineClass.ChoGGi_OText_SurResMod = {
	__parents = {"Text"},
	text_style = "Action",
}

local text_table = {}

local function AddIcons()
	local pairs, type = pairs, type
	local table_iclear = table.iclear
	local table_concat = table.concat
	local str_Metals = _InternalTranslate(T(3514,"Metals"))
	local str_Polymers = _InternalTranslate(T(3515,"Polymers"))

	local r = const.ResourceScale
	local g_MapSectors = g_MapSectors

	SuspendPassEdits("ChoGGi_MapOverviewShowSurfaceResources:AddIcons")

	for sector in pairs(g_MapSectors) do
		-- skip 1-10
		if type(sector) == "table" then

			local metals_c = 0
			local polymers_c = 0
			local markers = sector.markers.surface
			for i = 1, #markers do
				local obj = markers[i].placed_obj
				-- placed_obj is removed from marker once it's empty
				if IsValid(obj) then
					if mod_ShowMetals and obj.resource == "Metals" then
						metals_c = metals_c + obj:GetAmount()
					elseif mod_ShowPolymers and obj.resource == "Polymers" then
						polymers_c = polymers_c + obj:GetAmount()
					end
				end
			end
			-- add text for found res
			table_iclear(text_table)
			local c = 0
			if metals_c > 0 then
				c = c + 1
				text_table[c] = str_Metals .. " " .. metals_c / r
			end
			if polymers_c > 0 then
				c = c + 1
				text_table[c] = str_Polymers .. " " .. polymers_c / r
			end

			if c > 0 then
				local text = ChoGGi_OText_SurResMod:new()
				text:SetText(table_concat(text_table, "\n"))
				text:SetPos(sector:GetPos())
				text:SetOpacityInterpolation(mod_TextOpacity)
			end
		end
	end

	ResumePassEdits("ChoGGi_MapOverviewShowSurfaceResources:AddIcons")
end

local orig_OverviewModeDialog_Init = OverviewModeDialog.Init
function OverviewModeDialog.Init(...)
	AddIcons()
	return orig_OverviewModeDialog_Init(...)
end

local function ClearIcons()
	SuspendPassEdits("ChoGGi_MapOverviewShowSurfaceResources:ClearIcons")
	MapDelete("map", "ChoGGi_OText_SurResMod")
	ResumePassEdits("ChoGGi_MapOverviewShowSurfaceResources:ClearIcons")
end

local orig_OverviewModeDialog_Close = OverviewModeDialog.Close
function OverviewModeDialog.Close(...)
	ClearIcons()
	return orig_OverviewModeDialog_Close(...)
end

-- we don't want them around for saves
OnMsg.SaveGame = ClearIcons
