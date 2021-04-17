-- See LICENSE for terms

local mod_SignHeight
local mod_LowerHigher

local next = next
local point = point

local function GetHeight()
	local height = 0
	if mod_LowerHigher then
		height = (mod_SignHeight * 10) * -1
	else
		height = mod_SignHeight * 10
	end

	-- need a point obj for sign_offset
	return point(0, 0, height)
end

local function UpdateSigns()
	local height = GetHeight()
	local objs = UICity.labels.Building or ""
	for i = 1, #objs do
		local obj = objs[i]
		obj.sign_offset = height
		-- no sense in updating buildings with no signs
		if obj.signs and next(obj.signs) then
			obj:DoUpdateSignsVisibility()
		end
	end
end

-- fired when settings are changed/init
local function ModOptions()
	mod_SignHeight = CurrentModOptions:GetProperty("SignHeight")
	mod_LowerHigher = CurrentModOptions:GetProperty("LowerHigher")

	-- make sure we're in-game
	if not UICity then
		return
	end
	UpdateSigns()
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

OnMsg.CityStart = UpdateSigns
OnMsg.LoadGame = UpdateSigns

function OnMsg.BuildingInit(obj)
	obj.sign_offset = GetHeight()
	obj:DoUpdateSignsVisibility()
end
