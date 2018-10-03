local bt = BuildingTemplates

-- I included all the "default" costs just in case they change them
bt.ArtWorkshop.construction_cost_Concrete = 20000
bt.ArtWorkshop.construction_cost_Polymers = 5000
bt.ArtWorkshop.maintenance_build_up_per_hr = 600
bt.ArtWorkshop.maintenance_resource_amount = 1000
bt.ArtWorkshop.maintenance_resource_type = "Concrete"

bt.ArtificialSun.construction_cost_Concrete = 200000
bt.ArtificialSun.construction_cost_Metals = 300000
bt.ArtificialSun.construction_cost_Polymers = 300000
bt.ArtificialSun.maintenance_build_up_per_hr = 600
bt.ArtificialSun.maintenance_resource_amount = 3000
bt.ArtificialSun.maintenance_resource_type = "Polymers"

bt.AtomicBattery.construction_cost_Concrete = 5000
bt.AtomicBattery.construction_cost_Polymers = 5000
bt.AtomicBattery.maintenance_build_up_per_hr = 600
bt.AtomicBattery.maintenance_resource_amount = 2000
bt.AtomicBattery.maintenance_resource_type = "Polymers"

bt.Battery_WaterFuelCell.construction_cost_Concrete = 3000
bt.Battery_WaterFuelCell.construction_cost_Polymers = 2000
bt.Battery_WaterFuelCell.maintenance_build_up_per_hr = 600
bt.Battery_WaterFuelCell.maintenance_resource_amount = 1000
bt.Battery_WaterFuelCell.maintenance_resource_type = "Polymers"

bt.BioroboticsWorkshop.construction_cost_Concrete = 20000
bt.BioroboticsWorkshop.construction_cost_MachineParts = 5000
bt.BioroboticsWorkshop.maintenance_build_up_per_hr = 600
bt.BioroboticsWorkshop.maintenance_resource_amount = 1000
bt.BioroboticsWorkshop.maintenance_resource_type = "Concrete"

bt.BlackCubeLargeMonument.construction_cost_BlackCube = 126000

bt.BlackCubeMonolith.construction_cost_BlackCube = 284000

bt.BlackCubeSmallMonument.construction_cost_BlackCube = 42000

bt["Casino Complex"].construction_cost_Concrete = 40000
bt["Casino Complex"].construction_cost_Electronics = 20000
bt["Casino Complex"].maintenance_build_up_per_hr = 600
bt["Casino Complex"].maintenance_resource_amount = 2000
bt["Casino Complex"].maintenance_resource_type = "Electronics"

bt.CloningVats.construction_cost_Electronics = 10000
bt.CloningVats.construction_cost_Metals = 50000
bt.CloningVats.construction_cost_Polymers = 20000
bt.CloningVats.maintenance_build_up_per_hr = 600
bt.CloningVats.maintenance_resource_amount = 3000
bt.CloningVats.maintenance_resource_type = "Polymers"

bt.DefenceTower.construction_cost_Electronics = 5000
bt.DefenceTower.construction_cost_Metals = 10000
bt.DefenceTower.maintenance_build_up_per_hr = 600
bt.DefenceTower.maintenance_resource_amount = 1000
bt.DefenceTower.maintenance_resource_type = "Electronics"

if bt.Diner then
	bt.Diner.construction_cost_Concrete = 10000
	bt.Diner.construction_cost_Metals = 5000
	bt.Diner.maintenance_build_up_per_hr = 600
	bt.Diner.maintenance_resource_amount = 1000
	bt.Diner.maintenance_resource_type = "Concrete"
end

bt.DomeBasic.construction_cost_Concrete = 80000
bt.DomeBasic.construction_cost_Metals = 20000
bt.DomeBasic.construction_cost_Polymers = 10000
bt.DomeBasic.maintenance_build_up_per_hr = 600
bt.DomeBasic.maintenance_resource_amount = 1000
bt.DomeBasic.maintenance_resource_type = "Concrete"

bt.DomeDiamond.construction_cost_Concrete = 100000
bt.DomeDiamond.construction_cost_Metals = 150000
bt.DomeDiamond.construction_cost_Polymers = 150000
bt.DomeDiamond.maintenance_build_up_per_hr = 600
bt.DomeDiamond.maintenance_resource_amount = 4000
bt.DomeDiamond.maintenance_resource_type = "Polymers"

bt.DomeHexa.construction_cost_Concrete = 50000
bt.DomeHexa.construction_cost_Metals = 20000
bt.DomeHexa.construction_cost_Polymers = 20000
bt.DomeHexa.maintenance_build_up_per_hr = 600
bt.DomeHexa.maintenance_resource_amount = 1000
bt.DomeHexa.maintenance_resource_type = "Polymers"

bt.DomeMedium.construction_cost_Concrete = 150000
bt.DomeMedium.construction_cost_Metals = 80000
bt.DomeMedium.construction_cost_Polymers = 25000
bt.DomeMedium.maintenance_build_up_per_hr = 600
bt.DomeMedium.maintenance_resource_amount = 2000
bt.DomeMedium.maintenance_resource_type = "Polymers"

bt.DomeMega.construction_cost_Concrete = 300000
bt.DomeMega.construction_cost_Metals = 200000
bt.DomeMega.construction_cost_Polymers = 100000
bt.DomeMega.maintenance_build_up_per_hr = 600
bt.DomeMega.maintenance_resource_amount = 5000
bt.DomeMega.maintenance_resource_type = "Polymers"

bt.DomeMegaTrigon.construction_cost_Concrete = 200000
bt.DomeMegaTrigon.construction_cost_Metals = 150000
bt.DomeMegaTrigon.construction_cost_Polymers = 120000
bt.DomeMegaTrigon.maintenance_build_up_per_hr = 600
bt.DomeMegaTrigon.maintenance_resource_amount = 3000
bt.DomeMegaTrigon.maintenance_resource_type = "Polymers"

bt.DomeMicro.construction_cost_Concrete = 40000
bt.DomeMicro.construction_cost_Metals = 30000
bt.DomeMicro.maintenance_build_up_per_hr = 600
bt.DomeMicro.maintenance_resource_amount = 1000
bt.DomeMicro.maintenance_resource_type = "Concrete"

bt.DomeOval.construction_cost_Concrete = 150000
bt.DomeOval.construction_cost_Metals = 150000
bt.DomeOval.construction_cost_Polymers = 100000
bt.DomeOval.maintenance_build_up_per_hr = 600
bt.DomeOval.maintenance_resource_amount = 4000
bt.DomeOval.maintenance_resource_type = "Polymers"

bt.DomeTrigon.construction_cost_Concrete = 100000
bt.DomeTrigon.construction_cost_Metals = 60000
bt.DomeTrigon.construction_cost_Polymers = 15000
bt.DomeTrigon.maintenance_build_up_per_hr = 600
bt.DomeTrigon.maintenance_resource_amount = 1500
bt.DomeTrigon.maintenance_resource_type = "Polymers"

bt.DroneFactory.construction_cost_Electronics = 10000
bt.DroneFactory.construction_cost_Metals = 20000
bt.DroneFactory.maintenance_build_up_per_hr = 600
bt.DroneFactory.maintenance_resource_amount = 1000
bt.DroneFactory.maintenance_resource_type = "Electronics"

bt.DroneHub.construction_cost_Electronics = 8000
bt.DroneHub.construction_cost_Metals = 12000
bt.DroneHub.maintenance_build_up_per_hr = 600
bt.DroneHub.maintenance_resource_amount = 1000
bt.DroneHub.maintenance_resource_type = "Electronics"

bt.ElectricitySwitch.construction_cost_Metals = 1000

bt.ElectronicsFactory.construction_cost_Concrete = 10000
bt.ElectronicsFactory.construction_cost_Electronics = 15000
bt.ElectronicsFactory.construction_cost_Metals = 5000
bt.ElectronicsFactory.maintenance_build_up_per_hr = 600
bt.ElectronicsFactory.maintenance_resource_amount = 3000
bt.ElectronicsFactory.maintenance_resource_type = "MachineParts"

bt.Farm.construction_cost_Concrete = 8000

bt.FountainLarge.construction_cost_Concrete = 4000

bt.FountainSmall.construction_cost_Concrete = 2000

bt.FuelFactory.construction_cost_Concrete = 5000
bt.FuelFactory.construction_cost_MachineParts = 5000
bt.FuelFactory.construction_cost_Metals = 5000
bt.FuelFactory.maintenance_build_up_per_hr = 600
bt.FuelFactory.maintenance_resource_amount = 1000
bt.FuelFactory.maintenance_resource_type = "MachineParts"

bt.FungalFarm.construction_cost_Concrete = 10000
bt.FungalFarm.construction_cost_Electronics = 5000
bt.FungalFarm.construction_cost_Metals = 15000
bt.FungalFarm.maintenance_build_up_per_hr = 600
bt.FungalFarm.maintenance_resource_amount = 1000
bt.FungalFarm.maintenance_resource_type = "Metals"

bt.FusionReactor.construction_cost_Concrete = 40000
bt.FusionReactor.construction_cost_Electronics = 20000
bt.FusionReactor.construction_cost_Polymers = 20000
bt.FusionReactor.maintenance_build_up_per_hr = 600
bt.FusionReactor.maintenance_resource_amount = 3000
bt.FusionReactor.maintenance_resource_type = "Electronics"

bt.GardenAlleys_Medium.construction_cost_Concrete = 4000

bt.GardenAlleys_Small.construction_cost_Concrete = 2000

bt.GardenNatural_Medium.construction_cost_Concrete = 4000

bt.GardenNatural_Small.construction_cost_Concrete = 2000

bt.GardenStone.construction_cost_Concrete = 4000

bt.GeoscapeDome.construction_cost_Concrete = 400000
bt.GeoscapeDome.construction_cost_Metals = 200000
bt.GeoscapeDome.construction_cost_Polymers = 300000
bt.GeoscapeDome.maintenance_build_up_per_hr = 600
bt.GeoscapeDome.maintenance_resource_amount = 3000
bt.GeoscapeDome.maintenance_resource_type = "Polymers"

bt.HangingGardens.construction_cost_Concrete = 40000
bt.HangingGardens.construction_cost_Polymers = 10000
bt.HangingGardens.maintenance_build_up_per_hr = 600
bt.HangingGardens.maintenance_resource_amount = 4000
bt.HangingGardens.maintenance_resource_type = "Concrete"

bt.HydroponicFarm.construction_cost_Metals = 4000
bt.HydroponicFarm.construction_cost_Polymers = 2000
bt.HydroponicFarm.maintenance_build_up_per_hr = 600
bt.HydroponicFarm.maintenance_resource_amount = 1000
bt.HydroponicFarm.maintenance_resource_type = "Metals"

bt.Infirmary.construction_cost_Concrete = 15000
bt.Infirmary.maintenance_build_up_per_hr = 600
bt.Infirmary.maintenance_resource_amount = 1000
bt.Infirmary.maintenance_resource_type = "Concrete"

bt.Lake.construction_cost_Concrete = 3000

bt.LampProjector.construction_cost_Concrete = 1000

bt.LandingPad.construction_cost_Concrete = 10000

bt.LargeWaterTank.construction_cost_Concrete = 10000
bt.LargeWaterTank.construction_cost_Metals = 30000
bt.LargeWaterTank.maintenance_build_up_per_hr = 600
bt.LargeWaterTank.maintenance_resource_amount = 3000
bt.LargeWaterTank.maintenance_resource_type = "Metals"

bt.LifesupportSwitch.construction_cost_Metals = 1000

bt.LightTrap.construction_cost_Concrete = 10000
bt.LightTrap.construction_cost_Electronics = 5000
bt.LightTrap.construction_cost_Polymers = 5000
bt.LightTrap.maintenance_build_up_per_hr = 600
bt.LightTrap.maintenance_resource_amount = 1000
bt.LightTrap.maintenance_resource_type = "Metals"

bt.LivingQuarters.construction_cost_Concrete = 10000
bt.LivingQuarters.maintenance_build_up_per_hr = 600
bt.LivingQuarters.maintenance_resource_amount = 1000
bt.LivingQuarters.maintenance_resource_type = "Concrete"

bt.MDSLaser.construction_cost_Electronics = 5000
bt.MDSLaser.construction_cost_Metals = 15000
bt.MDSLaser.maintenance_build_up_per_hr = 600
bt.MDSLaser.maintenance_resource_amount = 1000
bt.MDSLaser.maintenance_resource_type = "Electronics"

bt.MOXIE.construction_cost_Metals = 5000
bt.MOXIE.maintenance_build_up_per_hr = 600
bt.MOXIE.maintenance_resource_amount = 2000
bt.MOXIE.maintenance_resource_type = "Metals"

bt.MachinePartsFactory.construction_cost_Concrete = 10000
bt.MachinePartsFactory.construction_cost_Electronics = 2000
bt.MachinePartsFactory.construction_cost_Metals = 10000
bt.MachinePartsFactory.maintenance_build_up_per_hr = 600
bt.MachinePartsFactory.maintenance_resource_amount = 2000
bt.MachinePartsFactory.maintenance_resource_type = "Electronics"

bt.MartianUniversity.construction_cost_Concrete = 30000
bt.MartianUniversity.construction_cost_Electronics = 20000
bt.MartianUniversity.construction_cost_Metals = 10000
bt.MartianUniversity.maintenance_build_up_per_hr = 600
bt.MartianUniversity.maintenance_resource_amount = 3000
bt.MartianUniversity.maintenance_resource_type = "Electronics"

bt.MechanizedDepotConcrete.construction_cost_MachineParts = 3000
bt.MechanizedDepotConcrete.construction_cost_Metals = 12000
bt.MechanizedDepotConcrete.maintenance_build_up_per_hr = 600
bt.MechanizedDepotConcrete.maintenance_resource_amount = 1000
bt.MechanizedDepotConcrete.maintenance_resource_type = "MachineParts"

bt.MechanizedDepotElectronics.construction_cost_MachineParts = 3000
bt.MechanizedDepotElectronics.construction_cost_Metals = 12000
bt.MechanizedDepotElectronics.maintenance_build_up_per_hr = 600
bt.MechanizedDepotElectronics.maintenance_resource_amount = 1000
bt.MechanizedDepotElectronics.maintenance_resource_type = "MachineParts"

bt.MechanizedDepotFood.construction_cost_MachineParts = 3000
bt.MechanizedDepotFood.construction_cost_Metals = 12000
bt.MechanizedDepotFood.maintenance_build_up_per_hr = 600
bt.MechanizedDepotFood.maintenance_resource_amount = 1000
bt.MechanizedDepotFood.maintenance_resource_type = "MachineParts"

bt.MechanizedDepotFuel.construction_cost_MachineParts = 3000
bt.MechanizedDepotFuel.construction_cost_Metals = 12000
bt.MechanizedDepotFuel.maintenance_build_up_per_hr = 600
bt.MechanizedDepotFuel.maintenance_resource_amount = 1000
bt.MechanizedDepotFuel.maintenance_resource_type = "MachineParts"

bt.MechanizedDepotMachineParts.construction_cost_MachineParts = 3000
bt.MechanizedDepotMachineParts.construction_cost_Metals = 12000
bt.MechanizedDepotMachineParts.maintenance_build_up_per_hr = 600
bt.MechanizedDepotMachineParts.maintenance_resource_amount = 1000
bt.MechanizedDepotMachineParts.maintenance_resource_type = "MachineParts"

bt.MechanizedDepotMetals.construction_cost_MachineParts = 3000
bt.MechanizedDepotMetals.construction_cost_Metals = 12000
bt.MechanizedDepotMetals.maintenance_build_up_per_hr = 600
bt.MechanizedDepotMetals.maintenance_resource_amount = 1000
bt.MechanizedDepotMetals.maintenance_resource_type = "MachineParts"

bt.MechanizedDepotMysteryResource.construction_cost_MachineParts = 3000
bt.MechanizedDepotMysteryResource.construction_cost_Metals = 12000
bt.MechanizedDepotMysteryResource.maintenance_build_up_per_hr = 600
bt.MechanizedDepotMysteryResource.maintenance_resource_amount = 1000
bt.MechanizedDepotMysteryResource.maintenance_resource_type = "MachineParts"

bt.MechanizedDepotPolymers.construction_cost_MachineParts = 3000
bt.MechanizedDepotPolymers.construction_cost_Metals = 12000
bt.MechanizedDepotPolymers.maintenance_build_up_per_hr = 600
bt.MechanizedDepotPolymers.maintenance_resource_amount = 1000
bt.MechanizedDepotPolymers.maintenance_resource_type = "MachineParts"

bt.MechanizedDepotRareMetals.construction_cost_MachineParts = 3000
bt.MechanizedDepotRareMetals.construction_cost_Metals = 12000
bt.MechanizedDepotRareMetals.maintenance_build_up_per_hr = 600
bt.MechanizedDepotRareMetals.maintenance_resource_amount = 1000
bt.MechanizedDepotRareMetals.maintenance_resource_type = "MachineParts"

if bt.MedicalCenter then
	bt.MedicalCenter.construction_cost_Concrete = 30000
	bt.MedicalCenter.construction_cost_Metals = 30000
	bt.MedicalCenter.construction_cost_Polymers = 10000
	bt.MedicalCenter.maintenance_build_up_per_hr = 600
	bt.MedicalCenter.maintenance_resource_amount = 3000
	bt.MedicalCenter.maintenance_resource_type = "Polymers"
end

bt.MetalsExtractor.construction_cost_Concrete = 20000
bt.MetalsExtractor.construction_cost_MachineParts = 5000
bt.MetalsExtractor.maintenance_build_up_per_hr = 600
bt.MetalsExtractor.maintenance_resource_amount = 2000
bt.MetalsExtractor.maintenance_resource_type = "MachineParts"

bt.MoholeMine.construction_cost_Concrete = 400000
bt.MoholeMine.construction_cost_MachineParts = 300000
bt.MoholeMine.construction_cost_Metals = 100000
bt.MoholeMine.maintenance_build_up_per_hr = 600
bt.MoholeMine.maintenance_resource_amount = 3000
bt.MoholeMine.maintenance_resource_type = "MachineParts"

bt.MoistureVaporator.construction_cost_Metals = 2000
bt.MoistureVaporator.construction_cost_Polymers = 5000
bt.MoistureVaporator.maintenance_build_up_per_hr = 600
bt.MoistureVaporator.maintenance_resource_amount = 2000
bt.MoistureVaporator.maintenance_resource_type = "Metals"

bt.NetworkNode.construction_cost_Concrete = 50000
bt.NetworkNode.construction_cost_Electronics = 20000
bt.NetworkNode.construction_cost_Metals = 50000
bt.NetworkNode.maintenance_build_up_per_hr = 600
bt.NetworkNode.maintenance_resource_amount = 3000
bt.NetworkNode.maintenance_resource_type = "Electronics"

bt.Nursery.construction_cost_Concrete = 10000
bt.Nursery.maintenance_build_up_per_hr = 600
bt.Nursery.maintenance_resource_amount = 1000
bt.Nursery.maintenance_resource_type = "Concrete"

bt.OmegaTelescope.construction_cost_Concrete = 400000
bt.OmegaTelescope.construction_cost_Electronics = 300000
bt.OmegaTelescope.construction_cost_Metals = 300000
bt.OmegaTelescope.maintenance_build_up_per_hr = 600
bt.OmegaTelescope.maintenance_resource_amount = 3000
bt.OmegaTelescope.maintenance_resource_type = "Electronics"

bt.OpenAirGym.construction_cost_Metals = 10000
bt.OpenAirGym.construction_cost_Polymers = 8000

bt.OxygenTank.construction_cost_Metals = 3000
bt.OxygenTank.maintenance_build_up_per_hr = 600
bt.OxygenTank.maintenance_resource_amount = 1000
bt.OxygenTank.maintenance_resource_type = "Metals"

bt.Passage.construction_cost_Concrete = 2000

bt.PassageRamp.construction_cost_Concrete = 5000

bt.Playground.construction_cost_Polymers = 8000

bt.PolymerPlant.construction_cost_Concrete = 10000
bt.PolymerPlant.construction_cost_MachineParts = 5000
bt.PolymerPlant.construction_cost_Metals = 5000
bt.PolymerPlant.maintenance_build_up_per_hr = 600
bt.PolymerPlant.maintenance_resource_amount = 2000
bt.PolymerPlant.maintenance_resource_type = "MachineParts"

bt.PowerDecoy.construction_cost_Concrete = 10000
bt.PowerDecoy.construction_cost_Electronics = 5000
bt.PowerDecoy.construction_cost_Polymers = 5000

bt.PreciousMetalsExtractor.construction_cost_MachineParts = 5000
bt.PreciousMetalsExtractor.construction_cost_Metals = 20000
bt.PreciousMetalsExtractor.maintenance_build_up_per_hr = 600
bt.PreciousMetalsExtractor.maintenance_resource_amount = 2000
bt.PreciousMetalsExtractor.maintenance_resource_type = "MachineParts"

bt.ProjectMorpheus.construction_cost_Concrete = 200000
bt.ProjectMorpheus.construction_cost_Electronics = 300000
bt.ProjectMorpheus.construction_cost_Metals = 400000
bt.ProjectMorpheus.maintenance_build_up_per_hr = 600
bt.ProjectMorpheus.maintenance_resource_amount = 3000
bt.ProjectMorpheus.maintenance_resource_type = "Electronics"

bt.RCExplorerBuilding.construction_cost_Electronics = 10000
bt.RCExplorerBuilding.construction_cost_Metals = 20000

bt.RCRoverBuilding.construction_cost_Electronics = 10000
bt.RCRoverBuilding.construction_cost_Metals = 20000

bt.RCTransportBuilding.construction_cost_Electronics = 10000
bt.RCTransportBuilding.construction_cost_Metals = 20000

bt.RechargeStation.construction_cost_Metals = 1000

bt.RefugeeRocket.construction_cost_Electronics = 20000
bt.RefugeeRocket.construction_cost_Metals = 60000

bt.RegolithExtractor.construction_cost_MachineParts = 2000
bt.RegolithExtractor.construction_cost_Metals = 6000
bt.RegolithExtractor.maintenance_build_up_per_hr = 600
bt.RegolithExtractor.maintenance_resource_amount = 1000
bt.RegolithExtractor.maintenance_resource_type = "MachineParts"

bt.ResearchLab.construction_cost_Concrete = 15000
bt.ResearchLab.construction_cost_Electronics = 8000
bt.ResearchLab.maintenance_build_up_per_hr = 600
bt.ResearchLab.maintenance_resource_amount = 1000
bt.ResearchLab.maintenance_resource_type = "Electronics"

bt.Sanatorium.construction_cost_Concrete = 50000
bt.Sanatorium.construction_cost_Metals = 20000
bt.Sanatorium.construction_cost_Polymers = 10000
bt.Sanatorium.maintenance_build_up_per_hr = 600
bt.Sanatorium.maintenance_resource_amount = 2000
bt.Sanatorium.maintenance_resource_type = "Polymers"

bt.School.construction_cost_Concrete = 25000
bt.School.construction_cost_Electronics = 10000
bt.School.maintenance_build_up_per_hr = 600
bt.School.maintenance_resource_amount = 2000
bt.School.maintenance_resource_type = "Electronics"

bt.ScienceInstitute.construction_cost_Concrete = 30000
bt.ScienceInstitute.construction_cost_Electronics = 20000
bt.ScienceInstitute.construction_cost_Polymers = 10000
bt.ScienceInstitute.maintenance_build_up_per_hr = 600
bt.ScienceInstitute.maintenance_resource_amount = 4000
bt.ScienceInstitute.maintenance_resource_type = "Electronics"

if bt.SecurityStation then
	bt.SecurityStation.construction_cost_Concrete = 15000
	bt.SecurityStation.construction_cost_Metals = 5000
	bt.SecurityStation.maintenance_build_up_per_hr = 600
	bt.SecurityStation.maintenance_resource_amount = 1000
	bt.SecurityStation.maintenance_resource_type = "Concrete"
en

bt.SensorTower.construction_cost_Electronics = 1000
bt.SensorTower.construction_cost_Metals = 1000
bt.SensorTower.maintenance_build_up_per_hr = 600
bt.SensorTower.maintenance_resource_amount = 1000
bt.SensorTower.maintenance_resource_type = "Metals"

bt.ShopsElectronics.construction_cost_Concrete = 10000
bt.ShopsElectronics.construction_cost_Electronics = 3000
bt.ShopsElectronics.maintenance_build_up_per_hr = 600
bt.ShopsElectronics.maintenance_resource_amount = 1000
bt.ShopsElectronics.maintenance_resource_type = "Concrete"

if bt.ShopsFood then
	bt.ShopsFood.construction_cost_Concrete = 10000
	bt.ShopsFood.maintenance_build_up_per_hr = 600
	bt.ShopsFood.maintenance_resource_amount = 1000
	bt.ShopsFood.maintenance_resource_type = "Concrete"
end

bt.ShopsJewelry.construction_cost_Concrete = 10000
bt.ShopsJewelry.construction_cost_Polymers = 2000
bt.ShopsJewelry.maintenance_build_up_per_hr = 600
bt.ShopsJewelry.maintenance_resource_amount = 1000
bt.ShopsJewelry.maintenance_resource_type = "Concrete"

bt.ShuttleHub.construction_cost_Concrete = 10000
bt.ShuttleHub.construction_cost_Electronics = 10000
bt.ShuttleHub.construction_cost_Polymers = 15000
bt.ShuttleHub.maintenance_build_up_per_hr = 600
bt.ShuttleHub.maintenance_resource_amount = 1000
bt.ShuttleHub.maintenance_resource_type = "Electronics"

bt.SmartHome.construction_cost_Concrete = 15000
bt.SmartHome.construction_cost_Electronics = 10000
bt.SmartHome.maintenance_build_up_per_hr = 600
bt.SmartHome.maintenance_resource_amount = 500
bt.SmartHome.maintenance_resource_type = "Electronics"

bt.SmartHome_Small.construction_cost_Concrete = 5000
bt.SmartHome_Small.construction_cost_Electronics = 3000
bt.SmartHome_Small.maintenance_build_up_per_hr = 600
bt.SmartHome_Small.maintenance_resource_amount = 500
bt.SmartHome_Small.maintenance_resource_type = "Electronics"

bt.SolarPanel.construction_cost_Metals = 1000
bt.SolarPanel.maintenance_build_up_per_hr = 600
bt.SolarPanel.maintenance_resource_amount = 500
bt.SolarPanel.maintenance_resource_type = "Metals"

bt.SolarPanelBig.construction_cost_Metals = 4000
bt.SolarPanelBig.maintenance_build_up_per_hr = 600
bt.SolarPanelBig.maintenance_resource_amount = 1000
bt.SolarPanelBig.maintenance_resource_type = "Metals"

bt.SpaceElevator.construction_cost_Concrete = 400000
bt.SpaceElevator.construction_cost_MachineParts = 150000
bt.SpaceElevator.construction_cost_Metals = 200000
bt.SpaceElevator.construction_cost_Polymers = 150000
bt.SpaceElevator.maintenance_build_up_per_hr = 600
bt.SpaceElevator.maintenance_resource_amount = 3000
bt.SpaceElevator.maintenance_resource_type = "MachineParts"

bt.Spacebar.construction_cost_Concrete = 15000
bt.Spacebar.construction_cost_Metals = 5000
bt.Spacebar.maintenance_build_up_per_hr = 600
bt.Spacebar.maintenance_resource_amount = 1000
bt.Spacebar.maintenance_resource_type = "Concrete"

bt.Statue.construction_cost_Concrete = 1000

bt.StirlingGenerator.construction_cost_Electronics = 6000
bt.StirlingGenerator.construction_cost_Polymers = 12000
bt.StirlingGenerator.maintenance_build_up_per_hr = 600
bt.StirlingGenerator.maintenance_resource_amount = 1000
bt.StirlingGenerator.maintenance_resource_type = "Polymers"

bt.SubsurfaceHeater.construction_cost_MachineParts = 5000
bt.SubsurfaceHeater.construction_cost_Metals = 15000
bt.SubsurfaceHeater.maintenance_build_up_per_hr = 600
bt.SubsurfaceHeater.maintenance_resource_amount = 2000
bt.SubsurfaceHeater.maintenance_resource_type = "Metals"

bt.SupplyRocket.construction_cost_Electronics = 20000
bt.SupplyRocket.construction_cost_Metals = 60000
bt.SupplyRocket.launch_fuel = 60000

bt.TheExcavator.construction_cost_Concrete = 100000
bt.TheExcavator.construction_cost_MachineParts = 200000
bt.TheExcavator.construction_cost_Metals = 300000
bt.TheExcavator.maintenance_build_up_per_hr = 600
bt.TheExcavator.maintenance_resource_amount = 3000
bt.TheExcavator.maintenance_resource_type = "MachineParts"

bt.TradeRocket.construction_cost_Electronics = 20000
bt.TradeRocket.construction_cost_Metals = 60000

bt.TriboelectricScrubber.construction_cost_Electronics = 5000
bt.TriboelectricScrubber.construction_cost_Metals = 15000
bt.TriboelectricScrubber.maintenance_build_up_per_hr = 600
bt.TriboelectricScrubber.maintenance_resource_amount = 1000
bt.TriboelectricScrubber.maintenance_resource_type = "Electronics"

bt.Tunnel.construction_cost_Concrete = 80000
bt.Tunnel.construction_cost_MachineParts = 30000
bt.Tunnel.construction_cost_Metals = 20000

bt.VRWorkshop.construction_cost_Concrete = 20000
bt.VRWorkshop.construction_cost_Electronics = 5000
bt.VRWorkshop.maintenance_build_up_per_hr = 600
bt.VRWorkshop.maintenance_resource_amount = 1000
bt.VRWorkshop.maintenance_resource_type = "Concrete"

bt.WaterExtractor.construction_cost_Concrete = 6000
bt.WaterExtractor.construction_cost_MachineParts = 2000
bt.WaterExtractor.maintenance_build_up_per_hr = 600
bt.WaterExtractor.maintenance_resource_amount = 1000
bt.WaterExtractor.maintenance_resource_type = "MachineParts"

bt.WaterReclamationSystem.construction_cost_Concrete = 50000
bt.WaterReclamationSystem.construction_cost_MachineParts = 5000
bt.WaterReclamationSystem.construction_cost_Polymers = 10000
bt.WaterReclamationSystem.maintenance_build_up_per_hr = 600
bt.WaterReclamationSystem.maintenance_resource_amount = 3000
bt.WaterReclamationSystem.maintenance_resource_type = "MachineParts"

bt.WaterTank.construction_cost_Metals = 3000
bt.WaterTank.maintenance_build_up_per_hr = 600
bt.WaterTank.maintenance_resource_amount = 1000
bt.WaterTank.maintenance_resource_type = "Metals"

bt.WindTurbine.construction_cost_Concrete = 4000
bt.WindTurbine.construction_cost_MachineParts = 1000
bt.WindTurbine.maintenance_build_up_per_hr = 600
bt.WindTurbine.maintenance_resource_amount = 500
bt.WindTurbine.maintenance_resource_type = "MachineParts"
