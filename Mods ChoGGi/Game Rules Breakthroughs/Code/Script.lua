-- See LICENSE for terms

local PlaceObj = PlaceObj
local table = table

local mod_BreakthroughsResearched
local mod_SortBreakthroughs
local mod_ExcludeBreakthroughs

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions

	mod_BreakthroughsResearched = options:GetProperty("BreakthroughsResearched")
	mod_SortBreakthroughs = options:GetProperty("SortBreakthroughs")
	mod_ExcludeBreakthroughs = options:GetProperty("ExcludeBreakthroughs")

	-- stop options from blanking out from ClassesPostprocess (2/2)
	if #options.properties == 0 then
		options.properties = nil
	end

end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

function OnMsg.ClassesPostprocess()
	if GameRulesMap.ChoGGi_AdvancedDroneDrive then
		return
	end

	ModOptions()

	-- sort by id
	local breaks
	if mod_SortBreakthroughs then
		breaks = table.icopy(Presets.TechPreset.Breakthroughs)
		table.sort(breaks, function(a, b)
			return a.id < b.id
		end)
	else
		-- random
		local temp_breaks = table.copy(Presets.TechPreset.Breakthroughs)
		breaks = {}
		for i = 1, #temp_breaks do
			local breakthrough = table.rand(temp_breaks)
			table.remove_value(temp_breaks, breakthrough)
			breaks[i] = breakthrough
		end
	end
--~ 	ex(breaks)

	local T = T
	local SafeTrans
	-- use rawget so game doesn't complain about _G
	if rawget(_G, "ChoGGi") then
		SafeTrans = ChoGGi.ComFuncs.Translate
	else
		local _InternalTranslate = _InternalTranslate
		local procall = procall

		SafeTrans = function(...)
			local varargs = ...
			local str
			procall(function()
				str = _InternalTranslate(T(varargs))
			end)
			return str or T(302535920011424, "You need to be in-game to see this text (or use my Library mod).")
		end
	end

	local name
	if mod_BreakthroughsResearched then
		name = _InternalTranslate(T(311, "Research"))
	else
		name = _InternalTranslate(T(510925660723, "Unlock"))
	end

	PlaceObj("GameRules", {
		challenge_mod = -50,
		description = T{302535920011598, "This will <name> all breakthroughs <yellow>no matter</yellow> if you've checked or unchecked any in the list.", name = name},
		display_name = T(11451, "Breakthrough") .. ": " .. T{302535920011599, "<name> All Breakthroughs", name = name},
		group = "Default",
		id = "ChoGGi_DoAllBreakthroughs",
		PlaceObj("Effect_Code", {
			OnApplyEffect = function(_, colony)
				colony = colony.SetTechResearched and colony or UIColony
				local func = mod_BreakthroughsResearched and colony.SetTechResearched or colony.SetTechDiscovered
				for i = 1, #breaks do
					func(colony, breaks[i].id)
				end
			end
		}),
	})

	for i = 1, #breaks do
		local def = breaks[i]
--~ 		ex(def)
		-- spaces don't work in image tags
		local image,newline
		if def.icon:find(" ", 1, true) then
			image = ""
			newline = ""
		else
			image = "<image " .. def.icon .. ">"
			newline = "\n\n"
		end
		local id = def.id
		PlaceObj("GameRules", {
			challenge_mod = -50,
			description = SafeTrans(def.description, def) .. newline .. image,
			display_name = T(11451, "Breakthrough") .. ": " .. T(def.display_name),
			group = "Default",
			id = "ChoGGi_" .. id,
			PlaceObj("Effect_Code", {
				OnApplyEffect = function(_, colony)
					if mod_ExcludeBreakthroughs then
						return
					end
					colony = colony.SetTechResearched and colony or UIColony
					if mod_BreakthroughsResearched then
						colony:SetTechResearched(id)
					else
						colony:SetTechDiscovered(id)
					end
				end
			}),
		})
	end

end

-- last checked picard 1008224: function Colony:GetUnregisteredBreakthroughs()
local function Colony_GetUnregisteredBreakthrough(self)
	local BreakthroughOrder = BreakthroughOrder
	local objs = Presets.TechPreset.Breakthroughs
	for i = 1, #objs do
		local tech = objs[i]
		-- we call this from TechAvailableCondition (inf loops are bad)
    if not table.find(BreakthroughOrder, tech.id) and not self:IsTechDiscovered(tech.id) then
			return tech
    end
  end
end

local lookup_rules
local function BuildRules()
	lookup_rules = {}
	local rules = g_CurrentMissionParams.idGameRules or empty_table
	for rule_id in pairs(rules) do
		-- build list of choggi rules
		if rule_id:sub(1, 7) == "ChoGGi_" then
			-- length of rule name minus 7 for prefix: ChoGGi_
			lookup_rules[rule_id:sub(-(rule_id:len()-7))] = true
		end
	end
end

-- block breakthroughs
local ChoOrig_Research_TechAvailableCondition = Research.TechAvailableCondition
function Research:TechAvailableCondition(tech, ...)
	if not mod_ExcludeBreakthroughs then
		return ChoOrig_Research_TechAvailableCondition(self, tech, ...)
	end

	if not lookup_rules then
		BuildRules()
	end

	if lookup_rules[tech.id] then
--~ 		-- return false to skip it
--~ 		return false
		-- not checking again if tech is in lookup_rules
		tech = Colony_GetUnregisteredBreakthrough(self)
	end

	return ChoOrig_Research_TechAvailableCondition(self, tech, ...)
end

local ChoOrig_SubsurfaceAnomaly_ScanCompleted = SubsurfaceAnomaly.ScanCompleted
function SubsurfaceAnomaly:ScanCompleted(scanner, ...)
  if self.tech_action == "breakthrough" then
		if not lookup_rules then
			BuildRules()
		end

		-- blocked breakthrough
		if lookup_rules[self.breakthrough_tech] then
			local tech = Colony_GetUnregisteredBreakthrough(scanner and scanner.city.colony or UIColony)
			-- not checking again if tech is in lookup_rules
			if tech then
				self.breakthrough_tech = tech.id
			end
		end

  end

	return ChoOrig_SubsurfaceAnomaly_ScanCompleted(self, scanner, ...)
end
