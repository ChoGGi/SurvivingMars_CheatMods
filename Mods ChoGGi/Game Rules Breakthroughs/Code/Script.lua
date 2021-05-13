-- See LICENSE for terms

local PlaceObj = PlaceObj
local table = table

local mod_BreakthroughsResearched
local mod_SortBreakthroughs
local mod_ExcludeBreakthroughs

-- fired when settings are changed/init
local function ModOptions()
	local options = CurrentModOptions

	mod_BreakthroughsResearched = options:GetProperty("BreakthroughsResearched")
	mod_SortBreakthroughs = options:GetProperty("SortBreakthroughs")
	mod_ExcludeBreakthroughs = options:GetProperty("ExcludeBreakthroughs")

	-- stop options from blanking out from ClassesPostprocess (2/2)
	if #options.properties == 0 then
		options.properties = nil
	end

end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

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
		description = T{302535920011598, "This will <name> all breakthroughs <yellow>no matter</yellow> if you've checked or unchecked any in the list.", name = name},
		display_name = T(11451, "Breakthrough") .. ": " .. T{302535920011599, "<name> All Breakthroughs", name = name},
		group = "Default",
		id = "ChoGGi_DoAllBreakthroughs",
		PlaceObj("Effect_Code", {
			OnApplyEffect = function(_, city)
				local func = mod_BreakthroughsResearched and city.SetTechResearched or city.SetTechDiscovered
				for i = 1, #breaks do
					func(city, breaks[i].id)
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
			description = SafeTrans(def.description, def) .. newline .. image,
			display_name = T(11451, "Breakthrough") .. ": " .. T(def.display_name),
			group = "Default",
			id = "ChoGGi_" .. id,
			PlaceObj("Effect_Code", {
				OnApplyEffect = function(_, city)
					if mod_ExcludeBreakthroughs then
						return
					end

					if mod_BreakthroughsResearched then
						city:SetTechResearched(id)
					else
						city:SetTechDiscovered(id)
					end
				end
			}),
		})
	end

end

local function City_GetUnregisteredBreakthroughs(self)
	local BreakthroughOrder = BreakthroughOrder
	local objs = Presets.TechPreset.Breakthroughs
	for i = 1, #objs do
		local tech = objs[i]
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
local orig_City_TechAvailableCondition = City.TechAvailableCondition
function City:TechAvailableCondition(tech, ...)
	if not mod_ExcludeBreakthroughs then
		return orig_City_TechAvailableCondition(self, tech, ...)
	end

	if not lookup_rules then
		BuildRules()
	end

	if lookup_rules[tech.id] then
--~ 		-- return false to skip it
--~ 		return false
	-- rand breakthrough to use instead
		tech = table.rand(City_GetUnregisteredBreakthroughs(self))
	end

	return orig_City_TechAvailableCondition(self, tech, ...)
end

local orig_SubsurfaceAnomaly_ScanCompleted = SubsurfaceAnomaly.ScanCompleted
function SubsurfaceAnomaly:ScanCompleted(scanner, ...)
  if self.tech_action == "breakthrough" then
		if not lookup_rules then
			BuildRules()
		end

		-- blocked breakthrough
		if lookup_rules[tech.id] then
			local breaks = (scanner and scanner.city or UICity):GetUnregisteredBreakthroughs()
			for i = 1, #breaks do
				local tech_id = breaks[i]
				-- if there's a rule left to use then use it, otherwise it's random tech
				if not lookup_rules[tech_id] then
					self.breakthrough_tech = tech_id
				end
			end
		end

  end

	return orig_SubsurfaceAnomaly_ScanCompleted(self, scanner, ...)
end


-- prevent blank mission profile screen
function OnMsg.LoadGame()
	local GameRulesMap = GameRulesMap
	local rules = g_CurrentMissionParams.idGameRules or empty_table
	for rule_id in pairs(rules) do
		-- If it isn't in the map then it isn't a valid rule
		if not GameRulesMap[rule_id] then
			rules[rule_id] = nil
		end
	end
end
