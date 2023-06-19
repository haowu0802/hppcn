-----------------------------------------------------------
-- United States of America
-----------------------------------------------------------

local P = {}
AI_USA = P

-- Tech weights
--   1.0 = 100% the total needs to equal 1.0
function P.TechWeights(minister)

	-- SSmith (23/07/2013)
	-- Changed to new format
	-- Early shift from air to naval techs

	local laTechWeights

	if CCurrentGameState.GetCurrentDate():GetYear() < 1938 then

		laTechWeights = {
			0.35, -- Land
			0.20, -- Air
			0.25, -- Naval
			0.20}; -- Other
	else
		laTechWeights = {
			0.30, -- Land
			0.35, -- Air
			0.20, -- Naval
			0.15}; -- Other
	end
	
	return laTechWeights
end

function P.Get_TechParams(minister)

	-- SSmith (21/08/2013)
	-- This is a new function to return a table of country-specific research config

	local laTechParams = {

		paratrooper_infantry		= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
		jungle_warfare_equipment 	= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.30, EndYear = 1999, Attribute = "" },
		engineer_bridging_equipment	= { Leadership = 12, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.30, EndYear = 1999, Attribute = "" },
		engineer_assault_equipment  	= { Leadership = 12, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.30, EndYear = 1999, Attribute = "" },
		mountain_gun_technology 	= { Leadership = 10, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		mountain_warfare_equipment 	= { Leadership = 10, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		mechanised_infantry 		= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
		anti_tank 			= { Leadership =  7, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		rocket_artillery_activation 	= { Leadership = 18, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		rocket_artillery 		= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		tank_brigade 			= { Leadership = 12, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "MediumTank" },
		tank_gun 			= { Leadership = 12, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "MediumTank" },
		tank_armour 			= { Leadership = 12, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "MediumTank" },
		heavy_tank_brigade 		= { Leadership = 30, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "HeavyTank" },
		heavy_tank_gun 			= { Leadership = 30, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "HeavyTank" },
		heavy_tank_armour 		= { Leadership = 30, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "HeavyTank" },
		heavy_tank_engine 		= { Leadership = 30, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "HeavyTank" },
		heavy_tank_reliability 		= { Leadership = 30, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "HeavyTank" },
		sloped_armor 			= { Leadership = 12, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
		self_propelled_support_brigade_tech = { Leadership = 30, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		sp_artillery_activation 	= { Leadership = 30, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		sp_artillery 			= { Leadership = 30, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		sp_rocket_artillery_activation 	= { Leadership = 30, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		sp_rocket_artillery 		= { Leadership = 30, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		tank_destroyer_activation 	= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		tank_destroyer 			= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
		sp_anti_air_activation 		= { Leadership = 30, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		sp_anti_air 			= { Leadership = 30, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		battleship_technology 		= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.35, EndYear = 1942, Attribute = "" },
		capital_ship_armor 		= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1942, Attribute = "" },
		capital_ship_engine 		= { Leadership = 18, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		capitalship_armament 		= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1942, Attribute = "" },
		escort_carrier_technology 	= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		carrier_technology 		= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		deck_armor 			= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		cag_naval_focus 		= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		air_launched_torpedo 		= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
		nav_development 		= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
		medium_navagation_radar 	= { Leadership = 18, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "" },
		basic_strategic_bomber 		= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		four_engine_airframe 		= { Leadership = 18, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
		large_fueltank 			= { Leadership = 18, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
		cargo_hold 			= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "" },
		strategic_bomber_armament 	= { Leadership = 18, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "" },
		large_bomb 			= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },

		synthetic_oil_development 	= { Leadership = 99, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		oil_to_coal_conversion 		= { Leadership = 99, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		civil_nuclear_research 		= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "CivilNuclear" },
		prefab_ports 			= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
		supply_production 		= { Leadership =  5, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		electronic_computing_machine 	= { Leadership = 18, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		da_bomb 			= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		supply_transportation 		= { Leadership =  3, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		supply_organisation 		= { Leadership =  3, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		nuclear_physics_research 	= { Leadership = 18, Priority = 0.30, EarlyOffset = 0.00, LateOffset = 0.10, EndYear = 1999, Attribute = "" },
		atomic_research 		= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		nuclear_research 		= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		isotope_seperation 		= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		artillery_training 		= { Leadership =  5, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		tank_crew_training 		= { Leadership = 10, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		special_forces_training 	= { Leadership =  7, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		officer_training		= { Leadership =  5, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		capital_ship_crew_training 	= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		carrier_crew_training 		= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		commander_decision_making 	= { Leadership =  7, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		radar_training 			= { Leadership = 12, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		night_equipment_training 	= { Leadership = 12, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		underway_repleshment 		= { Leadership = 12, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		base_operations 		= { Leadership = 12, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		battleship_taskforce_doctrine 	= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		battleline_cruiser_doctrine 	= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		carrier_escort_role_doctrine 	= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		sealane_interdiction 		= { Leadership = 10, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		trade_interdiction_submarine_doctrine = { Leadership = 10, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		force_projection 		= { Leadership = 18, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		carrier_taskforce_doctrine 	= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		cruiser_escort_doctrine 	= { Leadership = 18, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		fleet_escort_destroyer_doctrine = { Leadership = 18, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		fleet_submarine_doctrine 	= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		cag_pilot_training 		= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
		night_mission_training 		= { Leadership = 12, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		strategic_airforce_doctrine 	= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		airborne_assault_tactics 	= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		strategic_bombardment_tactics 	= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		strategic_air_command 		= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		naval_aviation_doctrine 	= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
		portstrike_tactics 		= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
		navalstrike_tactics 		= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
		naval_tactics 			= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" }
	}

	return laTechParams
end


-- END OF TECH RESEARCH OVERIDES
-- #######################################

-- #######################################
-- Production Overides the main LUA with country specific ones

-- Production Weights
--   1.0 = 100% the total needs to equal 1.0
function P.ProductionWeights(minister)
	local rValue
	local ministerCountry = minister:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	local japTag = CCountryDataBase.GetTag('JAP')
	local engTag = CCountryDataBase.GetTag('ENG')

	-- SSmith (21/06/2013)
	-- We need to consider whether we are at war with a major naval power or not
	-- For realism we shouldn't build up our land forces too quickly
	-- As the threat mechanics are seriously broken we will scale our peace-time actions by year
	-- After all we just know something is going to kick off somewhere...
	-- We also need to check the naval treaties and give the USN a boost when the escalator clause fires

	local isTreatySignatory = false
	if ministerCountry:GetFlags():IsFlagSet("washington_treaty")
	or ministerCountry:GetFlags():IsFlagSet("london_treaty")
	or ministerCountry:GetFlags():IsFlagSet("second_london_treaty")
	or ministerCountry:GetFlags():IsFlagSet("escalator_clause_invoked") then
		isTreatySignatory = true
	end

	local hasEscalatorClause = false
	if ministerCountry:GetFlags():IsFlagSet("escalator_clause_invoked") then
		hasEscalatorClause = true
	end

	-- SSmith (13/09/2013)
	-- Total economic mobilization increases land unit costs dramatically
	-- So we need to adapt by spending more on land forces
	local reserveStrength = ministerCountry:GetGlobalModifier():GetValue(CModifier._MODIFIER_RESERVES_PENALTY_SIZE_)

	if ministerCountry:IsAtWar() then
		if CCurrentGameState.GetCurrentDate():GetYear() > 1942
		or reserveStrength == 0 then
			local laArray = {
				0.45,	-- Land		-- It's at least 1943 so let's build even more ground forces!
				0.20,	-- Air
				0.25,	-- Sea
				0.10};	-- Other
			rValue = laArray
		elseif not (ministerCountry:GetRelation(japTag):HasWar()) and not (ministerCountry:GetRelation(engTag):HasWar()) then
			local laArray = {
				0.45,	-- Land		-- We are not at war with a naval power, so let's build more ground forces!
				0.25,	-- Air
				0.20,	-- Sea
				0.10};	-- Other
			rValue = laArray
		else
			local laArray = {		
				0.35,	-- Land
				0.25,	-- Air
				0.30,	-- Sea		-- We are at war with a naval power, so let's build more ships!
				0.10};	-- Other
			rValue = laArray
		end

	-- The year is 1936-37 (this used to check for threat < 10)

	elseif CCurrentGameState.GetCurrentDate():GetYear() < 1938
	and isTreatySignatory and not hasEscalatorClause then
		local laArray = {
			0.10,	-- Land
			0.35,	-- Air
			0.30,	-- Sea		-- Build up the USN
			0.25};	-- Other	-- Expand our economy
		rValue = laArray

	-- The year is 1938 (this used to check for threat < 25)

	elseif CCurrentGameState.GetCurrentDate():GetYear() < 1939 then
		local laArray = {
			0.10,	-- Land
			0.35,	-- Air
			0.35,	-- Sea		-- We need Yorktown and Enterprise
			0.20};	-- Other
		rValue = laArray

	-- The year is 1939 (this used to check for threat < 50)

	elseif CCurrentGameState.GetCurrentDate():GetYear() < 1940 then
		local laArray = {
			0.10,	-- Land
			0.35,	-- Air
			0.40,	-- Sea
			0.15};	-- Other
		rValue = laArray

	-- The year is at least 1940

	elseif CCurrentGameState.GetCurrentDate():GetYear() < 1942 then

		local laArray = {
			0.15,	-- Land
			0.35,	-- Air
			0.40,	-- Sea
			0.10};	-- Other
		rValue = laArray

	-- The year is at least 1942

	else
		local laArray = {		-- We are seriously threatened, so we need to take action. Now!
			0.25,	-- Land
			0.30,	-- Air
			0.35,	-- Sea
			0.10};	-- Other
		rValue = laArray
	end
	
	return rValue
end
-- Land ratio distribution
function P.LandRatio(minister)
	local rValue
	local ministerCountry = minister:GetCountry()

	-- SSmith (14/05/2013)
	-- As the threat mechanism is broken we will use the year to control the pre-war build up
	-- We need to make sure we get balanced mobile forces

	if ministerCountry:IsAtWar() then

		-- These are our war-time ratios

		local laArray = {
			2, -- Garrison
			10, -- Infantry		-- Basic infantry
			5, -- Motorized
			4, -- Mechanized
			4, -- Armor
			0, -- Militia
			0}; -- Cavalry
		rValue = laArray

	-- The year is 1936-37 (this used to check for threat < 10)

	elseif CCurrentGameState.GetCurrentDate():GetYear() < 1938 then
		local laArray = {
			5, -- Garrison		-- Garrisons
			11, -- Infantry		-- Infantry
			3, -- Motorized		-- Motorized if we can
			0, -- Mechanized
			0, -- Armor
			4, -- Militia
			2}; -- Cavalry
		rValue = laArray

	-- The year is 1938 (this used to check for threat < 25)

	elseif CCurrentGameState.GetCurrentDate():GetYear() < 1940 then
		local laArray = {
			5, -- Garrison
			12, -- Infantry		-- Infantry
			4, -- Motorized
			0, -- Mechanized
			0, -- Armor
			3, -- Militia
			1}; -- Cavalry
		rValue = laArray

	-- The year is 1940 (this used to check for threat < 50)

	elseif CCurrentGameState.GetCurrentDate():GetYear() < 1942 then
		local laArray = {
			5, -- Garrison
			13, -- Infantry
			4, -- Motorized		-- Motorized
			0, -- Mechanized
			2, -- Armor		-- Armour
			0, -- Militia
			1}; -- Cavalry
		rValue = laArray

	-- The year is at least 1942

	else
		local laArray = {
			5, -- Garrison
			11, -- Infantry
			4, -- Motorized
			2, -- Mechanized	-- Mechanized
			3, -- Armor
			0, -- Militia
			0}; -- Cavalry
		rValue = laArray
	end
	
	return rValue
end
-- Special Forces ratio distribution
function P.SpecialForcesRatio(minister)

	-- SSmith (08/06/2013)
	-- This will now return separate ratios for mountain, marine and airborne brigades
	-- The USA should train marines and airborne brigades when the war starts

	local ministerCountry = minister:GetCountry()
	if ministerCountry:IsAtWar() then
		local laArray = {
			25, -- Mountain
			20, -- Marine
			25}; -- Airborne
		return laArray
	else
		local laArray = {
			25, -- Mountain
			40, -- Marine
			50}; -- Airborne
		return laArray
	end
	
end
-- Air ratio distribution
function P.AirRatio(minister)

	-- SSmith (14/05/2013)
	-- We want a balanced USAAF with a lot of striking power
	
	local laArray
	if CCurrentGameState.GetCurrentDate():GetYear() < 1941 then
		laArray = {
			12, -- Fighter
			3, -- CAS
			4, -- Tactical
			3, -- Naval Bomber
			3}; -- Strategic
	else
		laArray = {
			9, -- Fighter
			3, -- CAS
			5, -- Tactical
			3, -- Naval Bomber
			5}; -- Strategic
	end
	
	return laArray
end
-- Naval ratio distribution
function P.NavalRatio(minister)
	local rValue
	local ministerCountry = minister:GetCountry()

	-- SSmith (14/05/2013)
	-- We need a more comprehensive set of production ratios
	-- This becomes much easier with the new production logic!

	if ministerCountry:IsAtWar() then

		-- Early war ratio through 1942 includes battleships

		if CCurrentGameState.GetCurrentDate():GetYear() < 1943 then
			local laArray = {
				7, -- Destroyers
				2, -- Submarines
				8, -- Cruisers
				4.5, -- Capital
				1, -- Escort Carrier
				2.5}; -- Carrier
			rValue = laArray

		-- Late war ratio from 1943 focuses on carriers

		else
			local laArray = {
				8, -- Destroyers
				2, -- Submarines
				8, -- Cruisers
				3, -- Capital
				2, -- Escort Carrier
				2}; -- Carrier
			rValue = laArray
		end
	else

		-- We are at peace

		local laArray = {
			7, -- Destroyers
			2.5, -- Submarines
			8, -- Cruisers
			5, -- Capital		-- Battleships when we can
			0, -- Escort Carrier
			2.5}; -- Carrier		-- Carriers when we can
		rValue = laArray
	end

	return rValue
end
-- Transport to Land unit distribution
function P.TransportLandRatio(minister)
	local rValue
	local ministerCountry = minister:GetCountry()

	-- SSmith (14/03/2013)
	-- We need a lot of transports for effective amphibious operations
	-- But we won't really do this until we are at war

	if ministerCountry:IsAtWar() then
		if CCurrentGameState.GetCurrentDate():GetYear() < 1944 then
			local laArray = {
				8, -- Land		-- Early in the war we have fewer land forces so we need a good ratio
				1}; -- Transport
			rValue = laArray
		else
			local laArray = {
				10, -- Land		-- Later in the war we will have more land forces so we can reduce the ratio
				1}; -- Transport
			rValue = laArray
		end
	elseif CCurrentGameState.GetCurrentDate():GetYear() > 1939 then
		local laArray = {
			12, -- Land			-- The world is probably in flames by now so let's take precautions
			1}; -- Transport
		rValue = laArray
	else
		local laArray = {
			25, -- Land
			1}; -- Transport
		rValue = laArray
	end
	return rValue
end

-- Do not build light armor if we can build medium
function P.Build_LightArmor(ic, minister, light_armor_brigade, vbGoOver)
	-- Replace Ligth Armor request with Armor if we can
	if minister:GetCountry():GetTechnologyStatus():IsUnitAvailable(CSubUnitDataBase.GetSubUnit("armor_brigade")) then
		return Utils.CreateDivision(minister, "armor_brigade", 0, ic, light_armor_brigade, 2, Utils.BuildArmorUnitArray(minister:GetCountry()), 1, vbGoOver)
	elseif minister:GetCountry():GetTechnologyStatus():IsUnitAvailable(CSubUnitDataBase.GetSubUnit("light_armor_brigade")) then
		return Utils.CreateDivision(minister, "light_armor_brigade", 0, ic, light_armor_brigade, 2, Utils.BuildArmorUnitArray(minister:GetCountry()), 1, vbGoOver)
	else
		return ic, 0
	end
end

-- Do not build battle cruisers
function P.Build_Battlecruiser(ic, minister, battlecruiser, vbGoOver)
	-- Replace most Battlecruiser request with a Battleship
	local nRandomFactor = math.random(100)
	if minister:GetCountry():GetTechnologyStatus():IsUnitAvailable(CSubUnitDataBase.GetSubUnit("battleship")) and nRandomFactor > 20 then
		return Utils.CreateDivision_nominor(minister, "battleship", 0, ic, battlecruiser, 1, vbGoOver)
	else
		return ic, 0
	end
end

-- SSmith (21/06/2013)
-- Redundant functions
-- Only build 3 Mountaineers!
--function P.Build_Mountain(ic, minister, bergsjaeger_brigade, vbGoOver)
--	-- Replace Mountaineers wiht Leg Infantry, if we already have enough.
--	local deployedUnits = minister:GetOwnerAI():GetDeployedSubUnitCounts()
--	local producedUnits = minister:GetOwnerAI():GetProductionSubUnitCounts()
--	if deployedUnits:GetAt(CSubUnitDataBase.GetSubUnit("bergsjaeger_brigade"):GetIndex()) + producedUnits:GetAt(CSubUnitDataBase.GetSubUnit("bergsjaeger_brigade"):GetIndex()) < 9 then
--		return Utils.CreateDivision_nominor(minister, "bergsjaeger_brigade", 0, ic, bergsjaeger_brigade, 3, vbGoOver)
--	else
--		return Utils.CreateDivision(minister, "infantry_brigade", 0, ic, bergsjaeger_brigade, 3, Utils.BuildLegUnitArray(minister:GetCountry()), 1, vbGoOver)
--	end
--end

-- Only build 8 Marines!
--function P.Build_Marine(ic, minister, marine_brigade, vbGoOver)
--	-- Replace Marines wiht Leg Infantry, if we already have enough.
--	local deployedUnits = minister:GetOwnerAI():GetDeployedSubUnitCounts()
--	local producedUnits = minister:GetOwnerAI():GetProductionSubUnitCounts()
--	if deployedUnits:GetAt(CSubUnitDataBase.GetSubUnit("marine_brigade"):GetIndex()) + producedUnits:GetAt(CSubUnitDataBase.GetSubUnit("marine_brigade"):GetIndex()) < 24 then
--		return Utils.CreateDivision_nominor(minister, "marine_brigade", 0, ic, marine_brigade, 3, vbGoOver)
--	else
--		return Utils.CreateDivision(minister, "infantry_brigade", 0, ic, marine_brigade, 3, Utils.BuildLegUnitArray(minister:GetCountry()), 1, vbGoOver)
--	end
--end

-- Only build 5 Paratroopers!
--function P.Build_Paratrooper(ic, minister, paratrooper_brigade, vbGoOver)
--	-- Replace Paratroopers wiht Leg Infantry, if we already have enough.
--	local deployedUnits = minister:GetOwnerAI():GetDeployedSubUnitCounts()
--	local producedUnits = minister:GetOwnerAI():GetProductionSubUnitCounts()
--	if deployedUnits:GetAt(CSubUnitDataBase.GetSubUnit("paratrooper_brigade"):GetIndex()) + producedUnits:GetAt(CSubUnitDataBase.GetSubUnit("paratrooper_brigade"):GetIndex()) < 15 then
--		return Utils.CreateDivision_nominor(minister, "paratrooper_brigade", 0, ic, paratrooper_brigade, 3, vbGoOver)
--	else
--		return Utils.CreateDivision(minister, "infantry_brigade", 0, ic, paratrooper_brigade, 3, Utils.BuildLegUnitArray(minister:GetCountry()), 1, vbGoOver)
--	end
--end

-- Build lots of factories!
function P.Build_Industry(ic, minister, vbGoOver)

	-- Build five factories at a time!
	local ai = minister:GetOwnerAI()
	local ministerCountry = minister:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	local industry = CBuildingDataBase.GetBuilding("industry")
	local industryCost = ministerCountry:GetBuildCost(industry):Get()
	local laCorePrv = {}
	local loTechStatus = ministerCountry:GetTechnologyStatus()
	
	laCorePrv = CoreProvincesLoop(ministerCountry, loTechStatus, 1, 1)
	
	local i = 0
	
	while i < 15 do	-- Should be alright, although we could use a 'for' loop.
		if (ic - industryCost) >= 0 or vbGoOver then
			if table.getn(laCorePrv[6]) > 0 then
				local constructCommand = CConstructBuildingCommand(ministerTag, industry, laCorePrv[6][math.random(table.getn(laCorePrv[6]))], 1 )

				if constructCommand:IsValid() then
					ai:Post( constructCommand )
					ic = ic - industryCost -- Upodate IC total	
				end
			end
		end
		i = i + 1
	end
	return ic
end

function P.DontBuildBuilding(minister, building)

	-- SSmith (14/05/2013)
	-- For now we won't build rocket test sites at all
	-- But the USA is the one country that can afford a nuclear programme!
	-- And if we do it we need to be serious about it!

	if tostring(building:GetName()) == "Rocket Test Site" then
		return true
	else
		if minister:GetOwnerAI():GetCurrentDate():GetYear() > 1938 and minister:GetOwnerAI():GetCurrentDate():GetYear() < 1944 then	-- It's 1939-43
			if math.random(0,100) < 65
			and tostring(building:GetName()) ~= "Nuclear Research Lab"	-- Encourage nuclear facilities!
			and tostring(building:GetName()) ~= "Industrial Capacity" then	-- or more factories!
				return true
			else
				return false
			end
		else
			return false
		end
	end
end
		
-- END OF PRODUTION OVERIDES
-- #######################################

function P.SpyPriority(ministerTag, ministerCountry, TargetCountry, TargetCountryTag)

	if ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( ministerCountry ) ) 
	or ( not Utils.ASSERT( TargetCountry ) )
	or ( not Utils.ASSERT( TargetCountryTag ) )
	then
		return nil
	end

	local gerTag = CCountryDataBase.GetTag('GER')
	
	-- we don't trust the Soviets now Germany has gone
	if tostring(TargetCountryTag) == "SOV" and Support.IsDefeated(ministerTag, gerTag) then
		return 3		
	else
		return nil
	end
end

function P.PickBestMission(ministerTag, ministerCountry, TargetCountry, TargetCountryTag)

	if ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( ministerCountry ) ) 
	or ( not Utils.ASSERT( TargetCountry ) )
	or ( not Utils.ASSERT( TargetCountryTag ) )
	then
		return nil
	end
	
	local CountryScriptMission = nil
	local gerTag = CCountryDataBase.GetTag('GER')
	
	-- we don't trust the Soviets now Germany has gone
	if tostring(TargetCountryTag) == "SOV" and Support.IsDefeated(ministerTag, gerTag) then
		CountryScriptMission = "IncreaseThreat"
	end
	
	return CountryScriptMission
end

function P.ForeignMinister_EvaluateDecision(score, agent, decision, scope)

	local lsDecision = tostring( decision:GetKey())

	-- SSmith (26/08/2013)
	-- Add random chances to make decisions more plausible

	if lsDecision == "went_too_far" then
		-- Use some strict modifiers but still do this mostly at random!
		-- It is a tough decision, not something you make without serious consideration!
		-- I also don't want the player to know exactly when the USA will come knocking.
		local agentCountry = agent:GetCountry()
		local highestThreatTag = agentCountry:GetHighestThreat()
		local highestThreat = agentCountry:GetRelation(highestThreatTag):GetThreat():Get()
		local neutrality = agentCountry:GetNeutrality():Get()
		
		local baseChance = 100 - ( neutrality - highestThreat )
		
		score = 0
		if baseChance > 0 then
			score = math.random(0,baseChance)
		end
		
		if highestThreat < 50 then
			score = 0
		elseif highestThreat < 60 then
			score = score - math.random(1,25)
		elseif highestThreat < 70 then
			score = score - math.random(1,15)
		elseif highestThreat < 80 then
			score = score - math.random(1,5)
		end
		if neutrality > 90 then
			score = score - math.random(1,20)
		elseif neutrality > 80 then
			score = score - math.random(1,15)
		elseif neutrality > 70 then
			score = score - math.random(1,10)
		elseif neutrality > 60 then
			score = score - math.random(1,5)
		end

		-- Still allow them to reconsider at the last minute!
		if score < math.random(1,50) then
			score = 0
		end

	elseif lsDecision == "gear_up_for_war" then
		if math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			score = 100
		else
			score = 0
		end

	elseif lsDecision == "destroyers_for_bases_agreement" then
		if math.mod( CCurrentGameState.GetAIRand(), 50) == 1 then
			score = 100
		else
			score = 0
		end

	elseif lsDecision == "the_lend_lease_act" then
		if math.mod( CCurrentGameState.GetAIRand(), 50) == 1 then
			score = 100
		else
			score = 0
		end

	elseif lsDecision == "flying_tigers" then
		if math.mod( CCurrentGameState.GetAIRand(), 50) == 1 then
			score = 100
		else
			score = 0
		end

	elseif lsDecision == "us_oil_embargo" then

		-- SSmith (12/09/2013)
		-- Add some checks before imposing the oil embargo
		-- Only do this if we are at war already or if China is well beaten or Indochina has been taken

		local japTag = CCountryDataBase.GetTag('JAP')
		local chiTag = CCountryDataBase.GetTag('CHI')
		local njgTag = CCountryDataBase.GetTag('NJG')
		if (agent:GetCountry():IsAtWar()
		  or Support.IsDefeated(japTag, chiTag) or chiTag:GetCountry():GetSurrenderLevel():Get() > 0.65
		  or njgTag:GetCountry():Exists()
		  or japTag:GetCountry():GetFlags():IsFlagSet("indochine_to_japan"))
		and math.mod( CCurrentGameState.GetAIRand(), 50) == 1 then
			score = 100
		else
			score = 0
		end

	elseif lsDecision == "forming_the_united_nations" then
		if math.mod( CCurrentGameState.GetAIRand(), 50) == 1 then
			score = 100
		else
			score = 0
		end

	elseif lsDecision == "operation_torch" then
		if math.mod( CCurrentGameState.GetAIRand(), 50) == 1 then
			score = 100
		else
			score = 0
		end

	elseif lsDecision == "back_out_from_the_treaties" then
		if math.mod( CCurrentGameState.GetAIRand(), 10) == 1 then
			score = 100
		else
			score = 0
		end
	end
	
	return score
end

function P.ProposeDeclareWar(minister)
	local ai = minister:GetOwnerAI()
	local ministerCountry = minister:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	local year = ai:GetCurrentDate():GetYear()
	local currentNeutrality = ministerCountry:GetNeutrality():Get()
	
	local axisFaction = CCurrentGameState.GetFaction("axis")
	local alliesFaction = CCurrentGameState.GetFaction("allies")
	local comminternFaction = CCurrentGameState.GetFaction("commintern")
	
	local loStrategy = ministerCountry:GetStrategy()
	
	-- The USA can DoW even if not in a faction.
	if not(loStrategy:IsPreparingWar()) then
	
		for loTargetCountry in CCurrentGameState.GetCountries() do
		
			local loTargetTag = loTargetCountry:GetCountryTag()
			
			if ministerCountry:HasFaction() then		-- Aligned USA
				if not(loTargetCountry:GetFaction() == ministerCountry:GetFaction()) then
					local currentThreat = ministerCountry:GetRelation(loTargetTag):GetThreat():Get()
					local canAttack = true
					
					if loTargetCountry:HasFaction() then
						canAttack = false
					end
					
					if canAttack and currentThreat > currentNeutrality + 10 and ministerCountry:IsMobilized() then
						Support.PrepareForWar( ministerTag, loTargetTag, 100 )
					end
				end
			else										-- Unaligned USA
				local currentThreat = ministerCountry:GetRelation(loTargetTag):GetThreat():Get()
				local canAttack = true
				
				if loTargetCountry:HasFaction() then
					local targetFaction = ministerCountry:GetRulingIdeology():GetGroup():GetFaction()
					local targetLeader = targetFaction:GetFactionLeader():GetCountry()
					local threatLeaderTag = loTargetCountry:GetFaction():GetFactionLeader()
					
					if loTargetCountry:GetFaction() == targetFaction then
						-- Ignore our ideological faction.
						canAttack = false
					end
				end
				
				if canAttack and currentThreat > currentNeutrality + 10 and ministerCountry:IsMobilized() then
					Support.PrepareForWar( ministerTag, loTargetTag, 100 )	-- Declare war ASAP.
				end
			end
		end
	end
end

function P.HandleMobilization( minister, needsMobilization )
	
	local ministerTag = minister:GetCountryTag()
	local ministerCountry = minister:GetCountry()
	local loStrategy = ministerCountry:GetStrategy()
	local currentNeutrality = ministerCountry:GetNeutrality():Get()
	
	if not(loStrategy:IsPreparingWar()) then
		for loTargetCountry in CCurrentGameState.GetCountries() do
			local loTargetTag = loTargetCountry:GetCountryTag()
			local currentThreat = ministerCountry:GetRelation(loTargetTag):GetThreat():Get()
			if currentThreat > currentNeutrality then
				return true
			end
		end
	end

	return needsMobilization
end

function P.DiploScore_InfluenceNation( score, ai, actor, recipient, observer )
	local lsRepTag = tostring(recipient)
	
	if lsRepTag == "AUS" or lsRepTag == "CZE" or lsRepTag == "SCH" then
		score = 0
	elseif lsRepTag == "HUN" or lsRepTag == "ROM" or lsRepTag == "BUL" or lsRepTag == "FIN" then
		score = score - 50
	elseif lsRepTag == "ITA" and Support.IsDefeated( CCountryDataBase.GetTag('ITA'), CCountryDataBase.GetTag('ETH') ) then
		-- Don't influence Italy after the Italo-Abyssinian war
		score = 0
	elseif lsRepTag == "JAP" and CCountryDataBase.GetTag('JAP'):GetCountry():GetRelation( CCountryDataBase.GetTag('ETH') ):HasWar() then
		-- Don't influence Japan if they are at war with China
		score = 0
	end

	return score
end

function P.DiploScore_OfferTrade(score, ai, actor, recipient, observer, voTradedFrom, voTradedTo)
	local lsActorTag = tostring(actor)
	
	if lsActorTag == "JAP"
	or lsActorTag == "CHI"
	or lsActorTag == "CHC" 
	or lsActorTag == "CGX" 
	or lsActorTag == "CSX" 
	or lsActorTag == "CXB"
	or lsActorTag == "CYN" 
	or lsActorTag == "SIK" then
		score = score + 20
	elseif lsActorTag == "ENG" or lsActorTag == "FRA" then
		score = score + 100
	elseif lsActorTag == "GER" or lsActorTag == "ITA" then
		score = score - 20
	end
	
	return score
end

function P.DiploScore_Embargo( score, ai, actor, recipient, observer)

	local gerTag = CCountryDataBase.GetTag('GER')
	local polTag = CCountryDataBase.GetTag('POL')
	local engTag = CCountryDataBase.GetTag('ENG')
	local chiTag = CCountryDataBase.GetTag('CHI')
	local cgxTag = CCountryDataBase.GetTag('CGX')
	local csxTag = CCountryDataBase.GetTag('CSX')
	local japTag = CCountryDataBase.GetTag('JAP')
	local chiCapital = chiTag:GetCountry():GetCapitalLocation()
	local actorCountry = actor:GetCountry() 
	local recipientCountry = recipient:GetCountry()
	local actorIdeologyGroup = actorCountry:GetRulingIdeology():GetGroup()
	local recipientIdeologyGroup = recipientCountry:GetRulingIdeology():GetGroup()

	if ( not actorIdeologyGroup == recipientIdeologyGroup )
	and
	(
		( recipient == japTag and CCurrentGameState.IsGlobalFlagSet( CString("us_oil_embargo") ) )	-- The US Oil Embargo is supposed to be in effect
		or
		(
			( ( not polTag:GetCountry():Exists() ) or polTag:GetCountry():IsGovernmentInExile() )	-- POL has fallen
			and recipientCountry:GetRelation(engTag):HasWar()										-- Recipient is at war with ENG
		)
		or
		(
			recipientCountry:GetRelation(chiTag):HasWar() and											-- Recipient is at war with CHI
			(
				( not cgxTag:GetCountry():Exists() ) or cgxTag:GetCountry():IsGovernmentInExile()		-- Guangxi is done, or
				or ( chiCapital:GetController() == recipientCountry:GetCountryTag() )					-- Nanjing has fallen
			)
			and ( ( not csxTag:GetCountry():Exists() ) or csxTag:GetCountry():IsGovernmentInExile()	)	-- and Shanxi is done
		)
		or ( actorCountry:GetRelation(recipient):GetThreat():Get() > 100 )								-- Or simply threatening (really threatening)
	)
	then
		return 100
	end
	
	return score
end

function P.DiploScore_Guarantee( score, ai, actor, recipient, observer)

-- The Monroe Doctrine is handled via event/decision now, Guarantees are no longer required. Or wanted.
--	local recipientCountry = recipient:GetCountry()
--	if not recipientCountry:HasFaction() then
--		local continent = tostring( recipientCountry:GetCapitalLocation():GetContinent():GetTag() )
--		if (continent == "north_america" or continent == "south_america") then
--			return 100
--		end
--	end
	
	return score
end

function P.DiploScore_LicenceTechnology( score, ai, actor, recipient, observer)

	if recipient == observer then		-- Should we sell license?
		local actorCountry = actor:GetCountry()
		local recipientCountry = recipient:GetCountry()
		local gerTag = CCountryDataBase.GetTag('GER')
		local japTag = CCountryDataBase.GetTag('JAP')
				
		if ( actorCountry:GetRelation(gerTag):HasWar() and recipientCountry:GetRelation(gerTag):HasEmbargo() )
		or ( actorCountry:GetRelation(japTag):HasWar() and recipientCountry:GetRelation(japTag):HasEmbargo() )
		then
			score = score * 2			-- How else could I check Lend-Lease?
		end
	end
	
	return score
end

function P.DiploScore_InviteToFaction(score, ai, actor, recipient, observer)
	if observer == recipient then
	-- Should we join?
		local warWithFaction = false
		if observer:GetCountry():IsAtWar() then
		-- If we are already at war, then check our enemies. If any of them is in a faction, we might need some backup!
		-- Otherwise we will do just fine.
			for enemyTag in observer:GetCountry():GetCurrentAtWarWith() do
				if enemyTag:GetCountry():HasFaction() then
					warWithFaction = true
					break
				end
			end
		end
		if warWithFaction then
			score = 100
		else
			score = 0
		end
	else
	-- Should we invite?
		local actorIdeology = actor:GetCountry():GetRulingIdeology():GetGroup()
		local recipientIdeology = recipient:GetCountry():GetRulingIdeology():GetGroup()
		-- The US should only be able to invite if the UK is down. They should be an Ideological Crusader in this case!
		if actorIdeology == recipientIdeology then
			score = score + 50
		else
			score = score - 25
		end
	end
	return score
end

-- Produce slightly better trained troops
function P.CallLaw_training_laws(minister, voCurrentLaw)
	local _ADVANCED_TRAINING_ = 30
	return CLawDataBase.GetLaw(_ADVANCED_TRAINING_)
end

return AI_USA

