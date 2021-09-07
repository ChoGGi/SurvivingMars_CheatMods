-- See LICENSE for terms

local orig_CargoTransporter_ExpeditionLoadRover = CargoTransporter.ExpeditionLoadRover
function CargoTransporter:ExpeditionLoadRover(...)
  local realm = GetRealm(self)
	local orig_MapGet = realm.MapGet

	-- don't do a filter check for o.class == class (by skipping extra params)
	realm.MapGet = function(world, class)
		return orig_MapGet(world, class)
	end

	orig_CargoTransporter_ExpeditionLoadRover(self, ...)
	realm.MapGet = orig_MapGet
end
