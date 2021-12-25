-- See LICENSE for terms

local shorties = {
	"SolarArray",
	"SubsurfaceHeater",
	"Tunnel",
	"LandingPad", "TradePad",
	"DroneHub",
	"ShuttleHub", "JumperShuttleHub",
	"AutomaticMetalsExtractor",
	"MetalsRefinery", "RareMetalsRefinery",
	"FuelFactory",
	"WasteRockProcessor",
	"PolymerPlant",
	"DroneFactory",
	"MOXIE",
	"OxygenTank",
	"WaterExtractor",
	"MoistureVaporator",
	"FungalFarm",
	"OpenPasture",
	"MechanizedDepotConcrete",
	"MechanizedDepotElectronics",
	"MechanizedDepotFood",
	"MechanizedDepotFuel",
	"MechanizedDepotMachineParts",
	"MechanizedDepotMetals",
	"MechanizedDepotMysteryResource",
	"MechanizedDepotPolymers",
	"MechanizedDepotRareMetals",
	"MechanizedDepotSeeds",
}
local shorties_c = #shorties

function OnMsg.ClassesPostprocess()
	local bt = BuildingTemplates
	for i = 1, shorties_c do
		local template = bt[shorties[i]]
		-- some are from DLC
		if template then
			template.is_tall = false
		end
	end
end
