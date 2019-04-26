-- See LICENSE for terms

local OnMsg = OnMsg

-- we don't add shortcuts and ain't supposed to drink no booze
OnMsg.ShortcutsReloaded = ChoGGi.ComFuncs.Rebuildshortcuts
-- so we at least have keys when it happens (what is "it"?)
OnMsg.ReloadLua = ChoGGi.ComFuncs.Rebuildshortcuts

-- use this message to perform post-built actions on the final classes
function OnMsg.ClassesBuilt()
	-- add build cat for my items
	local ChoGGi = ChoGGi
	local bc = BuildCategories
	if not table.find(bc,"id","ChoGGi") then
		bc[#bc+1] = {
			id = "ChoGGi",
			name = ChoGGi.Strings[302535920001400--[[ChoGGi--]]],
			image = ChoGGi.library_path .. "UI/bmc_incal_resources.png",
		}
	end
end

-- this is when RocketPayload_Init is called (CityStart is too soon)
OnMsg.NewMapLoaded = ChoGGi.ComFuncs.UpdateDataTablesCargo
OnMsg.LoadGame = ChoGGi.ComFuncs.UpdateDataTablesCargo

-- needed for UICity and some others that aren't created till around then
local function UpdateNames()
	-- needs a delay to get GlobalVar names
	CreateRealTimeThread(function()
		Sleep(1000)
		ChoGGi.ComFuncs.RetName_Update()
	end)
end
OnMsg.CityStart = UpdateNames
OnMsg.LoadGame = UpdateNames

-- update my cached strings
OnMsg.TranslationChanged = ChoGGi.ComFuncs.UpdateStringsList
OnMsg.TranslationChanged = ChoGGi.ComFuncs.UpdateDataTablesCargo
OnMsg.TranslationChanged = ChoGGi.ComFuncs.UpdateDataTables

OnMsg.ModsReloaded = ChoGGi.ComFuncs.UpdateDataTables

ChoGGi.Temp.UIScale = (LocalStorage.Options.UIScale + 0.0) / 100

local function RemoveChoGGiObjects()
	SuspendPassEdits("ChoGGiLibrary.OnMsgs.RemoveChoGGiObjects")
	MapDelete(true, "RotatyThing", function(o)
		if o.ChoGGi_blinky then
			return true
		end
	end)
	ChoGGi.ComFuncs.RemoveObjs{
		"ChoGGi_OHexSpot",
		"ChoGGi_OVector",
		"ChoGGi_OSphere",
		"ChoGGi_OPolyline",
		"ChoGGi_OText",
		"ChoGGi_OCircle",
		"ChoGGi_OOrientation",
	}
	ResumePassEdits("ChoGGiLibrary.OnMsgs.RemoveChoGGiObjects")
end
OnMsg.SaveGame = RemoveChoGGiObjects
OnMsg.LoadGame = RemoveChoGGiObjects
