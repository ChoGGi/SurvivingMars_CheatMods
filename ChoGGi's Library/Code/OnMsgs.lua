-- See LICENSE for terms

local DoneObject = DoneObject
local OnMsg = OnMsg
local TranslationTable = TranslationTable

	-- think they fixed this, test it
--~ local RemoveAttachAboveHeightLimit = ChoGGi.ComFuncs.RemoveAttachAboveHeightLimit

-- We don't add shortcuts and ain't supposed to drink no booze
OnMsg.ShortcutsReloaded = ChoGGi.ComFuncs.Rebuildshortcuts
-- So we have shortcuts when LUA reloads
OnMsg.ReloadLua = ChoGGi.ComFuncs.Rebuildshortcuts

function OnMsg.ClassesPostprocess()
	-- the first time you open a ModItemOptionInputBox the text will be blank when it's the default text.
	-- opening a second time fixes it or appending the "default" text like so:
	local template = XTemplates.PropTextInput[1]
	local idx = table.find(template, "name", "OnMouseButtonDown(self, pos, button)")
	if idx then
		template[idx].func = function(self, pos, button)
			XPropControl.OnMouseButtonDown(self, pos, button)
			if self.enabled then
				local prop_meta = self.prop_meta
				local obj = ResolvePropObj(self.context)
--~ 				CreateMarsRenameControl(GetDialog(self), prop_meta.name, obj[prop_meta.id],
				CreateMarsRenameControl(GetDialog(self), prop_meta.name, obj[prop_meta.id] or prop_meta.default,
					function(name)
						name = name:trim_spaces()
						obj:SetProperty(prop_meta.id, name)
						self:OnPropUpdate(self.context, prop_meta, name)
					end, nil, self.context, prop_meta)
			end
		end
	end
end

function OnMsg.ClassesBuilt()
	-- Add build cat for my items
	local bc = BuildCategories
	if not table.find(bc, "id", "ChoGGi") then
		bc[#bc+1] = {
			id = "ChoGGi",
			name = TranslationTable[302535920000001--[[ChoGGi]]],
			image = ChoGGi.library_path .. "UI/bmc_incal_resources.png",
		}
	end
end

-- This is when RocketPayload_Init is called (CityStart is too soon)
OnMsg.NewMapLoaded = ChoGGi.ComFuncs.UpdateDataTablesCargo

-- Needed for UICity and some others that aren't created till around then
local function Startup()
	CreateRealTimeThread(function()
		-- Needs a delay to get GlobalVar names
		Sleep(1000)
		ChoGGi.ComFuncs.RetName_Update()

		local ChoGGi = ChoGGi
		local UIColony = UIColony
		if not UIColony.ChoGGi then
			-- A place to store per-game values... that i'll use one of these days (tm)
			UIColony.ChoGGi = {}
		end
		if not UIColony.ChoGGi.version_init_LIB then
			UIColony.ChoGGi.version_init_ECM = ChoGGi.def and ChoGGi.def.version
			UIColony.ChoGGi.version_init_LIB = ChoGGi.def_lib.version
			UIColony.ChoGGi.version_init_LuaRevision = LuaRevision
		end
		UIColony.ChoGGi.version_current_ECM = ChoGGi.def and ChoGGi.def.version
		UIColony.ChoGGi.version_current_LIB = ChoGGi.def_lib.version
		UIColony.ChoGGi.version_current_LuaRevision = LuaRevision
		-- Only update this when user, so I can see it
		if not ChoGGi.testing then
			UIColony.ChoGGi.current_settings = table.copy(ChoGGi.UserSettings)
		end
	end)

end

OnMsg.CityStart = Startup

-- Update my cached strings
function OnMsg.TranslationChanged()
	ChoGGi.ComFuncs.UpdateStringsList()
	ChoGGi.ComFuncs.UpdateDataTablesCargo()
	ChoGGi.ComFuncs.UpdateDataTables()
	--
	ChoGGi.ComFuncs.UpdateTablesSponComm()
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
local function RemoveChoGGiObjects()
--~ local function RemoveChoGGiObjects(skip_height)
	SuspendPassEdits("ChoGGi_Library.OnMsgs.RemoveChoGGiObjects")

	-- MapDelete doesn't seem to work with func filtering?
	MapForEach(true, "RotatyThing", RemoveMyBlinky)

	-- any of my Classes_Objects.lua that are still in the save
	ChoGGi.ComFuncs.RemoveObjs("ChoGGi_ODeleteObjs", true)
	-- stop any units with pathing being shown (it'll error out either way)
	ChoGGi.ComFuncs.Pathing_StopAndRemoveAll()

	-- think they fixed this, test it
--~ 	-- remove any origin points above 65535 (or bad things happen)
--~ 	if not skip_height and ChoGGi.UserSettings.RemoveHeightLimitObjs then
--~ 		MapForEach("map", RemoveAttachAboveHeightLimit)
--~ 	end

	ResumePassEdits("ChoGGi_Library.OnMsgs.RemoveChoGGiObjects")
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
