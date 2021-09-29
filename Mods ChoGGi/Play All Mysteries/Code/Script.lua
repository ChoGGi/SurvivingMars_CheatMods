-- See LICENSE for terms

local ClassDescendantsList = ClassDescendantsList
local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local Random = ChoGGi.ComFuncs.Random

GlobalVar("g_ChoGGi_PlayAllMysteries_Finished", {})

local mod_EnableMod
local mod_SwitchMystery
local mod_ShowMystery
local mod_ShowPopup
local mod_MinSols
local mod_MaxSols
local mod_skips = {}

local function CheckFinished(new_myst, mysteries_c, list)
	local g_CurrentMissionParams = g_CurrentMissionParams
	local UIColony = UIColony
	-- loop till we find one not finished or we've gone through them all
	local finished_c = 0
	while true do

		g_CurrentMissionParams.idMystery = "random"
		UIColony:SelectMystery()
		local id = UIColony.mystery_id
		if not list[id] and not mod_skips[id] then
			-- found one
			new_myst = id
			break
		end

		finished_c = finished_c + 1
		-- all are finished
		if finished_c > mysteries_c then
			break
		end
	end
	return new_myst
end

local function PickRandomMystery(delay)
	if not mod_EnableMod or not UIColony then
		return
	end

	local new_myst = false
	-- build a list of mysteries player has finished and use those as a filter
	local finished_mysteries = {}

	-- hack? what hack?
	-- there's no mod access to AccountStorage, so we get mysteries by sending fake data to a func that can
	-- Lua\XTemplates\MysteryItem.lua: function(self, parent, context) -> parent:SetVisible(AccountStorage and AccountStorage.FinishedMysteries and AccountStorage.FinishedMysteries[context.value])
	local mystery_played = false
	local fake_parent = {
		SetVisible = function(_, toggle)
			mystery_played = toggle
		end,
	}
	local fake_context = {
		value = "some_myst_id",
	}

	-- [1]XTextButton[2]XImage[1]XTemplateCode
	local CheckMystFinished = XTemplates.MysteryItem[1][2][1].run

	local mystery_names = ClassDescendantsList("MysteryBase")
	local mysteries_c = #mystery_names
	local mysteries = {}

	local g_Classes = g_Classes
	for i = 1, mysteries_c do
		mysteries[i] = g_Classes[mystery_names[i]]
	end

	for i = 1, mysteries_c do
		local id = mysteries[i].class
		fake_context.value = id
		-- self is ignored, fake_parent gives us the finished state, fake_context sends the myst id
		CheckMystFinished(nil, fake_parent, fake_context)
		if mystery_played then
			finished_mysteries[id] = true
		end
	end

	-- now that we've got a list of finished mysteries...
	new_myst = CheckFinished(new_myst, mysteries_c, finished_mysteries)

	-- next pick a random one and check against per save file finished
	if not new_myst then
		new_myst = CheckFinished(new_myst, mysteries_c, g_ChoGGi_PlayAllMysteries_Finished)
	end

	-- clear and restart the list when all finished (there's always one of them)
	if not new_myst and #g_ChoGGi_PlayAllMysteries_Finished == mysteries_c then
		g_ChoGGi_PlayAllMysteries_Finished = {}
		new_myst = CheckFinished(new_myst, mysteries_c, g_ChoGGi_PlayAllMysteries_Finished)
	end

	-- doesn't hurt to check
	if not new_myst then
		return
	end

	-- let user know
	if mod_ShowPopup then
		if mod_ShowMystery then
			MsgPopup(
				mysteries[table.find(mysteries, "class", new_myst)].display_name,
				T(302535920012069, "Started Mystery")
			)
		else
			MsgPopup(
				T(302535920012069, "Started Mystery"),
				T(3486, "Mystery")
			)
		end
	end

	CreateGameTimeThread(function()
		Sleep(delay or 0)

		-- else CheatStartMystery will mark the current one as finished
		UIColony.mystery = false
		UIColony.mystery_id = ""

		-- CheatStartMystery checks for cheats enabled...
		local ChoOrig_CheatsEnabled = CheatsEnabled
		CheatsEnabled = function()
			return true
		end
		CheatStartMystery(new_myst)
		CheatsEnabled = ChoOrig_CheatsEnabled
	end)

end

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions
	mod_EnableMod = options:GetProperty("EnableMod")
	mod_SwitchMystery = options:GetProperty("SwitchMystery")
	mod_ShowMystery = options:GetProperty("ShowMystery")
	mod_ShowPopup = options:GetProperty("ShowPopup")
	mod_MinSols = options:GetProperty("MinSols") * const.Scale.sols
	mod_MaxSols = options:GetProperty("MaxSols") * const.Scale.sols

	local mystery_names = ClassDescendantsList("MysteryBase")
	for i = 1, #mystery_names do
		local myst_id = mystery_names[i]
		mod_skips[myst_id] = not options:GetProperty("MysteryClass_" .. myst_id)
	end

	if mod_SwitchMystery then
		PickRandomMystery()
	end
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- update per save list
function OnMsg.MysteryEnd()
  local mystery_id = UIColony.mystery_id
	local list = g_ChoGGi_PlayAllMysteries_Finished

	list[mystery_id] = true
	list[#list+1] = mystery_id

	PickRandomMystery(Random(mod_MinSols, mod_MaxSols))
end
