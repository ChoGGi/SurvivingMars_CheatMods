function OnMsg.LoadGame()
  --remove the -- to uncomment tech to unlock
  --change GrantTech to DiscoverTech, if you want to research it instead

--BIOTECH

  --Moisture Vaporator Upgrade (Hygroscopic Coating) - Water production increased by *%.
  --GrantTech("HygroscopicVaporators")

  --New Building: Farm - Produces Food. Large in-Dome building which is more work-efficient and requires no Power.
  --GrantTech("SoilAdaptation")

  --New Building: Fungal Farm - An out-Dome building that produces Food.
  --GrantTech("LowGFungi")

  --MOXIE Upgrade (Magnetic Filtering) - Oxygen production increased by *%.
  --GrantTech("MagneticFiltering")

  --New Spire Building: Water Reclamation System - drastically reduces the Water consumption of the Dome.
  --GrantTech("WaterReclamation")

  --Unlock new crops in Farms and Hydroponic Farms that provide Oxygen and improve soil quality.
  --GrantTech("UtilityCrops")

  --Martianborn Colonists graduate faster in Universities and Sanatoriums and have higher chance to gain Perks from Schools.
  --GrantTech("MartianbornAdaptability")

  --Farms increase the Comfort of all residences in the Dome.
  --GrantTech("BiomeEngineering")

  --Residences in Basic Domes have improved Comfort.
  --GrantTech("DomeBioscaping")

  --New Spire Building: Medical Center - has larger capacity and is more effective than the Infirmary.
  --GrantTech("MicrogravityMedicine")

  --Unlock new crops in Farms and Hydroponic Farms that provide better Food yields.
  --GrantTech("GeneAdaptation")

  --Water consumption of Domes reduced by *%.
  --GrantTech("WaterCoservationSystem")

  --Farm, Hydroponic Farm & Fungal Farm Upgrade: Automation - Decreases number of workers.
  --GrantTech("FarmAutomation ")

  --New Spire Building: Hanging Gardens - a beautiful park complex that greatly improves the Comfort of all Residences in the Dome.
  --GrantTech("HangingGardens")

  --Medical Center Upgrade (Holographic Scanner) - Increases birth rate in the Dome.
  --GrantTech("HolographicScanning")

  --New Building: Moisture Vaporator - Produces Water from the atmosphere. Doesn't produce during Dust Storms.
  --GrantTech("MoistureFarming")

  --Infirmary & Medical Center Upgrade: Improves Service Comfort and provides Relaxation, allowing Colonists to visit and gain Comfort.
  --GrantTech("RejuvenationTreatment")

  --Retirement age and death from old age happen later in the Colonists' lifespan.
  --GrantTech("StemReconstruction")

  --New Wonder: Geoscape Dome - A slice of Earth on Mars, this Dome has high Comfort and increases the Sanity of its inhabitants on every Sol.
  --GrantTech("LocalizedTerraforming")

--ENGINEERING

  --Rocket Cargo Space increased by * kg.
  --GrantTech("FuelCompression")

  --Allows the clearing of salvaged and destroyed buildings.
  --GrantTech("DecommissionProtocol")

  --New Building: Polymer Factory - Produces Polymers from Water and Fuel.
  --New Building: Fuel Refinery - Produces Fuel from Water.
  --GrantTech("LowGHydrosynthsis")

  --Rockets and Shuttles require less Fuel.
  --GrantTech("AdvancedMartianEngines")

  --New Building: Apartments - A Residential Building that houses many Colonists.
  --GrantTech("LowGHighrise")

  --Passenger Rockets carry * more Colonists.
  --GrantTech("CompactPassengerModule")

  --Water, Oxygen and Power storage capacity expanded by *
  --GrantTech("StorageCompression")

  --New Dome: Medium - A medium-sized Dome.
  --GrantTech("LowGEngineering")

  --In-Dome buildings require maintenance less often.
  --GrantTech("SustainableArchitecture")

  --New Buildings: Smart Homes & Smart Complex - Provides a very comfortable living space for Colonists. Residents will recover Sanity when resting.
  --GrantTech("SmartHome")

  --New Building: Electronics Factory - Produces Electronics from Rare Metals.
  --GrantTech("MicroManufacturing")

  --New Spire Building: Arcology - provides comfortable living space for many colonists.
  --GrantTech("Arcology")

  --Building construction costs in Metals & Concrete reduced by * (excluding Domes).
  --GrantTech("MarsNoveau")

  --Out-Dome buildings require maintenance less often.
  --GrantTech("ResilientArchitecture")

  --Passenger Rockets carry * more Colonists.
  --GrantTech("AdvancedPassengerModule")

  --New Dome: Mega - The most advanced and spacious Dome design.
  --GrantTech("GravityEngineering")

  --Rare Metals Extractor production increased by *.
  --GrantTech("PlasmaCutters")

  --Drones can extract concrete from Waste Rock stored in Dumping Sites.
  --GrantTech("WasteRockLiquefaction")

  --Wonder: Space Elevator - Exports Rare Metals to Earth and offers resupply materials and prefabs at preferential prices.
  --GrantTech("OrbitalEngineering")

--ROBOTICS

  --The RC Transport harvests resources faster and its maximum storage is increased by *.
  --GrantTech("TransportOptimization")

  --Drones and Rovers move * faster.
  --GrantTech("LowGDrive")

  --Drone Hubs are constructed with additional * Drones and the maximum number of Drones is increased by *.
  --GrantTech("DroneSwarm")

  --Generate <research(param1)> per Sol for each RC Explorer vehicle. Multiple vehicles result in collaboration losses.
  --GrantTech("ExplorerAI")

  --New Building: Drone Hub - Controls Drones and allocates them to different jobs.
  --GrantTech("DroneHub")

  --Drone battery capacity increased by *%.
  --GrantTech("BatteryOptimization")

  --The RC Rover no longer needs recharging, starts with * additional Drones and command limit increased by *.
  --GrantTech("RoverCommandAI")

  --New Building: Drone Assembler - Constructs Drone Prefabs from Electronics which can then be used in Drone Hubs to construct new drones.
  --GrantTech("DronePrinting")

  --New Building: Machine Parts Factory - Produces Machine Parts from Metals.
  --GrantTech("3DMachining")

  --New Building: Shuttle Hub - Houses and refuels Shuttles that facilitate long-range transportation of resources between Depots and resettling of Colonists between Domes.
  --GrantTech("CO2JetPropulsion")

  --Extractor Upgrade (Fueled Extractor) - Production increased by *% as long as the building is supplied with Fuel.
  --GrantTech("FueledExtractors")

  --Factory Upgrade (Factory AI) - performance increased by *%.
  --GrantTech("FactoryAI")

  --Shuttle speed increased by *%.
  --GrantTech("MartianAerodynamics")

  --Can construct RC Rover, RC Transport and RC Explorer.
  --GrantTech("RoverPrinting")

  --The maximum number of Shuttles that the Shuttle Hub can house is increased by *.
  --GrantTech("CompactHangars")

  --Shuttle cargo capacity increased by *.
  --GrantTech("HighPoweredJets")

  --New Spire Building: Network Node - increases the research output of all Research Labs and Science Institutes in the Dome.
  --GrantTech("TheMartianNetwork")

  --Wonder: Mohole Mine - Extracts Metals, Rare Metals and Waste Rock without the need of a deposit, while heating the surrounding area.
  --GrantTech("ProjectMohole")

  --Wonder: The Excavator - Produces Concrete directly from the Martian soil without requiring a deposit.
  --GrantTech("LargeScaleExcavation")

--PHYSICS

  --Extractor Upgrade (Amplify) - Increases production by *% but also increases Power consumption by <power(param2)>.
  --GrantTech("ExtractorAmplification")

  --Sensor Towers no longer require Power or maintenance.
  --GrantTech("AutonomousSensors")

  --New Building: Subsurface Heater - Increases the local temperature in cold areas and protects nearby buildings from Cold Waves. Consumes Water.
  --GrantTech("SubsurfaceHeating")

  --Wind Turbine Upgrade (Polymer Blades): Power production increased by *%.
  --GrantTech("LowGTurbines")

  --Probes are cheaper and can deep scan.
  --GrantTech("AdaptedProbes")

  --New Building: Stirling Generator - Generates Power. While closed the Generator is protected from dust, but produces less Power.
  --GrantTech("StirlingGenerator")

  --New Building: Atomic Accumulator - Stores electrical Power. Has huge capacity but charges slowly.
  --GrantTech("AtomicAccumulator")

  --Solar Panels are gradually cleaned from dust when closed, resulting in less frequent maintenance.
  --GrantTech("DustRepulsion")

  --Factory Upgrade (Amplify) - Increases production by *% but also increases Power consumption by <power(param2)>.
  --GrantTech("FactoryAmplification")

  --Sectors can now be scanned again for deep deposits. Exploiting these deposits requires additional technologies.
  --GrantTech("DeepScanning")

  --Can exploit deep Water deposits.
  --GrantTech("DeepWaterExtraction")

  --Can exploit deep Metal and Rare Metal deposits.
  --GrantTech("DeepMetalExtraction")

  --New Building: Fusion Reactor - Generates Power. Out-Dome building which requires Workers to operate.
  --GrantTech("NuclearFusion")

  --New Building: MDS Laser - Destroys falling meteors in its range.
  --GrantTech("MeteorDefenseSystem")

  --New Building: Triboelectric Scrubber - Emits pulses which reduce the Dust accumulated on buildings in its range.
  --GrantTech("TriboelectricScrubbing")

  --Research Labs, Science Institutes and the Network Node Upgrade (Amplify) - Increases production by *% but also increases Power consumption.
  --GrantTech("ResearchAmplification")

  --Fusion Reactor Upgrade(Auto-regulator) - reduces the amount of workers.
  --GrantTech("FusionAutoregulation")

  --Wonder: Artificial Sun - Produces colossal amounts of Power. It provides light for nearby Solar Panels during the dark hours and heats the surrounding area. Consumes vast amounts of Water on startup.
  --GrantTech("MicroFusion")

  --Wonder: Omega Telescope - Gives access to new Breakthrough Technologies and boosts overall research.
  --GrantTech("InterplanetaryAstronomy")

--SOCIAL

  --More applicants will start to appear on Earth.
  --GrantTech("LiveFromMars")

  --Engineers and Geologists have +* performance when working in their specialty.
  --GrantTech("ProductivityTraining")

  --Increases research provided by sponsor by <research(param1)>.
  --GrantTech("EarthMarsInitiative")

  --Scientists and Botanists have +* performance when working in their specialty.
  --GrantTech("SystematicTraining")

  --Receive a one-time grant of <funding(param1)> funding.
  --GrantTech("MarsHype")

  --New Building: Martian University - Trains Scientists, Geologists, Botanists, Medic, Engineers or Security specialists.
  --GrantTech("MartianEducation")

  --License Martian technology for use back on Earth. Earn <funding(param1)> funding.
  --GrantTech("MartianPatents")

  --Lowers the risk of colonists developing flaws after Sanity breakdown.
  --GrantTech("SupportiveCommunity")

  --Security Officers and Medics have +* performance when working in their specialty.
  --GrantTech("EmergencyTraining")

  --Colonists without the proper specialization suffer a lower work penalty.
  --GrantTech("GeneralTraining")

  --New Building: Science Institute - Generates Research faster than a Research Lab.
  --GrantTech("MartianInstituteOfScience")

  --New Spire Building: Sanatorium - treats colonists to remove flaws.
  --GrantTech("BehavioralShaping")

  --Decorations have increased Service Comfort.
  --GrantTech("MartianFestivals")

  --Martianrborn don't take Sanity damage from disasters.
  --GrantTech("MartianbornStrength")

  --Martianborn don't take Sanity damage when working in out-Dome buildings.
  --GrantTech("MartianbornResilience")

  --Residential Building Upgrade (Home Collective) - Increases the Service Comfort of the building by *.
  --GrantTech("HomeCollective")

  --License Martian copyrights for use back on Earth. Earn <funding(param1)> funding.
  --GrantTech("MartianCopyrithgts")
  --^ that's how they spelled it...

  --Sanatorium Upgrade (Behavioral Melding) - replaces removed flaws with random Perks.
  --GrantTech("BehavioralMelding")

  --Wonder: Project Morpheus - Stimulates the development of new Perks in adult Colonists throughout the entire Colony.
  --GrantTech("DreamReality")

--BREAKTHROUGH

  --Buildings construct themselves slowly without Drones. Nanites will seek out resources from nearby resource depots.
  --GrantTech("ConstructionNanites")

  --Buildings require maintenance less often.
  --GrantTech("HullPolarization")

  --When a colonist dies there's a *% chance he or she is reconstructed as youth with the same traits.
  --GrantTech("ProjectPhoenix")

  --Bodies of dead Colonists are converted to Food.
  --GrantTech("SoylentGreen")

  --Unlocks Rare Trait - Empath. Empaths raise the Morale of all Colonists in the Dome. The effect stacks with other Empaths.
  --GrantTech("NeuralEmpathy")

  --Colonists need to sleep for only 1 hour and regain extra Sanity when sleeping.
  --GrantTech("RapidSleep")

  --Allows the construction of Biorobots in the Drone Assembler. Biorobots eat and can gain traits but can't reproduce and never die from old age.
  --GrantTech("ThePositronicBrain")

  --When a colonist suffers a Sanity breakdown, they fall asleep and wake up after * hours with * Sanity. Colonists can't commit suicide or gain flaws due to sanity breakdown.
  --GrantTech("SafeMode")

  --Residents in the Arcology get a bonus to work performance based on the number of unique perks and specializations of colonists living in the Arcology.
  --GrantTech("HiveMind")

  --Colonists have a *% chance to lose a flaw on their journey to Mars.
  --GrantTech("SpaceRehabilitation")

  --Recharge Stations service Drones in a * hex-range instantly.
  --GrantTech("WirelessPower")

  --Allows Drones Prefabs to be constructed in the Drone Assembler using Metals instead of Electronics.
  --GrantTech("PrintedElectronics")

  --Uncovers extremely rich underground Metal deposits.
  --GrantTech("CoreMetals")

  --Uncovers extremely rich underground Water deposits.
  --GrantTech("CoreWater")

  --Uncovers extremely rich underground Rare Metal deposits.
  --GrantTech("CoreRareMetals")

  --Instant and free power cable construction. Power cables do not suffer from power faults.
  --GrantTech("SuperiorCables")

  --Instant and free pipe construction. Pipes don't suffer from leaks.
  --GrantTech("SuperiorPipes")

  --Uncovers new Anomalies: Alien Artifacts - which provide a boost to all research when scanned.
  --GrantTech("AlienImprints")

  --All colonists gain +*  performance during night shifts
  --GrantTech("NocturnalAdaptation")

  --Doubles the chance that a Colonist will have or gain a rare trait.
  --GrantTech("GeneSelection")

  --All Colonists consume *% less Food.
  --GrantTech("MartianDiet")

  --Fusion Reactors Upgrade (Eternal Fusion) - Fusion Reactors no longer require workers and operate at * performance.
  --GrantTech("EternalFusion")

  --Converts unused Power into Research Points.
  --GrantTech("SuperconductingComputing")

  --All Extractors continue to extract small amounts when their deposit is depleted.
  --GrantTech("NanoRefinement")

  --Drones carry two resources at once.
  --GrantTech("ArtificialMuscles")

  --Colonists in Domes with a Spire have increased Morale.
  --GrantTech("InspiringArchitecture")

  --Unlocks giant crops which have an increased Food output.
  --GrantTech("GiantCrops")

  --Dome Concrete costs reduced by *%.
  --GrantTech("NeoConcrete")

  --Drones move *% faster.
  --GrantTech("AdvancedDroneDrive")

  --Water requirements of crops is reduced by *%.
  --GrantTech("DryFarming")

  --Lowers Metals costs for building construction by *%.
  --GrantTech("MartianSteel")

  --Moisture Vaporator Upgrade (Vector Pump) - Water production increased by 100%.
  --GrantTech("VectorPump")

  --Fungal Farm Upgrade (Superfungus) - Increases production while increasing Oxygen consumption.
  --GrantTech("Superfungus")

  --Solar Panels and Large Solar Panels Power production increased by *%.
  --GrantTech("HypersensitivePhotovoltaics")

  --Wind Turbines Power production increased by *%.
  --GrantTech("FrictionlessComposites")

  --Research Lab & Science Institute Upgrade (Zero-Space Computing) - Research points production increased.
  --GrantTech("ZeroSpaceComputing")

  --New Dome: Oval Dome - An elongated Dome which has space for two Spires.
  --GrantTech("MultispiralArchitecture")

  --Extractor Upgrade (Magnetic Extraction) - Production increased by *%.
  --GrantTech("MagneticExtraction")

  --Doubles the performance bonus when Colonists are working on a heavy workload.
  --GrantTech("SustainedWorkload")

  --Seniors can work and have children.
  --GrantTech("ForeverYoung")

  --Martianborn gain * performance.
  --GrantTech("MartianbornIngenuity")

  --Passenger Rockets carry * more Colonists.
  --GrantTech("CryoSleep")

  --New Spire Building: Cloning Vats - creates Clones over time. Cloned colonists grow and age twice as fast.
  --GrantTech("Cloning")

  --Domes restore Sanity to their inhabitants every Sol.
  --GrantTech("GoodVibrations")

  --Domes cost *% less basic resources.
  --GrantTech("DomeStreamlining")

  --All Spires can be ordered as prefabs from Earth.
  --GrantTech("PrefabCompression")

  --Metals Extractors and Rare Metals Extractors can work without crews at * performance.
  --GrantTech("ExtractorAI")

  --Non-medical Service Buildings Upgrade (Service Bots) - service buildings no longer require workers and operate at * performance.
  --GrantTech("ServiceBots")

  --Amplify upgrades grant a bigger boost to production.
  --GrantTech("OverchargeAmplification")

  --Stirling Generator Upgrade (Plutonium Core) - Increased Power production while opened.
  --GrantTech("PlutoniumSynthesis")

  --Schools can train the Workaholic and Hippie traits.
  --GrantTech("InterplanetaryLearning")

  --Colonists gain * bonus work performance when all their stats are in the green.
  --GrantTech("Vocation-Oriented Society")

  --Rocket travel time to and from Earth reduced by *%.
  --GrantTech("PlasmaRocket")

  --Drone Hubs no longer require Power or maintenance.
  --GrantTech("AutonomousHubs")

  --Factory Upgrade (Automation) - Lowers the amount of Workers needed in factories.
  --GrantTech("FactoryAutomation")

--Mystery unlocks?

  --A 'surface scratcher' step towards understanding the elusive chemical properties of the mystery Cubes, what dangers the Cubes might pose and how to manage them.
  --GrantTech("BlackCubesDisposal")

  --Aims to find a way to capture and dismantle an alien Dredger by studying its structure and physical properties.
  --GrantTech("AlienDiggersDestruction")

  --An attempt to decode the transmissions sent out by Dredgers in order to predict their behavior and landing sites.
  --GrantTech("AlienDiggersDetection")

  --Water Extractor, Concrete Extractor, Metals Extractor and Rare Metals Extractor gain +*% bonus production.
  --GrantTech("XenoExtraction")

  --Decoy Building that keeps single Spheres into captivity.
  --GrantTech("RegolithExtractor")

  --A way to immunize our colonists from the negative health effects of the Mirror Spheres.
  --GrantTech("PowerDecoy")

  --Mirror Spheres in captivity may be broken down to their building parts.
  --GrantTech("Xeno-Terraforming")

  --Push to decipher the Dreamers’ brain patterns while in trance.
  --GrantTech("DreamSimulation")

  --Track down Number Six's physical location.
  --GrantTech("NumberSixTracing")

  --A stationary turret that protects the nearby area from hostile vehicles and incoming meteors.
  --GrantTech("DefenseTower")

  --Focus your research to help the development of the Beyond Earth Initiative projects. Each time the research is completed you can refocus your research towards a new project.
  --GrantTech("SolExploration")

  --Series of dangerous experiments which could lead to the discovery of a cure for the Wildfire infection.
  --GrantTech("WildfireCure")

end
