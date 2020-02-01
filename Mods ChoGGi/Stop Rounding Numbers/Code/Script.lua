-- See LICENSE for terms

local orig_MulDivRound = MulDivRound
local function fake_MulDivRound(value)
	return value * 10
end

local orig_FormatResourceValueMaxResource = FormatResourceValueMaxResource
function FormatResourceValueMaxResource(context_obj, value, max, resource, ...)
	MulDivRound = fake_MulDivRound
	local ret = orig_FormatResourceValueMaxResource(context_obj, value, max, resource, ...)
	MulDivRound = orig_MulDivRound
	return ret
end
