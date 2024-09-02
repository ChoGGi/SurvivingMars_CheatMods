-- See LICENSE for terms

local PlaceObj = PlaceObj
local T = T
local _InternalTranslate = _InternalTranslate

-- add some descriptions
local SafeTrans
-- use rawget so game doesn't complain about _G
if rawget(_G, "ChoGGi") then
	SafeTrans = ChoGGi_Funcs.Common.Translate
else
	local procall = procall

	SafeTrans = function(...)
		local varargs = {...}
		local str
		procall(function()
			str = _InternalTranslate(T(table.unpack(varargs)))
		end)
		return str or T(302535920011424, "You need to be in-game to see this text (or use my Library mod).")
	end
end

local mod_options = {}
local c = #mod_options

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
		mod_options[c] = PlaceObj("ModItemOptionToggle", {
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
table.sort(mod_options, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)

table.insert(mod_options, 1, PlaceObj("ModItemOptionToggle", {
	"name", "AlwaysApplyOptions",
	"DisplayName", "<yellow>" .. _InternalTranslate(T(302535920011814, "Always Apply Options")),
	"Help", T(302535920011815, "Unlock/Research Breakthroughs whenever you load a game/start a new game (otherwise you need to press Apply in mod options)."),
	"DefaultValue", false,
}))
table.insert(mod_options, 2, PlaceObj("ModItemOptionToggle", {
	"name", "BreakthroughsResearched",
	"DisplayName", "<yellow>" .. _InternalTranslate(T(302535920011423, "Breakthroughs Researched")),
	"Help", T(302535920011813, "Turn on to research instead of unlock breakthroughs."),
	"DefaultValue", false,
}))
table.insert(mod_options, 3, PlaceObj("ModItemOptionToggle", {
	"name", "BreakthroughsRandomOrder",
	"DisplayName", "<yellow>" .. _InternalTranslate(T(0000, "Breakthroughs Random Order")),
	"Help", T(0000, "Unlock/Research breakthroughs in a random order."),
	"DefaultValue", true,
}))

return mod_options
