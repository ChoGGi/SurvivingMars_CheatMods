-- See LICENSE for terms

local ChoOrig_MulDivRound = MulDivRound
local function ChoFake_MulDivRound(value)
	return value * 10
end

local ChoOrig_FormatResourceValueMaxResource = FormatResourceValueMaxResource
function FormatResourceValueMaxResource(context_obj, value, max, resource, ...)
	MulDivRound = ChoFake_MulDivRound
	-- I do pcalls for safety when wanting to change back a global var
	local result, ret = pcall(ChoOrig_FormatResourceValueMaxResource, context_obj, value, max, resource, ...)
	MulDivRound = ChoOrig_MulDivRound
	if result then
		return ret
	else
		print("ChoOrig_FormatResourceValueMaxResource failed!", ret)
	end
end
