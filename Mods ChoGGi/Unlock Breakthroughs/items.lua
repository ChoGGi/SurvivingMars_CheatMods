-- See LICENSE for terms

local PlaceObj = PlaceObj
local T = T

-- add some descriptions
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

local properties = {}
local c = 0

local bt = Presets.TechPreset.Breakthroughs
for i = 1, #bt do
	local def = bt[i]
	local id = def.id
	if id ~= "None" then
		-- spaces don't work in image tags...
		local image, newline
		if def.icon:find(" ", 1, true) then
			image = ""
			newline = ""
		else
			image = "<image " .. def.icon .. ">"
			newline = "\n\n"
		end

		c = c + 1
		properties[c] = PlaceObj("ModItemOptionToggle", {
			"name", id,
			"DisplayName", SafeTrans(def.display_name) .. (
				def.icon ~= "UI/Icons/Research/story_bit.tga" and " <right>" .. image or ""
			),
			"Help", SafeTrans(def.description, def) .. newline .. image,
			"DefaultValue", false,
		})
	end
end

local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(properties, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)

-- stick res option first
table.insert(properties, 1, PlaceObj("ModItemOptionToggle", {
	"name", "BreakthroughsResearched",
	"DisplayName", "<yellow>" .. SafeTrans(T(302535920011423, "Breakthroughs Researched")),
	"Help", T(302535920011813, "Turn on to research instead of unlock breakthroughs."),
	"DefaultValue", false,
}))
table.insert(properties, 1, PlaceObj("ModItemOptionToggle", {
	"name", "AlwaysApplyOptions",
	"DisplayName", "<yellow>" .. SafeTrans(T(302535920011814, "Always Apply Options")),
	"Help", T(302535920011815, "Unlock/Research Breakthroughs whenever you load a game/start a new game/apply options."),
	"DefaultValue", false,
}))

return properties
