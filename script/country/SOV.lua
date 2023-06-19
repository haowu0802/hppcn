-----------------------------------------------------------
-- Soviet Union
-----------------------------------------------------------

local P = {}
AI_SOV = P

-- Tech weights
--   1.0 = 100% the total needs to equal 1.0
function P.TechWeights(minister)
	local laTechWeights

	-- SSmith (23/07/2013)
	-- Changed to new format
	-- Early shift from air to naval techs

	local laTechWeights

	if CCurrentGameState.GetCurrentDate():GetYear() < 1938 then

		laTechWeights = {
			0.30, -- Land
			0.25, -- Air
			0.25, -- Naval
			0.20}; -- Other

	elseif minister:GetCountry():GetTotalLeadership():Get() < 15 then

		laTechWeights = {
			0.50, -- Land
			0.30, -- Air
			0.05, -- Naval
			0.15}; -- Other

	elseif minister:GetCountry():GetTotalLeadership():Get() < 30 then

		laTechWeights = {
			0.40, -- Land
			0.35, -- Air
			0.10, -- Naval
			0.15}; -- Other
	else
		laTechWeights = {
			0.35, -- Land
			0.30, -- Air
			0.20, -- Naval
			0.15}; -- Other
	end
	
	return laTechWeights
end

function P.Get_TechParams(minister)

	-- SSmith (21/08/2013)
	-- This is a new function to return a table of country-specific research config

	local laTechParams = {

		engineer_bridging_equipment	= { Leadership = 12, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		engineer_assault_equipment  	= { Leadership = 12, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		weapon_salt_water_proofing 	= { Leadership = 12, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
		artic_warfare_equipment 	= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		amphibious_warfare_equipment 	= { Leadership = 12, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
		mechanised_infantry 		= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
		anti_tank 			= { Leadership =  7, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		rocket_artillery_activation 	= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		rocket_artillery 		= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		tank_brigade 			= { Leadership = 12, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "MediumTank" },
		tank_gun 			= { Leadership = 12, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "MediumTank" },
		tank_armour 			= { Leadership = 12, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "MediumTank" },
		tank_engine 			= { Leadership = 12, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "MediumTank" },
		tank_reliability 		= { Leadership = 12, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "MediumTank" },
		heavy_tank_brigade 		= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "HeavyTank" },
		heavy_tank_gun 			= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "HeavyTank" },
		heavy_tank_armour 		= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "HeavyTank" },
		sloped_armor 			= { Leadership = 12, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
		self_propelled_support_brigade_tech = { Leadership = 30, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		sp_artillery_activation 	= { Leadership = 30, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		sp_artillery 			= { Leadership = 30, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		sp_rocket_artillery_activation 	= { Leadership = 30, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		sp_rocket_artillery 		= { Leadership = 30, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		tank_destroyer_activation 	= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		tank_destroyer 			= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
		sp_anti_air_activation 		= { Leadership = 30, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		sp_anti_air 			= { Leadership = 30, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		destroyer_technology 		= { Leadership =  7, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.35, EndYear = 1999, Attribute = "ShipBuilding" },
		destroyer_engine 		= { Leadership =  7, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		multi_purpose_guns 		= { Leadership =  7, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		smallwarship_asw 		= { Leadership = 12, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		heavycruiser_technology 	= { Leadership = 12, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.35, EndYear = 1999, Attribute = "ShipBuilding" },
		heavycruiser_armament 		= { Leadership = 12, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		lightcruiser_technology 	= { Leadership =  7, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.35, EndYear = 1999, Attribute = "ShipBuilding" },
		lightcruiser_armament 		= { Leadership =  7, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		cruiser_engine 			= { Leadership =  7, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		cruiser_armor 			= { Leadership =  7, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		submarine_technology 		= { Leadership =  7, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "ShipBuilding" },
		submarine_engine 		= { Leadership =  7, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		torpedoes 			= { Leadership =  7, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		battleship_technology 		= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.35, EndYear = 1942, Attribute = "" },
		capital_ship_armor 		= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1942, Attribute = "" },
		capital_ship_engine 		= { Leadership = 18, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1942, Attribute = "" },
		capitalship_armament 		= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1942, Attribute = "" },
		fast_battleship 		= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1942, Attribute = "" },

		escort_fighter_development 	= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		escort_fighter_armament		= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		escort_fighter_drop_tanks 	= { Leadership = 18, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		supply_production 		= { Leadership =  5, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		supply_transportation 		= { Leadership =  3, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		supply_organisation 		= { Leadership =  3, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		tank_crew_training 		= { Leadership = 10, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		special_forces_training 	= { Leadership =  7, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		capital_ship_crew_training 	= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		night_equipment_training 	= { Leadership = 12, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		battleship_taskforce_doctrine 	= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		battleline_cruiser_doctrine 	= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		asw_tactics 			= { Leadership = 10, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

		cas_pilot_training 		= { Leadership =  7, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		cas_groundcrew_training 	= { Leadership =  7, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		night_mission_training 		= { Leadership = 12, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
		airborne_assault_tactics 	= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" }
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

	-- The Soviet Union shouldn't invest in officers early to reflect the purges
	-- The Soviets will need to get their act together later though

	local officer_ratio = ministerCountry:GetOfficerRatio():Get()
	local gerTag = CCountryDataBase.GetTag('GER')
	local year = CCurrentGameState.GetCurrentDate():GetYear()
	
	if ministerCountry:GetRelation(gerTag):HasWar()					-- We are already at war with Germany!
	or (year >= 1940 and (not ministerCountry:GetRelation(gerTag):HasNap()))	-- We will probably go to war soon!
	then
		if officer_ratio < 0.75 then		-- We can't build units! We need more Officers!
			LEADERSHIP_NCO = 0.75
			LEADERSHIP_ESPIONAGE = 0.00	-- Espionage can wait
			LEADERSHIP_DIPLOMACY = 0.00	-- Diplomacy can wait
		elseif officer_ratio < 1.00 then	-- We need much more than that!
			LEADERSHIP_NCO = 0.50
			LEADERSHIP_ESPIONAGE = 0.00	-- Espionage can wait.
			LEADERSHIP_DIPLOMACY = 0.00	-- Diplomacy can wait.
		elseif officer_ratio < 1.25 then	-- Reached 100%, but we could still use some more!
			LEADERSHIP_NCO = 0.25
		elseif officer_ratio < 1.50 then	-- We are still not equal to the Germans!
			LEADERSHIP_NCO = 0.05
		else
			LEADERSHIP_NCO = 0.00
		end
	else
		if officer_ratio < 0.75 then		-- We can't build units! We need more Officers!
			LEADERSHIP_NCO = 0.25
		elseif officer_ratio < 1.00 then	-- We are still not competent.
			LEADERSHIP_NCO = 0.10
		elseif officer_ratio < 1.25 then
			LEADERSHIP_NCO = 0.05
		else
			LEADERSHIP_NCO = 0.0
		end
	end

	-- Just in case we really need some diplomatic points...	
	if ministerCountry:GetDiplomaticInfluence():Get() < 5 and LEADERSHIP_DIPLOMACY < 0.05
		then LEADERSHIP_DIPLOMACY = 0.05
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
function P.ProductionWeights(minister)
	local laArray
	local ministerCountry = minister:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	local gerTag = CCountryDataBase.GetTag('GER')
	local engTag = CCountryDataBase.GetTag('ENG')
	local usaTag = CCountryDataBase.GetTag('USA')

	-- SSmith (20/06/2013)
	-- We should also check if we are at war with the Allies
	-- We also need to decide how to react to the Bitter Peace
	-- I've removed the miscellaneous "at war" condition because I don't want early skirmishes to stop the IC build!
	-- The CalcDesperation method is an unknown quantity so we will use surrender progress

	if ministerCountry:GetRelation(gerTag):HasWar() then	-- War with Germany...
		-- Desperation check and if so increase land production
		if ministerCountry:GetSurrenderLevel():Get() > 0.25 then	-- ...and we are losing badly!
			laArray = {
				0.85, 	-- Land
				0.15, 	-- Air
				0.00, 	-- Sea
				0.00}; 	-- Other
		else						-- ...and we are doing okay.
			laArray = {
				0.70, 	-- Land
				0.20, 	-- Air
				0.05, 	-- Sea
				0.05}; 	-- Other
		end
	elseif ministerCountry:GetRelation(engTag):HasWar()
	or ministerCountry:GetRelation(usaTag):HasWar() then	-- War with Britain or the USA...
		laArray = {
			0.60, 	-- Land
			0.20, 	-- Air
			0.15, 	-- Sea
			0.05}; 	-- Other
	elseif Support.IsDefeated(ministerTag, gerTag) then	-- Germany is defeated!
		laArray = {
			0.45, 	-- Land
			0.20, 	-- Air
			0.25, 	-- Sea
			0.10}; 	-- Other
	elseif Support.IsDefeated(gerTag, ministerTag) then	-- We are defeated by Germany!
		laArray = {
			0.70, 	-- Land
			0.15, 	-- Air
			0.10, 	-- Sea
			0.05}; 	-- Other
	elseif minister:GetOwnerAI():GetCurrentDate():GetYear() > 1939 then
		laArray = {
			0.55, 	-- Land				-- The year is at least 1940 so get ready for war!
			0.25, 	-- Air
			0.10, 	-- Sea
			0.10}; 	-- Other
	elseif minister:GetOwnerAI():GetCurrentDate():GetYear() > 1938
	or ministerCountry:IsAtWar() then
		laArray = {					-- The year is at least 1939 or we're at war (perhaps with Japan)
			0.45, 	-- Land				-- Start building some units but don't give up on IC just yet!
			0.25, 	-- Air
			0.10, 	-- Sea
			0.20}; 	-- Other
	elseif minister:GetOwnerAI():GetCurrentDate():GetYear() > 1937 then
		laArray = {					-- The year is at least 1938 so start switching to military production
			0.25, 	-- Land
			0.15, 	-- Air
			0.05, 	-- Sea
			0.55}; 	-- Other
	else							-- In 1936-37 we should stick to the Five Year Plan!
		laArray = {					-- We're going to throw everything at IC now!
			0.00, 	-- Land
			0.00, 	-- Air
			0.00, 	-- Sea
			1.00}; 	-- Other
	end
	
	return laArray
end
-- Land ratio distribution
function P.LandRatio(minister)
	local laArray
	
	-- SSmith (20/06/2013)
	-- I have increased the number of sections to get a better balance of forces
	-- The aim is to get enough armour and mechanized units but not to go over the top
	-- We are going to set the armour and mobile targets higher from 1939

	if minister:GetOwnerAI():GetCurrentDate():GetYear() > 1942 then
		laArray = {
			1, -- Garrison
			13, -- Infantry
			4, -- Motorized
			3, -- Mechanized
			3, -- Armor
			0, -- Militia
			1}; -- Cavalry
	elseif minister:GetOwnerAI():GetCurrentDate():GetYear() > 1941 then
		laArray = {
			1, -- Garrison
			13, -- Infantry
			4, -- Motorized
			2, -- Mechanized
			3, -- Armor
			0, -- Militia
			2}; -- Cavalry
	elseif minister:GetOwnerAI():GetCurrentDate():GetYear() > 1939 then
		laArray = {
			1, -- Garrison
			14, -- Infantry
			4, -- Motorized
			1, -- Mechanized
			4, -- Armor
			0, -- Militia
			1}; -- Cavalry
	else
		laArray = {
			2, -- Garrison
			13, -- Infantry
			4, -- Motorized
			0, -- Mechanized
			4, -- Armor
			0, -- Militia
			2}; -- Cavalry
	end

	return laArray
end
-- Special Forces ratio distribution
function P.SpecialForcesRatio(minister)

	-- SSmith (08/06/2013)
	-- This will now return separate ratios for mountain, marine and airborne brigades
	-- The USSR should have a lot of airborne troops

	local laArray = {
		25, -- Mountain
		50, -- Marine
		25}; -- Airborne
	
	return laArray
end
-- Air ratio distribution
function P.AirRatio(minister)
	local ministerTag = minister:GetCountry():GetCountryTag()
	local gerTag = CCountryDataBase.GetTag('GER')

	-- SSmith (13/05/2013)
	-- Added a new section for when Germany is defeated

	if Support.IsDefeated(ministerTag, gerTag) then
		laArray = {
			10, -- Fighter
			4, -- CAS
			5, -- Tactical
			3, -- Naval Bomber
			3}; -- Strategic
	else
		laArray = {
			14, -- Fighter
			5, -- CAS
			5, -- Tactical
			1, -- Naval Bomber
			0}; -- Strategic
	end

	return laArray
end
-- Naval ratio distribution
function P.NavalRatio(minister)
	local laArray
	local ministerTag = minister:GetCountry():GetCountryTag()
	local gerTag = CCountryDataBase.GetTag('GER')
	
	-- SSmith (13/05/2013)
	-- Thanks to the production logic this can be simplified if Germany is beaten

	if Support.IsDefeated(ministerTag, gerTag) then
		laArray = {
			7, -- Destroyers	
			6, -- Submarines
			8, -- Cruisers
			0, -- Capital		<- Battleships are outdated, so we should build Carriers!
			2, -- Escort Carrier
			2}; -- Carrier
	else
		laArray = {
			6, -- Destroyers
			10, -- Submarines
			6, -- Cruisers
			3, -- Capital		<- We still have Battleships.
			0, -- Escort Carrier
			0}; -- Carrier
	end
	
	return laArray
end
-- Transport to Land unit distribution
function P.TransportLandRatio(minister)
	local laArray
	local ministerTag = minister:GetCountry():GetCountryTag()
	local gerTag = CCountryDataBase.GetTag('GER')

	-- SSmith (13/05/2013)
	-- Fewer transports unless Germany is defeated
	
	if Support.IsDefeated(ministerTag, gerTag) then
		laArray = {
		40, -- Land
		1}; -- Transport
	else
		laArray = {
		180, -- Land
		1}; -- Transport
	end
	
	return laArray
end

-- Build Infantry with two support brigades!
function P.Build_Infantry( ic, minister, infantry_brigade, vbGoOver )
	return Utils.CreateDivision( minister, "infantry_brigade", 0, ic, infantry_brigade, 2, Utils.BuildLegUnitArray( minister:GetCountry() ), 2, vbGoOver )
end

-- Do not build light armor if we can build medium
function P.Build_LightArmor( ic, minister, light_armor_brigade, vbGoOver )
	-- Replace Ligth Armor request with Armor if we can
	if minister:GetCountry():GetTechnologyStatus():IsUnitAvailable( CSubUnitDataBase.GetSubUnit("armor_brigade") ) then
		return Utils.CreateDivision( minister, "armor_brigade", 0, ic, light_armor_brigade, 2, Utils.BuildArmorUnitArray( minister:GetCountry() ), 1, vbGoOver )
	elseif minister:GetCountry():GetTechnologyStatus():IsUnitAvailable(CSubUnitDataBase.GetSubUnit("light_armor_brigade")) then
		return Utils.CreateDivision( minister, "light_armor_brigade", 0, ic, light_armor_brigade, 2, Utils.BuildArmorUnitArray( minister:GetCountry() ), 1, vbGoOver )
	else
		return ic, 0
	end
end

-- Do not build battle cruisers
function P.Build_Battlecruiser(ic, minister, battlecruiser, vbGoOver)
	-- Replace most Battlecruiser request with a Battleship
	local nRandomFactor = math.random(100)
	if minister:GetCountry():GetTechnologyStatus():IsUnitAvailable( CSubUnitDataBase.GetSubUnit("battleship") ) and nRandomFactor > 50 then
		return Utils.CreateDivision_nominor( minister, "battleship", 0, ic, battlecruiser, 1, vbGoOver )
	else
		return ic, 0
	end
end

-- SSmith (21/06/2013)
-- Redundant functions
-- Only build 15 Mountaineers!
--function P.Build_Mountain(ic, minister, bergsjaeger_brigade, vbGoOver)
--	-- Replace Mountaineers wiht Leg Infantry, if we already have enough.
--	local deployedUnits = minister:GetOwnerAI():GetDeployedSubUnitCounts()
--	local producedUnits = minister:GetOwnerAI():GetProductionSubUnitCounts()
--	if deployedUnits:GetAt( CSubUnitDataBase.GetSubUnit("bergsjaeger_brigade"):GetIndex() ) + producedUnits:GetAt( CSubUnitDataBase.GetSubUnit("bergsjaeger_brigade"):GetIndex() ) < 45 then
--		return Utils.CreateDivision_nominor(minister, "bergsjaeger_brigade", 0, ic, bergsjaeger_brigade, 3, vbGoOver)
--	else
--		return Utils.CreateDivision(minister, "infantry_brigade", 0, ic, bergsjaeger_brigade, 3, Utils.BuildLegUnitArray(minister:GetCountry()), 1, vbGoOver)
--	end
--end

-- Only build 5 Marines!
--function P.Build_Marine(ic, minister, marine_brigade, vbGoOver)
--	-- Replace Marines wiht Leg Infantry, if we already have enough.
--	local deployedUnits = minister:GetOwnerAI():GetDeployedSubUnitCounts()
--	local producedUnits = minister:GetOwnerAI():GetProductionSubUnitCounts()
--	if deployedUnits:GetAt(CSubUnitDataBase.GetSubUnit("marine_brigade"):GetIndex()) + producedUnits:GetAt(CSubUnitDataBase.GetSubUnit("marine_brigade"):GetIndex()) < 15 then
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
function P.Build_Industry( ic, minister, vbGoOver )

	-- Build five factories at a time!
	local ai = minister:GetOwnerAI()
	local ministerCountry = minister:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	local industry = CBuildingDataBase.GetBuilding("industry" )
	local industryCost = ministerCountry:GetBuildCost(industry):Get()
	local laCorePrv = {}
	local loTechStatus = ministerCountry:GetTechnologyStatus()
	
	laCorePrv = CoreProvincesLoop( ministerCountry, loTechStatus, 1, 1 )
	
	local maxIndustry
	if minister:GetOwnerAI():GetCurrentDate():GetYear() >= 1940 then
		maxIndustry = 5
	else
		maxIndustry = 15
	end
	
	-- Don't build too many factories at once!
	local nTotalFactoryBuilds = 0
	for provinceID in ministerCountry:GetCoreProvinces() do
		nTotalFactoryBuilds = nTotalFactoryBuilds + CCurrentGameState.GetProvince( provinceID ):GetCurrentConstructionLevel(industry)
	end
	
	while nTotalFactoryBuilds < maxIndustry do
		if ( ic - industryCost ) >= 0 or vbGoOver then
			if table.getn( laCorePrv[ 6 ] ) > 0 then
				-- Only use provinces from Asia!
				local usableProvinceList = Support.ProvincesOnContient( laCorePrv[ 6 ], 'asia' )
				local industryProvinceID
				if table.getn( usableProvinceList ) > 0 then
					industryProvinceID = usableProvinceList[ math.random( table.getn( usableProvinceList ) ) ]
				else
					industryProvinceID = laCorePrv[6][ math.random( table.getn( laCorePrv[ 6 ] ) ) ]
				end
				local constructCommand = CConstructBuildingCommand( ministerTag, industry, industryProvinceID, 1 )

				if constructCommand:IsValid() then
					ai:Post( constructCommand )
					ic = ic - industryCost		-- Upodate IC total	
				end
			end
		end
		nTotalFactoryBuilds = nTotalFactoryBuilds + 1
	end
	return ic
end

-- We don't want to build any other building than Industry for the first four years.
function P.DontBuildBuilding( minister, building )

	-- SSmith (13/05/2013)
	-- For now we won't allow effort to be wasted on nuclear/rocket research

	if minister:GetOwnerAI():GetCurrentDate():GetYear() < 1940
	and building:GetName() ~= 'industry'
	then
		return true
	elseif tostring(building:GetName()) == "Nuclear Research Lab" or tostring(building:GetName()) == "Rocket Test Site" then
		return true
	else
		return false
	end
end

-- We don't want to spend too much on Upgrades in the beginning.
function P.MaxUpgrade( ministerTag )

	-- SSmith (28/05/2013)
	-- We will allow limited upgrading if the Soviets are in an early war

	if CCurrentGameState.GetCurrentDate():GetYear() < 1940 and not ministerTag:GetCountry():IsAtWar() then
		-- Before '40, don't bother with that at all. We want to build LOTS of factories instead.
		return 0.0
	elseif CCurrentGameState.GetCurrentDate():GetYear() < 1941 then
		-- In '40, we can start working on it. But still don't overdo it.
		return 0.25
	end
	-- Never spend more than half though.
	return 0.5
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

	local sameIdeology = Utils.SameIdeology(ministerCountry, TargetCountry, nil)
	
	-- SSmith (11/05/2013)
	-- Fixed a syntax error that caused the Soviets to give maximum spy priority to half the countries in the world!

	-- bring Spanish republic into the party
	if tostring(TargetCountryTag) == "SPR" and not TargetCountry:HasFaction() then
		return 3
		
	-- support the communists
	elseif not TargetCountry:HasFaction() and sameIdeology == true then
		return 2
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
	local sameIdeology = Utils.SameIdeology(ministerCountry, TargetCountry, nil)
			
	-- bring Spanish republic into the fold
	if tostring(TargetCountryTag) == "SPR" and not TargetCountry:HasFaction() then
		CountryScriptMission = "BoostOurParty"
	
	elseif sameIdeology == true and not TargetCountry:HasFaction() then	
		CountryScriptMission = "BoostRulingParty"
	end
	
	return CountryScriptMission
end

-- End of Intelligence Hooks
-- #######################################

function P.ProposeDeclareWar( minister )
	local ministerCountry = minister:GetCountry()
	local ministerTag = minister:GetCountryTag()
	local gerTag = CCountryDataBase.GetTag('GER')
	local logerCountry = gerTag:GetCountry()
	
	local axisFaction = CCurrentGameState.GetFaction("axis")
	local alliesFaction = CCurrentGameState.GetFaction("allies")
	local comminternFaction = CCurrentGameState.GetFaction("commintern")
	
	local loStrategy = ministerCountry:GetStrategy()
	local ai = minister:GetOwnerAI()
		
	-- Do the Russians control Moscow?
	if CCurrentGameState.GetProvince(1409):GetOwner() == ministerTag then
		if logerCountry:IsAtWar() and not(ministerCountry:IsAtWar()) then
			local fraTag = CCountryDataBase.GetTag('FRA')
			local polTag = CCountryDataBase.GetTag('POL')
			local year = ai:GetCurrentDate():GetYear()
			local loRelation = ai:GetRelation(ministerTag, gerTag)
			
			-- If Germany is neighbors with France and Russia at the same time
			if logerCountry:GetRelation(fraTag):HasWar()		-- France is at war with Germany.
			and not(loRelation:HasNap())
			then
				local fraCountry = fraTag:GetCountry()
				local fraProvsInGermanHands = 0
				for fraProvinceID in fraCountry:GetOwnedProvinces() do
					local fraProvince = CCurrentGameState.GetProvince(fraProvinceID)
					if fraProvince:GetController() == gerTag then
						fraProvsInGermanHands = fraProvsInGermanHands + 1
					end
				end

				-- SSmith (22/06/2013)
				-- The CalcDesperation method is an unknown quantity we will use surrender progress instead

				if fraProvsInGermanHands > 15
				or gerTag:GetCountry():GetSurrenderLevel():Get() > 0.15
				then
					Support.PrepareForWar( ministerTag, gerTag, 100 )
				end
			elseif year >= 1942 								-- From '42, let's prepare!
			and ministerCountry:IsNeighbour(gerTag)
			and not(loRelation:HasNap()) then
				Support.PrepareForWar( ministerTag, gerTag, 100 )
			elseif year >= 1942 
			and ministerCountry:IsNeighbour(polTag) then
				Support.PrepareForWar( ministerTag, polTag, 100 )
			end
		end
		
		if ministerCountry:GetFaction() == comminternFaction
		and not(loStrategy:IsPreparingWar()) then		
			-- Generic DOW for countries not part of the same faction
			local currentNeutrality = ministerCountry:GetNeutrality():Get()
			for loTargetCountry in CCurrentGameState.GetCountries() do
				local loTargetTag = loTargetCountry:GetCountryTag()
				
				if not(loTargetCountry:GetFaction() == ministerCountry:GetFaction()) then
					local targetCountryCapitalContinentString = tostring(loTargetCountry:GetCapitalLocation():GetContinent())
					if ( targetCountryCapitalContinentString == "europe"	-- European,
					or targetCountryCapitalContinentString == "asia" 		-- Asian
					or ministerCountry:IsNeighbour(loTargetTag) )			-- or at least a neighbor.
					and Support.CompareMilitaryStrength(ministerTag, loTargetTag) > 1.5
					and ministerCountry:GetManpower():Get() > 500
					then
						local currentThreat = ministerCountry:GetRelation(loTargetTag):GetThreat():Get()
						local canAttack = ( Support.IsDefeated(ministerTag, gerTag) or ( not loTargetCountry:HasFaction() ) or loTargetCountry:GetFaction() == axisFaction )
						
						if Support.IsDefeated(ministerTag, gerTag) then		-- Germany is no longer a threat, so let's start the Revolution!
							local targetIdeologyGroup = loTargetCountry:GetRulingIdeology():GetGroup()
							local ministerIdeologyGroup = ministerCountry:GetRulingIdeology():GetGroup()
							if not ( targetIdeologyGroup == ministerIdeologyGroup ) and ministerCountry:IsNeighbour(loTargetTag) then
								Support.PrepareForWar( ministerTag, loTargetTag, 100 )	-- Let's start with neighbours!
							end
						elseif canAttack and currentThreat > currentNeutrality + 20 and ministerCountry:IsMobilized() then
							Support.PrepareForWar( ministerTag, loTargetTag, 100 )
						elseif currentThreat > currentNeutrality + 10 then
							local command = CToggleMobilizationCommand( ministerTag, true )
							ai:Post( command )
						end
					end
				end
			end
		end
	else
		-- Moscow is taken. Let's plan taking it back!

		-- SSmith (22/06/2013)
		-- The CalcDesperation method is an unknown quantity so we will use surrender progress instead

		local moscowOwnerTag = CCurrentGameState.GetProvince(1409):GetOwner()
		if moscowOwnerTag:GetCountry():GetSurrenderLevel():Get() > 0.25 then		-- The current controller of Moscow is getting beaten!
			local command = CToggleMobilizationCommand( ministerTag, true )
			ai:Post( command )
			Support.PrepareForWar( ministerTag, moscowOwnerTag, 100 )
		end
	end
end

function P.ForeignMinister_EvaluateDecision(score, agent, decision, scope)

	local ministerCountry = agent:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	local strategy = ministerCountry:GetStrategy()
	local finTag = CCountryDataBase.GetTag('FIN')
	local gerTag = CCountryDataBase.GetTag('GER')
	local fraTag = CCountryDataBase.GetTag('FRA')
	local engTag = CCountryDataBase.GetTag('ENG')
	local usaTag = CCountryDataBase.GetTag('USA')

	-- SSmith (28/08/2013)
	-- Add random chances to make decisions plausible
	
	if decision:GetKey():GetString() == 'finnish_winter_war' then
		local finCountry = finTag:GetCountry()
		if ( not finCountry:GetRelation(gerTag):IsGuaranteed() or ministerCountry:GetRelation(gerTag):HasWar() )
		and ( not finCountry:GetRelation(fraTag):IsGuaranteed() or ministerCountry:GetRelation(fraTag):HasWar() )
		and ( not finCountry:GetRelation(engTag):IsGuaranteed() or ministerCountry:GetRelation(engTag):HasWar() )
		and ( not finCountry:GetRelation(usaTag):IsGuaranteed() or ministerCountry:GetRelation(usaTag):HasWar() )
		and math.mod( CCurrentGameState.GetAIRand(), 10) == 1
		then
			return Support.PrepareForWarDecision( ministerTag, finTag, decision, 5.0 )	-- Should prepare, because they already have serious penalties!
		end
		score = 0
	elseif decision:GetKey():GetString() == 'great_officer_purge' then
		if ministerCountry:GetNationalUnity():Get() > 65 then			-- Only make the Purge, if we have low Unity!
			score = 0
		elseif math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			score = 100
		else
			score = 0
		end
	elseif decision:GetKey():GetString() == 'attack_on_poland'
	or decision:GetKey():GetString() == 'attack_on_poland_no_guarantee'
	then
		local polTag = CCountryDataBase.GetTag('POL')
		if polTag:GetCountry():GetSurrenderLevel():Get() > 0.25 then
			score = 100		-- There really shouldn't be any need to prepare by then, so don't waste any time!
		else
			score = 0
		end
	elseif decision:GetKey():GetString() == 'industry_moved_to_siberia_v1' then	-- Only make this decision, if the provinces are threatened!
		if CCurrentGameState.GetProvince(989):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(1492):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(1694):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(2222):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(2394):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(2641):IsFrontProvince(true)
		then
			score = 100
		else
			score = 0
		end
	elseif decision:GetKey():GetString() == 'industry_moved_to_siberia_v2' then	-- Only make this decision, if the provinces are threatened!
		if CCurrentGameState.GetProvince(1494):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(1696):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(1819):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(1937):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(2167):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(2517):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(2519):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(3176):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(3309):IsFrontProvince(true)
		then
			score = 100
		else
			score = 0
		end
	elseif decision:GetKey():GetString() == 'industry_moved_to_siberia_v3' then	-- Only make this decision, if the provinces are threatened!
		if CCurrentGameState.GetProvince(782):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(1409):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(2286):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(2401):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(7150):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(2781):IsFrontProvince(true)
		or CCurrentGameState.GetProvince(7249):IsFrontProvince(true)
		then
			score = 100
		else
			score = 0
		end
	elseif decision:GetKey():GetString() == 'spanish_civil_war_russian_intervention' then
		if math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			score = 100
		else
			score = 0
		end
	elseif decision:GetKey():GetString() == 'sino_soviet_non_aggression_pact' then
		if math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			score = 100
		else
			score = 0
		end
	elseif decision:GetKey():GetString() == 'operation_zet' then
		if math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			score = 100
		else
			score = 0
		end
	elseif decision:GetKey():GetString() == 'claim_bessarabia' then
		if math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			score = 100
		else
			score = 0
		end
	elseif decision:GetKey():GetString() == 'operation_countenance' then
		if math.mod( CCurrentGameState.GetAIRand(), 50) == 1 then
			score = 100
		else
			score = 0
		end
	elseif decision:GetKey():GetString() == 'ultimatum_to_the_baltic_states' or decision:GetKey():GetString() == 'ultimatum_to_the_baltic_states_v2'
	or decision:GetKey():GetString() == 'ultimatum_to_the_baltic_states_v3' then
		if math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			score = 100
		else
			score = 0
		end
	elseif decision:GetKey():GetString() == 'demand_eastern_poland' then
		if math.mod( CCurrentGameState.GetAIRand(), 10) == 1 then
			score = 100
		else
			score = 0
		end
	elseif decision:GetKey():GetString() == 'end_of_tannu_tuva' then
		if math.mod( CCurrentGameState.GetAIRand(), 250) == 1 then
			score = 100
		else
			score = 0
		end
	elseif decision:GetKey():GetString() == 'molotov_line_1' or decision:GetKey():GetString() == 'molotov_line_2'
	or decision:GetKey():GetString() == 'molotov_line_3' or decision:GetKey():GetString() == 'molotov_line_4'
	or decision:GetKey():GetString() == 'molotov_line_5' then
		if math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			score = 100
		else
			score = 0
		end
	elseif decision:GetKey():GetString() == 'bitter_peace' then

		-- SSmith (28/11/2013)
		-- We will handle acceptance of the Bitter Peace by checking a country variable calculated in the Foreign Minister script

		if ministerCountry:GetVariables():GetVariable(CString("ai_bitter_peace")):Get() > 99 then
			score = 100
		else
			score = 0
		end
	end
	
	return score
end

function P.DiploScore_OfferTrade(score, ai, actor, recipient, observer, voTradedFrom, voTradedTo)
	local lsActorTag = tostring(actor)
	local actorIdeologyGroup = actor:GetCountry():GetRulingIdeology():GetGroup()
	local recipientIdeologyGroup = recipient:GetCountry():GetRulingIdeology():GetGroup()
	
	if lsActorTag == "GER" then
		score = score + 20
	elseif actorIdeologyGroup == recipientIdeologyGroup then
		score = score + 50
	end
	
	return score
end

function P.DiploScore_InfluenceNation( score, ai, actor, recipient, observer )
	local axisFaction = CCurrentGameState.GetFaction('axis')
	local alliesFaction = CCurrentGameState.GetFaction('allies')
	local recipientIdeologyGroup = recipient:GetCountry():GetRulingIdeology():GetGroup()
	local actorIdeologyGroup = actor:GetCountry():GetRulingIdeology():GetGroup()

	if axisFaction:GetNumberOfMembers() > 0						-- Until one of the other factions are down, we only want to worry about
	and alliesFaction:GetNumberOfMembers() > 0					-- our ideological friends!
	and not ( actorIdeologyGroup == recipientIdeologyGroup )
	then
		return 0
	else
		return score
	end
end

function P.DiploScore_InviteToFaction( score, ai, actor, recipient, observer)

	-- SSmith (10/11/2013)
	-- Don't let Xinjiang join Comintern

	local japTag = CCountryDataBase.GetTag('JAP')
	local chcTag = CCountryDataBase.GetTag('CHC')
	local sikTag = CCountryDataBase.GetTag('SIK')

	local recipientTagString = tostring(recipient)
	local actorIdeologyGroup = actor:GetCountry():GetRulingIdeology():GetGroup()
	local recipientIdeologyGroup = recipient:GetCountry():GetRulingIdeology():GetGroup()

	if actorIdeologyGroup == recipientIdeologyGroup then
		score = score + 50
	else
		score = score - 25
	end
	
	if (recipient == chcTag or recipient == sikTag) and not Support.IsDefeated(actor, japTag) then
		score = 0
	end
	
	return score
end

function P.DiploScore_CallAlly(liScore, ai, actor, recipient, observer)

	-- SSmith (02/06/2013)
	-- The USSR is getting called against Japan by Xinjiang
	-- We will say no unless we have defeated Germany

	if observer == recipient then

		local gerTag = CCountryDataBase.GetTag('GER')
		local japTag = CCountryDataBase.GetTag('JAP')

		if actor:GetCountry():GetRelation(japTag):HasWar()
		and not recipient:GetCountry():GetRelation(japTag):HasWar()
		and not Support.IsDefeated(recipient, gerTag) then
			liScore = 0
		end

		-- SSmith (10/11/2013)
		-- Check that we don't get called against Germany after Bitter Peace

		if actor:GetCountry():GetRelation(gerTag):HasWar()
		and recipient:GetCountry():GetFlags():IsFlagSet("bitter_peace")
		and not recipient:GetCountry():GetRelation(gerTag):HasWar() then
			liScore = 0
		end
	end
	
	return liScore
end

function P.HandlePuppets(minister)

	-- SSmith (22/11/2013)
	-- Add exceptions for Soviet Republics and Baltic States

	local laCountryExceptions = { "RUS", "ARM", "AZB", "BLR", "GEO", "UKR", "KAZ", "KYG", "TRK", "TAJ", "UZB", "EST", "LAT", "LIT", "TAN" }
	return laCountryExceptions
end

-- Soviets want more troops, let them learn on the battlefield.
--   helps them produce troops faster
function P.CallLaw_training_laws(minister, voCurrentLaw)
	local _MINIMAL_TRAINING_ = 28
	return CLawDataBase.GetLaw(_MINIMAL_TRAINING_)
end

function P.HandleMobilization( minister, needsMobilization )

	-- SSmith (17/04/2013)
	-- Added a mobilization function to prevent premature mobilization due to Japanese threat
	-- We will only mobilize if Germany is at war or has defeated Poland
	-- And we will demobilize otherwise if it's before 1940

	local ministerTag = minister:GetCountryTag()
	local ministerCountry = minister:GetCountry()
	local gerTag = CCountryDataBase.GetTag('GER')
	local polTag = CCountryDataBase.GetTag('POL')

	if gerTag:GetCountry():IsAtWar() or Support.IsDefeated(gerTag, polTag) then
		needsMobilization = true
	elseif minister:GetOwnerAI():GetCurrentDate():GetYear() < 1940 then
		needsMobilization = false
	end

	return needsMobilization
end

return AI_SOV
