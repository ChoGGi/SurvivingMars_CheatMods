-- See LICENSE for terms

local function RemoveMoxieFromSuspend()
	local g_SuspendLabels = g_SuspendLabels
	for i = 1, #g_SuspendLabels do
		if g_SuspendLabels[i] == "MOXIE" then
			table.remove(g_SuspendLabels, i)
			break
		end
	end
end

-- add the tech to research
function OnMsg.ClassesPostprocess()
	if TechDef.ChoGGi_DustyMOXIE then
		return
	end

	PlaceObj("TechPreset", {
		SortKey = 11,
		position = range(11, 11),
		description = T(302535920011463, "No more suspension during dust storms."),
		display_name = T(302535920011464,"Remove MOXIE from dust storm suspend"),
		group = "Engineering",
		icon = "UI/Icons/traits_disable.tga",
		id = "ChoGGi_DustyMOXIE",
		PlaceObj("Effect_Code", {
			OnApplyEffect = function()
				RemoveMoxieFromSuspend()
			end,
		}),
	})

end

-- each time game loads check if tech is researched, if so remove MOXIE from dust suspend
function OnMsg.LoadGame()
	if UICity:IsTechResearched("ChoGGi_DustyMOXIE") then
		RemoveMoxieFromSuspend()
	end
end
