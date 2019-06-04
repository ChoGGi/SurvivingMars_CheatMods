-- See LICENSE for terms

local OnMsg = OnMsg

-- we don't add shortcuts and ain't supposed to drink no booze
OnMsg.ShortcutsReloaded = ChoGGi.ComFuncs.Rebuildshortcuts
-- so we at least have keys when it happens (what is "it"?)
OnMsg.ReloadLua = ChoGGi.ComFuncs.Rebuildshortcuts

-- use this message to perform post-built actions on the final classes
function OnMsg.ClassesBuilt()
	-- add build cat for my items
	local bc = BuildCategories
	if not table.find(bc, "id", "ChoGGi") then
		bc[#bc+1] = {
			id = "ChoGGi",
			name = ChoGGi.Strings[302535920001400--[[ChoGGi]]],
			image = ChoGGi.library_path .. "UI/bmc_incal_resources.png",
		}
	end
end

-- this is when RocketPayload_Init is called (CityStart is too soon)
OnMsg.NewMapLoaded = ChoGGi.ComFuncs.UpdateDataTablesCargo

-- needed for UICity and some others that aren't created till around then
local function Startup()
	-- needs a delay to get GlobalVar names
	CreateRealTimeThread(function()
		Sleep(1000)
		ChoGGi.ComFuncs.RetName_Update()
	end)
end

OnMsg.CityStart = Startup

-- update my cached strings
OnMsg.TranslationChanged = ChoGGi.ComFuncs.UpdateStringsList
OnMsg.TranslationChanged = ChoGGi.ComFuncs.UpdateDataTablesCargo
OnMsg.TranslationChanged = ChoGGi.ComFuncs.UpdateDataTables
OnMsg.TranslationChanged = ChoGGi.ComFuncs.UpdateOtherTables

OnMsg.ModsReloaded = ChoGGi.ComFuncs.UpdateDataTables
OnMsg.ModsReloaded = ChoGGi.ComFuncs.UpdateTablesSponComm

ChoGGi.Temp.UIScale = (LocalStorage.Options.UIScale + 0.0) / 100

-- obj cleanup if mod is removed from saved game
local function RemoveChoGGiObjects()
	SuspendPassEdits("ChoGGiLibrary.OnMsgs.RemoveChoGGiObjects")
	MapDelete(true, "RotatyThing", function(o)
		if o.ChoGGi_blinky then
			return true
		end
	end)
	ChoGGi.ComFuncs.RemoveObjs("ChoGGi_ODeleteObjs")
	ResumePassEdits("ChoGGiLibrary.OnMsgs.RemoveChoGGiObjects")
end
OnMsg.SaveGame = RemoveChoGGiObjects

function OnMsg.LoadGame()
	ChoGGi.ComFuncs.UpdateDataTablesCargo()
	Startup()
	RemoveChoGGiObjects()
end