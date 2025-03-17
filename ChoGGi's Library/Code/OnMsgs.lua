-- See LICENSE for terms

local ChoGGi_Funcs = ChoGGi_Funcs
local what_game = ChoGGi.what_game
local OnMsg = OnMsg
local T = T
local Translate = ChoGGi_Funcs.Common.Translate

-- I think the gc needs some help?
local g_env = _G
function OnMsg.ChoGGi_UpdateBlacklistFuncs(env)
	g_env = env

	local ChoOrig_ReloadLua = env.ReloadLua
	ChoGGi_Funcs.Common.AddToOriginal("ReloadLua")
	function env.ReloadLua(...)
		table.clear(env.ChoGGi_lookup_names)

		return ChoOrig_ReloadLua(...)
	end

end
	-- think they fixed this, test it
--~ local RemoveAttachAboveHeightLimit = ChoGGi_Funcs.Common.RemoveAttachAboveHeightLimit

-- We don't add shortcuts and ain't supposed to drink no booze
OnMsg.ShortcutsReloaded = ChoGGi_Funcs.Common.Rebuildshortcuts
-- So we have shortcuts when LUA reloads
OnMsg.ReloadLua = ChoGGi_Funcs.Common.Rebuildshortcuts

function OnMsg.ClassesPostprocess()
	if what_game == "Mars" then

		-- Add build cat for my items
		local bc = BuildCategories
		if not table.find(bc, "id", "ChoGGi") then
			bc[#bc+1] = {
				id = "ChoGGi",
				name = T(302535920000001--[[ChoGGi]]),
				image = ChoGGi.library_path .. "UI/bmc_incal_resources.png",
			}
		end

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
					CreateMarsRenameControl(GetDialog(self), prop_meta.name, obj[prop_meta.id] or prop_meta.default,
						function(name)
							name = name:trim_spaces()
							obj:SetProperty(prop_meta.id, name)
							self:OnPropUpdate(self.context, prop_meta, name)
						end, nil, self.context, prop_meta)
				end
			end
		end

		-- change rollover max width
		if ChoGGi.UserSettings.WiderRollovers then
			local roll = what_game == "Mars" and XTemplates.Rollover[1] or XTemplates.RolloverGeneric[1]
			local idx = table.find(roll, "Id", "idContent")
			if idx then
				roll = roll[idx]
				idx = table.find(roll, "Id", "idText")
				if idx then
					roll[idx].MaxWidth = ChoGGi.UserSettings.WiderRollovers
				end
			end
		end

	end -- what_game
end

-- This is when ResupplyItemsInit is called (CityStart is too soon)
OnMsg.NewMapLoaded = ChoGGi_Funcs.Common.UpdateDataTablesCargo

-- Needed for UICity and some others that aren't created till around then
local function Startup()
	if g_ParadoxAccountLoggedIn then
		printC("Paradox account signed in.")
	else
		print(Translate(302535920001471--[[Not signed into Paradox account, mods from Paradox Platform might be out of date!]]))
	end

	CreateRealTimeThread(function()
		-- Needs a delay to get GlobalVar names
		Sleep(1000)
		ChoGGi_Funcs.Common.RetName_Update()

		local ChoGGi = ChoGGi
		local UIColony = ChoGGi.is_gp and UICity or UIColony
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
	ChoGGi_Funcs.Common.UpdateStringsList()
	if ChoGGi.what_game == "Mars" then
		ChoGGi_Funcs.Common.UpdateDataTablesCargo()
		ChoGGi_Funcs.Common.UpdateDataTables()
		--
		ChoGGi_Funcs.Common.UpdateTablesSponComm()
		ChoGGi_Funcs.Common.UpdateOtherTables()
	end
	-- true to update translated names
	ChoGGi_Funcs.Common.RetName_Update(true)
end

function OnMsg.ModsReloaded()
	ChoGGi_Funcs.Common.UpdateDataTables()
	ChoGGi_Funcs.Common.UpdateTablesSponComm()
end

ChoGGi.Temp.UIScale = (LocalStorage.Options.UIScale + 0.0) / 100

-- obj cleanup if mod is removed from saved game
local function RemoveChoGGiObjects()
	SuspendPassEdits("ChoGGi_Library.OnMsgs.RemoveChoGGiObjects")

	local GameMaps = GameMaps
	for _, map in pairs(GameMaps) do
		-- MapDelete doesn't seem to work with func filtering?
		map.realm:MapForEach(true, "RotatyThing", function(o)
			if o.ChoGGi_blinky then
				o:delete()
			end
		end)
	end

	-- any of my Classes_Objects.lua that are still in the save
	ChoGGi_Funcs.Common.RemoveObjs("ChoGGi_ODeleteObjs", true)
	-- stop any units with pathing being shown (it'll error out either way)
	ChoGGi_Funcs.Common.Pathing_StopAndRemoveAll()

	ResumePassEdits("ChoGGi_Library.OnMsgs.RemoveChoGGiObjects")
end
OnMsg.SaveGame = RemoveChoGGiObjects

function OnMsg.LoadGame()
	ChoGGi_Funcs.Common.UpdateDataTablesCargo()
	Startup()
	RemoveChoGGiObjects()

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

	g_env.collectgarbage("collect")
	g_env.collectgarbage("collect")
end
