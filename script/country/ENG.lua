-----------------------------------------------------------
-- United Kingdom
-----------------------------------------------------------

local P = {}
AI_ENG = P

-- Tech weights
--   1.0 = 100% the total needs to equal 1.0
function P.TechWeights(minister)

	-- SSmith (23/07/2013)
	-- Changed to new format
	-- Early shift from air to naval techs

	local laTechWeights

	if CCurrentGameState.GetCurrentDate():GetYear() < 1938 then

		laTechWeights = {
			0.30, -- Land
			0.15, -- Air
			0.35, -- Naval
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
		desert_warfare_equipment 	= { Leadership = 18, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		engineer_bridging_equipment	= { Leadership = 12, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.30, EndYear = 1999, Attribute = "" },
		engineer_assault_equipment  	= { Leadership = 12, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.30, EndYear = 1999, Attribute = "" },
		mountain_gun_technology 	= { Leadership = 10, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		jungle_warfare_equipment 	= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		mountain_warfare_equipment 	= { Leadership = 10, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		mechanised_infantry 		= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },

		super_heavy_tank_brigade 	= { Leadership = 12, Priority = 0.90, EarlyOffset = 0.50, LateOffset = 0.40, EndYear = 1999, Attribute = "InfantryTank" },
		super_heavy_tank_gun 		= { Leadership = 12, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "InfantryTank" },
		super_heavy_tank_armour 	= { Leadership = 12, Priority = 0.90, EarlyOffset = 0.50, LateOffset = 0.40, EndYear = 1999, Attribute = "InfantryTank" },
		tank_brigade 			= { Leadership = 12, Priority = 0.90, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "MediumTank" },
		tank_gun 			= { Leadership = 12, Priority = 0.90, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "MediumTank" },
		tank_armour 			= { Leadership = 12, Priority = 0.90, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "MediumTank" },
		heavy_tank_brigade 		= { Leadership = 99, Priority = 0.80, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "HeavyTank" },
		heavy_tank_gun 			= { Leadership = 99, Priority = 0.80, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "HeavyTank" },
		heavy_tank_armour 		= { Leadership = 99, Priority = 0.80, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "HeavyTank" },
		heavy_tank_engine 		= { Leadership = 99, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "HeavyTank" },
		heavy_tank_reliability 		= { Leadership = 99, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "HeavyTank" },
		sloped_armor 			= { Leadership = 12, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
		tank_destroyer_activation 	= { Leadership = 18, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		tank_destroyer 			= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "" },

		smallwarship_asw 		= { Leadership = 12, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		battleship_technology 		= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.35, EndYear = 1942, Attribute = "" },
		capital_ship_armor 		= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1942, Attribute = "" },
		capital_ship_engine 		= { Leadership = 18, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		capitalship_armament 		= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1942, Attribute = "" },
		escort_carrier_technology 	= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		carrier_technology 		= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		deck_armor 			= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		cag_air_focus 			= { Leadership = 18, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		air_launched_torpedo 		= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "Naval" },
		nav_development 		= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
		medium_navagation_radar 	= { Leadership = 18, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "" },
		four_engine_airframe 		= { Leadership = 18, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
		large_fueltank 			= { Leadership = 18, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
		cargo_hold 			= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "" },
		strategic_bomber_armament 	= { Leadership = 18, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "" },
		large_bomb 			= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },

		prefab_ports 			= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
		supply_production 		= { Leadership =  5, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		electronic_computing_machine 	= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		supply_transportation 		= { Leadership =  3, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		supply_organisation 		= { Leadership =  3, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		artillery_training 		= { Leadership =  5, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		tank_crew_training 		= { Leadership = 10, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		special_forces_training 	= { Leadership =  7, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "" },
		officer_training		= { Leadership =  5, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		capital_ship_crew_training 	= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		carrier_crew_training 		= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		radar_training 			= { Leadership = 12, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		night_equipment_training 	= { Leadership = 12, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		underway_repleshment 		= { Leadership = 12, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		base_operations 		= { Leadership = 12, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		sealane_control 		= { Leadership = 10, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		battleship_taskforce_doctrine 	= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		battleline_cruiser_doctrine 	= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		carrier_escort_role_doctrine 	= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		asw_tactics 			= { Leadership = 10, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		sealane_interdiction 		= { Leadership = 10, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		trade_interdiction_submarine_doctrine = { Leadership = 10, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		cag_pilot_training 		= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
		night_mission_training 		= { Leadership = 12, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		strategic_airforce_doctrine 	= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.10, EndYear = 1999, Attribute = "" },
		airborne_assault_tactics 	= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		strategic_bombardment_tactics 	= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		strategic_air_command 		= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		naval_aviation_doctrine 	= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.10, EndYear = 1999, Attribute = "Naval" },
		portstrike_tactics 		= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
		navalstrike_tactics 		= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
		naval_tactics 			= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" }
	}

	return laTechParams
end

-- SSmith (10/05/2013)
-- I have removed the custom TechSliders function

-- END OF TECH RESEARCH OVERIDES
-- #######################################


-- #######################################
-- Production Overides the main LUA with country specific ones

-- Production Weights
--   1.0 = 100% the total needs to equal 1.0
function P.ProductionWeights(minister)
	local rValue
	local ministerCountry = minister:GetCountry()
	local ministerTag = minister:GetCountryTag()
	local fraTag = CCountryDataBase.GetTag('FRA')
	local gerTag = CCountryDataBase.GetTag('GER')
	local usaTag = CCountryDataBase.GetTag('USA')
	local itaTag = CCountryDataBase.GetTag('ITA')
	local egyTag = CCountryDataBase.GetTag('EGY')
	local palTag = CCountryDataBase.GetTag('PAL')

	-- SSmith (04/06/2013)
	-- New section of logic added if London has been lost
	-- With the naval treaties we must be able to invest in the Royal Navy as soon as we are at war
	-- Now the escalator clause is implemented we must prepare for new construction in 1939

	local isTreatySignatory = false
	if ministerCountry:GetFlags():IsFlagSet("washington_treaty")
	or ministerCountry:GetFlags():IsFlagSet("london_treaty")
	or ministerCountry:GetFlags():IsFlagSet("second_london_treaty")
	or ministerCountry:GetFlags():IsFlagSet("escalator_clause_invoked") then
		isTreatySignatory = true
	end

	local hasEscalatorClause = false
	if ministerCountry:GetFlags():IsFlagSet("escalator_clause_invoked")
	and CCurrentGameState.GetCurrentDate():GetYear() > 1938 then
		hasEscalatorClause = true
	end

	if not(minister:GetCountry():IsAtWar()) then	-- Before and after the war

		-- In the pre-war period our naval construction is constrained by the naval treaties
		-- We need to set aside resources for the navy but this is the chance to build up the RAF, the army and build installations

		if isTreatySignatory and not hasEscalatorClause then
			local laArray = {
				0.15, -- Land
				0.45, -- Air
				0.25, -- Sea
				0.15}; -- Other
			rValue = laArray

		-- If the escalator clause has been invoked then we can build Ark Royal!

		elseif hasEscalatorClause and CCurrentGameState.GetCurrentDate():GetYear() < 1939 then
			local laArray = {
				0.15, -- Land
				0.40, -- Air
				0.30, -- Sea
				0.15}; -- Other
			rValue = laArray

		-- If the naval treaties have lapsed or war is imminent then we need to invest in the Royal Navy urgently!

		else
			local laArray = {
				0.15, -- Land
				0.35, -- Air
				0.40, -- Sea
				0.10}; -- Other
			rValue = laArray
		end
	else						-- During the war, based on different factors

		-- If we have lost London then we should be building land forces because we are in a desperate situation

		if CCurrentGameState.GetProvince(1964):GetController() ~= ministerTag then
			local laArray = {
				0.65, -- Land		-- We need lots of land forces!
				0.15, -- Air
				0.15, -- Sea
				0.05}; -- Other
			rValue = laArray

		-- If the war has started early then we need to continue to strengthen the army but we can now build capital ships!

		elseif CCurrentGameState.GetCurrentDate():GetYear() < 1939 then
			local laArray = {
				0.20, -- Land		-- If the war starts early, then build a few more land units
				0.30, -- Air
				0.40, -- Sea		-- And invest in the Royal Navy!
				0.10}; -- Other
			rValue = laArray

		-- If the USA is in our faction then we should be going on the offensive

		elseif usaTag:GetCountry():GetFaction() == ministerTag:GetCountry():GetFaction() then
			local laArray = {
				0.35, -- Land		-- More land forces!
				0.30, -- Air
				0.30, -- Sea
				0.05}; -- Other
			rValue = laArray
		
		-- We are losing in the Middle East

		elseif Support.IsDefeated(itaTag, egyTag) or Support.IsDefeated(itaTag, palTag)		-- Egypt or Palestine are down
		or CCurrentGameState.GetProvince(5563):GetController() ~= ministerTag then		-- or we've lost Suez!
			local laArray = {
				0.30, -- Land		-- More land forces!
				0.30, -- Air
				0.35, -- Sea
				0.05}; -- Other
			rValue = laArray

		-- France is defeated or it's mid-war so we need to build land, air and naval forces

		elseif Support.IsDefeated(gerTag, fraTag) or CCurrentGameState.GetCurrentDate():GetYear() > 1940 then
			local laArray = {
				0.30, -- Land
				0.30, -- Air		-- Invest in the RAF!
				0.35, -- Sea
				0.05}; -- Other	
			rValue = laArray

		-- Our default war ratios should be balanced but favouring naval production

		else
			local laArray = {
				0.25, -- Land
				0.35, -- Air
				0.35, -- Sea
				0.05}; -- Other
			rValue = laArray
		end
	end
	
	return rValue
end
-- Land ratio distribution
function P.LandRatio(minister)
	local rValue
	local ministerTag = minister:GetCountryTag()
	local fraTag = CCountryDataBase.GetTag('FRA')
	local gerTag = CCountryDataBase.GetTag('GER')
	local usaTag = CCountryDataBase.GetTag('USA')

	-- SSmith (04/06/2013)
	-- New section added if London has fallen
	-- Make sure we can build a balanced force including armour
	-- ISTs no longer count towards the unit totals so the early war armour requirement can never be satisfied!
	-- Added a new section to encourage garrisons in the early game

	if not(minister:GetCountry():IsAtWar()) then
		if CCurrentGameState.GetCurrentDate():GetYear() < 1939 then	-- Before the war 1936-38
			local laArray = {
				7, 	-- Garrison
				12, -- Infantry
				4, 	-- Motorized
				0, 	-- Mechanized
				2, 	-- Armor
				0, 	-- Militia
				0}; -- Cavalry
			rValue = laArray
		else								-- Before or after the war 1939 onwards
			local laArray = {
				5, 	-- Garrison
				12, -- Infantry
				4, 	-- Motorized
				2, 	-- Mechanized
				2, 	-- Armor
				0, 	-- Militia
				0}; -- Cavalry
			rValue = laArray
		end
	else
		if CCurrentGameState.GetCurrentDate():GetYear() < 1939 then	-- If the war starts early
			local laArray = {
				5, 	-- Garrison
				14, -- Infantry
				4, 	-- Motorized
				0, 	-- Mechanized
				2, 	-- Armor	-- More armour
				0, 	-- Militia
				0}; -- Cavalry
			rValue = laArray
		elseif CCurrentGameState.GetProvince(1964):GetController() ~= ministerTag then	-- If we've lost London!
			local laArray = {
				4, 	-- Garrison
				16, -- Infantry		-- More basic infantry
				3, 	-- Motorized
				1, 	-- Mechanized
				1, 	-- Armor
				0, 	-- Militia
				0}; -- Cavalry
			rValue = laArray
		elseif usaTag:GetCountry():GetFaction() == ministerTag:GetCountry():GetFaction() then	-- USA joined, so prepare for invasion!
			local laArray = {
				3, -- Garrison
				11, -- Infantry
				5, -- Motorized		-- More mobile forces
				3, -- Mechanized	-- Mechanized
				3, -- Armor		-- Armour
				0, -- Militia
				0}; -- Cavalry
			rValue = laArray
		elseif Support.IsDefeated(gerTag, fraTag) then			-- France is defeated, so build up our defences!
			local laArray = {
				4, 	-- Garrison
				12, -- Infantry
				4, 	-- Motorized	-- More mobile forces
				2, 	-- Mechanized	-- Mechanized
				3, 	-- Armor	-- Armour
				0, 	-- Militia
				0}; -- Cavalry
			rValue = laArray
		else								-- Default at war ratios
			local laArray = {
				4, -- Garrison
				13, -- Infantry
				4, -- Motorized
				2, -- Mechanized
				2, -- Armor
				0, -- Militia
				0}; -- Cavalry
			rValue = laArray
		end
	end
		
	return rValue
end
-- Special Forces ratio distribution
function P.SpecialForcesRatio(minister)

	-- SSmith (08/06/2013)
	-- This will now return separate ratios for mountain, marine and airborne brigades
	-- The UK should have a balanced array of special forces when the war starts

	local ministerCountry = minister:GetCountry()
	if minister:GetCountry():IsAtWar() then
		local laArray = {
			20, -- Mountain
			20, -- Marine
			20}; -- Airborne
		return laArray
	else
		local laArray = {
			20, -- Mountain
			40, -- Marine
			50}; -- Airborne
		return laArray
	end
end
-- Air ratio distribution
function P.AirRatio(minister)
	local rValue
	local ministerTag = minister:GetCountryTag()
	local fraTag = CCountryDataBase.GetTag('FRA')
	local gerTag = CCountryDataBase.GetTag('GER')
	local usaTag = CCountryDataBase.GetTag('USA')
	
	-- SSmith (14/05/2013)
	-- We need a balanced array of air power including heavy bombers

	if not(minister:GetCountry():IsAtWar())						-- Before and after the war
	or CCurrentGameState.GetProvince(1964):GetController() ~= ministerTag then	-- Or if London has fallen
		local laArray = {
			14, -- Fighter			-- We need air cover
			3, -- CAS
			4, -- Tactical
			2, -- Naval Bomber
			2}; -- Strategic
		rValue = laArray
	else
		if CCurrentGameState.GetCurrentDate():GetYear() < 1939 then		-- If the war starts early
			local laArray = {
				12, -- Fighter
				3, -- CAS
				5, -- Tactical
				2, -- Naval Bomber
				3}; -- Strategic	-- Start to build our bomber force
			rValue = laArray
		elseif usaTag:GetCountry():GetFaction() == ministerTag:GetCountry():GetFaction() then
			local laArray = {						-- USA joined, so prepare for invasion!
				9, -- Fighter
				3, -- CAS
				4, -- Tactical
				3, -- Naval Bomber
				6}; -- Strategic	-- It's time for a bomber offensive
			rValue = laArray
		elseif Support.IsDefeated(gerTag, fraTag) then
			local laArray = {		-- France is defeated, so let's harass the Germans!
				9, -- Fighter
				3, -- CAS
				4, -- Tactical
				3, -- Naval Bomber	-- We need protect our sealanes
				6}; -- Strategic	-- We need to hit back at Germany
			rValue = laArray
		else
			local laArray = {		-- Default war ratio
				10, -- Fighter
				3, -- CAS
				5, -- Tactical
				3, -- Naval Bomber
				4}; -- Strategic
			rValue = laArray
		end
	end
		
	return rValue
end
-- Naval ratio distribution
function P.NavalRatio(minister)
	local rValue
	local ministerCountry = minister:GetCountry()
	local ministerTag = minister:GetCountryTag()
	local fraTag = CCountryDataBase.GetTag('FRA')
	local gerTag = CCountryDataBase.GetTag('GER')
	local usaTag = CCountryDataBase.GetTag('USA')

	-- SSmith (14/05/2013)
	-- This is mostly changed to work by date instead of circumstances
	-- This means we can phase out battleships
	-- The necessary exception is what to do if London falls
	-- This becomes much easier now we have the new production logic!
	
	if not(minister:GetCountry():IsAtWar()) then

		-- We are at peace

		local laArray = {
			7.50, -- Destroyers		-- Work to a balanced ratio
			3, -- Submarines
			9, -- Cruisers
			3.75, -- Capital			-- Build new battleships if we can
			0, -- Escort Carrier
			1.75}; -- Carrier		-- Build new carriers if we can
		rValue = laArray
	else
			
		-- If London has fallen we should forget capital ships!

		if CCurrentGameState.GetProvince(1964):GetController() ~= ministerTag then
			local laArray = {
				10, -- Destroyers
				3, -- Submarines
				10, -- Cruisers
				1, -- Capital
				1, -- Escort Carrier
				0}; -- Carrier
			rValue = laArray

		-- Before 1942 we need battleships and carriers!

		elseif CCurrentGameState.GetCurrentDate():GetYear() < 1942 then
			local laArray = {
				8.25, -- Destroyers
				2, -- Submarines
				8.50, -- Cruisers
				3.75, -- Capital		-- Battleships
				1, -- Escort Carrier
				1.50}; -- Carrier
			rValue = laArray

		-- In 1942 we need carriers quickly but fewer battleships!

		elseif CCurrentGameState.GetCurrentDate():GetYear() < 1943 then
			local laArray = {
				9, -- Destroyers
				2, -- Submarines
				8.5, -- Cruisers
				3, -- Capital		-- Battleships
				1.5, -- Escort Carrier
				1}; -- Carrier
			rValue = laArray

		-- From 1943 we can forget battleships and concentrate on carriers and replacing losses!
		else
			local laArray = {
				9, -- Destroyers
				2, -- Submarines
				9, -- Cruisers
				2, -- Capital
				1.5, -- Escort Carrier
				1.5}; -- Carrier	-- Carriers
			rValue = laArray
		end
	end

	return rValue
end
-- Transport to Land unit distribution
function P.TransportLandRatio(minister)
	local ministerTag = minister:GetCountryTag()
	local gerTag = CCountryDataBase.GetTag('GER')
	local usaTag = CCountryDataBase.GetTag('USA')
	local laArray
	
	-- SSmith (13/05/2013)
	-- Increase the base number of transports so that we can shift troops around the world (was 1:30)
	
	if usaTag:GetCountry():GetFaction() == ministerTag:GetCountry():GetFaction() then
		laArray = {			-- USA joined, so prepare for invasion!
			10, -- Land
			1}; -- Transport
	else
		laArray = {			-- Build a reasonable amount.
			15, -- Land
			1}; -- Transport
	end
	
	return laArray
end

-- Build Strong Garrison units with no police
function P.Build_Garrison(ic, minister, garrison_brigade, vbGoOver)

	-- SSmith (20/06/2013)
	-- Brigade count check removed because it was stopping unit construction!

	ic, garrison_brigade = Utils.CreateDivision(minister, "garrison_brigade", 0, ic, garrison_brigade, 3, Utils.BuildDefenceGarrisonUnitArray(minister:GetCountry()), 1, vbGoOver)

	return ic, garrison_brigade
end

-- Do not build Light Armour, we will build Infantry with Infantry Support Tanks.
function P.Build_LightArmor(ic, minister, light_armor_brigade, vbGoOver)

	-- SSmith (26/05/2013)
	-- This function will override light armour in favour of infantry with ISTs before 1941

	if minister:GetCountry():GetTechnologyStatus():IsUnitAvailable(CSubUnitDataBase.GetSubUnit("infantry_brigade"))
	and minister:GetCountry():GetTechnologyStatus():IsUnitAvailable(CSubUnitDataBase.GetSubUnit("super_heavy_armor_brigade"))
	and CCurrentGameState.GetCurrentDate():GetYear() < 1941
	then
		local LegUnitArray = {}
		local super_heavy_armor_brigade = CSubUnitDataBase.GetSubUnit("super_heavy_armor_brigade")
		table.insert( LegUnitArray, super_heavy_armor_brigade )
		return Utils.CreateDivision(minister, "infantry_brigade", 0, ic, light_armor_brigade, 3, LegUnitArray, 1, vbGoOver)
	elseif minister:GetCountry():GetTechnologyStatus():IsUnitAvailable(CSubUnitDataBase.GetSubUnit("light_armor_brigade")) then
		return Utils.CreateDivision(minister, "light_armor_brigade", 0, ic, light_armor_brigade, 2, Utils.BuildArmorUnitArray(minister:GetCountry()), 1, vbGoOver)
	else
		return ic, 0
	end
end

-- Do not build Armour, we will build Infantry with Infantry Support Tanks.
function P.Build_Armor(ic, minister, armor_brigade, vbGoOver)

	-- SSmith (26/05/2013)
	-- This function will override armour in favour of infantry with ISTs before 1941

	if minister:GetCountry():GetTechnologyStatus():IsUnitAvailable(CSubUnitDataBase.GetSubUnit("infantry_brigade"))
	and minister:GetCountry():GetTechnologyStatus():IsUnitAvailable(CSubUnitDataBase.GetSubUnit("super_heavy_armor_brigade"))
	and CCurrentGameState.GetCurrentDate():GetYear() < 1941
	then
		local LegUnitArray = {}
		local super_heavy_armor_brigade = CSubUnitDataBase.GetSubUnit("super_heavy_armor_brigade")
		table.insert( LegUnitArray, super_heavy_armor_brigade )
		return Utils.CreateDivision(minister, "infantry_brigade", 0, ic, armor_brigade, 3, LegUnitArray, 1, vbGoOver)
	elseif minister:GetCountry():GetTechnologyStatus():IsUnitAvailable(CSubUnitDataBase.GetSubUnit("armor_brigade")) then
		return Utils.CreateDivision(minister, "armor_brigade", 0, ic, armor_brigade, 2, Utils.BuildArmorUnitArray(minister:GetCountry()), 1, vbGoOver)
	else
		return ic, 0
	end
end

-- Do not build cavalry
function P.Build_Cavalry(ic, minister, cavalry_brigade, vbGoOver)
	return ic, 0
end

-- Do not build battlecruisers
function P.Build_Battlecruiser(ic, minister, battlecruiser, vbGoOver)
	-- Replace Battlecruiser request with a Battleship
	if minister:GetCountry():GetTechnologyStatus():IsUnitAvailable(CSubUnitDataBase.GetSubUnit("battleship")) then
		return Utils.CreateDivision_nominor(minister, "battleship", 0, ic, battlecruiser, 1, vbGoOver)
	else
		return ic, 0
	end
end


-- SSmith (21/06/2013)
-- Redundant functions

-- Only build 5 Mountaineers!
--function P.Build_Mountain(ic, minister, bergsjaeger_brigade, vbGoOver)
--	-- Replace Mountaineers wiht Leg Infantry, if we already have enough.
--	local deployedUnits = minister:GetOwnerAI():GetDeployedSubUnitCounts()
--	local producedUnits = minister:GetOwnerAI():GetProductionSubUnitCounts()
--	if deployedUnits:GetAt(CSubUnitDataBase.GetSubUnit("bergsjaeger_brigade"):GetIndex()) + producedUnits:GetAt(CSubUnitDataBase.GetSubUnit("bergsjaeger_brigade"):GetIndex()) < 15 then
--		return Utils.CreateDivision_nominor(minister, "bergsjaeger_brigade", 0, ic, bergsjaeger_brigade, 3, vbGoOver)
--	else
--		return Utils.CreateDivision(minister, "infantry_brigade", 0, ic, bergsjaeger_brigade, 3, Utils.BuildLegUnitArray(minister:GetCountry()), 1, vbGoOver)
--	end
--end

-- Only build 10 Marines!
--function P.Build_Marine(ic, minister, marine_brigade, vbGoOver)
--	-- Replace Marines wiht Leg Infantry, if we already have enough.
--	local deployedUnits = minister:GetOwnerAI():GetDeployedSubUnitCounts()
--	local producedUnits = minister:GetOwnerAI():GetProductionSubUnitCounts()
--	if deployedUnits:GetAt(CSubUnitDataBase.GetSubUnit("marine_brigade"):GetIndex()) + producedUnits:GetAt(CSubUnitDataBase.GetSubUnit("marine_brigade"):GetIndex()) < 30 then
--		return Utils.CreateDivision_nominor(minister, "marine_brigade", 0, ic, marine_brigade, 3, vbGoOver)
--	else
--		return Utils.CreateDivision(minister, "infantry_brigade", 0, ic, marine_brigade, 3, Utils.BuildLegUnitArray(minister:GetCountry()), 1, vbGoOver)
--	end
--end

-- Only build 3 Paratroopers!
--function P.Build_Paratrooper(ic, minister, paratrooper_brigade, vbGoOver)
--	-- Replace Paratroopers wiht Leg Infantry, if we already have enough.
--	local deployedUnits = minister:GetOwnerAI():GetDeployedSubUnitCounts()
--	local producedUnits = minister:GetOwnerAI():GetProductionSubUnitCounts()
--	if deployedUnits:GetAt(CSubUnitDataBase.GetSubUnit("paratrooper_brigade"):GetIndex()) + producedUnits:GetAt(CSubUnitDataBase.GetSubUnit("paratrooper_brigade"):GetIndex()) < 9 then
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
	local industry = CBuildingDataBase.GetBuilding("industry" )
	local industryCost = ministerCountry:GetBuildCost(industry):Get()
	local laCorePrv = {}
	local loTechStatus = ministerCountry:GetTechnologyStatus()
	
	laCorePrv = CoreProvincesLoop(ministerCountry, loTechStatus, 1, 1)
	
	local i = 0
	
	while i < 3 do	-- Should be alright, although we could use a 'for' loop.
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

function P.Build_Radar(ic, minister, vbGoOver)

	-- SSmith 01/05/2013
	-- New function to control where British radar stations are built

	-- Only build limited radars before 1940
	if minister:GetOwnerAI():GetCurrentDate():GetYear() < 1940 then
		ic = Support.Build_Radar(ic, minister, 2021, 5, vbGoOver) -- Dover
		ic = Support.Build_Radar(ic, minister, 2250, 5, vbGoOver) -- Plymouth
		ic = Support.Build_Radar(ic, minister, 1524, 5, vbGoOver) -- Hull
		ic = Support.Build_Radar(ic, minister, 604, 5, vbGoOver) -- Scapa Flow
	else
		ic = Support.Build_Radar(ic, minister, 2021, 10, vbGoOver) -- Dover
		ic = Support.Build_Radar(ic, minister, 2250, 5, vbGoOver) -- Plymouth
		ic = Support.Build_Radar(ic, minister, 1524, 5, vbGoOver) -- Hull
		ic = Support.Build_Radar(ic, minister, 604, 5, vbGoOver) -- Scapa Flow
		ic = Support.Build_Radar(ic, minister, 5191, 5, vbGoOver) -- Gibraltar
		ic = Support.Build_Radar(ic, minister, 5359, 5, vbGoOver) -- Malta
		ic = Support.Build_Radar(ic, minister, 6394, 5, vbGoOver) -- Singapore
	end
	
	return ic
end

function P.DontBuildBuilding(minister, building)

	-- SSmith (13/05/2013)
	-- New function to regulate radar building and nuclear/rocket facilities

	if tostring(building:GetName()) == "Nuclear Research Lab" or tostring(building:GetName()) == "Rocket Test Site" then
		return true
	--elseif minister:GetOwnerAI():GetCurrentDate():GetYear() < 1940 then
	--	if math.random(0,100) < 35
	--	and tostring(building:GetName()) ~= "Radar Station" and tostring(building:GetName()) ~= "Industrial Capacity" then
	--		return true
	--	else
	--		return false
	--	end
	else
		return false
	end
end
		
-- END OF PRODUTION OVERIDES
-- #######################################

-- #######################################
-- Intelligence Hooks

-- Home_Spies(minister)
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
	local fraTag = CCountryDataBase.GetTag('FRA')
	
	-- Note: nothing for Germany here because we don't want to antagonise them (also France will DOW too early)
	-- We want to have the USA as a friend!
	if tostring(TargetCountryTag) == "USA" and not TargetCountry:HasFaction() then
		-- Get worried if France falls
		if Support.IsDefeated(ministerTag, fraTag) then
			return 3
		else
			return 1
		end
	
	-- We don't trust the Soviets. but will ignore them before the war with Germany
	elseif tostring(TargetCountryTag) == "SOV" and Support.IsDefeated(ministerTag, gerTag)
	then
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
	
	local sameIdeology = Utils.SameIdeology(ministerCountry, TargetCountry, nil)
	local gerTag = CCountryDataBase.GetTag('GER')
	local CountryScriptMission = nil
	
	-- We want to have the USA as a friend!
	if tostring(TargetCountryTag) == "USA" and not TargetCountry:HasFaction() then
		if sameIdeology == true then
			CountryScriptMission = "BoostRulingParty"
		else
			CountryScriptMission = "BoostOurParty"
		end
	
	-- We don't trust the Soviets.
	elseif tostring(TargetCountryTag) == "SOV" and Support.IsDefeated(ministerTag, gerTag) then
		CountryScriptMission = "IncreaseThreat"
	end
	
	return CountryScriptMission
end

-- End of Intelligence Hooks
-- #######################################

function P.ProposeDeclareWar(minister)
	local ai = minister:GetOwnerAI()
	local ministerCountry = minister:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	local year = ai:GetCurrentDate():GetYear()
	
	local axisFaction = CCurrentGameState.GetFaction("axis")
	local alliesFaction = CCurrentGameState.GetFaction("allies")
	local comminternFaction = CCurrentGameState.GetFaction("commintern")
	local axisLeaderTag = axisFaction:GetFactionLeader()
	
	local loStrategy = ministerCountry:GetStrategy()
	
	local fraTag = CCountryDataBase.GetTag('FRA')
	local gerTag = CCountryDataBase.GetTag('GER')
	local itaTag = CCountryDataBase.GetTag('ITA')
	
	-- Make sure UK is part of the allies
	if ministerCountry:GetFaction() == alliesFaction
	and not(loStrategy:IsPreparingWar())
	-- Don't be too aggressive while France is around, as that could have very unwelcome results... Let them start the wars!
	and
	(
		not fraTag:GetCountry():Exists()										-- France doesn't exist,
		or fraTag:GetCountry():IsGovernmentInExile()							-- is in exile,
		or not fraTag:GetCountry():HasFaction()									-- is not in any faction
		or not ministerCountry:GetFaction() == fraTag:GetCountry():GetFaction()	-- or at least not in ours!
	)
	then
		local loMinisterCapital = ministerCountry:GetCapitalLocation():GetContinent()
	
		-- Generic DOW for countries not part of the same faction
		
		local currentNeutrality = ministerCountry:GetNeutrality():Get()
		for loTargetCountry in CCurrentGameState.GetCountries() do
			local loTargetTag = loTargetCountry:GetCountryTag()
			
			if not(loTargetCountry:GetFaction() == ministerCountry:GetFaction()) then
				if ( loTargetCountry:GetCapitalLocation():GetContinent() == loMinisterCapital	-- Same continent
				or ministerCountry:IsNeighbour(loTargetTag)	)									-- or at least a neighbor.
				and Support.CompareMilitaryStrength(ministerTag, loTargetTag) > 1.5
				and ministerCountry:GetManpower():Get() > 200
				then
					local currentThreat = ministerCountry:GetRelation(loTargetTag):GetThreat():Get()
					local canAttack = ( Support.IsDefeated(ministerTag, gerTag) or ( not loTargetCountry:HasFaction() ) or loTargetCountry:GetFaction() == axisFaction or ( not ministerCountry:IsAtWar() and year > 1940 ) )
					
					if canAttack and currentThreat > currentNeutrality + 20 and ministerCountry:IsMobilized() then
						Support.PrepareForWar( ministerTag, loTargetTag, 100 )
					elseif currentThreat > currentNeutrality + 10 then
						local command = CToggleMobilizationCommand( ministerTag, true )
						ai:Post( command )
					end
				end
			end
		end

		if not(ministerCountry:IsAtWar()) then
			local loGerCountry = gerTag:GetCountry()
			local loItaCountry = itaTag:GetCountry()
			
			-- Check for UK to keep an eye on Germany
			if not(ministerCountry:GetRelation(gerTag):HasWar())
			and loGerCountry:GetFaction() == axisFaction
			and loGerCountry:IsAtWar() then
				if ministerCountry:IsMobilized() then
					Support.PrepareForWar( ministerTag, gerTag, 0.75 )
				else
					local command = CToggleMobilizationCommand( ministerTag, true )
					ai:Post( command )
					return
				end
			end
			
			-- Check for UK to keep an eye on Italy
			if not(ministerCountry:GetRelation(itaTag):HasWar())
			and loItaCountry:GetFaction() == axisFaction
			and loItaCountry:IsAtWar() then
				if ministerCountry:IsMobilized() then
					Support.PrepareForWar( ministerTag, itaTag, 0.75 )
				else
					local command = CToggleMobilizationCommand( ministerTag, true )
					ai:Post( command )
					return
				end
			end
		end
	end
end

function P.DiploScore_OfferTrade(score, ai, actor, recipient, observer, voTradedFrom, voTradedTo)
	local lsActorTag = tostring(actor)
	
	if lsActorTag == "AST" 
	or lsActorTag == "CAN" 
	or lsActorTag == "SAF" 
	or lsActorTag == "NZL" then
		score = score + 20
	elseif lsActorTag == "USA" or lsActorTag == "FRA" then
		score = score + 100
	end
	
	return score
end

function P.DiploScore_InfluenceNation( score, ai, actor, recipient, observer )
	local lsRepTag = tostring(recipient)
	
	if lsRepTag == "AUS" or lsRepTag == "CZE" or lsRepTag == "SCH" or lsRepTag == "SWE"		-- Shouldn't bother,
	or lsRepTag == "AST" or lsRepTag == "CAN" or lsRepTag == "SAF" or lsRepTag == "NZL"		-- we get them for free or never.
	then
		return 0
	elseif lsRepTag == "HUN" or lsRepTag == "ROM" or lsRepTag == "BUL" or lsRepTag == "FIN" then
		score = score - 50
	elseif lsRepTag == "ITA" and Support.IsDefeated( CCountryDataBase.GetTag('ITA'), CCountryDataBase.GetTag('ETH') ) then
		-- Don't influence Italy after the Italo-Abyssinian war
		score = 0
	elseif lsRepTag == "JAP" and CCountryDataBase.GetTag('JAP'):GetCountry():GetRelation( CCountryDataBase.GetTag('ETH') ):HasWar() then
		-- Don't influence Japan if they are at war with China
		score = 0
	elseif lsRepTag == "USA" then
		score = score + 70
	end

	return score
end

function P.DiploScore_InviteToFaction( score, ai, actor, recipient, observer)

	local recipientTagString = tostring(recipient)
	local actorIdeologyGroup = actor:GetCountry():GetRulingIdeology():GetGroup()
	local recipientIdeologyGroup = recipient:GetCountry():GetRulingIdeology():GetGroup()

	if actorIdeologyGroup == recipientIdeologyGroup then
		score = score + 50
	else
		score = score - 25
	end
	
	return score
end

function P.ForeignMinister_EvaluateDecision(score, agent, decision, scope)
	local lsDecision = tostring(decision:GetKey())
	local country = agent:GetCountry()
	local countryTag = country:GetCountryTag()

	-- SSmith (26/08/2013)
	-- Add random chances to decisions to make them more realistic
	
	if lsDecision == "spanish_civil_war_british_intervention_spr" or lsDecision == "spanish_civil_war_british_intervention_full_spr" then
		if country:GetRulingIdeology():GetGroup():GetKey() == 'communism'		-- Only intervene in the SCW if we are not a democracy!
		and math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == "spanish_civil_war_british_intervention_spa" or lsDecision == "spanish_civil_war_british_intervention_full_spa" then
		if country:GetRulingIdeology():GetGroup():GetKey() == 'fascism'		-- Only intervene in the SCW if we are not a democracy!
		and math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			score = 100
		else
			score = 0
		end

	elseif lsDecision == "operation_wilfred" then

		-- SSmith (29/11/2013)
		-- Allow this from 1940 or if Denmark has fallen

		local gerTag = CCountryDataBase.GetTag('GER')
		local denTag = CCountryDataBase.GetTag('DEN')
		if (CCurrentGameState.GetCurrentDate():GetYear() > 1939 or Support.IsDefeated(gerTag, denTag))
		and math.mod( CCurrentGameState.GetAIRand(), 5) == 1 then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == "reconstruct_queen_elizabeth" or lsDecision == "reconstruct_valiant" then
		if math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == "help_for_china" then
		if math.mod( CCurrentGameState.GetAIRand(), 50) == 1 then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == "guarantee_independence_of_poland" then
		if math.mod( CCurrentGameState.GetAIRand(), 10) == 1 then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == "us_occupation_of_iceland_greenland" then
		if math.mod( CCurrentGameState.GetAIRand(), 100) == 1 then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == "destruction_of_french_fleet" then
		if math.mod( CCurrentGameState.GetAIRand(), 10) == 1 then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == "operation_countenance" then
		if math.mod( CCurrentGameState.GetAIRand(), 50) == 1 then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == "anglo_iraqi_war" then
		if math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == "offer_separate_peace" then
		if math.mod( CCurrentGameState.GetAIRand(), 10) == 1 then
			score = 100
		else
			score = 0
		end

	elseif lsDecision == "give_back_territory_to_YEM"
	or lsDecision == "give_back_territory_to_GRE"
	or lsDecision == "give_back_territory_to_TUR"
	or lsDecision == "give_back_territory_to_VEN"
	then
		return 0
	end
	
	return score
end

function P.HandlePuppets(minister)

	-- SSmith (22/11/2013)
	-- Add exceptions for our colonies

	local laCountryExceptions = { "CEY", "MTA", "CYP", "JAM", "GUY" }
	return laCountryExceptions
end

function P.HandleMobilization( minister, needsMobilization )
	
	local ministerTag = minister:GetCountryTag()
	local ministerCountry = minister:GetCountry()
	local ai = minister:GetOwnerAI()
	
	-- Special check for Germany.
	local gerTag = CCountryDataBase.GetTag('GER')
	
	if ministerCountry:GetRelation(gerTag):GetThreat():Get() > 50 then		-- Mobilize if Germany is threatening!
		needsMobilization = true
	end
	
	return needsMobilization
end

function P.DiploScore_Embargo( score, ai, actor, recipient, observer)

	local japTag = CCountryDataBase.GetTag('JAP')
	local actorIdeologyGroup = actor:GetCountry():GetRulingIdeology():GetGroup()
	local recipientIdeologyGroup = recipient:GetCountry():GetRulingIdeology():GetGroup()

	if ( not actorIdeologyGroup == recipientIdeologyGroup )
	and	( recipient == japTag and CCurrentGameState.IsGlobalFlagSet( CString("us_oil_embargo") ) )	-- The Oil Embargo against Japan is supposed to be in effect
	then
		return 100
	end
	
	return score
end

-- Produce slightly better trained troops
function P.CallLaw_training_laws(minister, voCurrentLaw)
	local _ADVANCED_TRAINING_ = 30
	return CLawDataBase.GetLaw(_ADVANCED_TRAINING_)
end

return AI_ENG

