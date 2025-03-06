-- See LICENSE for terms

local function LoadModData()
	local settings
	if LocalStorage.ModPersistentData[CurrentModId] then
		settings = LocalStorage.ModPersistentData[CurrentModId]
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


local function SaveModData(data)
	if not data then
		-- if you keep the table somewhere
--~ 		LoadModData()
--~ 		data = SomeGlobalTableDataIsStoredIn
		return PrintError(CurrentModId .. "No data to save")
	end

	-- we want it stored as a table in LocalStorage, not a string (sometimes i send it as a string so)
	if type(data) == "string" then
		local err
		err, data = LuaCodeToTuple(data)
		if err then
			return PrintError(err)
		end
	end

	LocalStorage.ModPersistentData[CurrentModId] = data
	SaveLocalStorage()
end


LoadModData()
print(SaveModData(data))
