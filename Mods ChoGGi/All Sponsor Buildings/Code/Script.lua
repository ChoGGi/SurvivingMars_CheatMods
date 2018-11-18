function OnMsg.ModsReloaded()
	local spon_str = "sponsor_status%s"
	for _,bld in pairs(BuildingTemplates) do

			-- set each status to false if it isn't
			for i = 1, 3 do
				local str = spon_str:format(i)
				if bld[str] ~= false then
					bld[str] = false
				end
			end

	end
end
