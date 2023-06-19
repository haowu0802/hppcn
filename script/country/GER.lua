-----------------------------------------------------------
-- Germany
-----------------------------------------------------------

local P = {}
AI_GER = P

-- #######################################
-- Start of Tech Research

-- Tech weights
--   1.0 = 100% the total needs to equal 1.0
function P.TechWeights( minister )
	local laTechWeights

	-- SSmith (23/07/2013)
	-- Changed to new format
	-- Early shift from air to naval techs

	local laTechWeights

	if CCurrentGameState.GetCurrentDate():GetYear() < 1938 then

		laTechWeights = {
			0.35, -- Land
			0.15, -- Air
			0.30, -- Naval
			0.20}; -- Other

	elseif CCurrentGameState.GetCurrentDate():GetYear() < 1940 then

		laTechWeights = {
			0.37, -- Land
			0.33, -- Air
			0.10, -- Naval
			0.20}; -- Other
	else
		laTechWeights = {
			0.40, -- Land
			0.35, -- Air
			0.05, -- Naval
			0.20}; -- Other
	end

	return laTechWeights
end

function P.Get_TechParams(minister)

	-- SSmith (21/08/2013)
	-- This is a new function to return a table of country-specific research config

	local laTechParams = {

		paratrooper_infantry		= { Leadership = 12, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
		artic_warfare_equipment 	= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		engineer_bridging_equipment	= { Leadership = 12, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.30, EndYear = 1999, Attribute = "" },
		engineer_assault_equipment  	= { Leadership = 12, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.30, EndYear = 1999, Attribute = "" },
		weapon_salt_water_proofing 	= { Leadership = 12, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
		amphibious_warfare_equipment 	= { Leadership = 12, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
		mechanised_infantry 		= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
		anti_tank 			= { Leadership =  7, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		rocket_artillery_activation 	= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		rocket_artillery 		= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		tank_brigade 			= { Leadership = 12, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "MediumTank" },
		tank_gun 			= { Leadership = 12, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "MediumTank" },
		tank_armour 			= { Leadership = 12, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "MediumTank" },
		tank_engine 			= { Leadership = 12, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "MediumTank" },
		tank_reliability 		= { Leadership = 12, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "MediumTank" },
		heavy_tank_brigade 		= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "HeavyTank" },
		heavy_tank_gun 			= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "HeavyTank" },
		heavy_tank_armour 		= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "HeavyTank" },
		sloped_armor 			= { Leadership = 12, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
		self_propelled_support_brigade_tech = { Leadership = 30, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		sp_artillery_activation 	= { Leadership = 30, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		sp_artillery 			= { Leadership = 30, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		sp_rocket_artillery_activation 	= { Leadership = 30, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		sp_rocket_artillery 		= { Leadership = 30, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		tank_destroyer_activation 	= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		tank_destroyer 			= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
		sp_anti_air_activation 		= { Leadership = 30, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		sp_anti_air 			= { Leadership = 30, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		destroyer_technology 		= { Leadership =  7, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.25, EndYear = 1939, Attribute = "ShipBuilding" },
		destroyer_engine 		= { Leadership =  7, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.20, EndYear = 1939, Attribute = "" },
		multi_purpose_guns 		= { Leadership =  7, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.25, EndYear = 1939, Attribute = "" },
		smallwarship_asw 		= { Leadership = 12, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		heavycruiser_technology 	= { Leadership = 12, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.25, EndYear = 1939, Attribute = "ShipBuilding" },
		heavycruiser_armament 		= { Leadership = 12, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.20, EndYear = 1939, Attribute = "" },
		lightcruiser_technology 	= { Leadership =  7, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.25, EndYear = 1939, Attribute = "ShipBuilding" },
		lightcruiser_armament 		= { Leadership =  7, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.20, EndYear = 1939, Attribute = "" },
		cruiser_engine 			= { Leadership =  7, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.20, EndYear = 1939, Attribute = "" },
		cruiser_armor 			= { Leadership =  7, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.20, EndYear = 1939, Attribute = "" },
		submarine_technology 		= { Leadership =  7, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "ShipBuilding" },
		submarine_engine 		= { Leadership =  7, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		battlecruiser_technology 	= { Leadership = 12, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1938, Attribute = "" },
		battleship_technology 		= { Leadership = 12, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1939, Attribute = "" },
		capital_ship_armor 		= { Leadership = 12, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1939, Attribute = "" },
		capital_ship_engine 		= { Leadership = 12, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1939, Attribute = "" },
		capitalship_armament 		= { Leadership = 12, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1939, Attribute = "" },

		multi_role_fighter_development 	= { Leadership = 12, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		escort_fighter_development 	= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		supply_production 		= { Leadership =  5, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		supply_transportation 		= { Leadership =  3, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		supply_organisation 		= { Leadership =  3, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		artillery_training 		= { Leadership =  5, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		tank_crew_training 		= { Leadership = 10, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		special_forces_training 	= { Leadership =  7, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		officer_training		= { Leadership =  5, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		destroyer_crew_training 	= { Leadership =  7, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1939, Attribute = "" },
		capital_ship_crew_training 	= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1939, Attribute = "" },
		submarine_crew_training 	= { Leadership =  7, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		cruiser_crew_training 		= { Leadership =  7, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1939, Attribute = "" },
		fire_control_system_training 	= { Leadership =  7, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1939, Attribute = "" },
		radar_training 			= { Leadership = 12, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1939, Attribute = "" },
		commander_decision_making 	= { Leadership =  7, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1939, Attribute = "" },
		night_equipment_training 	= { Leadership = 12, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1939, Attribute = "" },
		base_operations 		= { Leadership = 12, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1939, Attribute = "" },
		sealane_control 		= { Leadership = 10, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1939, Attribute = "" },
		asw_tactics 			= { Leadership = 10, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		sealane_interdiction 		= { Leadership = 10, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		independent_battleship_operations = { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1939, Attribute = "" },
		independent_cruiser_operations 	= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1939, Attribute = "" },
		independent_destroyer_operations = { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1939, Attribute = "" },
		trade_interdiction_submarine_doctrine = { Leadership = 10, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		cas_pilot_training 		= { Leadership =  7, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		cas_groundcrew_training 	= { Leadership =  7, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		interdiction_tactics 		= { Leadership = 10, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		installation_strike_tactics 	= { Leadership = 10, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		tactical_air_command 		= { Leadership = 10, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		strategic_airforce_doctrine 	= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.15, EndYear = 1999, Attribute = "" },
		airborne_assault_tactics 	= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.15, EndYear = 1999, Attribute = "" },
		naval_aviation_doctrine 	= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.15, EndYear = 1999, Attribute = "Naval" },
		portstrike_tactics 		= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.15, EndYear = 1999, Attribute = "Naval" },
		navalstrike_tactics 		= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.15, EndYear = 1999, Attribute = "Naval" },
		naval_tactics 			= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.15, EndYear = 1999, Attribute = "Naval" }
	}

	return laTechParams
end

-- SSmith (10/05/2013)
-- I have replaced this with a new function

function P.TechSliders(ministerCountry, techSliderArray)

	local LEADERSHIP_RESEARCH = techSliderArray[1]
	local LEADERSHIP_ESPIONAGE = techSliderArray[2]
	local LEADERSHIP_DIPLOMACY = techSliderArray[3]
	local LEADERSHIP_NCO = techSliderArray[4]

	-- Germany needs a custom officer ratio to create an efficient Wehrmacht!

	local officer_ratio = ministerCountry:GetOfficerRatio():Get()

	if officer_ratio < 1.00 then
		LEADERSHIP_NCO = 0.50	-- We must get to 100%!
	elseif officer_ratio < 1.25 then
		LEADERSHIP_NCO = 0.35	-- Keep pushing to 125%!
	elseif officer_ratio < 1.50 then
		LEADERSHIP_NCO = 0.25	-- Getting to 150% is ideal!
	elseif officer_ratio < 1.65 then
		LEADERSHIP_NCO = 0.05	-- You can never have too many officers!
	else
		LEADERSHIP_NCO = 0.00
	end

	techSliderArray = {
		LEADERSHIP_RESEARCH,
		LEADERSHIP_ESPIONAGE,
		LEADERSHIP_DIPLOMACY,
		LEADERSHIP_NCO};

	return techSliderArray

end

-- END OF TECH RESEARCH OVERIDES
-- #######################################

-- #######################################
-- Production Overides the main LUA with country specific ones

-- Production Weights
--   1.0 = 100% the total needs to equal 1.0
function P.ProductionWeights( minister )
	local laArray
	local ministerCountry = minister:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()	

	-- SSmith (22/06/2013)
	-- The CalcDesperation method is an unknown quantity
	-- We will use surrender progress instead

	if ministerCountry:IsAtWar() then
		-- Desperation check and if so heavy production of land forces
		if ministerCountry:GetSurrenderLevel():Get() > 0.25 then
			laArray = {
				0.80, -- Land
				0.10, -- Air
				0.05, -- Sea
				0.05}; -- Other
		else	-- If we are not desperate, check who we are fighting!
			if CCurrentGameState.GetProvince( 1409 ):GetController() == ministerTag then
				laArray = {				-- We control Moscow, so we will most likely win on the Eastern Front. Europe is won.
					0.50, -- Land			-- Let's shift our focus to the Navy to defeat our overseas foes!
					0.10, -- Air
					0.30, -- Sea
					0.10}; -- Other
			else
				laArray = {					-- Focus mostly on Land, but spend a good amount on Air and Sea as well
					0.70, -- Land
					0.10, -- Air
					0.15, -- Sea
					0.05}; -- Other
			end
		end
	else
		if CCurrentGameState.GetCurrentDate():GetYear() <= 1937 then		-- During the first two years, be balanced!
			laArray = {
				0.55, -- Land
				0.20, -- Air
				0.15, -- Sea
				0.10}; -- Other
		elseif CCurrentGameState.GetCurrentDate():GetYear() <= 1939 then	-- Before the War, build land units mostly.
			laArray = {
				0.65, -- Land
				0.15, -- Air
				0.15, -- Sea
				0.05}; -- Other
		else
			laArray = {							-- After the War, be more balanced!
				0.50, -- Land
				0.15, -- Air
				0.25, -- Sea
				0.10}; -- Other
		end
	end
	
	return laArray
end
-- Land ratio distribution
function P.LandRatio( minister )	
	local laArray
	local ministerCountry = minister:GetCountry()

	-- SSmith (12/05/2013)
	-- We should build balanced forces with a lot of mobile units
	-- Also a few garrisons might be handy
	
	if ministerCountry:IsAtWar() then		-- Emphasize on mobile/armoured units!
		laArray = {
			3, -- Garrison
			12, -- Infantry
			4, -- Motorized
			2, -- Mechanized
			3, -- Armor
			0, -- Militia
			1}; -- Cavalry
	else
		if CCurrentGameState.GetCurrentDate():GetYear() < 1940 then	-- Before the War, build mostly Infantry.
			if minister:GetCountry():GetTechnologyStatus():IsUnitAvailable( CSubUnitDataBase.GetSubUnit( "armor_brigade" ) )
			-- This unit count restriction is probably not necessary
			--and ministerCountry:GetUnits():GetCount( CSubUnitDataBase.GetSubUnit( "armor_brigade" ) ) < 20 
			then					-- Build up some armour the first chance we get, but no need to overdo it!
				laArray = {
					4, -- Garrison
					12, -- Infantry
					5, -- Motorized
					0, -- Mechanized
					3, -- Armor
					0, -- Militia
					1}; -- Cavalry
			else					-- Still build some Light Tanks, we want those as well!
				laArray = {
					3, -- Garrison
					13, -- Infantry
					5, -- Motorized
					0, -- Mechanized
					2, -- Armor
					0, -- Militia
					2}; -- Cavalry
			end
		else						-- After the war build less armour and more motorized infantry.
			laArray = {
				3, -- Garrison
				13, -- Infantry
				3, -- Motorized
				3, -- Mechanized
				3, -- Armor
				0, -- Militia
				0}; -- Cavalry
		end		
	end
	
	return laArray
end
-- Special Forces ratio distribution
function P.SpecialForcesRatio( minister )

	-- SSmith (08/06/2013)
	-- This will now return separate ratios for mountain, marine and airborne brigades
	-- Germany should recruit airborne brigades more than marines

	local laArray = {
		20, -- Mountain
		35, -- Marine
		25}; -- Airborne
	
	return laArray
end
-- Air ratio distribution
function P.AirRatio( minister )

	-- SSmith (12/05/2013)
	-- We need a balanced Luftwaffe giving plenty of air support

	local laArray = {
		13, -- Fighter
		5, -- CAS
		5, -- Tactical
		2, -- Naval Bomber
		0}; -- Strategic
	
	return laArray
end
-- Naval ratio distribution
function P.NavalRatio( minister )
	local laArray
	local ministerCountry = minister:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()

	-- SSmith (12/05/2013)
	-- This is can be simplified now that we have the new production logic
	-- We will build a balanced fleet if we've taken Moskva or London
	-- Otherwise at war we will switch to submarines
	-- Before the war we will try for some capitals and escorts

	if CCurrentGameState.GetProvince(1409):GetController() == ministerTag
	or CCurrentGameState.GetProvince(1964):GetController() == ministerTag then

		-- We have got Moskva or London so we can afford to be ambitious!

		laArray = {
			7, -- Destroyers	-- A general balanced build
			5, -- Submarines
			7, -- Cruisers
			3, -- Capital
			1, -- Escort Carrier
			2}; -- Carrier
	else
		if ministerCountry:IsAtWar() then

			-- We are at war so we will concentrate on submarines

			laArray = {
				4, -- Destroyers
				12, -- Submarines
				4, -- Cruisers
				3, -- Capital
				1, -- Escort Carrier
				1}; -- Carrier
		else

			-- Before the war we want some capital ships and escorts

			laArray = {
				6, -- Destroyers
				4, -- Submarines
				9, -- Cruisers
				6, -- Capital
				0, -- Escort Carrier
				0}; -- Carrier
		end
	end
	return laArray
end
-- Transport to Land unit distribution
function P.TransportLandRatio( minister )

	-- SSmith (26/03/2013)
	-- Germany doesn't build enough transports to invade Norway/Britain (was 1:60)
	-- If we are at war with the Soviets and haven't taken Moscow then we should ignore transports
	-- Otherwise we should build sensible numbers so that we can invade places

	local ministerCountry = minister:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	local sovTag = CCountryDataBase.GetTag('SOV')
	local laArray

	if not ministerCountry:GetRelation(sovTag):HasWar()
	or CCurrentGameState.GetProvince(1409):GetController() == ministerTag then
		laArray = {
			30, -- Land
			1}; -- Transport
	else
		laArray = {
			120, -- Land
			1}; -- Transport	
	end
	
	return laArray
end

-- Do not build light armor if we can build medium
function P.Build_LightArmor( ic, minister, light_armor_brigade, vbGoOver )
	-- Replace Light Armor request with Armor if we can
	if minister:GetCountry():GetTechnologyStatus():IsUnitAvailable( CSubUnitDataBase.GetSubUnit("armor_brigade")) then
		return Utils.CreateDivision( minister, "armor_brigade", 0, ic, light_armor_brigade, 2, Utils.BuildArmorUnitArray( minister:GetCountry()), 1, vbGoOver )
	elseif minister:GetCountry():GetTechnologyStatus():IsUnitAvailable( CSubUnitDataBase.GetSubUnit("light_armor_brigade")) then
		return Utils.CreateDivision( minister, "light_armor_brigade", 0, ic, light_armor_brigade, 2, Utils.BuildArmorUnitArray( minister:GetCountry()), 1, vbGoOver )
	else
		return ic, 0
	end
end

-- SSmith (12/05/2013)
-- New functions to build battlecruisers/battleships before/after 1938

function P.Build_Battlecruiser(ic, minister, battlecruiser, vbGoOver)
	if CCurrentGameState.GetCurrentDate():GetYear() < 1938 then
		return Utils.CreateDivision_nominor(minister, "battlecruiser", 0, ic, battlecruiser, 1, vbGoOver)
	else
		return Utils.CreateDivision_nominor(minister, "battleship", 0, ic, battlecruiser, 1, vbGoOver)
	end
end

function P.Build_Battleship(ic, minister, battleship, vbGoOver)
	if CCurrentGameState.GetCurrentDate():GetYear() < 1938 then
		return Utils.CreateDivision_nominor(minister, "battlecruiser", 0, ic, battleship, 1, vbGoOver)
	else
		return Utils.CreateDivision_nominor(minister, "battleship", 0, ic, battleship, 1, vbGoOver)
	end
end

-- SSmith (21/06/2013)
-- Redundant functions
-- Only build 5 Mountaineers!
--function P.Build_Mountain( ic, minister, bergsjaeger_brigade, vbGoOver )
--	-- Replace Mountaineers wiht Leg Infantry, if we already have enough.
--	local deployedUnits = minister:GetOwnerAI():GetDeployedSubUnitCounts()
--	local producedUnits = minister:GetOwnerAI():GetProductionSubUnitCounts()
--	if deployedUnits:GetAt( CSubUnitDataBase.GetSubUnit("bergsjaeger_brigade"):GetIndex()) + producedUnits:GetAt( CSubUnitDataBase.GetSubUnit("bergsjaeger_brigade"):GetIndex()) < 15 then
--		return Utils.CreateDivision_nominor( minister, "bergsjaeger_brigade", 0, ic, bergsjaeger_brigade, 3, vbGoOver )
--	else
--		return Utils.CreateDivision( minister, "infantry_brigade", 0, ic, bergsjaeger_brigade, 3, Utils.BuildLegUnitArray( minister:GetCountry()), 1, vbGoOver )
--	end
--end

-- Only build 5 Marines!
--function P.Build_Marine( ic, minister, marine_brigade, vbGoOver )
--	-- Replace Marines wiht Leg Infantry, if we already have enough.
--	local deployedUnits = minister:GetOwnerAI():GetDeployedSubUnitCounts()
--	local producedUnits = minister:GetOwnerAI():GetProductionSubUnitCounts()
--	if deployedUnits:GetAt( CSubUnitDataBase.GetSubUnit("marine_brigade"):GetIndex()) + producedUnits:GetAt( CSubUnitDataBase.GetSubUnit("marine_brigade"):GetIndex()) < 15 then
--		return Utils.CreateDivision_nominor( minister, "marine_brigade", 0, ic, marine_brigade, 3, vbGoOver )
--	else
--		return Utils.CreateDivision( minister, "infantry_brigade", 0, ic, marine_brigade, 3, Utils.BuildLegUnitArray( minister:GetCountry()), 1, vbGoOver )
--	end
--end

-- Only build 5 Paratroopers!
--function P.Build_Paratrooper( ic, minister, paratrooper_brigade, vbGoOver )
--	-- Replace Paratroopers wiht Leg Infantry, if we already have enough.
--	local deployedUnits = minister:GetOwnerAI():GetDeployedSubUnitCounts()
--	local producedUnits = minister:GetOwnerAI():GetProductionSubUnitCounts()
--	if deployedUnits:GetAt( CSubUnitDataBase.GetSubUnit("paratrooper_brigade"):GetIndex()) + producedUnits:GetAt( CSubUnitDataBase.GetSubUnit("paratrooper_brigade"):GetIndex()) < 15 then
--		return Utils.CreateDivision_nominor( minister, "paratrooper_brigade", 0, ic, paratrooper_brigade, 3, vbGoOver )
--	else
--		return Utils.CreateDivision( minister, "infantry_brigade", 0, ic, paratrooper_brigade, 3, Utils.BuildLegUnitArray( minister:GetCountry()), 1, vbGoOver )
--	end
--end

-- Build lots of factories!
function P.Build_Industry( ic, minister, vbGoOver )

	-- Build five factories at a time!
	local ai = minister:GetOwnerAI()
	local ministerCountry = minister:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	local industry = CBuildingDataBase.GetBuilding("industry" )
	local industryCost = ministerCountry:GetBuildCost( industry ):Get()
	local laCorePrv = {}
	local loTechStatus = ministerCountry:GetTechnologyStatus()
	
	laCorePrv = CoreProvincesLoop( ministerCountry, loTechStatus, 1, 1 )
	
	local maxIndustry = 5
	
	-- Don't build too many factories at once!
	local nTotalFactoryBuilds = 0
	for provinceID in ministerCountry:GetCoreProvinces() do
		nTotalFactoryBuilds = nTotalFactoryBuilds + CCurrentGameState.GetProvince( provinceID ):GetCurrentConstructionLevel( industry )
	end
	
	while nTotalFactoryBuilds < maxIndustry do
		if ( ic - industryCost ) >= 0 or vbGoOver then
			if table.getn( laCorePrv[6]) > 0 then
				local constructCommand = CConstructBuildingCommand( ministerTag, industry, laCorePrv[6][math.random( table.getn( laCorePrv[6]))], 1 )

				if constructCommand:IsValid() then
					ai:Post( constructCommand )
					ic = ic - industryCost -- Upodate IC total	
				end
			end
		end
		nTotalFactoryBuilds = nTotalFactoryBuilds + 1
	end
	return ic
end
		
-- Have Germany Fortify the French Line
function P.Build_Fort( ic, minister, vbGoOver )
	-- Only build the forts until 1940

	-- SSmith (12/05/2013)
	-- We will build to level 2 and continue through 1939
	-- Corrected province ID for Saarlouis (was Cattenom!)

	if minister:GetOwnerAI():GetCurrentDate():GetYear() < 1940 then
		ic = Support.Build_Fort( ic, minister, 3084, 2, vbGoOver ) -- Lörrach
		ic = Support.Build_Fort( ic, minister, 3016, 2, vbGoOver ) -- Freiburg
		ic = Support.Build_Fort( ic, minister, 2948, 2, vbGoOver ) -- Offenburg
		ic = Support.Build_Fort( ic, minister, 2882, 2, vbGoOver ) -- Baden Baden
		ic = Support.Build_Fort( ic, minister, 2751, 2, vbGoOver ) -- Karlsruhe
		ic = Support.Build_Fort( ic, minister, 2685, 2, vbGoOver ) -- Landau	
		ic = Support.Build_Fort( ic, minister, 2619, 2, vbGoOver ) -- Pirmasens
		ic = Support.Build_Fort( ic, minister, 2553, 2, vbGoOver ) -- Saarbrücken
		ic = Support.Build_Fort( ic, minister, 2490, 2, vbGoOver ) -- Saarlouis
	end
	
	return ic
end

function P.DontBuildBuilding(minister, building)

	-- SSmith (12/05/2013)
	-- Focus most construction on industry or the western defences before the war
	-- Don't build rocket or nuclear facilities (this might be reconsidered later)

	if tostring(building:GetName()) == "Nuclear Research Lab" or tostring(building:GetName()) == "Rocket Test Site" then
		return true
	elseif minister:GetOwnerAI():GetCurrentDate():GetYear() < 1940 then
		if math.random(0,100) < 65
		and tostring(building:GetName()) ~= "Land Fort" and tostring(building:GetName()) ~= "Industrial Capacity" then
			return true
		else
			return false
		end
	else
		if tostring(building:GetName()) == "Land Fort" then	-- We don't need them any longer
			return true
		else
			return false
		end
	end
end

-- END OF PRODUTION OVERIDES
-- #######################################

-- #######################################
-- Intelligence Hooks

function P.Home_Spies( ministerCountry)
	-- Germany must always stop foreign spies to avoid early war
	if ministerCountry:IsAtWar() then
		return nil
	else
		return "CounterEspionage"
	end
end

function P.SpyPriority(ministerTag, ministerCountry, TargetCountry, TargetCountryTag)

	if ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( ministerCountry ) ) 
	or ( not Utils.ASSERT( TargetCountry ) )
	or ( not Utils.ASSERT( TargetCountryTag ) )
	then
		return nil
	end

	local cRelation = ministerCountry:GetRelation(TargetCountryTag)

	-- We want the Anshluss.
	if tostring(TargetCountryTag) == "AUS" then
		return 3
	
	-- We want a good result in Munich
	elseif tostring(TargetCountryTag) == "CZE" then
		return 3

	-- Wa want these countries in our faction
	elseif (tostring(TargetCountryTag) == "ROM" or tostring(TargetCountryTag) == "HUN" or tostring(TargetCountryTag) == "SPA"
	or tostring(TargetCountryTag) == "BUL" or tostring(TargetCountryTag) == "ITA") and not TargetCountry:HasFaction() then
		return 2
	elseif (tostring(TargetCountryTag) == "YUG" or tostring(TargetCountryTag) == "FIN") and not TargetCountry:HasFaction() then
		return 1

	-- We want them to go down as quickly as possible (If we are at war, that is) otherwise raise threat prior to war.
	elseif tostring(TargetCountryTag) == "SOV" then
		if cRelation:HasWar() then
			return 3
		else
			return 1 
		end
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
	
	local cRelation = ministerCountry:GetRelation(TargetCountryTag)
	local CountryScriptMission = nil
	
	-- We want the Anshluss.
	if tostring(TargetCountryTag) == "AUS" then
		CountryScriptMission = "BoostOurParty"
	
	-- We want a good result in Munich
	elseif tostring(TargetCountryTag) == "CZE" then
		CountryScriptMission = "BoostOurParty"

	-- We want them to go down as quickly as possible (If we are at war, that is) otherwise lets keep them weak.
	elseif tostring(TargetCountryTag) == "SOV" and cRelation:HasWar() then
		CountryScriptMission = "LowerNationalUnity"
	end
	
	return CountryScriptMission	
end

-- End of Intelligence Hooks
-- #######################################


-- #######################################
-- Diplomacy Hooks
-- These all must return a numeric score (100 being 100% chance of success )

function P.DiploScore_InfluenceNation( score, ai, actor, recipient, observer )
	local lsRepTag = tostring( recipient )
	
	if lsRepTag == "AUS" or lsRepTag == "CZE" or lsRepTag == "SCH"
	or lsRepTag == "NOR" or lsRepTag == "DEN"
	or lsRepTag == "HOL" or lsRepTag == "BEL"
	or lsRepTag == "POL" or lsRepTag == "LUX"
	then
		score = 0 								-- we get or fight them anyway
	elseif lsRepTag == "HUN" or lsRepTag == "ROM" or lsRepTag == "BUL"
	or lsRepTag == "ITA" or lsRepTag == "JAP" or lsRepTag == "SPA"
	then
		score = score + 70
	elseif lsRepTag == "FIN" then
		score = score + 10
	elseif lsRepTag == "AST" or lsRepTag == "CAN" or lsRepTag == "SAF" or lsRepTag == "NZL" then
		-- Commonwealth
		score = 0
	end

	return score
end

function P.DiploScore_OfferTrade( score, ai, actor, recipient, observer, voTradedFrom, voTradedTo )
	local lsActorTag = tostring( actor )
	
	if lsActorTag == "NOR"
	and CCurrentGameState.GetCurrentDate():GetYear() < 1939
	and actor:GetCountry():GetRelation( recipient ):GetValue():Get() < 75
	then
		-- At the start, we want good enough relations with Norway so they give access to Narwik.
		score = score + 100
	elseif lsActorTag == "SOV" or lsActorTag == "SWE" or lsActorTag == "ITA"
	or lsActorTag == "JAP" or lsActorTag == "USA" or lsActorTag == "SCH"
	or lsActorTag == "BEL" or lsActorTag == "HOL" or lsActorTag == "SPA"
	then
		score = score + 25
	end
	
	return score
end

function P.DiploScore_InviteToFaction( score, ai, actor, recipient, observer )

	local recipientTagString = tostring( recipient )
	local actorIdeologyGroup = actor:GetCountry():GetRulingIdeology():GetGroup()
	local recipientIdeologyGroup = recipient:GetCountry():GetRulingIdeology():GetGroup()

	-- SSmith (29/09/2013)
	-- Fixed the check for Japan defeating China (and vice versa)

	-- SSmith (12/11/2013)
	-- Our preferred partner is China unless Manchukuo recognised
	-- Check that our partner is in good shape
	-- If Japan or China is defeated then accept the other

	if recipientTagString == "AUS" then				-- we got better plans for you...
		return 0
	elseif recipientTagString == "CHI" then 			-- Only accept China if they are stronger than Japan!
		local otherTag = CCountryDataBase.GetTag('JAP')
		local manTag = CCountryDataBase.GetTag('MAN')
		local njgTag = CCountryDataBase.GetTag('NJG')
		if Support.IsDefeated(recipient, otherTag) then		-- If Japan is defeated or otherwise no longer a threat to China then OK!
			return 100
		elseif actor:GetCountry():GetFlags():IsFlagSet("manchukuo_recognized") then
			return 0					-- We recognised Manchukuo so reject China!
		elseif recipient:GetCountry():GetSurrenderLevel():Get() < 0.01 and Support.IsDefeated(recipient, njgTag)
		and (Support.IsDefeated(recipient, manTag) or manTag:GetCountry():GetSurrenderLevel():Get() > 0.25
		    or not actor:GetCountry():GetRelation(manTag):HasWar()) then
			return 100					-- China hasn't lost ground and is beating Manchukuo!
		else
			return 0
		end
	elseif recipientTagString == "JAP" then 			-- Only accept Japan if they are stronger than China!
		local otherTag = CCountryDataBase.GetTag('CHI')
		local manTag = CCountryDataBase.GetTag('MAN')
		local njgTag = CCountryDataBase.GetTag('NJG')
		if Support.IsDefeated(recipient, otherTag) then		-- If China is defeated or otherwise no longer a threat to Japan then OK!
			return 100
		elseif not actor:GetCountry():GetFlags():IsFlagSet("manchukuo_recognized") then
			return 0					-- We haven't recognised Manchukuo so reject Japan!
		elseif recipient:GetCountry():GetSurrenderLevel():Get() < 0.01
		and (otherTag:GetCountry():GetSurrenderLevel():Get() > 0.25 or not Support.IsDefeated(otherTag, njgTag)) then
			return 100					-- Japan hasn't lost ground and is beating China!
		else
			return 0
		end
	elseif recipientTagString == "CGX" or recipientTagString == "CSX"	-- Don't invite the Chinese Warlords or Tibet!
	or recipientTagString == "CXB" or recipientTagString == "CYN"
	or recipientTagString == "TIB" or recipientTagString == "SIK"
	then
		return 0
	elseif recipientTagString == "ROM" or recipientTagString == "HUN"	-- If Hungary and Romania are fighting eachother, leave them alone.
	then
		if CCountryDataBase.GetTag('HUN'):GetCountry():GetRelation( CCountryDataBase.GetTag('ROM')):HasWar() then
			return 0
		end
	elseif actorIdeologyGroup == recipientIdeologyGroup then
		score = score + 50
		return score
	end
	
	return score
end

function P.DiploScore_Alliance( score, ai, actor, recipient, observer, action )
	local country = observer:GetCountry()
	local strategy = country:GetStrategy()
	if tostring( recipient ) == "GER" then		-- We are being offered an alliance!
		if tostring( actor ) == "FIN"
		and
		(
			country:GetRelation( CCountryDataBase.GetTag('SOV')):HasWar()		-- If we are at war with the USSR,
			or
			strategy:IsPreparingWarWith( CCountryDataBase.GetTag('SOV'))			-- or preparing for the war,
		)
		then								 									-- they might prove usefull!
			return 100
		else
			return 0							-- We usually don't want simple allies.
		end
	elseif tostring( recipient ) == "FIN"
	and
	(
		country:GetRelation( CCountryDataBase.GetTag('SOV')):HasWar()		-- If we are at war with the USSR,
		or
		strategy:IsPreparingWarWith( CCountryDataBase.GetTag('SOV'))			-- or preparing for the war,
	)
	then								 									-- they might prove usefull!
		return 100
	end
	return score
end

--##########################
-- Foreign Minister Hooks

function P.ForeignMinister_EvaluateDecision( score, agent, decision, scope )
	local ministerCountry = agent:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	local lsDecision = tostring( decision:GetKey())
	local liYear = CCurrentGameState.GetCurrentDate():GetYear()
	local liMonth = CCurrentGameState.GetCurrentDate():GetMonthOfYear()
	local liDay = CCurrentGameState.GetCurrentDate():GetDayOfMonth()
	local strategy = ministerCountry:GetStrategy()
	
	local yugTag = CCountryDataBase.GetTag('YUG')
	local ausTag = CCountryDataBase.GetTag('AUS')
	local polTag = CCountryDataBase.GetTag('POL')
	local czeTag = CCountryDataBase.GetTag('CZE')
	local sovTag = CCountryDataBase.GetTag('SOV')
	local fraTag = CCountryDataBase.GetTag('FRA')
	local denTag = CCountryDataBase.GetTag('DEN')
	local hunTag = CCountryDataBase.GetTag('HUN')

	-- SSmith (26/08/2013)
	-- Add random chances to make decisions more realistic

	if lsDecision == "molotov_ribbentrop_pact" then

		-- SSmith (26/04/2013)
		-- The MRP check was bugged because it didn't handle every contingency
		-- This meant it generally fired at the beginning of July 1939!
		-- I have re-worked this so that there is a chance that Hitler will strike early

		if CCurrentGameState.IsGlobalFlagSet(CString("SovietsFirst")) then
			return 0
		elseif liYear > 1939 or liMonth > 7 then

			-- SSmith (30/05/2013)
			-- Make it more likely to get MRP before we choose Danzig!

			-- September 1939 or even later
			if math.mod( CCurrentGameState.GetAIRand(), 3 ) == 1 then
				return 100
			else
				return 0
			end
		elseif liMonth == 7 and liDay > 20 then
			-- Late August 1939 (the historical case)
			if math.mod( CCurrentGameState.GetAIRand(), 7 ) == 1 then
				return 100
			else
				return 0
			end
		elseif liMonth < 6 then
			-- June (a modest chance for Germany to go early)
			if math.mod( CCurrentGameState.GetAIRand(), 135 ) == 1 then
				return 100
			else
				return 0
			end
		else
			-- July or early August (a chance to go sometime in between)
			if math.mod( CCurrentGameState.GetAIRand(), 275 ) == 1 then
				return 100
			else
				return 0
			end
		end
		
	elseif lsDecision == "helping_italy_in_greece" or lsDecision == "intervene_in_yugoslavia" then		-- Balkan War
		if math.mod( CCurrentGameState.GetAIRand(), 10) == 1 then
			return Support.PrepareForWarDecision( ministerTag, yugTag, decision, 5.0 )
		else
			return 0
		end

	elseif lsDecision == "danzig_or_war" then

		-- SSmith (26/04/2013)
		-- I'm adding a little random factor here for the sake of realism

		if liYear >= 1939 then
			if liMonth >= 8 or ministerCountry:GetRelation( sovTag ):HasNap() then
				if math.mod( CCurrentGameState.GetAIRand(), 7 ) == 1 then
					return Support.PrepareForWarDecision( ministerTag, polTag, decision, 5.0 )
				end
			end
		end		
		return 0
		
	elseif lsDecision == "anschluss_of_austria_intrigue"
	then											-- Anschluss by internal pressure ( a human player may still decide to have war )
		if math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			return Support.PrepareForWarDecision( ministerTag, ausTag, decision, 2.0 )
		else
			return 0
		end
		
	elseif lsDecision == "anschluss_of_austria_force"
	then											-- Anschluss by military threat <- War is more probable.
		if liYear >= 1938 and liMonth >= 3 then
			-- In case of a forced Anschluss, we should always prepare for war!
			if math.mod( CCurrentGameState.GetAIRand(), 20) == 1 then
				return Support.PrepareForWarDecision( ministerTag, ausTag, decision, 5.0 )
			end
		end
		return 0
		
	elseif lsDecision == "the_treaty_of_munich" then
		if math.mod( CCurrentGameState.GetAIRand(), 50) == 1 then
			return Support.PrepareForWarDecision( ministerTag, czeTag, decision, 2.0 )
		else
			score = 0
		end

	elseif lsDecision == "first_vienna_award" then
		if CCurrentGameState.IsGlobalFlagSet(CString("SovietsFirst")) and not Support.IsDefeated(ministerTag, sovTag) then

			-- SSmith (28/11/2013)
			-- If we are going for the Soviets first then we will honour the Munich Treaty

			return 0
		else
			if math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
				return Support.PrepareForWarDecision( ministerTag, czeTag, decision, 2.0 )
			else
				return 0
			end
		end
		
	elseif lsDecision == "operation_barbarossa" then
		if liMonth > 3 and liMonth < 8
		and ( not ( ministerCountry:GetRelation( yugTag ):HasWar() ) or Support.IsDefeated( ministerTag, yugTag ) )
		then
			-- Only do this if we are not at war with Yugoslavia or they are taken care of already
			return Support.PrepareForWarDecision( ministerTag, sovTag, decision, 5.0 )
		end
		return 0

	elseif lsDecision == "deal_with_the_traitors" then
		if math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			if hunTag:GetCountry():GetFlags():IsFlagSet("barbarossa_traitor") then
				return Support.PrepareForWarDecision( ministerTag, hunTag, decision, 1.0 )
			else
				return 100
			end
		else
			return 0
		end
	
	elseif lsDecision == "trade_iron_with_sweden" then				-- We want this immediately!
		return 100
		
	elseif lsDecision == "demand_military_access_in_sweden" then	-- Check for Denmark first!
		if Support.IsDefeated( ministerTag, denTag ) then
			return 100
		else
			return 0
		end
	
	elseif lsDecision == "mobilize_for_war" or lsDecision == "mobilize_soldiers" then
		-- We should Mobilize for War ASAP. We will need all the Manpower we can have!
		if math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			return 100
		else
			return 0
		end

	elseif lsDecision == "reoccupation_of_the_rhineland_hpp" then
		if math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			return 100
		else
			return 0
		end

	elseif lsDecision == "spanish_civil_war_german_intervention" then
		if math.mod( CCurrentGameState.GetAIRand(), 10) == 1 then
			return 100
		else
			return 0
		end

	elseif lsDecision == "propose_the_anti_comintern_pact" then
		if math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			return 100
		else
			return 0
		end

	elseif lsDecision == "claims_on_memel" then
		if math.mod( CCurrentGameState.GetAIRand(), 10) == 1 then
			return 100
		else
			return 0
		end

	elseif lsDecision == "destroying_the_sudeten_line" or lsDecision == "destroying_the_maginot_line" then
		if math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			return 100
		else
			return 0
		end
	elseif lsDecision == "yugoslavian_partisans" then
		if math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			return 100
		else
			return 0
		end
	end
	
	return score
end

function P.CallAlly( minister )
	local ministerCountry = minister:GetCountry()
	local ministerTag = minister:GetCountryTag()
	local ai = minister:GetOwnerAI() 
	
	-- Loop through all wars
	for loDiploStatus in ministerCountry:GetDiplomacy() do
		local loTargetTag = loDiploStatus:GetTarget()
		local lsTargetTag = tostring( loTargetTag )
		
		if loTargetTag:IsValid() and loDiploStatus:HasWar() then
			local loWar = loDiploStatus:GetWar()
			if loWar:IsLimited() then
				local loTargetCountry = loTargetTag:GetCountry()
				
				-- Call in Puppets
				for loPuppetTag in ministerCountry:GetVassals() do	
					if not loWar:IsPartOfWar( loPuppetTag ) then
						P.ExecuteCallAlly( ai, ministerTag, loPuppetTag, loTargetTag )
					end
				end					
				
				-- Call in all potential allies
				for loAllyTag in ministerCountry:GetAllies() do
					local loAllyCountry = loAllyTag:GetCountry()
					
					--Utils.LUA_DEBUGOUT("lsAllyTag: " .. tostring( tostring( loAllyTag )))
					
					-- Check to see if the two are already at war?
					if not( loAllyCountry:GetRelation( loTargetTag ):HasWar()) then
						local lsAllyTag = tostring( loAllyTag )					
						
						-- Puppet check is added cause it means they are someone elses puppet and
						-- they should be called by that country's AI.
						if not loAllyTag:GetCountry():IsSubject()
						then
						
							-- We are desperate so overide all else statements!

							-- SSmith (22/06/2013)
							-- The CalcDesperation method is an unknown quantity
							-- We will use surrender progress instead and really we should always do this if we're losing

							if ministerCountry:GetSurrenderLevel():Get() > 0.05
							and loTargetTag:GetCountry():IsNeighbour( ministerTag )		-- Only call common neighbors,
							and loTargetTag:GetCountry():IsNeighbour( loAllyTag )		-- because others couldn't help anyway.
							then
								-- Call in all allies!
								P.ExecuteCallAlly( ai, ministerTag, loAllyTag, loTargetTag )
								
							-- Call every European neighbours of the Soviets against them!
							elseif lsTargetTag == "SOV"
							and loTargetTag:GetCountry():IsNeighbour( ministerTag )		-- Only call common neighbors,
							and loTargetTag:GetCountry():IsNeighbour( loAllyTag )		-- because others couldn't help much anyway.
							then
								P.ExecuteCallAlly( ai, ministerTag, loAllyTag, loTargetTag )

							-- SSmith (15/11/2013)
							-- We need some additional checks to call Axis allies into Germany's wars

							elseif lsAllyTag == "ITA" then

								-- Call Italy against France, United Kingdom or the Soviets

								if lsTargetTag == "FRA" or lsTargetTag == "ENG" or lsTargetTag == "SOV" then

									-- Only if France is either defeated or losing

									local fraTag = CCountryDataBase.GetTag('FRA')
									if Support.IsDefeated(ministerTag, fraTag)
									or fraTag:GetCountry():GetSurrenderLevel():Get() > 0.15 then
										P.ExecuteCallAlly( ai, ministerTag, loAllyTag, loTargetTag )
									end
								end

							elseif lsAllyTag == "SPA" or lsAllyTag == "POR" then

								-- Call Spain or Portugal against the United Kingdom

								if lsTargetTag == "ENG" then

									-- Only if France and Spain are defeated

									local fraTag = CCountryDataBase.GetTag('FRA')
									local spaTag = CCountryDataBase.GetTag('SPA')
									local sprTag = CCountryDataBase.GetTag('SPR')
									if Support.IsDefeated(ministerTag, fraTag)
									and Support.IsDefeated(ministerTag, spaTag)	-- Shows Spain is Axis, safe for Portugal!
									and Support.IsDefeated(ministerTag, sprTag) then
										P.ExecuteCallAlly( ai, ministerTag, loAllyTag, loTargetTag )
									end
								end
							
							elseif lsAllyTag == "HUN" or lsAllyTag == "ROM" or lsAllyTag == "FIN" or lsAllyTag == "TUR" then

								-- Call Hungary, Romania, Finland and Turkey against the Soviets

								if lsTargetTag == "SOV" then
									P.ExecuteCallAlly( ai, ministerTag, loAllyTag, loTargetTag )
								end

							elseif lsAllyTag == "YUG" or lsAllyTag == "BUL" or lsAllyTag == "GRE" then

								-- Call Yugoslavia, Bulgaria and Greece against the Soviets

								if lsTargetTag == "SOV" then

									-- Check for neighbours in Comintern or losing to the Soviets

									for loNeighbourTag in loAllyTag:GetCountry():GetNeighbours() do
										if tostring(loNeighbourTag:GetCountry():GetFaction():GetTag()) == "comintern"
										or (loTargetCountry:GetRelation(loNeighbourTag):HasWar()
											and (Support.IsDefeated(loTargetTag, loNeighbourTag)
											or loNeighbourTag:GetCountry():GetSurrenderLevel():Get() > 0.25)) then
												P.ExecuteCallAlly( ai, ministerTag, loAllyTag, loTargetTag )
										end
									end

								end
							end

						end
					end
				end
			end
		end
	end
end
function P.ExecuteCallAlly( ai, ministerTag, voAllyTag, voTargetTag )
	local loAction = CCallAllyAction( ministerTag, voAllyTag, voTargetTag )
	loAction:SetValue( true ) -- limited
	if loAction:IsSelectable() and loAction:GetAIAcceptance() > 50 then
		ai:PostAction( loAction )
	end
end

function P.ProposeDeclareWar( minister )
	local ai = minister:GetOwnerAI()
	local ministerCountry = minister:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	local strategy = ministerCountry:GetStrategy()
	local year = ai:GetCurrentDate():GetYear()
	local month = ai:GetCurrentDate():GetMonthOfYear()

	-- SSmith (24/11/2013)
	-- Don't start a war later than September or before April
	-- And check our political situation!

	if ministerCountry:GetRulingIdeology():GetGroup():GetKey():GetString() ~= "fascism"	-- Only if we are in the fascist ideology group!
	or ministerCountry:IsSubject()								-- Not if we've been puppeted!
	or ministerCountry:IsGovernmentInExile()						-- Not if we are in exile!
	or ministerCountry:GetSurrenderLevel():Get() > 0.10					-- Not if we are losing!
	then
		return
	end

	local ausTag = CCountryDataBase.GetTag('AUS')
	local engTag = CCountryDataBase.GetTag('ENG')
	local fraTag = CCountryDataBase.GetTag('FRA')
	local itaTag = CCountryDataBase.GetTag('ITA')
	local polTag = CCountryDataBase.GetTag('POL')
	local sovTag = CCountryDataBase.GetTag('SOV')
	local czeTag = CCountryDataBase.GetTag('CZE')
	local denTag = CCountryDataBase.GetTag('DEN')
	local norTag = CCountryDataBase.GetTag('NOR')
	local sweTag = CCountryDataBase.GetTag('SWE')
	local holTag = CCountryDataBase.GetTag('HOL')
	local belTag = CCountryDataBase.GetTag('BEL')
	local luxTag = CCountryDataBase.GetTag('LUX')
	local yugTag = CCountryDataBase.GetTag('YUG')
	local greTag = CCountryDataBase.GetTag('GRE')
	local hunTag = CCountryDataBase.GetTag('HUN')
	local romTag = CCountryDataBase.GetTag('ROM')
	local sprTag = CCountryDataBase.GetTag('SPR')
	local schTag = CCountryDataBase.GetTag('SCH')
	local usaTag = CCountryDataBase.GetTag('USA')

	-- 1939
	-- Austria

	if year >= 1939
	and not Support.IsDefeated( ministerTag, ausTag )
	and not strategy:IsPreparingWarWith( ausTag )
	and not ministerCountry:GetRelation( ausTag ):HasWar()
	and month > 2 and month < 9
	then
		Support.PrepareForWar( ministerTag, ausTag, 100 )
	end

	-- 1939
	-- Soviet Union first strategy!
	-- But not if we are fighting the UK, France or Italy
	
	if year >= 1939
	and CCurrentGameState.IsGlobalFlagSet(CString("SovietsFirst"))
	and (Support.IsDefeated( ministerTag, engTag ) or not ministerCountry:GetRelation( engTag ):HasWar())
	and (Support.IsDefeated( ministerTag, fraTag ) or not ministerCountry:GetRelation( fraTag ):HasWar())
	and (Support.IsDefeated( ministerTag, itaTag ) or not ministerCountry:GetRelation( itaTag ):HasWar())
	then
		-- Poland needs to be taken first!

		if not Support.IsDefeated( ministerTag, polTag )
		and not strategy:IsPreparingWarWith( polTag )
		and not ministerCountry:GetRelation( polTag ):HasWar()
		and month > 2 and month < 9
		then
			if ministerCountry:GetRelation( polTag ):HasNap() then
				local action = CNapAction( ministerTag, polTag )
				action:SetValue( false )
				if action:IsSelectable() then
					ai:PostAction( action )
				end
			end
			Support.PrepareForWar( ministerTag, polTag, 100 )
		end

		-- Now for the Soviet Union!

		if Support.IsDefeated( ministerTag, polTag )
		and not Support.IsDefeated( ministerTag, sovTag )
		and CCurrentGameState.GetProvince(1409):GetController() == sovTag
		and not strategy:IsPreparingWarWith( sovTag )
		and not ministerCountry:GetRelation( sovTag ):HasWar()
		and month > 3 and month < 8
		then
			if ministerCountry:GetRelation( sovTag ):HasNap() then
				local action = CNapAction( ministerTag, sovTag )
				action:SetValue( false )
				if action:IsSelectable() then
					ai:PostAction( action )
				end
			end
			Support.PrepareForWar( ministerTag, sovTag, 100 )
		end
	end
	
	-- 1940
	-- Czechoslovakia
	-- Not if we're going after the Soviets

	if year >= 1940
	and (Support.IsDefeated( ministerTag, polTag ) or not ministerCountry:GetRelation( polTag ):HasWar())
	and (Support.IsDefeated( ministerTag, sovTag ) or not ministerCountry:GetRelation( sovTag ):HasWar())
	and (Support.IsDefeated( ministerTag, sovTag ) or not CCurrentGameState.IsGlobalFlagSet(CString("SovietsFirst"))
	    or ministerCountry:GetRelation( engTag ):HasWar())
	and not Support.IsDefeated( ministerTag, czeTag )
	and not strategy:IsPreparingWarWith( czeTag )
	and not ministerCountry:GetRelation( czeTag ):HasWar()
	and month > 2 and month < 9
	then
		if ministerCountry:GetRelation( czeTag ):HasNap() then
			local action = CNapAction( ministerTag, czeTag )
			action:SetValue( false )
			if action:IsSelectable() then
				ai:PostAction( action )
			end
		end
		Support.PrepareForWar( ministerTag, czeTag, 100 )
	end

	-- 1940
	-- Poland
	-- If they have our cores or France is defeated

	if year >= 1940
	and (Support.IsDefeated( ministerTag, czeTag ) or not ministerCountry:GetRelation( czeTag ):HasWar())
	and (Support.OwnsAnyCores( ministerTag, polTag ) or Support.IsDefeated( ministerTag, fraTag ))
	and not Support.IsDefeated( ministerTag, polTag )
	and not strategy:IsPreparingWarWith( polTag )
	and not ministerCountry:GetRelation( polTag ):HasWar()
	and month > 2 and month < 9
	then
		if ministerCountry:GetRelation( polTag ):HasNap() then
			local action = CNapAction( ministerTag, polTag )
			action:SetValue( false )
			if action:IsSelectable() then
				ai:PostAction( action )
			end
		end
		Support.PrepareForWar( ministerTag, polTag, 100 )
	end

	-- Denmark
	-- We need to close the Baltic against the British

	if ( ministerCountry:GetRelation( engTag ):HasWar() or ministerCountry:GetRelation( fraTag ):HasWar() )
	and ( not ministerCountry:GetRelation( czeTag ):HasWar() or Support.IsDefeated( ministerTag, czeTag ) )
	and ( not ministerCountry:GetRelation( polTag ):HasWar() or Support.IsDefeated( ministerTag, polTag ) )
	and not Support.IsDefeated( ministerTag, denTag )
	and not strategy:IsPreparingWarWith( denTag )
	and not ministerCountry:GetRelation( denTag ):HasWar()
	and month > 2 and month < 9
	then
		if ministerCountry:GetRelation( denTag ):HasNap() then
			local action = CNapAction( ministerTag, denTag )
			action:SetValue( false )
			if action:IsSelectable() then
				ai:PostAction( action )
			end
		end
		Support.PrepareForWar( ministerTag, denTag, 100 )
	end

	-- Norway
	-- We should do this to protect the Swedish iron trade if the British have mined Norwegian waters
	-- Otherwise we should do it as a precaution once France is defeated
	-- Unless we are fighting the Soviets

	if ministerCountry:GetRelation( engTag ):HasWar()
	and ( CCurrentGameState.IsGlobalFlagSet( CString("norwegian_coast_mined"))
	    or ( (ministerCountry:GetFlags():IsFlagSet("swedish_iron") or Support.IsDefeated( ministerTag, sweTag ))
	        and Support.IsDefeated( ministerTag, fraTag ) ) )
	and (Support.IsDefeated(ministerTag, denTag) or ministerCountry:GetRelation(denTag):HasWar())
	and ( not ministerCountry:GetRelation( sovTag ):HasWar() or Support.IsDefeated( ministerTag, sovTag ) )
	and not Support.IsDefeated( ministerTag, norTag )
	and not strategy:IsPreparingWarWith( norTag )
	and not ministerCountry:GetRelation( norTag ):HasWar()
	and month > 2 and month < 9
	then
		if ministerCountry:GetRelation( norTag ):HasNap() then
			local action = CNapAction( ministerTag, norTag )
			action:SetValue( false )
			if action:IsSelectable() then
				ai:PostAction( action )
			end
		end
		Support.PrepareForWar( ministerTag, norTag, 500 )
	end

	-- Sweden
	-- We should do this if Sweden has refused to cooperate with our Norwegian operation
	-- Otherwise we should secure Swedish iron if they refused to trade
	-- Unless we are fighting the Soviets

	if ministerCountry:GetRelation( engTag ):HasWar()
	and (CCurrentGameState.IsGlobalFlagSet(CString("sweden_declines_access"))
	    or not ministerCountry:GetFlags():IsFlagSet("swedish_iron"))
	and (Support.IsDefeated(ministerTag, denTag) or ministerCountry:GetRelation(denTag):HasWar())
	and ( not ministerCountry:GetRelation( sovTag ):HasWar() or Support.IsDefeated( ministerTag, sovTag ) )
	and not Support.IsDefeated( ministerTag, sweTag )
	and not strategy:IsPreparingWarWith( sweTag )
	and not ministerCountry:GetRelation( sweTag ):HasWar()
	and month > 2 and month < 9
	then
		if ministerCountry:GetRelation( sweTag ):HasNap() then
			local action = CNapAction( ministerTag, sweTag )
			action:SetValue( false )
			if action:IsSelectable() then
				ai:PostAction( action )
			end
		end
		Support.PrepareForWar( ministerTag, sweTag, 200 )
	end

	-- The Low Countries
	-- If we're at war with France or the UK
	-- As long as we're dealing with Denmark and Norway
	-- Not while we're fighting the Czechs, Poles or Italians
	-- Not if we are fighting the Soviets
	-- Go ASAP if an ally is already inside France!

	if (ministerCountry:GetRelation( engTag ):HasWar() or ministerCountry:GetRelation( fraTag ):HasWar())
	and (Support.IsDefeated(ministerTag, denTag) or ministerCountry:GetRelation(denTag):HasWar())
	and not strategy:IsPreparingWarWith( norTag )
	and ( not ministerCountry:GetRelation( czeTag ):HasWar() or Support.IsDefeated( ministerTag, czeTag ) )
	and ( not ministerCountry:GetRelation( polTag ):HasWar() or Support.IsDefeated( ministerTag, polTag ) )
	and ( not ministerCountry:GetRelation( itaTag ):HasWar() or Support.IsDefeated( ministerTag, itaTag )
	    or itaTag:GetCountry():GetSurrenderLevel():Get() > 0.25 )
	and ( not ministerCountry:GetRelation( sovTag ):HasWar() or Support.IsDefeated( ministerTag, sovTag ) )
	and ( (month > 2 and month < 9)
	    or ( ministerCountry:GetRelation( fraTag ):HasWar() and not Support.IsDefeated( ministerTag, fraTag)
		and (CCurrentGameState.GetProvince(3479):GetController() ~= fraTag		-- Bordeaux
		    or CCurrentGameState.GetProvince(3961):GetController() ~= fraTag		-- Toulouse
		    or CCurrentGameState.GetProvince(3687):GetController() ~= fraTag		-- Lyon
		    or CCurrentGameState.GetProvince(4229):GetController() ~= fraTag) ) )	-- Marseille
	then

		-- Netherlands
		if not Support.IsDefeated( ministerTag, holTag )
		and not strategy:IsPreparingWarWith( holTag )
		and not ministerCountry:GetRelation( holTag ):HasWar()
		then
			if ministerCountry:GetRelation( holTag ):HasNap() then
				local action = CNapAction( ministerTag, holTag )
				action:SetValue( false )
				if action:IsSelectable() then
					ai:PostAction( action )
				end
			end
			Support.PrepareForWar( ministerTag, holTag, 100 )
		end

		-- Belgium
		if (Support.IsDefeated( ministerTag, holTag ) or ministerCountry:GetRelation( holTag ):HasWar())
		and not Support.IsDefeated( ministerTag, belTag )
		and not strategy:IsPreparingWarWith( belTag )
		and not ministerCountry:GetRelation( belTag ):HasWar()
		then
			if ministerCountry:GetRelation( belTag ):HasNap() then
				local action = CNapAction( ministerTag, belTag )
				action:SetValue( false )
				if action:IsSelectable() then
					ai:PostAction( action )
				end
			end
			Support.PrepareForWar( ministerTag, belTag, 100 )
		end

		-- Luxembourg
		if (Support.IsDefeated( ministerTag, holTag ) or ministerCountry:GetRelation( holTag ):HasWar())
		and not Support.IsDefeated( ministerTag, luxTag )
		and not strategy:IsPreparingWarWith( luxTag )
		and not ministerCountry:GetRelation( luxTag ):HasWar()
		then
			if ministerCountry:GetRelation( luxTag ):HasNap() then
				local action = CNapAction( ministerTag, luxTag )
				action:SetValue( false )
				if action:IsSelectable() then
					ai:PostAction( action )
				end
			end
			Support.PrepareForWar( ministerTag, luxTag, 100 )
		end
	end

	-- France is beaten so we can deal with targets of opportunity
	-- But not if we're fighting Italy or the Soviets
	-- And only if there's a good reason

	if Support.IsDefeated( ministerTag, fraTag )
	and ( not ministerCountry:GetRelation( itaTag ):HasWar() or Support.IsDefeated( ministerTag, itaTag ) )
	and ( not ministerCountry:GetRelation( sovTag ):HasWar() or Support.IsDefeated( ministerTag, sovTag ) )
	and month > 2 and month < 9
	then
		local ministerIdeologyGroup = ministerCountry:GetRulingIdeology():GetGroup()

		-- Yugoslavia
		-- Only if they are the wrong ideology or we're fighting Greece and they're not
		-- Ignore them if Italy is at war with Greece because we have a decision for that

		if not Support.IsDefeated( ministerTag, yugTag )
		and not strategy:IsPreparingWarWith( yugTag )
		and not ministerCountry:GetRelation( yugTag ):HasWar()
		then
			local yugIdeologyGroup = yugTag:GetCountry():GetRulingIdeology():GetGroup()
			if yugIdeologyGroup == ministerIdeologyGroup
			and (not ministerCountry:GetRelation( greTag ):HasWar() or yugTag:GetCountry():GetRelation( greTag ):HasWar()
			    or itaTag:GetCountry():GetRelation( greTag ):HasWar()) then
				-- Do nothing
			else
				if ministerCountry:GetRelation( yugTag ):HasNap() then
					local action = CNapAction( ministerTag, yugTag )
					action:SetValue( false )
					if action:IsSelectable() then
						ai:PostAction( action )
					end
				end
				Support.PrepareForWar( ministerTag, yugTag, 100 )
			end
		end

		-- Hungary
		-- But only if they are the wrong ideology or we're fighting Romania and they're not

		if not Support.IsDefeated( ministerTag, hunTag )
		and not strategy:IsPreparingWarWith( hunTag )
		and not ministerCountry:GetRelation( hunTag ):HasWar()
		then
			local hunIdeologyGroup = hunTag:GetCountry():GetRulingIdeology():GetGroup()
			if hunIdeologyGroup == ministerIdeologyGroup 
			and (not ministerCountry:GetRelation( romTag ):HasWar() or hunTag:GetCountry():GetRelation( romTag ):HasWar()) then
				-- Do nothing
			else
				if ministerCountry:GetRelation( hunTag ):HasNap() then
					local action = CNapAction( ministerTag, hunTag )
					action:SetValue( false )
					if action:IsSelectable() then
						ai:PostAction( action )
					end
				end
				Support.PrepareForWar( ministerTag, hunTag, 100 )
			end
		end

		-- Republican Spain
		-- Because we have unfinished business!

		if not Support.IsDefeated( ministerTag, sprTag )
		and not strategy:IsPreparingWarWith( sprTag )
		and not ministerCountry:GetRelation( sprTag ):HasWar()
		then
			local sprIdeologyGroup = sprTag:GetCountry():GetRulingIdeology():GetGroup()
			if sprIdeologyGroup == ministerIdeologyGroup then
				-- Do nothing
			else
				if ministerCountry:GetRelation( sprTag ):HasNap() then
					local action = CNapAction( ministerTag, sprTag )
					action:SetValue( false )
					if action:IsSelectable() then
						ai:PostAction( action )
					end
				end
				Support.PrepareForWar( ministerTag, sprTag, 100 )
			end
		end

		-- Switzerland
		-- Because we want to unify the German nation!
		-- We will check an AI flag to do this before the Soviets are down!

		if (CCurrentGameState.GetProvince(1409):GetController() == ministerTag 
		    or ministerCountry:GetVariables():GetVariable(CString("ai_tannenbaum")):Get() > 1.5)
		and not Support.IsDefeated( ministerTag, schTag )
		and not strategy:IsPreparingWarWith( schTag )
		and not ministerCountry:GetRelation( schTag ):HasWar()
		then
			if ministerCountry:GetRelation( schTag ):HasNap() then
				local action = CNapAction( ministerTag, schTag )
				action:SetValue( false )
				if action:IsSelectable() then
					ai:PostAction( action )
				end
			end
			Support.PrepareForWar( ministerTag, schTag, 100 )
		end
	end

	-- The Soviet Union should be handled via decision
	-- However let's prepare in 1942 if we've beaten Poland and France
	-- Unless we're fighting Italy or Spain
	
	if year >= 1942
	and Support.IsDefeated( ministerTag, polTag )
	and (Support.IsDefeated( ministerTag, fraTag ) or not ministerCountry:GetRelation( fraTag ):HasWar())
	and (Support.IsDefeated( ministerTag, itaTag ) or not ministerCountry:GetRelation( itaTag ):HasWar())
	and (Support.IsDefeated( ministerTag, sprTag ) or not ministerCountry:GetRelation( sprTag ):HasWar())
	and not Support.IsDefeated( ministerTag, sovTag )
	and CCurrentGameState.GetProvince(1409):GetController() == sovTag
	and not strategy:IsPreparingWarWith( sovTag )
	and not ministerCountry:GetRelation( sovTag ):HasWar()
	and month > 3 and month < 8
	then
		if ministerCountry:GetRelation( sovTag ):HasNap() then
			local action = CNapAction( ministerTag, sovTag )
			action:SetValue( false )
			if action:IsSelectable() then
				ai:PostAction( action )
			end
		end
		Support.PrepareForWar( ministerTag, sovTag, 100 )
	end


	-- Germany should not stop at this point though. If they are successful enough,
	-- they should practically go for World Domination along with the rest of the Axis!
	if year >= 1940 and Support.IsDefeated( ministerTag, sovTag )
	and Support.IsDefeated( ministerTag, engTag ) and Support.IsDefeated( ministerTag, fraTag )
	then	-- The surrounding majors we had to fight are done. Let's take care of the rest!
		
		-- First of all, Italy. They are supposed to be our buddy, but who knows...
		if not Support.IsDefeated( ministerTag, itaTag ) then
			if not ministerCountry:GetRelation( itaTag ):HasWar()
			and not strategy:IsPreparingWarWith( itaTag )
			then
				Support.PrepareForWar( ministerTag, itaTag, 100 )
			else
				-- One target at a time is enough.
				return
			end
		end
		
		-- Then go through the rest of our neighbours!
		for neighborTag in ministerCountry:GetNeighbours() do
			if not Support.IsDefeated( ministerTag, neighborTag ) then
				if not ministerCountry:GetRelation( neighborTag ):HasWar()
				and not strategy:IsPreparingWarWith( neighborTag )
				then
					Support.PrepareForWar( ministerTag, neighborTag, 50 )
				else
					-- One target at a time is enough.
					return
				end
			end
		end
		
		-- We don't have any neutral neighbours. How about the US? ;)
		if not Support.IsDefeated( ministerTag, usaTag ) then
			if not ministerCountry:GetRelation( usaTag ):HasWar()
			and not strategy:IsPreparingWarWith( usaTag )
			then
				Support.PrepareForWar( ministerTag, usaTag, 100 )
			else
				-- One target at a time is enough.
				return
			end
		end
		
		-- And now the rest of the world!
		for targetCountry in CCurrentGameState.GetCountries() do
			local targetTag = targetCountry:GetCountryTag()
			if not Support.IsDefeated( ministerTag, targetTag ) then
				if not ministerCountry:GetRelation( targetTag ):HasWar()
				and not strategy:IsPreparingWarWith( targetTag )
				then
					Support.PrepareForWar( ministerTag, targetTag, 100 )
				else
					-- One target at a time is enough.
					return
				end
			end
		end
		
	end
	
end


--##########################
-- Politics Minister Hooks

function P.HandlePuppets(minister)

	-- SSmith (22/11/2013)
	-- Add exceptions for other Germany tags and countries we want to annex

	local laCountryExceptions = { "DDR", "DFR", "AUS", "CZE", "SCH" }
	return laCountryExceptions
end

-- Create very highly trained troops
function P.CallLaw_training_laws( minister, voCurrentLaw )
	local _SPECIALIST_TRAINING_ = 31
	return CLawDataBase.GetLaw( _SPECIALIST_TRAINING_ )
end

return AI_GER
