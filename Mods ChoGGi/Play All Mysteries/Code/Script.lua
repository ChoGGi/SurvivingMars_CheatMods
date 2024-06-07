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

local function CheckFinished(mystery_names, mysteries_c, list)
--~	local g_CurrentMissionParams = g_CurrentMissionParams
--~	local UIColony = UIColony
--~	loop till we find one not finished or we've gone through them all
	
	
--~	local finished_c = 0
--~	local id = ""
	local filtered = {}
	
	-- sylar8376: 
	--			'UIColony:SelectMystery()' rolls randomly,
	--		which means there is a decent chance that 'mysteries_c + 1' rolls won't be enough to get to get 'new_myst'.
	--		Aka no mystery will be selected, essentially stopping the mod.
	--			Extra: 'UIColony:SelectMystery()' prioritizes unplayed mysteries (AccountStorage), so if 
	--		a player has that one mystery left unplayed but has it disabled in mod options, mod will just stop working for them
--~	while true do
--~
--~		g_CurrentMissionParams.idMystery = "random"
--~		UIColony:SelectMystery()
--~		local id = UIColony.mystery_id
--~		if not list[id] and not mod_skips[id] then
--~			-- found one
--~			new_myst = id
--~			break
--~		end
--~
--~		finished_c = finished_c + 1
--~		-- all are finished
--~		if finished_c > mysteries_c then
--~			break
--~		end
--~	end
	
	-- sylar8376: create 'filtered' list from 'mystery_names' without finished mysteries
	for i = 1, mysteries_c do
		if not list[mystery_names[i]] then
			filtered[#filtered + 1] = mystery_names[i]
		end
	end

	if #filtered > 0 then
		return filtered[Random(#filtered) + 1]
	else
		return false
	end
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
	
	--	sylar8376: remove DLC locked mysteries
	--			shamelessly borrowed from Mysteries.lua\Mysteries:SelectMystery()
	--			Ah, fine, remove mod_skips[] here too
	local name = ""
	for i = mysteries_c, 1, -1 do
		name = mystery_names[i]
		if not Platform.developer and not IsDlcAvailable(mysteries[i].dlc)
			or mod_skips[name] then
			
			table.remove(mysteries, i)
			table.remove(mystery_names, i)
			mysteries_c = mysteries_c - 1
		end
	end

	-- now that we've got a list of finished mysteries...
	new_myst = CheckFinished(mystery_names, mysteries_c, finished_mysteries)

	-- next pick a random one and check against per save file finished
	if not new_myst then
		new_myst = CheckFinished(mystery_names, mysteries_c, g_ChoGGi_PlayAllMysteries_Finished)
	end

	-- clear and restart the list when all finished (there's always one of them)
	-- sylar8376:
	--			warning: it should be working now
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
				T(0000, "Play All Mysteries Mod")
			)
		end
	end

--~ 	-- clear out old mysteries from s_SeqListPlayers (figured it would do it, guess not)
--~ 	local s_SeqListPlayers = s_SeqListPlayers
--~ 	for i = #s_SeqListPlayers, 1, -1 do
--~ 		local player = s_SeqListPlayers[i]
--~ 		if player.seq_list and tostring(player.seq_list.file_name):find("Mystery_", 1, true) then
--~ 			player:CleanUp()
--~ 			player:Done()
--~ 		end
--~ 	end

	CreateGameTimeThread(function()
		Sleep(delay or 0)

		-- else CheatStartMystery will mark the current one as finished
		UIColony.mystery = false
		UIColony.mystery_id = ""
		
		-- CheatStartMystery checks for cheats enabled...
		local ChoOrig_CheatsEnabled = CheatsEnabled
		function CheatsEnabled()
			return true
		end
	-- I do pcalls for safety when wanting to change back a global var
		pcall(CheatStartMystery, new_myst)
		CheatsEnabled = ChoOrig_CheatsEnabled

		--sylar8376:
		--			I'm pretty sure, Msg() goes through before mystery starts waiting
		--		I couldn't find related scripts. What am I missing?

		-- force skip waitmsg from St. Elmo's Fire
		--if new_myst == "LightsMystery" and g_ColonyNotViableUntil == -1 then
			--Msg("ColonyApprovalPassed")
		--end

		-- from Mysteries.lua\OnMsg.PostLoadGame()
		-- last checked 1011166
		if UIColony and UIColony.mystery then
			UIColony.mystery_id = UIColony.mystery.class
			--reload resource pretty desc/name
			UIColony.mystery:ApplyMysteryResourceProperties()
		end

		-- sylar8376: why? CheatStartMystery\mysteries:InitMysteries() already sent this msg
		Msg("MysteryChosen")
		
		-- sylar8376: send "ColonyApprovalPassed" here after a pause?
		if new_myst == "LightsMystery" and g_ColonyNotViableUntil == -1 then
			-- sylar8376:
			--			One hour wait should be enough, but let it be 6
			--		Nobody is going to notice anyway with 15+ sols of mystery's delay
			Sleep(const.Scale.sols / 4)
			Msg("ColonyApprovalPassed")
		end

--~ 		print("Play All Mysteries:", new_myst)
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
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- update per save list
function OnMsg.MysteryEnd()
	-- let user know
	if mod_ShowPopup then
		MsgPopup(
			T(0000, "Ended Mystery"),
			T(0000, "Play All Mysteries Mod")
		)
	end

  local mystery_id = UIColony.mystery_id
	local list = g_ChoGGi_PlayAllMysteries_Finished

	list[mystery_id] = true
	list[#list+1] = mystery_id

	PickRandomMystery(Random(mod_MinSols, mod_MaxSols))
end
