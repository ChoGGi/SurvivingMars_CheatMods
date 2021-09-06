-- See LICENSE for terms

-- I included all the original costs just in case they change them later on.
-- This won't block extra materials from being added to the cost.

-- thanks to a "modder" removing objects I get to wrap all of these in ifs...

function OnMsg.ClassesPostprocess()
	local bt = BuildingTemplates

	if bt.ArtWorkshop then
		bt.ArtWorkshop.construction_cost_Concrete = 20000
		bt.ArtWorkshop.construction_cost_Polymers = 5000
		bt.ArtWorkshop.maintenance_build_up_per_hr = 600
		bt.ArtWorkshop.maintenance_resource_amount = 1000
		bt.ArtWorkshop.maintenance_resource_type = "Concrete"
	end

	if bt.ArtificialSun then
		bt.ArtificialSun.construction_cost_Concrete = 200000
		bt.ArtificialSun.construction_cost_Metals = 300000
		bt.ArtificialSun.construction_cost_Polymers = 300000
		bt.ArtificialSun.maintenance_build_up_per_hr = 600
		bt.ArtificialSun.maintenance_resource_amount = 3000
		bt.ArtificialSun.maintenance_resource_type = "Polymers"
	end

	if bt.AtomicBattery then
		bt.AtomicBattery.construction_cost_Concrete = 5000
		bt.AtomicBattery.construction_cost_Polymers = 5000
		bt.AtomicBattery.maintenance_build_up_per_hr = 600
		bt.AtomicBattery.maintenance_resource_amount = 2000
		bt.AtomicBattery.maintenance_resource_type = "Polymers"
	end

	if bt.Battery_WaterFuelCell then
		bt.Battery_WaterFuelCell.construction_cost_Concrete = 3000
		bt.Battery_WaterFuelCell.construction_cost_Polymers = 2000
		bt.Battery_WaterFuelCell.maintenance_build_up_per_hr = 600
		bt.Battery_WaterFuelCell.maintenance_resource_amount = 1000
		bt.Battery_WaterFuelCell.maintenance_resource_type = "Polymers"
	end

	if bt.BioroboticsWorkshop then
		bt.BioroboticsWorkshop.construction_cost_Concrete = 20000
		bt.BioroboticsWorkshop.construction_cost_MachineParts = 5000
		bt.BioroboticsWorkshop.maintenance_build_up_per_hr = 600
		bt.BioroboticsWorkshop.maintenance_resource_amount = 1000
		bt.BioroboticsWorkshop.maintenance_resource_type = "Concrete"
	end

	if bt.BlackCubeLargeMonument then
		bt.BlackCubeLargeMonument.construction_cost_BlackCube = 126000
	end

	if bt.BlackCubeMonolith then
		bt.BlackCubeMonolith.construction_cost_BlackCube = 284000
	end

	if bt.BlackCubeSmallMonument then
		bt.BlackCubeSmallMonument.construction_cost_BlackCube = 42000
	end

	local cc = bt["Casino Complex"] or bt.CasinoComplex
	if cc then
		cc.construction_cost_Concrete = 40000
		cc.construction_cost_Electronics = 20000
		cc.maintenance_build_up_per_hr = 600
		cc.maintenance_resource_amount = 2000
		cc.maintenance_resource_type = "Electronics"
	end

	if bt.CloningVats then
		bt.CloningVats.construction_cost_Electronics = 10000
		bt.CloningVats.construction_cost_Metals = 50000
		bt.CloningVats.construction_cost_Polymers = 20000
		bt.CloningVats.maintenance_build_up_per_hr = 600
		bt.CloningVats.maintenance_resource_amount = 3000
		bt.CloningVats.maintenance_resource_type = "Polymers"
	end

	if bt.DefenceTower then
		bt.DefenceTower.construction_cost_Electronics = 5000
		bt.DefenceTower.construction_cost_Metals = 10000
		bt.DefenceTower.maintenance_build_up_per_hr = 600
		bt.DefenceTower.maintenance_resource_amount = 1000
		bt.DefenceTower.maintenance_resource_type = "Electronics"
	end

	if bt.Diner then
		bt.Diner.construction_cost_Concrete = 10000
		bt.Diner.construction_cost_Metals = 5000
		bt.Diner.maintenance_build_up_per_hr = 600
		bt.Diner.maintenance_resource_amount = 1000
		bt.Diner.maintenance_resource_type = "Concrete"
	end

	if bt.DomeBasic then
		bt.DomeBasic.construction_cost_Concrete = 80000
		bt.DomeBasic.construction_cost_Metals = 20000
		bt.DomeBasic.construction_cost_Polymers = 10000
		bt.DomeBasic.maintenance_build_up_per_hr = 600
		bt.DomeBasic.maintenance_resource_amount = 1000
		bt.DomeBasic.maintenance_resource_type = "Concrete"
	end

	if bt.DomeDiamond then
		bt.DomeDiamond.construction_cost_Concrete = 100000
		bt.DomeDiamond.construction_cost_Metals = 150000
		bt.DomeDiamond.construction_cost_Polymers = 150000
		bt.DomeDiamond.maintenance_build_up_per_hr = 600
		bt.DomeDiamond.maintenance_resource_amount = 4000
		bt.DomeDiamond.maintenance_resource_type = "Polymers"
	end

	if bt.DomeHexa then
		bt.DomeHexa.construction_cost_Concrete = 50000
		bt.DomeHexa.construction_cost_Metals = 20000
		bt.DomeHexa.construction_cost_Polymers = 20000
		bt.DomeHexa.maintenance_build_up_per_hr = 600
		bt.DomeHexa.maintenance_resource_amount = 1000
		bt.DomeHexa.maintenance_resource_type = "Polymers"
	end

	if bt.DomeMedium then
		bt.DomeMedium.construction_cost_Concrete = 150000
		bt.DomeMedium.construction_cost_Metals = 80000
		bt.DomeMedium.construction_cost_Polymers = 25000
		bt.DomeMedium.maintenance_build_up_per_hr = 600
		bt.DomeMedium.maintenance_resource_amount = 2000
		bt.DomeMedium.maintenance_resource_type = "Polymers"
	end

	if bt.DomeMega then
		bt.DomeMega.construction_cost_Concrete = 300000
		bt.DomeMega.construction_cost_Metals = 200000
		bt.DomeMega.construction_cost_Polymers = 100000
		bt.DomeMega.maintenance_build_up_per_hr = 600
		bt.DomeMega.maintenance_resource_amount = 5000
		bt.DomeMega.maintenance_resource_type = "Polymers"
	end

	if bt.DomeMegaTrigon then
		bt.DomeMegaTrigon.construction_cost_Concrete = 200000
		bt.DomeMegaTrigon.construction_cost_Metals = 150000
		bt.DomeMegaTrigon.construction_cost_Polymers = 120000
		bt.DomeMegaTrigon.maintenance_build_up_per_hr = 600
		bt.DomeMegaTrigon.maintenance_resource_amount = 3000
		bt.DomeMegaTrigon.maintenance_resource_type = "Polymers"
	end

	if bt.DomeMicro then
		bt.DomeMicro.construction_cost_Concrete = 40000
		bt.DomeMicro.construction_cost_Metals = 30000
		bt.DomeMicro.maintenance_build_up_per_hr = 600
		bt.DomeMicro.maintenance_resource_amount = 1000
		bt.DomeMicro.maintenance_resource_type = "Concrete"
	end

	if bt.DomeOval then
		bt.DomeOval.construction_cost_Concrete = 150000
		bt.DomeOval.construction_cost_Metals = 150000
		bt.DomeOval.construction_cost_Polymers = 100000
		bt.DomeOval.maintenance_build_up_per_hr = 600
		bt.DomeOval.maintenance_resource_amount = 4000
		bt.DomeOval.maintenance_resource_type = "Polymers"
	end

	if bt.DomeTrigon then
		bt.DomeTrigon.construction_cost_Concrete = 100000
		bt.DomeTrigon.construction_cost_Metals = 60000
		bt.DomeTrigon.construction_cost_Polymers = 15000
		bt.DomeTrigon.maintenance_build_up_per_hr = 600
		bt.DomeTrigon.maintenance_resource_amount = 1500
		bt.DomeTrigon.maintenance_resource_type = "Polymers"
	end

	if bt.DroneFactory then
		bt.DroneFactory.construction_cost_Electronics = 10000
		bt.DroneFactory.construction_cost_Metals = 20000
		bt.DroneFactory.maintenance_build_up_per_hr = 600
		bt.DroneFactory.maintenance_resource_amount = 1000
		bt.DroneFactory.maintenance_resource_type = "Electronics"
	end

	if bt.DroneHub then
		bt.DroneHub.construction_cost_Electronics = 8000
		bt.DroneHub.construction_cost_Metals = 12000
		bt.DroneHub.maintenance_build_up_per_hr = 600
		bt.DroneHub.maintenance_resource_amount = 1000
		bt.DroneHub.maintenance_resource_type = "Electronics"
	end

	if bt.ElectricitySwitch then
		bt.ElectricitySwitch.construction_cost_Metals = 1000
	end

	if bt.ElectronicsFactory then
		bt.ElectronicsFactory.construction_cost_Concrete = 10000
		bt.ElectronicsFactory.construction_cost_Electronics = 15000
		bt.ElectronicsFactory.construction_cost_Metals = 5000
		bt.ElectronicsFactory.maintenance_build_up_per_hr = 600
		bt.ElectronicsFactory.maintenance_resource_amount = 3000
		bt.ElectronicsFactory.maintenance_resource_type = "MachineParts"
	end

	if bt.Farm then
		bt.Farm.construction_cost_Concrete = 8000
	end

	if bt.FountainLarge then
		bt.FountainLarge.construction_cost_Concrete = 4000
	end

	if bt.FountainSmall then
		bt.FountainSmall.construction_cost_Concrete = 2000
	end

	if bt.FuelFactory then
		bt.FuelFactory.construction_cost_Concrete = 5000
		bt.FuelFactory.construction_cost_MachineParts = 5000
		bt.FuelFactory.construction_cost_Metals = 5000
		bt.FuelFactory.maintenance_build_up_per_hr = 600
		bt.FuelFactory.maintenance_resource_amount = 1000
		bt.FuelFactory.maintenance_resource_type = "MachineParts"
	end

	if bt.FungalFarm then
		bt.FungalFarm.construction_cost_Concrete = 10000
		bt.FungalFarm.construction_cost_Electronics = 5000
		bt.FungalFarm.construction_cost_Metals = 15000
		bt.FungalFarm.maintenance_build_up_per_hr = 600
		bt.FungalFarm.maintenance_resource_amount = 1000
		bt.FungalFarm.maintenance_resource_type = "Metals"
	end

	if bt.FusionReactor then
		bt.FusionReactor.construction_cost_Concrete = 40000
		bt.FusionReactor.construction_cost_Electronics = 20000
		bt.FusionReactor.construction_cost_Polymers = 20000
		bt.FusionReactor.maintenance_build_up_per_hr = 600
		bt.FusionReactor.maintenance_resource_amount = 3000
		bt.FusionReactor.maintenance_resource_type = "Electronics"
	end

	if bt.GardenAlleys_Medium then
		bt.GardenAlleys_Medium.construction_cost_Concrete = 4000
	end

	if bt.GardenAlleys_Small then
		bt.GardenAlleys_Small.construction_cost_Concrete = 2000
	end

	if bt.GardenNatural_Medium then
		bt.GardenNatural_Medium.construction_cost_Concrete = 4000
	end

	if bt.GardenNatural_Small then
		bt.GardenNatural_Small.construction_cost_Concrete = 2000
	end

	if bt.GardenStone then
		bt.GardenStone.construction_cost_Concrete = 4000
	end

	if bt.GeoscapeDome then
		bt.GeoscapeDome.construction_cost_Concrete = 400000
		bt.GeoscapeDome.construction_cost_Metals = 200000
		bt.GeoscapeDome.construction_cost_Polymers = 300000
		bt.GeoscapeDome.maintenance_build_up_per_hr = 600
		bt.GeoscapeDome.maintenance_resource_amount = 3000
		bt.GeoscapeDome.maintenance_resource_type = "Polymers"
	end

	if bt.HangingGardens then
		bt.HangingGardens.construction_cost_Concrete = 40000
		bt.HangingGardens.construction_cost_Polymers = 10000
		bt.HangingGardens.maintenance_build_up_per_hr = 600
		bt.HangingGardens.maintenance_resource_amount = 4000
		bt.HangingGardens.maintenance_resource_type = "Concrete"
	end

	if bt.HydroponicFarm then
		bt.HydroponicFarm.construction_cost_Metals = 4000
		bt.HydroponicFarm.construction_cost_Polymers = 2000
		bt.HydroponicFarm.maintenance_build_up_per_hr = 600
		bt.HydroponicFarm.maintenance_resource_amount = 1000
		bt.HydroponicFarm.maintenance_resource_type = "Metals"
	end

	if bt.Infirmary then
		bt.Infirmary.construction_cost_Concrete = 15000
		bt.Infirmary.maintenance_build_up_per_hr = 600
		bt.Infirmary.maintenance_resource_amount = 1000
		bt.Infirmary.maintenance_resource_type = "Concrete"
	end

	if bt.Lake then
		bt.Lake.construction_cost_Concrete = 3000
	end

	if bt.LampProjector then
		bt.LampProjector.construction_cost_Concrete = 1000
	end

	if bt.LandingPad then
		bt.LandingPad.construction_cost_Concrete = 10000
	end

	if bt.LargeWaterTank then
		bt.LargeWaterTank.construction_cost_Concrete = 10000
		bt.LargeWaterTank.construction_cost_Metals = 30000
		bt.LargeWaterTank.maintenance_build_up_per_hr = 600
		bt.LargeWaterTank.maintenance_resource_amount = 3000
		bt.LargeWaterTank.maintenance_resource_type = "Metals"
	end

	if bt.LifesupportSwitch then
		bt.LifesupportSwitch.construction_cost_Metals = 1000
	end

	if bt.LightTrap then
		bt.LightTrap.construction_cost_Concrete = 10000
		bt.LightTrap.construction_cost_Electronics = 5000
		bt.LightTrap.construction_cost_Polymers = 5000
		bt.LightTrap.maintenance_build_up_per_hr = 600
		bt.LightTrap.maintenance_resource_amount = 1000
		bt.LightTrap.maintenance_resource_type = "Metals"
	end

	if bt.LivingQuarters then
		bt.LivingQuarters.construction_cost_Concrete = 10000
		bt.LivingQuarters.maintenance_build_up_per_hr = 600
		bt.LivingQuarters.maintenance_resource_amount = 1000
		bt.LivingQuarters.maintenance_resource_type = "Concrete"
	end

	if bt.MDSLaser then
		bt.MDSLaser.construction_cost_Electronics = 5000
		bt.MDSLaser.construction_cost_Metals = 15000
		bt.MDSLaser.maintenance_build_up_per_hr = 600
		bt.MDSLaser.maintenance_resource_amount = 1000
		bt.MDSLaser.maintenance_resource_type = "Electronics"
	end

	if bt.MOXIE then
		bt.MOXIE.construction_cost_Metals = 5000
		bt.MOXIE.maintenance_build_up_per_hr = 600
		bt.MOXIE.maintenance_resource_amount = 2000
		bt.MOXIE.maintenance_resource_type = "Metals"
	end

	if bt.MachinePartsFactory then
		bt.MachinePartsFactory.construction_cost_Concrete = 10000
		bt.MachinePartsFactory.construction_cost_Electronics = 2000
		bt.MachinePartsFactory.construction_cost_Metals = 10000
		bt.MachinePartsFactory.maintenance_build_up_per_hr = 600
		bt.MachinePartsFactory.maintenance_resource_amount = 2000
		bt.MachinePartsFactory.maintenance_resource_type = "Electronics"
	end

	if bt.MartianUniversity then
		bt.MartianUniversity.construction_cost_Concrete = 30000
		bt.MartianUniversity.construction_cost_Electronics = 20000
		bt.MartianUniversity.construction_cost_Metals = 10000
		bt.MartianUniversity.maintenance_build_up_per_hr = 600
		bt.MartianUniversity.maintenance_resource_amount = 3000
		bt.MartianUniversity.maintenance_resource_type = "Electronics"
	end

	if bt.MechanizedDepotConcrete then
		bt.MechanizedDepotConcrete.construction_cost_MachineParts = 3000
		bt.MechanizedDepotConcrete.construction_cost_Metals = 12000
		bt.MechanizedDepotConcrete.maintenance_build_up_per_hr = 600
		bt.MechanizedDepotConcrete.maintenance_resource_amount = 1000
		bt.MechanizedDepotConcrete.maintenance_resource_type = "MachineParts"
	end

	if bt.MechanizedDepotElectronics then
		bt.MechanizedDepotElectronics.construction_cost_MachineParts = 3000
		bt.MechanizedDepotElectronics.construction_cost_Metals = 12000
		bt.MechanizedDepotElectronics.maintenance_build_up_per_hr = 600
		bt.MechanizedDepotElectronics.maintenance_resource_amount = 1000
		bt.MechanizedDepotElectronics.maintenance_resource_type = "MachineParts"
	end

	if bt.MechanizedDepotFood then
		bt.MechanizedDepotFood.construction_cost_MachineParts = 3000
		bt.MechanizedDepotFood.construction_cost_Metals = 12000
		bt.MechanizedDepotFood.maintenance_build_up_per_hr = 600
		bt.MechanizedDepotFood.maintenance_resource_amount = 1000
		bt.MechanizedDepotFood.maintenance_resource_type = "MachineParts"
	end

	if bt.MechanizedDepotFuel then
		bt.MechanizedDepotFuel.construction_cost_MachineParts = 3000
		bt.MechanizedDepotFuel.construction_cost_Metals = 12000
		bt.MechanizedDepotFuel.maintenance_build_up_per_hr = 600
		bt.MechanizedDepotFuel.maintenance_resource_amount = 1000
		bt.MechanizedDepotFuel.maintenance_resource_type = "MachineParts"
	end

	if bt.MechanizedDepotMachineParts then
		bt.MechanizedDepotMachineParts.construction_cost_MachineParts = 3000
		bt.MechanizedDepotMachineParts.construction_cost_Metals = 12000
		bt.MechanizedDepotMachineParts.maintenance_build_up_per_hr = 600
		bt.MechanizedDepotMachineParts.maintenance_resource_amount = 1000
		bt.MechanizedDepotMachineParts.maintenance_resource_type = "MachineParts"
	end

	if bt.MechanizedDepotMetals then
		bt.MechanizedDepotMetals.construction_cost_MachineParts = 3000
		bt.MechanizedDepotMetals.construction_cost_Metals = 12000
		bt.MechanizedDepotMetals.maintenance_build_up_per_hr = 600
		bt.MechanizedDepotMetals.maintenance_resource_amount = 1000
		bt.MechanizedDepotMetals.maintenance_resource_type = "MachineParts"
	end

	if bt.MechanizedDepotMysteryResource then
		bt.MechanizedDepotMysteryResource.construction_cost_MachineParts = 3000
		bt.MechanizedDepotMysteryResource.construction_cost_Metals = 12000
		bt.MechanizedDepotMysteryResource.maintenance_build_up_per_hr = 600
		bt.MechanizedDepotMysteryResource.maintenance_resource_amount = 1000
		bt.MechanizedDepotMysteryResource.maintenance_resource_type = "MachineParts"
	end

	if bt.MechanizedDepotPolymers then
		bt.MechanizedDepotPolymers.construction_cost_MachineParts = 3000
		bt.MechanizedDepotPolymers.construction_cost_Metals = 12000
		bt.MechanizedDepotPolymers.maintenance_build_up_per_hr = 600
		bt.MechanizedDepotPolymers.maintenance_resource_amount = 1000
		bt.MechanizedDepotPolymers.maintenance_resource_type = "MachineParts"
	end

	if bt.MechanizedDepotRareMetals then
		bt.MechanizedDepotRareMetals.construction_cost_MachineParts = 3000
		bt.MechanizedDepotRareMetals.construction_cost_Metals = 12000
		bt.MechanizedDepotRareMetals.maintenance_build_up_per_hr = 600
		bt.MechanizedDepotRareMetals.maintenance_resource_amount = 1000
		bt.MechanizedDepotRareMetals.maintenance_resource_type = "MachineParts"
	end

	if bt.MedicalCenter then
		bt.MedicalCenter.construction_cost_Concrete = 30000
		bt.MedicalCenter.construction_cost_Metals = 30000
		bt.MedicalCenter.construction_cost_Polymers = 10000
		bt.MedicalCenter.maintenance_build_up_per_hr = 600
		bt.MedicalCenter.maintenance_resource_amount = 3000
		bt.MedicalCenter.maintenance_resource_type = "Polymers"
	end

	if bt.MetalsExtractor then
		bt.MetalsExtractor.construction_cost_Concrete = 20000
		bt.MetalsExtractor.construction_cost_MachineParts = 5000
		bt.MetalsExtractor.maintenance_build_up_per_hr = 600
		bt.MetalsExtractor.maintenance_resource_amount = 2000
		bt.MetalsExtractor.maintenance_resource_type = "MachineParts"
	end

	if bt.MoholeMine then
		bt.MoholeMine.construction_cost_Concrete = 400000
		bt.MoholeMine.construction_cost_MachineParts = 300000
		bt.MoholeMine.construction_cost_Metals = 100000
		bt.MoholeMine.maintenance_build_up_per_hr = 600
		bt.MoholeMine.maintenance_resource_amount = 3000
		bt.MoholeMine.maintenance_resource_type = "MachineParts"
	end

	if bt.MoistureVaporator then
		bt.MoistureVaporator.construction_cost_Metals = 2000
		bt.MoistureVaporator.construction_cost_Polymers = 5000
		bt.MoistureVaporator.maintenance_build_up_per_hr = 600
		bt.MoistureVaporator.maintenance_resource_amount = 2000
		bt.MoistureVaporator.maintenance_resource_type = "Metals"
	end

	if bt.NetworkNode then
		bt.NetworkNode.construction_cost_Concrete = 50000
		bt.NetworkNode.construction_cost_Electronics = 20000
		bt.NetworkNode.construction_cost_Metals = 50000
		bt.NetworkNode.maintenance_build_up_per_hr = 600
		bt.NetworkNode.maintenance_resource_amount = 3000
		bt.NetworkNode.maintenance_resource_type = "Electronics"
	end

	if bt.Nursery then
		bt.Nursery.construction_cost_Concrete = 10000
		bt.Nursery.maintenance_build_up_per_hr = 600
		bt.Nursery.maintenance_resource_amount = 1000
		bt.Nursery.maintenance_resource_type = "Concrete"
	end

	if bt.OmegaTelescope then
		bt.OmegaTelescope.construction_cost_Concrete = 400000
		bt.OmegaTelescope.construction_cost_Electronics = 300000
		bt.OmegaTelescope.construction_cost_Metals = 300000
		bt.OmegaTelescope.maintenance_build_up_per_hr = 600
		bt.OmegaTelescope.maintenance_resource_amount = 3000
		bt.OmegaTelescope.maintenance_resource_type = "Electronics"
	end

	if bt.OpenAirGym then
		bt.OpenAirGym.construction_cost_Metals = 10000
		bt.OpenAirGym.construction_cost_Polymers = 8000
	end

	if bt.OxygenTank then
		bt.OxygenTank.construction_cost_Metals = 3000
		bt.OxygenTank.maintenance_build_up_per_hr = 600
		bt.OxygenTank.maintenance_resource_amount = 1000
		bt.OxygenTank.maintenance_resource_type = "Metals"
	end

	if bt.Passage then
		bt.Passage.construction_cost_Concrete = 2000
	end

	if bt.PassageRamp then
		bt.PassageRamp.construction_cost_Concrete = 5000
	end

	if bt.Playground then
		bt.Playground.construction_cost_Polymers = 8000
	end

	if bt.PolymerPlant then
		bt.PolymerPlant.construction_cost_Concrete = 10000
		bt.PolymerPlant.construction_cost_MachineParts = 5000
		bt.PolymerPlant.construction_cost_Metals = 5000
		bt.PolymerPlant.maintenance_build_up_per_hr = 600
		bt.PolymerPlant.maintenance_resource_amount = 2000
		bt.PolymerPlant.maintenance_resource_type = "MachineParts"
	end

	if bt.PowerDecoy then
		bt.PowerDecoy.construction_cost_Concrete = 10000
		bt.PowerDecoy.construction_cost_Electronics = 5000
		bt.PowerDecoy.construction_cost_Polymers = 5000
	end

	if bt.PreciousMetalsExtractor then
		bt.PreciousMetalsExtractor.construction_cost_MachineParts = 5000
		bt.PreciousMetalsExtractor.construction_cost_Metals = 20000
		bt.PreciousMetalsExtractor.maintenance_build_up_per_hr = 600
		bt.PreciousMetalsExtractor.maintenance_resource_amount = 2000
		bt.PreciousMetalsExtractor.maintenance_resource_type = "MachineParts"
	end

	if bt.ProjectMorpheus then
		bt.ProjectMorpheus.construction_cost_Concrete = 200000
		bt.ProjectMorpheus.construction_cost_Electronics = 300000
		bt.ProjectMorpheus.construction_cost_Metals = 400000
		bt.ProjectMorpheus.maintenance_build_up_per_hr = 600
		bt.ProjectMorpheus.maintenance_resource_amount = 3000
		bt.ProjectMorpheus.maintenance_resource_type = "Electronics"
	end

	if bt.RCExplorerBuilding then
		bt.RCExplorerBuilding.construction_cost_Electronics = 10000
		bt.RCExplorerBuilding.construction_cost_Metals = 20000
	end

	if bt.RCRoverBuilding then
		bt.RCRoverBuilding.construction_cost_Electronics = 10000
		bt.RCRoverBuilding.construction_cost_Metals = 20000
	end

	if bt.RCTransportBuilding then
		bt.RCTransportBuilding.construction_cost_Electronics = 10000
		bt.RCTransportBuilding.construction_cost_Metals = 20000
	end

	if bt.RechargeStation then
		bt.RechargeStation.construction_cost_Metals = 1000
	end

	if bt.RefugeeRocket then
		bt.RefugeeRocket.construction_cost_Electronics = 20000
		bt.RefugeeRocket.construction_cost_Metals = 60000
	end

	if bt.RegolithExtractor then
		bt.RegolithExtractor.construction_cost_MachineParts = 2000
		bt.RegolithExtractor.construction_cost_Metals = 6000
		bt.RegolithExtractor.maintenance_build_up_per_hr = 600
		bt.RegolithExtractor.maintenance_resource_amount = 1000
		bt.RegolithExtractor.maintenance_resource_type = "MachineParts"
	end

	if bt.ResearchLab then
		bt.ResearchLab.construction_cost_Concrete = 15000
		bt.ResearchLab.construction_cost_Electronics = 8000
		bt.ResearchLab.maintenance_build_up_per_hr = 600
		bt.ResearchLab.maintenance_resource_amount = 1000
		bt.ResearchLab.maintenance_resource_type = "Electronics"
	end

	if bt.Sanatorium then
		bt.Sanatorium.construction_cost_Concrete = 50000
		bt.Sanatorium.construction_cost_Metals = 20000
		bt.Sanatorium.construction_cost_Polymers = 10000
		bt.Sanatorium.maintenance_build_up_per_hr = 600
		bt.Sanatorium.maintenance_resource_amount = 2000
		bt.Sanatorium.maintenance_resource_type = "Polymers"
	end

	if bt.School then
		bt.School.construction_cost_Concrete = 25000
		bt.School.construction_cost_Electronics = 10000
		bt.School.maintenance_build_up_per_hr = 600
		bt.School.maintenance_resource_amount = 2000
		bt.School.maintenance_resource_type = "Electronics"
	end

	if bt.ScienceInstitute then
		bt.ScienceInstitute.construction_cost_Concrete = 30000
		bt.ScienceInstitute.construction_cost_Electronics = 20000
		bt.ScienceInstitute.construction_cost_Polymers = 10000
		bt.ScienceInstitute.maintenance_build_up_per_hr = 600
		bt.ScienceInstitute.maintenance_resource_amount = 4000
		bt.ScienceInstitute.maintenance_resource_type = "Electronics"
	end

	if bt.SecurityStation then
		bt.SecurityStation.construction_cost_Concrete = 15000
		bt.SecurityStation.construction_cost_Metals = 5000
		bt.SecurityStation.maintenance_build_up_per_hr = 600
		bt.SecurityStation.maintenance_resource_amount = 1000
		bt.SecurityStation.maintenance_resource_type = "Concrete"
	end

	if bt.SensorTower then
		bt.SensorTower.construction_cost_Electronics = 1000
		bt.SensorTower.construction_cost_Metals = 1000
		bt.SensorTower.maintenance_build_up_per_hr = 600
		bt.SensorTower.maintenance_resource_amount = 1000
		bt.SensorTower.maintenance_resource_type = "Metals"
	end

	if bt.ShopsElectronics then
		bt.ShopsElectronics.construction_cost_Concrete = 10000
		bt.ShopsElectronics.construction_cost_Electronics = 3000
		bt.ShopsElectronics.maintenance_build_up_per_hr = 600
		bt.ShopsElectronics.maintenance_resource_amount = 1000
		bt.ShopsElectronics.maintenance_resource_type = "Concrete"
	end

	if bt.ShopsFood then
		bt.ShopsFood.construction_cost_Concrete = 10000
		bt.ShopsFood.maintenance_build_up_per_hr = 600
		bt.ShopsFood.maintenance_resource_amount = 1000
		bt.ShopsFood.maintenance_resource_type = "Concrete"
	end

	if bt.ShopsJewelry then
		bt.ShopsJewelry.construction_cost_Concrete = 10000
		bt.ShopsJewelry.construction_cost_Polymers = 2000
		bt.ShopsJewelry.maintenance_build_up_per_hr = 600
		bt.ShopsJewelry.maintenance_resource_amount = 1000
		bt.ShopsJewelry.maintenance_resource_type = "Concrete"
	end

	if bt.ShuttleHub then
		bt.ShuttleHub.construction_cost_Concrete = 10000
		bt.ShuttleHub.construction_cost_Electronics = 10000
		bt.ShuttleHub.construction_cost_Polymers = 15000
		bt.ShuttleHub.maintenance_build_up_per_hr = 600
		bt.ShuttleHub.maintenance_resource_amount = 1000
		bt.ShuttleHub.maintenance_resource_type = "Electronics"
	end

	if bt.SmartHome then
		bt.SmartHome.construction_cost_Concrete = 15000
		bt.SmartHome.construction_cost_Electronics = 10000
		bt.SmartHome.maintenance_build_up_per_hr = 600
		bt.SmartHome.maintenance_resource_amount = 500
		bt.SmartHome.maintenance_resource_type = "Electronics"
	end

	if bt.SmartHome_Small then
		bt.SmartHome_Small.construction_cost_Concrete = 5000
		bt.SmartHome_Small.construction_cost_Electronics = 3000
		bt.SmartHome_Small.maintenance_build_up_per_hr = 600
		bt.SmartHome_Small.maintenance_resource_amount = 500
		bt.SmartHome_Small.maintenance_resource_type = "Electronics"
	end

	if bt.SolarPanel then
		bt.SolarPanel.construction_cost_Metals = 1000
		bt.SolarPanel.maintenance_build_up_per_hr = 600
		bt.SolarPanel.maintenance_resource_amount = 500
		bt.SolarPanel.maintenance_resource_type = "Metals"
	end

	if bt.SolarPanelBig then
		bt.SolarPanelBig.construction_cost_Metals = 4000
		bt.SolarPanelBig.maintenance_build_up_per_hr = 600
		bt.SolarPanelBig.maintenance_resource_amount = 1000
		bt.SolarPanelBig.maintenance_resource_type = "Metals"
	end

	if bt.SpaceElevator then
		bt.SpaceElevator.construction_cost_Concrete = 400000
		bt.SpaceElevator.construction_cost_MachineParts = 150000
		bt.SpaceElevator.construction_cost_Metals = 200000
		bt.SpaceElevator.construction_cost_Polymers = 150000
		bt.SpaceElevator.maintenance_build_up_per_hr = 600
		bt.SpaceElevator.maintenance_resource_amount = 3000
		bt.SpaceElevator.maintenance_resource_type = "MachineParts"
	end

	if bt.Spacebar then
		bt.Spacebar.construction_cost_Concrete = 15000
		bt.Spacebar.construction_cost_Metals = 5000
		bt.Spacebar.maintenance_build_up_per_hr = 600
		bt.Spacebar.maintenance_resource_amount = 1000
		bt.Spacebar.maintenance_resource_type = "Concrete"
	end

	if bt.Statue then
		bt.Statue.construction_cost_Concrete = 1000
	end

	if bt.StirlingGenerator then
		bt.StirlingGenerator.construction_cost_Electronics = 6000
		bt.StirlingGenerator.construction_cost_Polymers = 12000
		bt.StirlingGenerator.maintenance_build_up_per_hr = 600
		bt.StirlingGenerator.maintenance_resource_amount = 1000
		bt.StirlingGenerator.maintenance_resource_type = "Polymers"
	end

	if bt.SubsurfaceHeater then
		bt.SubsurfaceHeater.construction_cost_MachineParts = 5000
		bt.SubsurfaceHeater.construction_cost_Metals = 15000
		bt.SubsurfaceHeater.maintenance_build_up_per_hr = 600
		bt.SubsurfaceHeater.maintenance_resource_amount = 2000
		bt.SubsurfaceHeater.maintenance_resource_type = "Metals"
	end

	if bt.SupplyRocket then
		bt.SupplyRocket.construction_cost_Electronics = 20000
		bt.SupplyRocket.construction_cost_Metals = 60000
		bt.SupplyRocket.launch_fuel = 60000
	end

	if bt.TheExcavator then
		bt.TheExcavator.construction_cost_Concrete = 100000
		bt.TheExcavator.construction_cost_MachineParts = 200000
		bt.TheExcavator.construction_cost_Metals = 300000
		bt.TheExcavator.maintenance_build_up_per_hr = 600
		bt.TheExcavator.maintenance_resource_amount = 3000
		bt.TheExcavator.maintenance_resource_type = "MachineParts"
	end

	if bt.TradeRocket then
		bt.TradeRocket.construction_cost_Electronics = 20000
		bt.TradeRocket.construction_cost_Metals = 60000
	end

	if bt.TriboelectricScrubber then
		bt.TriboelectricScrubber.construction_cost_Electronics = 5000
		bt.TriboelectricScrubber.construction_cost_Metals = 15000
		bt.TriboelectricScrubber.maintenance_build_up_per_hr = 600
		bt.TriboelectricScrubber.maintenance_resource_amount = 1000
		bt.TriboelectricScrubber.maintenance_resource_type = "Electronics"
	end

	if bt.Tunnel then
		bt.Tunnel.construction_cost_Concrete = 80000
		bt.Tunnel.construction_cost_MachineParts = 30000
		bt.Tunnel.construction_cost_Metals = 20000
	end

	if bt.VRWorkshop then
		bt.VRWorkshop.construction_cost_Concrete = 20000
		bt.VRWorkshop.construction_cost_Electronics = 5000
		bt.VRWorkshop.maintenance_build_up_per_hr = 600
		bt.VRWorkshop.maintenance_resource_amount = 1000
		bt.VRWorkshop.maintenance_resource_type = "Concrete"
	end

	if bt.WaterExtractor then
		bt.WaterExtractor.construction_cost_Concrete = 6000
		bt.WaterExtractor.construction_cost_MachineParts = 2000
		bt.WaterExtractor.maintenance_build_up_per_hr = 600
		bt.WaterExtractor.maintenance_resource_amount = 1000
		bt.WaterExtractor.maintenance_resource_type = "MachineParts"
	end

	if bt.WaterReclamationSystem then
		bt.WaterReclamationSystem.construction_cost_Concrete = 50000
		bt.WaterReclamationSystem.construction_cost_MachineParts = 5000
		bt.WaterReclamationSystem.construction_cost_Polymers = 10000
		bt.WaterReclamationSystem.maintenance_build_up_per_hr = 600
		bt.WaterReclamationSystem.maintenance_resource_amount = 3000
		bt.WaterReclamationSystem.maintenance_resource_type = "MachineParts"
	end

	if bt.WaterTank then
		bt.WaterTank.construction_cost_Metals = 3000
		bt.WaterTank.maintenance_build_up_per_hr = 600
		bt.WaterTank.maintenance_resource_amount = 1000
		bt.WaterTank.maintenance_resource_type = "Metals"
	end

	if bt.WindTurbine then
		bt.WindTurbine.construction_cost_Concrete = 4000
		bt.WindTurbine.construction_cost_MachineParts = 1000
		bt.WindTurbine.maintenance_build_up_per_hr = 600
		bt.WindTurbine.maintenance_resource_amount = 500
		bt.WindTurbine.maintenance_resource_type = "MachineParts"
	end

end
