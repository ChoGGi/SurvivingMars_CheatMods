-- See LICENSE for terms

local OnMsg = OnMsg
local IsAttachAboveHeightLimit = ChoGGi.ComFuncs.IsAttachAboveHeightLimit
local function HasRotatyBlinky(o)
	if o.ChoGGi_blinky then
		return true
	end
end

-- we don't add shortcuts and ain't supposed to drink no booze
OnMsg.ShortcutsReloaded = ChoGGi.ComFuncs.Rebuildshortcuts
-- so we have shortcuts when LUA reloads
OnMsg.ReloadLua = ChoGGi.ComFuncs.Rebuildshortcuts

-- use this message to perform post-built actions on the final classes
function OnMsg.ClassesBuilt()
	-- add build cat for my items
	local bc = BuildCategories
	if not table.find(bc, "id", "ChoGGi") then
		bc[#bc+1] = {
			id = "ChoGGi",
			name = ChoGGi.Strings[302535920000001--[[ChoGGi]]],
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
function OnMsg.TranslationChanged()
	ChoGGi.ComFuncs.UpdateStringsList()
	ChoGGi.ComFuncs.UpdateDataTablesCargo()
	ChoGGi.ComFuncs.UpdateDataTables()
	ChoGGi.ComFuncs.UpdateOtherTables()
	-- true to update translated names
	ChoGGi.ComFuncs.RetName_Update(true)
end

function OnMsg.ModsReloaded()
	ChoGGi.ComFuncs.UpdateDataTables()
	ChoGGi.ComFuncs.UpdateTablesSponComm()
end

ChoGGi.Temp.UIScale = (LocalStorage.Options.UIScale + 0.0) / 100

-- obj cleanup if mod is removed from saved game
local function RemoveChoGGiObjects(skip_height)
	SuspendPassEdits("ChoGGiLibrary.OnMsgs.RemoveChoGGiObjects")

	local objs = MapGet(true, "RotatyThing", HasRotatyBlinky)
	for i = #objs, 1, -1 do
		objs[i]:delete()
	end

	-- any of my objs added in Classes_Objects.lua
	ChoGGi.ComFuncs.RemoveObjs("ChoGGi_ODeleteObjs")
	-- stop any units with pathing being shown (it'll error out anyways)
	ChoGGi.ComFuncs.Pathing_StopAndRemoveAll()

	-- remove any origin points above 65535 (or bad things happen)
	if not skip_height and ChoGGi.UserSettings.RemoveHeightLimitObjs then
		local objs = MapGet("map", IsAttachAboveHeightLimit)
		for i = #objs, 1, -1 do
			objs[i]:delete()
		end
	end

	ResumePassEdits("ChoGGiLibrary.OnMsgs.RemoveChoGGiObjects")
end
OnMsg.SaveGame = RemoveChoGGiObjects

function OnMsg.LoadGame()
	ChoGGi.ComFuncs.UpdateDataTablesCargo()
	Startup()
	RemoveChoGGiObjects(true)
end