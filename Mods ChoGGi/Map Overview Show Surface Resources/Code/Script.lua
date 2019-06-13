-- See LICENSE for terms

local options
local mod_ShowPolymers
local mod_ShowMetals
local mod_TextOpacity

-- fired when settings are changed and new/load
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

local lookup = {}
local text_table = {}

local function AddIcons()
	local pairs, type = pairs, type
	local point = point
	local table_iclear = table.iclear
	local table_concat = table.concat
	lookup.Metals = _InternalTranslate(T(3514,"Metals"))
	lookup.Polymers = _InternalTranslate(T(3515,"Polymers"))

	local r = const.ResourceScale

	local g_MapSectors = g_MapSectors
	for sector in pairs(g_MapSectors) do
		-- skip 1-10
		if type(sector) == "table" then
			local surf_res = sector.deposits.surface
			table_iclear(text_table)
			local c = 0
			for id, amount in pairs(surf_res) do

				if id == "Metals" and mod_ShowMetals then
					c = c + 1
					text_table[c] = lookup[id] .. ": " .. amount / r
				elseif id == "Polymers" and mod_ShowPolymers then
					c = c + 1
					text_table[c] = lookup[id] .. ": " .. amount / r
				end

			end
			if c > 0 then
				local text = ChoGGi_OText_SurResMod:new()
				text:SetText(table_concat(text_table, "\n"))
				text:SetPos(sector:GetPos())
				text:SetOpacityInterpolation(mod_TextOpacity)
			end
		end
	end
end

local orig_OverviewModeDialog_Init = OverviewModeDialog.Init
function OverviewModeDialog.Init(...)
	AddIcons()
	return orig_OverviewModeDialog_Init(...)
end

local orig_OverviewModeDialog_Close = OverviewModeDialog.Close
function OverviewModeDialog.Close(...)
	MapDelete("map", "ChoGGi_OText_SurResMod")
	return orig_OverviewModeDialog_Close(...)
end

-- we don't want them around for saves
function OnMsg.SaveGame()
	SuspendPassEdits("Map Overview Show Loose Resources.SaveGame")
	MapDelete("map", "ChoGGi_OText_SurResMod")
	ResumePassEdits("Map Overview Show Loose Resources.SaveGame")
end
