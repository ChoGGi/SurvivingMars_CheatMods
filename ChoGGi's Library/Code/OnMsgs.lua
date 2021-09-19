-- See LICENSE for terms

local DoneObject = DoneObject
local OnMsg = OnMsg

local RemoveAttachAboveHeightLimit = ChoGGi.ComFuncs.RemoveAttachAboveHeightLimit

-- we don't add shortcuts and ain't supposed to drink no booze
OnMsg.ShortcutsReloaded = ChoGGi.ComFuncs.Rebuildshortcuts
-- so we have shortcuts when LUA reloads
OnMsg.ReloadLua = ChoGGi.ComFuncs.Rebuildshortcuts

-- use this message to perform post-built actions on the final classes
function OnMsg.ClassesBuilt()
	-- add build cat for my items
	local BuildCategories = BuildCategories
	if not table.find(BuildCategories, "id", "ChoGGi") then
		BuildCategories[#BuildCategories+1] = {
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

		local UIColony = UIColony
		if not UIColony.ChoGGi then
			-- a place to store per-game values... that i'll use one of these days (tm)
			UIColony.ChoGGi = {}
		end
		if not UIColony.ChoGGi.version_init_LIB then
			UIColony.ChoGGi.version_init_ECM = ChoGGi.def.version
			UIColony.ChoGGi.version_init_LIB = ChoGGi.def_lib.version
			UIColony.ChoGGi.version_init_LuaRevision = LuaRevision
		end
		UIColony.ChoGGi.version_current_ECM = ChoGGi.def.version
		UIColony.ChoGGi.version_current_LIB = ChoGGi.def_lib.version
		UIColony.ChoGGi.version_current_LuaRevision = LuaRevision
		UIColony.ChoGGi.current_settings = table.copy(ChoGGi.UserSettings)
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

local function RemoveMyBlinky(o)
	if o.ChoGGi_blinky then
		DoneObject(o)
	end
end
-- obj cleanup if mod is removed from saved game
local function RemoveChoGGiObjects(skip_height)
	SuspendPassEdits("ChoGGiLibrary.OnMsgs.RemoveChoGGiObjects")

	-- MapDelete doesn't seem to work with func filtering?
	MapForEach(true, "RotatyThing", RemoveMyBlinky)

	-- any of my objs added in Classes_Objects.lua
	ChoGGi.ComFuncs.RemoveObjs("ChoGGi_ODeleteObjs")
	-- stop any units with pathing being shown (it'll error out anyways)
	ChoGGi.ComFuncs.Pathing_StopAndRemoveAll()

	-- remove any origin points above 65535 (or bad things happen)
	if not skip_height and ChoGGi.UserSettings.RemoveHeightLimitObjs then
		MapForEach("map", RemoveAttachAboveHeightLimit)
	end

	ResumePassEdits("ChoGGiLibrary.OnMsgs.RemoveChoGGiObjects")
end
OnMsg.SaveGame = RemoveChoGGiObjects

function OnMsg.LoadGame()
	ChoGGi.ComFuncs.UpdateDataTablesCargo()
	Startup()
	RemoveChoGGiObjects(true)

	-- prevent blank mission profile screen (from removing game rule mods mid-game)
	local rules = g_CurrentMissionParams.idGameRules
	if rules then
		local GameRulesMap = GameRulesMap
		for rule_id in pairs(rules) do
			-- If it isn't in the map then it isn't a valid rule
			if not GameRulesMap[rule_id] then
				rules[rule_id] = nil
			end
		end
	end
end
