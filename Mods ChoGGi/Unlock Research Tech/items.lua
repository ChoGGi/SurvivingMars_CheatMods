-- See LICENSE for terms

local PlaceObj = PlaceObj
local T = T

-- add some descriptions
local SafeTrans, library_around
-- use rawget so game doesn't complain about _G
if rawget(_G, "ChoGGi") then
	SafeTrans = ChoGGi.ComFuncs.Translate
	library_around = true
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

local mod_options = {}
local c = 0
local TechDef = TechDef
for id, def in pairs(TechDef) do
	if def.group ~= "Breakthroughs" and id ~= "None" then

		-- spaces don't work in image tags
		local image,newline
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
local _InternalTranslate = _InternalTranslate
table.sort(mod_options, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)

-- stick res option first
table.insert(mod_options, 1, PlaceObj("ModItemOptionToggle", {
	"name", "TechResearched",
	"DisplayName", "<yellow>" .. SafeTrans(T(302535920011857, "Tech Researched")),
	"Help", T(302535920011858, "Turn on to research instead of unlock tech."),
	"DefaultValue", false,
}))
table.insert(mod_options, 1, PlaceObj("ModItemOptionToggle", {
	"name", "AlwaysApplyOptions",
	"DisplayName", "<yellow>" .. SafeTrans(T(302535920011859, "Always Apply Options")),
	"Help", T(302535920011860, "Unlock/Research techs whenever you load a game/start a new game (otherwise you need to press Apply in mod options)."),
	"DefaultValue", false,
}))

return mod_options
