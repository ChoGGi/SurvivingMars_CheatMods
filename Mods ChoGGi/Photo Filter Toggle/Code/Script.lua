-- See LICENSE for terms

local options
local photos = {}
local photo_c = 0

local PhotoFilterPresetMap = PhotoFilterPresetMap
for id in pairs(PhotoFilterPresetMap) do
	if id ~= "None" then
		photo_c = photo_c + 1
		photos[photo_c] = id
	end
end

local CmpLower = CmpLower
table.sort(photos, function(a, b)
	return CmpLower(a, b)
end)

local function ApplyFilter()
	local apply
	for i = 1, photo_c do
		local filter = photos[i]
		if options:GetProperty(filter) then
			apply = filter
		end
	end

	if not UICity then
		return
	end

	apply = PhotoFilterPresetMap[apply]
	if apply then
		g_PhotoFilter = apply:GetShaderDescriptor()
	else
		g_PhotoFilter = false
	end
	PP_Rebuild()

end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ApplyFilter()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ApplyFilter()
end

OnMsg.CityStart = ApplyFilter
OnMsg.LoadGame = ApplyFilter
