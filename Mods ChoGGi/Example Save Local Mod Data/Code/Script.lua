-- See LICENSE for terms

local mod_id = "ChoGGi_ExampleSaveLocalModData"

local function SaveModData(data)
	if not data then
		-- if you keep the table somewhere
--~ 		data = SomeGlobalTableDataIsStoredIn
		return PrintError(mod_id .. "No data to save")
	end

	-- we want it stored as a table in LocalStorage, not a string (sometimes i send it as a string so)
	if type(data) == "string" then
		local err
		err, data = LuaCodeToTuple(data)
		if err then
			return PrintError(err)
		end
	end

	LocalStorage.ModPersistentData[mod_id] = data
	SaveLocalStorage()
end



local function LoadModData()
	local settings
	if LocalStorage.ModPersistentData[mod_id] then
		settings = LocalStorage.ModPersistentData[mod_id]
	end

	if not settings or not next(settings) then
		-- no settings so use defaults
		settings = {
			data1 = true,
			data2 = empty_table,
		}
	end

	return settings
end
