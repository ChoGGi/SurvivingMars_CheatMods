-- See LICENSE for terms

local ChoOrig_CargoTransporter_ExpeditionLoadRover = CargoTransporter.ExpeditionLoadRover
function CargoTransporter:ExpeditionLoadRover(...)
  local realm = GetRealm(self)
	local ChoOrig_MapGet = realm.MapGet

	-- don't do a filter check for o.class == class (by skipping extra params)
	realm.MapGet = function(world, class)
		return ChoOrig_MapGet(world, class)
	end

	ChoOrig_CargoTransporter_ExpeditionLoadRover(self, ...)
	realm.MapGet = ChoOrig_MapGet
end
