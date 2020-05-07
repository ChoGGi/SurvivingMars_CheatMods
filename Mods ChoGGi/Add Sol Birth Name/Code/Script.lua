-- See LICENSE for terms

function OnMsg.ColonistBorn(colonist)
	colonist.name = colonist:GetDisplayName() .. " " .. UICity.day
end
