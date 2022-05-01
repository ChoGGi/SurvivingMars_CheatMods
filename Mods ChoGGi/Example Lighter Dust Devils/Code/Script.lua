-- See LICENSE for terms


function OnMsg.ClassesBuilt()

	local type = type
	local g_Classes = g_Classes

	local function PaintItBlack(name)
		local cls = g_Classes[name]
		if not cls then
			return
		end
		local ChoOrig_func = cls.StartFX

		cls.StartFX = function(self)
			ChoOrig_func(self)
			self:GetAttaches()[1]:SetColorModifier(-1)

			local minions = self.minions
			if type(minions) == "table" and #minions > 0 then
				for i = 1, #minions do
					local par = minions[i]:GetAttaches()
					if type(par) == "table" and #par > 0 then
						par[1]:SetColorModifier(-1)
					end
				end
			end
		end
	end

	PaintItBlack("DustDevil1")
	PaintItBlack("DustDevil2")
	PaintItBlack("DustDevilMajor1")
	PaintItBlack("DustDevilMajor2")

end
