-- See LICENSE for terms

if not g_AvailableDlc.armstrong then
	print(CurrentModDef.title , ": Green Planet DLC not installed!")
	return
end

GlobalVar("g_ChoGGi_GM_TerraformingLocked", false)

function OnMsg.ClassesPostprocess()
	if GameRulesMap.FullyTerraformed then
		return
	end

	PlaceObj("GameRules", {
		challenge_mod = -50,
		description = T(302535920011425,"Start off with terraforming params maxed, and the ground green."),
		display_name = T(302535920011426, "Fully Terraformed"),
		flavor = T(323117615670, [[
<grey>"Boredom always precedes a period of great creativity."
<right>Robert M. Pirsig</grey><left>]]),
		group = "Default",
		id = "FullyTerraformed",
		PlaceObj("Effect_Code", {
			OnApplyEffect = function()
				-- max params
				local SetTerraformParamPct = SetTerraformParamPct
				for param in pairs(Terraforming) do
					SetTerraformParamPct(param, 100)
				end

				-- green soil
				SoilAddAmbient(100 * const.SoilGridScale, -1000)
				local objs = MainCity.labels.SoilRemove or ""
				for i = 1, #objs do
					objs[i]:ClearSoilUnderneath()
				end
				OnSoilGridChanged()

				--
				SuspendPassEdits("ChoGGi.FullyTerraformed.spawning some trees")
	-- might help speed it up?
	SuspendTerrainInvalidations("ChoGGi.ComFuncs.PlantRandomVegetation")

				-- spawn a bunch of trees
				if rawget(_G,"ChoGGi") and ChoGGi.ComFuncs.PlantRandomVegetation then
					ChoGGi.ComFuncs.PlantRandomVegetation(2500)
				elseif rawget(_G,"dbg_PlantRandomVegetation") then
					dbg_PlantRandomVegetation(1500)
				end
				-- eh... close enough for now
				for _ = 1, 20 do
					PlaceObjectIn("VegFocusTask", self:GetMapID(), {
						min_foci = 10,
						max_foci = 20,
						max_sq = 100 * const.SoilGridScale,
						min_to_spawn = 2500,
						max_to_spawn = 5000,
						veg_types = {
							"Grass",
							"Grass",
							"Grass",
							"Grass",
							"Grass"
						},
					})
				end

				--
	ResumeTerrainInvalidations("ChoGGi.ComFuncs.PlantRandomVegetation")
				ResumePassEdits("ChoGGi.FullyTerraformed.spawning some trees")
			end,
		}),
	})

	PlaceObj("GameRules", {
		challenge_mod = -100,
		description = T(302535920011427, "Terraforming params never go down."),
		display_name = T(302535920011428, "Terraforming Locked"),
		flavor = T(302535920011429, "\n" .. [[<grey>"Water, fire, air and dirt
Fucking magnets, how do they work?
And I don't wanna talk to a scientist
Y'all motherfuckers lying, and getting me pissed."
<right>Mike E. Clark</grey><left>]]),
		group = "Default",
		id = "TerraformingLocked",
		PlaceObj("Effect_Code", {
			OnApplyEffect = function()
				g_ChoGGi_GM_TerraformingLocked = true
			end,
		}),
	})
end

function OnMsg.TerraformParamChanged(name, new_value, old_value)
	if new_value < old_value and g_ChoGGi_GM_TerraformingLocked then
		SetTerraformParam(name, old_value)
	end
end
