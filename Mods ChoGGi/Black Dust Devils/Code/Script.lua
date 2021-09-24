-- See LICENSE for terms

function OnMsg.ClassesBuilt()

	local type = type
	local g_Classes = g_Classes

	local function PaintItBlack(name)
		local ChoOrig_func = g_Classes[name].StartFX

		g_Classes[name].StartFX = function(self)
			ChoOrig_func(self)
			self:GetAttaches()[1]:SetColorModifier(0)

			local minions = self.minions
			if type(minions) == "table" and #minions > 0 then
				for i = 1, #minions do
					local par = minions[i]:GetAttaches()
					if type(par) == "table" and #par > 0 then
						par[1]:SetColorModifier(0)
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
