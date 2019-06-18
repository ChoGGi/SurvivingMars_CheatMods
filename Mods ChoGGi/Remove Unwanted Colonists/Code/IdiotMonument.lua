-- See LICENSE for terms

GlobalVar("g_IdiotMonument", false)

DefineClass.IdiotMonument = {
	__parents = {
		"Building",
	},
	entity = "IceSet_05",
}

function IdiotMonument:GameInit()
	-- if there's already one replace with new one
	if IsValid(g_IdiotMonument) then
		g_IdiotMonument:OnDemolish()
	end
	g_IdiotMonument = self

	self:SetScale(250)
	self:SetPos(self:GetPos()+point(0, 0, 5000), 10000)
end

function IdiotMonument:OnDemolish()
	g_IdiotMonument = false

	CreateGameTimeThread(function()
		PlayFX("ElectrostaticStormArea", "start", self)
		self.fx_actor_class = "Crystal"
		PlayFX("CrystalCompose", "attach1", self)
		Sleep(2500)
		for i = 100, 1, -1 do
			self:SetOpacity(i)
			Sleep(25)
		end
		DoneObject(self)
	end)
end

function OnMsg.ClassesPostprocess()
	if not BuildingTemplates.IdiotMonument then
		PlaceObj("BuildingTemplate", {
			"Id", "IdiotMonument",
			"template_class", "IdiotMonument",
			"construction_cost_Concrete", 1000,
			"display_name", T(302535920011239, [[Idiot Monument]]),
			"display_name_pl", T(302535920011240, [[Idiot Monuments]]),
			"description", T(302535920011241, [[Here kitty kitty kitty]]),
			"display_icon", CurrentModPath .. "UI/IdiotMonument.png",
			"build_category", "ChoGGi",
			"Group", "ChoGGi",
			"dome_forbidden", true,
			"encyclopedia_exclude", true,
			"on_off_button", false,
		})
	end
end
