-- See LICENSE for terms

local ChoOrig_MulDivRound = MulDivRound
local function fake_MulDivRound(value)
	return value * 10
end

local ChoOrig_FormatResourceValueMaxResource = FormatResourceValueMaxResource
function FormatResourceValueMaxResource(context_obj, value, max, resource, ...)
	MulDivRound = fake_MulDivRound
	local ret = ChoOrig_FormatResourceValueMaxResource(context_obj, value, max, resource, ...)
	MulDivRound = ChoOrig_MulDivRound
	return ret
end
