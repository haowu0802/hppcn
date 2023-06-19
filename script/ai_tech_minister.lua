function BalanceLeadershipSliders( ai, ministerCountry )

	-- SSmith (10/05/2013)
	-- The basic principle here is that every country should have spies for domestic defence and have enough diplomacy for trades
	-- We will also check for puppet nations as they will only need minimal diplomacy for licences
	-- The logic will be re-written to deal with each slider setting separately
	-- I am also going to change the call to the country AI so that it can make custom adjustments after the main logic has been applied

	local ministerTag = ministerCountry:GetCountryTag()
	local totalIC = ministerCountry:GetTotalIC()

	-- Do Research by default
	local LEADERSHIP_RESEARCH = 1.0
	local LEADERSHIP_ESPIONAGE = 0.0
	local LEADERSHIP_DIPLOMACY = 0.0
	local LEADERSHIP_NCO = 0.0

	-- SSmith (10/05/2013)
	-- We will start with the espionage slider

	local domesticSpies = ministerCountry:GetSpyPresence(ministerTag):GetLevel():Get()

	if totalIC < 30 then
		-- Mediums and Minors should only care about internal security
		if domesticSpies < 5 then
			LEADERSHIP_ESPIONAGE = 0.20
		elseif domesticSpies < 10 then
			LEADERSHIP_ESPIONAGE = 0.10
		else
			LEADERSHIP_ESPIONAGE = 0.00
		end
	elseif totalIC < 100 then
		-- Regional Powers should invest in their own security and meddle a bit overseas
		if domesticSpies < 5 then
			LEADERSHIP_ESPIONAGE = 0.20
		elseif domesticSpies < 10 then
			LEADERSHIP_ESPIONAGE = 0.10
		else
			LEADERSHIP_ESPIONAGE = 0.05
		end
	else
		-- Major Powers and above should always invest in foreign espionage
		if domesticSpies < 5 then
			LEADERSHIP_ESPIONAGE = 0.20
		elseif domesticSpies < 10 then
			LEADERSHIP_ESPIONAGE = 0.15
		else
			LEADERSHIP_ESPIONAGE = 0.10
		end
	end

	-- SSmith (01/06/2013)
	-- If we have free spies then stop investing in espionage!

	if ministerCountry:GetNumberOfFreeSpies() > 5 then
		LEADERSHIP_ESPIONAGE = 0.00
	end

	-- SSmith (10/05/2013)
	-- Next we will handle the diplomacy slider

	local currentDiplomats = ministerCountry:GetDiplomaticInfluence():Get()

	if totalIC < 10 then
		-- Minors
		if currentDiplomats < 5 then
			LEADERSHIP_DIPLOMACY = 0.10
		else
			LEADERSHIP_DIPLOMACY = 0.00
		end
	elseif totalIC < 30 then
		-- Mediums
		if currentDiplomats < 5 then
			LEADERSHIP_DIPLOMACY = 0.15
		elseif currentDiplomats < 10 then
			LEADERSHIP_DIPLOMACY = 0.05
		else
			LEADERSHIP_DIPLOMACY = 0.00
		end
	elseif totalIC < 100 then
		-- Regional Powers
		if currentDiplomats < 5 then
			LEADERSHIP_DIPLOMACY = 0.20
		elseif currentDiplomats < 10 then
			LEADERSHIP_DIPLOMACY = 0.10
		elseif currentDiplomats < 15 then
			LEADERSHIP_DIPLOMACY = 0.05
		else
			LEADERSHIP_DIPLOMACY = 0.00
		end
	else
		-- Major Powers and above
		if currentDiplomats < 5 then
			LEADERSHIP_DIPLOMACY = 0.20
		elseif currentDiplomats < 15 then
			LEADERSHIP_DIPLOMACY = 0.10
		elseif currentDiplomats < 25 then
			LEADERSHIP_DIPLOMACY = 0.05
		else
			LEADERSHIP_DIPLOMACY = 0.00
		end
	end

	-- Puppets need very little diplomacy
	if ministerCountry:IsSubject() then
		if currentDiplomats < 5 then
			LEADERSHIP_DIPLOMACY = LEADERSHIP_DIPLOMACY * 0.5
		elseif currentDiplomats < 10 then
			LEADERSHIP_DIPLOMACY = LEADERSHIP_DIPLOMACY * 0.25
		else
			LEADERSHIP_DIPLOMACY = 0.00
		end

	end

	-- SSmith (10/05/2013)
	-- Now we will handle officer ratio

	local officer_ratio = ministerCountry:GetOfficerRatio():Get()

	if totalIC < 10 then
		-- Minors should aim for 100% officers
		if officer_ratio < 0.75 then
			LEADERSHIP_NCO = 0.25
		elseif officer_ratio < 1.00 then
			LEADERSHIP_NCO = 0.15
		else
			LEADERSHIP_NCO = 0.00
		end
	elseif totalIC < 30 then
		-- Mediums should aim for 125% officers
		if officer_ratio < 0.75 then
			LEADERSHIP_NCO = 0.35
		elseif officer_ratio < 1.00 then
			LEADERSHIP_NCO = 0.20
		elseif officer_ratio < 1.25 then
			LEADERSHIP_NCO = 0.10
		else
			LEADERSHIP_NCO = 0.00
		end
	elseif totalIC < 100 then
		-- Regional Powers should aim for 135% officers
		if officer_ratio < 0.75 then
			LEADERSHIP_NCO = 0.40
		elseif officer_ratio < 1.00 then
			LEADERSHIP_NCO = 0.25
		elseif officer_ratio < 1.25 then
			LEADERSHIP_NCO = 0.15
		elseif officer_ratio < 1.50 then
			LEADERSHIP_NCO = 0.05
		else
			LEADERSHIP_NCO = 0.00
		end
	else
		-- Major Powers and above should aim for the max possible officer ratio!
		if officer_ratio < 0.75 then
			LEADERSHIP_NCO = 0.50	-- We can't build new units!
		elseif officer_ratio < 1.00 then
			LEADERSHIP_NCO = 0.35
		elseif officer_ratio < 1.25 then
			LEADERSHIP_NCO = 0.25	-- We need a decent ratio first!
		elseif officer_ratio < 1.50 then
			LEADERSHIP_NCO = 0.15	-- Let's build up our Officer Ratio to max!
		else
			LEADERSHIP_NCO = 0.00
		end
	end

	-- SSmith (10/05/2013)
	-- Finally we will call a re-worked country function to make any further adjustments

	if Utils.HasCountryAIFunction( ministerTag, "TechSliders" ) then

		--Utils.LUA_DEBUGOUT(tostring(ministerTag) .. ": " .. tostring(LEADERSHIP_RESEARCH))
		--Utils.LUA_DEBUGOUT(tostring(ministerTag) .. ": " .. tostring(LEADERSHIP_ESPIONAGE))
		--Utils.LUA_DEBUGOUT(tostring(ministerTag) .. ": " .. tostring(LEADERSHIP_DIPLOMACY))
		--Utils.LUA_DEBUGOUT(tostring(ministerTag) .. ": " .. tostring(LEADERSHIP_NCO))

		local techSliderArray = {
			LEADERSHIP_RESEARCH,
			LEADERSHIP_ESPIONAGE,
			LEADERSHIP_DIPLOMACY,
			LEADERSHIP_NCO
		}; 
		techSliderArray = Utils.CallCountryAI( ministerTag, "TechSliders", ministerCountry, techSliderArray )
		LEADERSHIP_RESEARCH = techSliderArray[1]
		LEADERSHIP_ESPIONAGE = techSliderArray[2]
		LEADERSHIP_DIPLOMACY = techSliderArray[3]
		LEADERSHIP_NCO = techSliderArray[4]

		--Utils.LUA_DEBUGOUT(tostring(ministerTag) .. ": " .. tostring(LEADERSHIP_RESEARCH))
		--Utils.LUA_DEBUGOUT(tostring(ministerTag) .. ": " .. tostring(LEADERSHIP_ESPIONAGE))
		--Utils.LUA_DEBUGOUT(tostring(ministerTag) .. ": " .. tostring(LEADERSHIP_DIPLOMACY))
		--Utils.LUA_DEBUGOUT(tostring(ministerTag) .. ": " .. tostring(LEADERSHIP_NCO))

	end

	-- SSmith (10/05/2013)
	-- Everything we have left goes into research

	LEADERSHIP_RESEARCH = 1 - LEADERSHIP_NCO - LEADERSHIP_DIPLOMACY - LEADERSHIP_ESPIONAGE

	-- SSmith (21/06/2013)
	-- It is important that the AI reacts sensibly when leadership is limited
	-- Officers are essential so diplomacy and espionage must be curtailed if necessary
	-- We will aim to have 65% of our leadership invested in research!

	local shortfall = math.min(math.max((0.65 - LEADERSHIP_RESEARCH), 0), 0.25)

	-- SSmith (12/09/2013)
	-- Research becomes very stretched from in later years so we will tighten up the AI's focus even more!

	local year = CCurrentGameState.GetCurrentDate():GetYear()
	if year > 1942 then
		shortfall = math.min(math.max((0.85 - LEADERSHIP_RESEARCH), 0), 0.25)
	elseif year > 1940 then
		shortfall = math.min(math.max((0.75 - LEADERSHIP_RESEARCH), 0), 0.25)
	end

	if shortfall > 0 then
		local scalar = 1 - (shortfall * 3)
		LEADERSHIP_DIPLOMACY = LEADERSHIP_DIPLOMACY * scalar
		LEADERSHIP_ESPIONAGE = LEADERSHIP_ESPIONAGE * scalar
		LEADERSHIP_RESEARCH = 1 - LEADERSHIP_NCO - LEADERSHIP_DIPLOMACY - LEADERSHIP_ESPIONAGE
	end

	local command = CChangeLeadershipCommand( ministerCountry:GetCountryTag(), LEADERSHIP_NCO, LEADERSHIP_DIPLOMACY, LEADERSHIP_ESPIONAGE, LEADERSHIP_RESEARCH )
	ai:Post( command )
	
	return LEADERSHIP_RESEARCH
end

-- ############################################
-- THIS IS THE MAIN FUNCTION CALLED BY THE EXE
-- ############################################

function TechMinister_Tick( minister, vbSliders, vbResearch )
	local ai = minister:GetOwnerAI()
	local ministerCountry = minister:GetCountry()

	-- SSmith (17/07/2013)
	-- I'm adding some logging to check on how many research slots the majors are using

	--if CCurrentGameState.GetCurrentDate():GetDayOfMonth() == 0 then
	--	local ministerTag = minister:GetCountryTag()
	--	local ministerTagString = tostring(ministerTag)
	--	if ministerTagString == "ENG" or ministerTagString == "FRA" or ministerTagString == "GER" or ministerTagString == "ITA"
	--	or ministerTagString == "SOV" or ministerTagString == "JAP" or ministerTagString == "USA" or ministerTagString == "CHI" then
	--		if ministerTagString == "GER" then
	--			Utils.LUA_DEBUGOUT("")
	--		end
	--		Utils.LUA_DEBUGOUT(ministerTagString .. " " .. tostring(ministerCountry:GetAllowedResearchSlots()) .. " of " .. tostring(ministerCountry:GetTotalLeadership()))
	--	end
	--end

	if vbSliders then
		BalanceLeadershipSliders( ai, ministerCountry )
	end
	
	-- SSmith (18/07/2013)
	-- Add 1 to the number of slots allowed because the game rounds down

	if vbResearch then
		local ResearchSlotsAllowed = ministerCountry:GetAllowedResearchSlots() + 1
		local ResearchSlotsNeeded = ResearchSlotsAllowed - ministerCountry:GetNumberOfCurrentResearch()
		Process_Tech( ( CCurrentGameState.GetCurrentDate():GetYear() ), ResearchSlotsAllowed, ResearchSlotsNeeded, ai, minister, ministerCountry )
	end
end

--------------------------------
-- Get the default tech weights
--------------------------------

--   1.0 = 100% the total needs to equal 1.0
function Get_TechWeights( minister )
	local laTechWeights
	local liLeadership = minister:GetCountry():GetTotalLeadership():Get()

	-- SSmith (13/07/2013)
	-- This function will return default tech weightings for countries that don't have their own script

	if liLeadership < 7 then

		laTechWeights = {
			0.50, -- Land
			0.00, -- Air
			0.10, -- Naval
			0.40}; -- Other

	elseif liLeadership < 10 then

		laTechWeights = {
			0.45, -- Land
			0.15, -- Air
			0.15, -- Naval
			0.25}; -- Other
	else

		laTechWeights = {
			0.40, -- Land
			0.20, -- Air
			0.20, -- Naval
			0.20}; -- Other
	end
	
	return laTechWeights
end

-----------------------------------------------
-- Declare global parameters for tech research
-----------------------------------------------

-- SSmith (13/07/2013)
-- These are the indexes to the tech group arrays

local _RESEARCH_LAND_ = 1
local _RESEARCH_AIR_ = 2
local _RESEARCH_NAVAL_ = 3
local _RESEARCH_OTHER_ = 4		-- This should always be the highest index

-- SSmith (13/07/2013)
-- This table holds default parameters to influence how each technology is researched
-- This is global but country-specific overrides will be loaded from the country scripts when required

local p_TechParams = {
	default = {			-- These are the default values for any technology that isn't included in the table below
		Leadership = 0,		-- The minimum leadership required to research this tech
		Priority = 0.50,	-- The default priority of this tech (from 0.00 to 1.00, or higher if needed)
		EarlyOffset = 1.00,	-- The reduction in priority for each year ahead of time (if zero it will be defaulted to 1.00)
		LateOffset = 0.25,	-- The increase in priority for each year behind time (if zero it will be defaulted to half the priority)
		EndYear = 1999,		-- Stop researching from this year onwards
		Attribute = ""		-- Free-format text that can be used to control the logic
	},
	
	-- Infantry folder

	infantry_activation		= { Leadership =  0, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	cavalry_activation		= { Leadership =  0, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	mountain_infantry 		= { Leadership =  7, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	marine_infantry			= { Leadership = 12, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "Naval" },
	paratrooper_infantry		= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	engineer_brigade_activation 	= { Leadership = 12, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },

	smallarms_technology	    	= { Leadership =  0, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	support_weapon_technology   	= { Leadership =  0, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	light_artillery_technology  	= { Leadership =  3, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	light_anti_tank_technology  	= { Leadership =  3, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

	engineer_bridging_equipment	= { Leadership = 12, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.25, EndYear = 1999, Attribute = "" },
	engineer_assault_equipment  	= { Leadership = 12, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.25, EndYear = 1999, Attribute = "" },
	night_goggles		   	= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

	light_smallarms_technology 	= { Leadership = 10, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.25, EndYear = 1999, Attribute = "" },
	light_support_weapon_technology = { Leadership = 10, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.25, EndYear = 1999, Attribute = "" },
	mountain_gun_technology 	= { Leadership = 10, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.25, EndYear = 1999, Attribute = "" },
	weapon_salt_water_proofing 	= { Leadership = 12, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.25, EndYear = 1999, Attribute = "Naval" },

	desert_warfare_equipment 	= { Leadership = 99, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	artic_warfare_equipment 	= { Leadership = 99, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	jungle_warfare_equipment 	= { Leadership = 99, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	amphibious_warfare_equipment 	= { Leadership = 12, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.25, EndYear = 1999, Attribute = "Naval" },
	airborne_warfare_equipment 	= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.25, EndYear = 1999, Attribute = "" },
	mountain_warfare_equipment 	= { Leadership = 10, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.25, EndYear = 1999, Attribute = "" },

	mortorised_infantry 		= { Leadership =  7, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	mechanised_infantry 		= { Leadership = 99, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },

	horse_towed_support_brigade_tech = { Leadership = 5, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },

	artillery_activation 		= { Leadership =  5, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	artillery 			= { Leadership =  5, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	anti_tank_activation 		= { Leadership =  7, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	anti_tank 			= { Leadership =  7, Priority = 1.00, EarlyOffset = 0.50, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	anti_air_activation 		= { Leadership =  7, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	anti_air_guns 			= { Leadership =  7, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	rocket_artillery_activation 	= { Leadership = 99, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	rocket_artillery 		= { Leadership = 99, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

	-- Armour folder

	armored_car_activation 		= { Leadership =  7, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "" },
	armored_car 			= { Leadership =  7, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

	super_heavy_tank_brigade 	= { Leadership = 12, Priority = 0.70, EarlyOffset = 0.50, LateOffset = 0.40, EndYear = 1999, Attribute = "InfantryTank" },
	super_heavy_tank_gun 		= { Leadership = 12, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "InfantryTank" },
	super_heavy_tank_armour 	= { Leadership = 12, Priority = 0.70, EarlyOffset = 0.50, LateOffset = 0.40, EndYear = 1999, Attribute = "InfantryTank" },
	super_heavy_tank_engine 	= { Leadership = 12, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "InfantryTank" },
	super_heavy_tank_reliability 	= { Leadership = 12, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "InfantryTank" },

	lighttank_brigade 		= { Leadership = 10, Priority = 0.70, EarlyOffset = 0.50, LateOffset = 0.40, EndYear = 1999, Attribute = "LightTank" },
	lighttank_gun 			= { Leadership = 10, Priority = 0.70, EarlyOffset = 0.50, LateOffset = 0.40, EndYear = 1999, Attribute = "LightTank" },
	lighttank_armour 		= { Leadership = 10, Priority = 0.70, EarlyOffset = 0.50, LateOffset = 0.40, EndYear = 1999, Attribute = "LightTank" },
	lighttank_engine 		= { Leadership = 10, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "LightTank" },
	lighttank_reliability 		= { Leadership = 10, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "LightTank" },

	tank_brigade 			= { Leadership = 12, Priority = 0.80, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "MediumTank" },
	tank_gun 			= { Leadership = 12, Priority = 0.80, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "MediumTank" },
	tank_armour 			= { Leadership = 12, Priority = 0.80, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "MediumTank" },
	tank_engine 			= { Leadership = 12, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "MediumTank" },
	tank_reliability 		= { Leadership = 12, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "MediumTank" },

	heavy_tank_brigade 		= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "HeavyTank" },
	heavy_tank_gun 			= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "HeavyTank" },
	heavy_tank_armour 		= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "HeavyTank" },
	heavy_tank_engine 		= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "HeavyTank" },
	heavy_tank_reliability 		= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "HeavyTank" },

	sloped_armor 			= { Leadership = 12, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },

	truck_engine 			= { Leadership =  7, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "" },

	truck_towed_support_brigade_tech = { Leadership = 7, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	self_propelled_support_brigade_tech = { Leadership = 99, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

	sp_artillery_activation 	= { Leadership = 99, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	sp_artillery 			= { Leadership = 99, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	sp_rocket_artillery_activation 	= { Leadership = 99, Priority = 0.30, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	sp_rocket_artillery 		= { Leadership = 99, Priority = 0.30, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	tank_destroyer_activation 	= { Leadership = 99, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	tank_destroyer 			= { Leadership = 99, Priority = 0.60, EarlyOffset = 0.50, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	sp_anti_air_activation 		= { Leadership = 99, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	sp_anti_air 			= { Leadership = 99, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

	-- Escorts folder

	destroyer_technology 		= { Leadership =  7, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.35, EndYear = 1999, Attribute = "ShipBuilding" },
	destroyer_engine 		= { Leadership =  7, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	multi_purpose_guns 		= { Leadership =  7, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	light_antiaircraft 		= { Leadership =  7, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.30, EndYear = 1999, Attribute = "" },

	surface_detection_system 	= { Leadership =  7, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
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
	submarine_sonar 		= { Leadership = 12, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	submarine_airwarningequipment 	= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	modern_submarine 		= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

	-- Capital Ships folder

	const_material 			= { Leadership =  0, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "" },

	battlecruiser_technology 	= { Leadership = 99, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.35, EndYear = 1938, Attribute = "" },
	battleship_technology 		= { Leadership = 99, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.35, EndYear = 1942, Attribute = "" },
	capital_ship_armor 		= { Leadership = 99, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1942, Attribute = "" },
	capital_ship_engine 		= { Leadership = 99, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	capitalship_armament 		= { Leadership = 99, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1942, Attribute = "" },

	fast_battleship 		= { Leadership = 99, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1942, Attribute = "" },
	coastal_battleship 		= { Leadership = 99, Priority = 0.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1900, Attribute = "" },

	escort_carrier_technology 	= { Leadership = 99, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	carrier_technology 		= { Leadership = 99, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	deck_armor 			= { Leadership = 99, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	cag_development 		= { Leadership = 99, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

	cag_air_focus 			= { Leadership = 99, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	cag_land_focus 			= { Leadership = 99, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	cag_naval_focus 		= { Leadership = 99, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

	-- Bombers folder

	twin_engine_aircraft_design 	= { Leadership = 10, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	twin_engine_airframe 		= { Leadership = 10, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	medium_fueltank 		= { Leadership = 10, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	twin_engine_aircraft_armament 	= { Leadership = 10, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "" },
	medium_bomb 			= { Leadership = 10, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	air_launched_torpedo 		= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "Naval" },

	nav_development 		= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
	basic_strategic_bomber 		= { Leadership = 99, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

	four_engine_airframe 		= { Leadership = 99, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	large_fueltank 			= { Leadership = 99, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	cargo_hold 			= { Leadership = 99, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "" },

	strategic_bomber_armament 	= { Leadership = 99, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "" },
	large_bomb 			= { Leadership = 99, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },

	medium_airsearch_radar 		= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.20, EndYear = 1999, Attribute = "" },
	medium_navagation_radar 	= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "" },
	large_airsearch_radar 		= { Leadership = 18, Priority = 0.30, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	large_navagation_radar 		= { Leadership = 18, Priority = 0.30, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

	-- Fighters folder

	single_engine_aircraft_design 	= { Leadership =  7, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	single_engine_airframe 		= { Leadership =  7, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	aeroengine 			= { Leadership =  7, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	small_fueltank 			= { Leadership =  7, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	single_engine_aircraft_armament = { Leadership =  7, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	small_bomb 			= { Leadership =  7, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },

	cas_development 		= { Leadership =  7, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	multi_role_fighter_development 	= { Leadership = 12, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "" },

	advanced_aircraft_design 	= { Leadership =  7, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	rocket_interceptor_tech 	= { Leadership = 99, Priority = 0.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1900, Attribute = "" },
	jet_engine 			= { Leadership = 99, Priority = 0.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1900, Attribute = "" },

	drop_tanks 			= { Leadership = 12, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "" },

	small_airsearch_radar 		= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	small_navagation_radar 		= { Leadership = 18, Priority = 0.30, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

	escort_fighter_development 	= { Leadership = 18, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	escort_fighter_armament		= { Leadership = 18, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	escort_fighter_drop_tanks 	= { Leadership = 18, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

	-- Industry folder

	synthetic_oil_development 	= { Leadership = 12, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Oil" },
	oil_to_coal_conversion 		= { Leadership = 12, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Oil" },
	oil_refinning 			= { Leadership = 12, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Fuel" },
	steel_production 		= { Leadership = 10, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Metals" },
	raremetal_refinning_techniques 	= { Leadership = 10, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Rares" },
	coal_processing_technologies 	= { Leadership = 10, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Energy" },

	construction_engineering 	= { Leadership =  0, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	advanced_construction_engineering = { Leadership = 0, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

	industral_production 		= { Leadership =  7, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Resources" },
	industral_efficiency 		= { Leadership =  5, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

	civil_nuclear_research 		= { Leadership = 99, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "CivilNuclear" },
	prefab_ports 			= { Leadership = 99, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },

	first_aid 			= { Leadership =  5, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	combat_medicine 		= { Leadership =  5, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	agriculture			= { Leadership =  3, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	education 			= { Leadership =  0, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

	supply_production 		= { Leadership =  5, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	heavy_aa_guns 			= { Leadership =  7, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "" },

	electronic_mechanical_egineering = { Leadership = 7, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "" },
	radio_technology 		= { Leadership =  7, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "" },
	radio_detection_equipment 	= { Leadership = 12, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	radio 				= { Leadership =  7, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	radar 				= { Leadership =  7, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "" },

	census_tabulation_machine 	= { Leadership =  7, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "" },
	mechnical_computing_machine 	= { Leadership =  7, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "" },
	decryption_machine 		= { Leadership = 12, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "" },
	encryption_machine 		= { Leadership = 12, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "" },
	electronic_computing_machine 	= { Leadership = 99, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

	-- Secret Weapons folder

	strategic_rocket_development 	= { Leadership = 99, Priority = 0.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1900, Attribute = "" },
	flyingbomb_development 		= { Leadership = 99, Priority = 0.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1900, Attribute = "" },
	flyingrocket_development 	= { Leadership = 99, Priority = 0.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1900, Attribute = "" },
	strategicrocket_engine 		= { Leadership = 99, Priority = 0.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1900, Attribute = "" },
	strategicrocket_warhead 	= { Leadership = 99, Priority = 0.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1900, Attribute = "" },
	strategicrocket_structure 	= { Leadership = 99, Priority = 0.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1900, Attribute = "" },

	radar_guided_missile 		= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	radar_guided_bomb		= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	electric_powered_torpedo 	= { Leadership = 12, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
	proximity_fuse 			= { Leadership = 12, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	rocket_launcher 		= { Leadership = 18, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	sam 				= { Leadership = 99, Priority = 0.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	aam 				= { Leadership = 99, Priority = 0.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

	helecopters 			= { Leadership = 18, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	medical_evacuation 		= { Leadership = 18, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	pilot_rescue 			= { Leadership = 18, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	jet_interceptor_development 	= { Leadership = 99, Priority = 0.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1900, Attribute = "" },
	jet_bomber_development 		= { Leadership = 99, Priority = 0.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1900, Attribute = "" },
	jet_multi_role_development 	= { Leadership = 99, Priority = 0.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1900, Attribute = "" },
	da_bomb 			= { Leadership = 99, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

	-- Theory folder

	naval_engineering_research 	= { Leadership = 10, Priority = 0.30, EarlyOffset = 0.00, LateOffset = 0.10, EndYear = 1999, Attribute = "Naval" },
	submarine_engineering_research 	= { Leadership = 10, Priority = 0.30, EarlyOffset = 0.00, LateOffset = 0.10, EndYear = 1999, Attribute = "Naval" },

	supply_transportation 		= { Leadership =  3, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	supply_organisation 		= { Leadership =  3, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	civil_defence 			= { Leadership =  5, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

	rocket_science_research 	= { Leadership = 99, Priority = 0.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1900, Attribute = "" },
	rocket_tests 			= { Leadership = 18, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	rocket_engine 			= { Leadership = 99, Priority = 0.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1900, Attribute = "" },
	theorical_jet_engine 		= { Leadership = 99, Priority = 0.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1900, Attribute = "" },

	infantry_research 		= { Leadership =  5, Priority = 0.30, EarlyOffset = 0.00, LateOffset = 0.10, EndYear = 1999, Attribute = "" },
	artillery_research 		= { Leadership =  7, Priority = 0.30, EarlyOffset = 0.00, LateOffset = 0.10, EndYear = 1999, Attribute = "" },
	mobile_research 		= { Leadership = 99, Priority = 0.30, EarlyOffset = 0.00, LateOffset = 0.10, EndYear = 1999, Attribute = "" },
	automotive_research 		= { Leadership = 10, Priority = 0.30, EarlyOffset = 0.00, LateOffset = 0.10, EndYear = 1999, Attribute = "" },

	grand_battleplan_research 	= { Leadership =  7, Priority = 0.30, EarlyOffset = 0.00, LateOffset = 0.10, EndYear = 1999, Attribute = "GrandBattlePlan" },
	spearhead_research 		= { Leadership =  7, Priority = 0.30, EarlyOffset = 0.00, LateOffset = 0.10, EndYear = 1999, Attribute = "Blitzkrieg" },
	superior_firepower_research 	= { Leadership =  7, Priority = 0.30, EarlyOffset = 0.00, LateOffset = 0.10, EndYear = 1999, Attribute = "SuperiorFirepower" },
	human_wave_research 		= { Leadership =  7, Priority = 0.30, EarlyOffset = 0.00, LateOffset = 0.10, EndYear = 1999, Attribute = "HumanWave" },

	aeronautic_engineering_research = { Leadership = 10, Priority = 0.30, EarlyOffset = 0.00, LateOffset = 0.10, EndYear = 1999, Attribute = "" },
	jetengine_research 		= { Leadership = 99, Priority = 0.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1900, Attribute = "" },

	mechanicalengineering_research 	= { Leadership = 10, Priority = 0.30, EarlyOffset = 0.00, LateOffset = 0.10, EndYear = 1999, Attribute = "" },
	chemical_engineering_research 	= { Leadership = 10, Priority = 0.30, EarlyOffset = 0.00, LateOffset = 0.10, EndYear = 1999, Attribute = "" },
	electornicegineering_research 	= { Leadership = 12, Priority = 0.30, EarlyOffset = 0.00, LateOffset = 0.10, EndYear = 1999, Attribute = "" },

	nuclear_physics_research 	= { Leadership = 99, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	atomic_research 		= { Leadership = 99, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	nuclear_research 		= { Leadership = 99, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	isotope_seperation 		= { Leadership = 99, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

	-- Land Doctrines folder

	security_training 		= { Leadership =  7, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	infantry_training 		= { Leadership =  0, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	artillery_training 		= { Leadership =  5, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	tank_crew_training 		= { Leadership = 10, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "" },
	special_forces_training 	= { Leadership =  7, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.35, EndYear = 1999, Attribute = "" },
	officer_training		= { Leadership =  5, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.40, EndYear = 1999, Attribute = "" },

	firepower_1930 			= { Leadership =  3, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	firepower_1937 			= { Leadership =  3, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	firepower_1940 			= { Leadership =  3, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	firepower_1943 			= { Leadership =  3, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	firepower_1946 			= { Leadership =  3, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },

	shock_1930 			= { Leadership =  3, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	shock_1937 			= { Leadership =  3, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	shock_1940			= { Leadership =  3, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	shock_1943 			= { Leadership =  3, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	shock_1946 			= { Leadership =  3, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },

	infilitration_1930 		= { Leadership =  3, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	infilitration_1937 		= { Leadership =  3, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	infilitration_1940 		= { Leadership =  3, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	infilitration_1943 		= { Leadership =  3, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	infilitration_1946 		= { Leadership =  3, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },

	infantry_support_role_1930 	= { Leadership = 10, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	infantry_support_role_1937	= { Leadership = 10, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	infantry_support_role_1940 	= { Leadership = 10, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	infantry_support_role_1943 	= { Leadership = 10, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	infantry_support_role_1946 	= { Leadership = 10, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },

	schwerpunkt_1930 		= { Leadership = 10, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	schwerpunkt_1937 		= { Leadership = 10, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	schwerpunkt_1940 		= { Leadership = 10, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	schwerpunkt_1943		= { Leadership = 10, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	schwerpunkt_1946 		= { Leadership = 10, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },

	combined_arms_1930 		= { Leadership = 10, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	combined_arms_1937 		= { Leadership = 10, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	combined_arms_1940 		= { Leadership = 10, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	combined_arms_1943 		= { Leadership = 10, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	combined_arms_1946 		= { Leadership = 10, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },

	-- Operation Doctrines folder

	great_war_experience 		= { Leadership =  3, Priority = 1.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

	grand_battle_plan_1930 		= { Leadership =  3, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	grand_battle_plan_1937 		= { Leadership =  5, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	grand_battle_plan_1940 		= { Leadership =  5, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	grand_battle_plan_1943 		= { Leadership =  5, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	grand_battle_plan_1946 		= { Leadership =  5, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },

	blitzkrieg_1930 		= { Leadership =  3, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	blitzkrieg_1937 		= { Leadership =  5, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	blitzkrieg_1940 		= { Leadership =  5, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	blitzkrieg_1943 		= { Leadership =  5, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	blitzkrieg_1946 		= { Leadership =  5, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },

	superior_firepower_1930 	= { Leadership =  3, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	superior_firepower_1937 	= { Leadership =  5, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	superior_firepower_1940 	= { Leadership =  5, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	superior_firepower_1943 	= { Leadership =  5, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	superior_firepower_1946 	= { Leadership =  5, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },

	human_wave_1930 		= { Leadership =  3, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	human_wave_1937 		= { Leadership =  3, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	human_wave_1940 		= { Leadership =  5, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	human_wave_1943 		= { Leadership =  5, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	human_wave_1946 		= { Leadership =  5, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },

	mechanized_wave_1942 		= { Leadership =  5, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
	mechanized_wave_1945 		= { Leadership =  5, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },

	-- Naval Doctrines folder

	destroyer_crew_training 	= { Leadership =  7, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	capital_ship_crew_training 	= { Leadership = 18, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	submarine_crew_training 	= { Leadership =  7, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	cruiser_crew_training 		= { Leadership =  7, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	carrier_crew_training 		= { Leadership = 99, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

	fire_control_system_training 	= { Leadership =  7, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	radar_training 			= { Leadership = 12, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	commander_decision_making 	= { Leadership =  7, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	night_equipment_training 	= { Leadership = 12, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

	underway_repleshment 		= { Leadership = 12, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	base_operations 		= { Leadership = 12, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

	sealane_control 		= { Leadership = 10, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	battleship_taskforce_doctrine 	= { Leadership = 99, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	battleline_cruiser_doctrine 	= { Leadership = 99, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	carrier_escort_role_doctrine 	= { Leadership = 99, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	asw_tactics 			= { Leadership = 10, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

	sealane_interdiction 		= { Leadership = 10, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	independent_battleship_operations = { Leadership = 99, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	independent_cruiser_operations 	= { Leadership = 99, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	independent_destroyer_operations = { Leadership = 99, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	trade_interdiction_submarine_doctrine = { Leadership = 10, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

	force_projection 		= { Leadership = 99, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	carrier_taskforce_doctrine 	= { Leadership = 99, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	cruiser_escort_doctrine 	= { Leadership = 99, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	fleet_escort_destroyer_doctrine = { Leadership = 99, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	fleet_submarine_doctrine 	= { Leadership = 99, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

	-- Air Doctrines folder

	fighter_pilot_training 		= { Leadership =  7, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	cas_pilot_training 		= { Leadership =  7, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	bomber_pilot_training 		= { Leadership = 10, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	cag_pilot_training 		= { Leadership = 99, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },

	fighter_groundcrew_training 	= { Leadership =  7, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	cas_groundcrew_training 	= { Leadership =  7, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	bomber_groundcrew_training 	= { Leadership = 10, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

	night_mission_training 		= { Leadership = 12, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

	army_aviation_doctrine 		= { Leadership =  7, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.15, EndYear = 1999, Attribute = "" },
	ground_attack_tactics 		= { Leadership =  7, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	forward_air_control 		= { Leadership =  7, Priority = 0.30, EarlyOffset = 0.00, LateOffset = 0.10, EndYear = 1999, Attribute = "" },
	battlefield_interdiction 	= { Leadership =  7, Priority = 0.30, EarlyOffset = 0.00, LateOffset = 0.10, EndYear = 1999, Attribute = "" },
	army_air_command 		= { Leadership =  7, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

	fighter_defense_doctrine 	= { Leadership =  7, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.15, EndYear = 1999, Attribute = "" },
	interception_tactics 		= { Leadership =  7, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	bomber_targerting_focus 	= { Leadership =  7, Priority = 0.30, EarlyOffset = 0.00, LateOffset = 0.10, EndYear = 1999, Attribute = "" },
	fighter_targerting_focus 	= { Leadership =  7, Priority = 0.30, EarlyOffset = 0.00, LateOffset = 0.10, EndYear = 1999, Attribute = "" },
	fighter_ground_control 		= { Leadership = 12, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

	independent_airforce_doctrine 	= { Leadership = 10, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.15, EndYear = 1999, Attribute = "" },
	interdiction_tactics 		= { Leadership = 10, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	installation_strike_tactics 	= { Leadership = 10, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	tactical_air_command 		= { Leadership = 10, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

	strategic_airforce_doctrine 	= { Leadership = 99, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.15, EndYear = 1999, Attribute = "" },
	airborne_assault_tactics 	= { Leadership = 99, Priority = 0.30, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	strategic_bombardment_tactics 	= { Leadership = 99, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
	strategic_air_command 		= { Leadership = 99, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

	naval_aviation_doctrine 	= { Leadership = 99, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.15, EndYear = 1999, Attribute = "Naval" },
	portstrike_tactics 		= { Leadership = 99, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
	navalstrike_tactics 		= { Leadership = 99, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" },
	naval_tactics 			= { Leadership = 99, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "Naval" }
}



---------------------------------------------------------------
-- Processes the main tech reasearch for the specified country
---------------------------------------------------------------

function Process_Tech( pYear, ResearchSlotsAllowed, ResearchSlotsNeeded, ai, minister, ministerCountry )
	-- Performance check, exit if there are no slots available

	if ResearchSlotsNeeded <= 0 then
		return
	end
	
	-- SSmith (13/07/2013)
	-- I am re-designing this from first principles because it really doesn't work well enough
	-- No amount of effort is going to fix the old code!

	local ministerTag = minister:GetCountryTag()
	local ministerTagString = tostring(ministerTag)
	local ministerTech = ministerCountry:GetTechnologyStatus()
	local liLeadership = ministerCountry:GetTotalLeadership():Get()
	local liTotalIC = minister:GetCountry():GetTotalIC()
	local liPorts = ministerCountry:GetNumOfPorts()
	local liAirfields = ministerCountry:GetNumOfAirfields()

	local tagString = "XXX"
	if ministerTagString == tagString then
		Utils.LUA_DEBUGOUT("Research: " .. tagString)
		Utils.LUA_DEBUGOUT("Year: " .. tostring(pYear))
		Utils.LUA_DEBUGOUT("Allowed:" .. tostring(ResearchSlotsAllowed))
		Utils.LUA_DEBUGOUT("Needed:" .. tostring(ResearchSlotsNeeded))
		Utils.LUA_DEBUGOUT("")
	end

	-- Declare the tech folder mappings
	-- This table will be used to map in-game tech folders to tech groups used in this function

	local laTechFolders = {
		infantry_folder = { Index = _RESEARCH_LAND_ },
		armour_folder = { Index = _RESEARCH_LAND_ },
		land_doctrine_folder = { Index = _RESEARCH_LAND_ },
		operational_doctrine_folder = { Index = _RESEARCH_LAND_ },
		fighter_folder = { Index = _RESEARCH_AIR_ },
		bomber_folder = { Index = _RESEARCH_AIR_ },
		air_doctrine_folder = { Index = _RESEARCH_AIR_ },
		smallship_folder = { Index = _RESEARCH_NAVAL_ },
		capitalship_folder = { Index = _RESEARCH_NAVAL_ },
		naval_doctrine_folder = { Index = _RESEARCH_NAVAL_ },
		industry_folder = { Index = _RESEARCH_OTHER_ },
		secretweapon_folder = { Index = _RESEARCH_OTHER_ },
		theory_folder = { Index = _RESEARCH_OTHER_ }
	}

	-- Declare the tech groups
	-- This table will hold the weighting for each group and the ideal/used number of research slots

	local laTechGroups = {}
	for i = 1, _RESEARCH_OTHER_ do
		laTechGroups[i] = { Weight = 0, IdealSlots = 0, UsedSlots = 0, NeededSlots = 0 }
	end

	-- The tech weights will be obtained from the country script or from the generic function
	-- Weight system % based 1.0 = 100%

	local laTechWeights = {}
	if Utils.HasCountryAIFunction(ministerTag, "TechWeights") then
		-- Has specific distribution from specific script
		laTechWeights = Utils.CallCountryAI(ministerTag, "TechWeights", minister)
	else
		-- Use default function
		laTechWeights = Get_TechWeights(minister)
	end
	for i = 1, _RESEARCH_OTHER_ do
		laTechGroups[i].Weight = laTechWeights[i]
	end

	if ministerTagString == tagString then
		for i = 1, _RESEARCH_OTHER_  do
			Utils.LUA_DEBUGOUT("Base Weight " .. tostring(i) .. ": " .. tostring(laTechGroups[i].Weight))
		end
		Utils.LUA_DEBUGOUT("")
	end

	-- We will allow air research if we are a developed country (10 IC) and we have an airfield or still lack the means to construct one
	
	-- SSmith (29/09/2013)
	-- We will also allow air research if we have at least 8 leadership (because that indicates that we are a developed country)

	local lbIsAir = false
	if liTotalIC >= 10 or liLeadership >= 8 then
		if liAirfields > 0 or ministerTech:GetLevel(CTechnologyDataBase.GetTechnology("single_engine_aircraft_design")) < 1 then
			lbIsAir = true
		end
	end

	-- We will enable naval research if we are a developed country (10 IC) or if we haven't yet researched ship construction

	-- SSmith (29/09/2013)
	-- We will also allow naval research if we have at least 8 leadership (because that indicates that we are a developed country)

	local lbIsNaval = false
	if liPorts > 0 then
		if liTotalIC >= 10 or liLeadership >= 8 or ministerTech:GetLevel(CTechnologyDataBase.GetTechnology("const_material")) < 1 then
			lbIsNaval = true

			-- We will cut the naval allocation by half if we haven't got any basic design principles yet

			if ministerTech:GetLevel(CTechnologyDataBase.GetTechnology("destroyer_technology")) < 1
			and ministerTech:GetLevel(CTechnologyDataBase.GetTechnology("lightcruiser_technology")) < 1 then
				laTechGroups[_RESEARCH_NAVAL_].Weight = laTechGroups[_RESEARCH_NAVAL_].Weight * 0.5
			end
		end
	end

	-- We will now adjust the weights for countries that can't research air or naval techs

	if (not lbIsAir) or (not lbIsNaval) then
		local totalweight = 0
		for i = 1, _RESEARCH_OTHER_ do
			if (not lbIsAir) and i == _RESEARCH_AIR_ then
				laTechGroups[i].Weight = 0
			elseif (not lbIsNaval) and i == _RESEARCH_NAVAL_ then
				laTechGroups[i].Weight = 0
			end
			totalweight = totalweight + laTechGroups[i].Weight
		end
		
		for i = 1, _RESEARCH_OTHER_ do
			laTechGroups[i].Weight = laTechGroups[i].Weight * (1 / totalweight)
		end
	end

	-- The ideal spread of research slots can now be calculated
	
	for i = 1, _RESEARCH_OTHER_ do
		laTechGroups[i].IdealSlots = ResearchSlotsAllowed * laTechGroups[i].Weight
	end

	-- Now load the current research counts

	local techFolder
	local index
	for tech in ministerCountry:GetCurrentResearch() do
		techFolder = tostring(tech:GetFolder():GetKey())
		if not (laTechFolders[techFolder] == nil) then
			index = laTechFolders[techFolder].Index
			laTechGroups[index].UsedSlots = laTechGroups[index].UsedSlots + 1
		end
	end

	-- Now calculate the number of slots needed for each tech group

	for i = 1, _RESEARCH_OTHER_  do
		laTechGroups[i].NeededSlots = laTechGroups[i].IdealSlots - laTechGroups[i].UsedSlots
	end

	if ministerTagString == tagString then
		for i = 1, _RESEARCH_OTHER_  do
			Utils.LUA_DEBUGOUT("Weight " .. tostring(i) .. ": " .. tostring(laTechGroups[i].Weight))
			Utils.LUA_DEBUGOUT("IdealSlots " .. tostring(i) .. ": " .. tostring(laTechGroups[i].IdealSlots))
			Utils.LUA_DEBUGOUT("UsedSlots " .. tostring(i) .. ": " .. tostring(laTechGroups[i].UsedSlots))
			Utils.LUA_DEBUGOUT("NeededSlots " .. tostring(i) .. ": " .. tostring(laTechGroups[i].NeededSlots))
			Utils.LUA_DEBUGOUT("")
		end
		Utils.LUA_DEBUGOUT("Operational Doctrine: " .. CheckOperationalDoctrine(ministerCountry))
		Utils.LUA_DEBUGOUT("Armour Doctrine: " .. CheckArmourDoctrine(ministerCountry))
		Utils.LUA_DEBUGOUT("")
	end

	-- Call country-specific code to get any tech parameter overrides
	-- Store them in a local table

	local laCountryParams = {}
	if Utils.HasCountryAIFunction(ministerTag, "Get_TechParams") then
		laCountryParams = Utils.CallCountryAI(ministerTag, "Get_TechParams", minister)
	end

	-- Declare a working table to hold tech parameters

	local laTechParams = { Leadership = 0, Priority = 0.00, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" }

	-- Declare a table to hold the techs accepted as research candidates

	local laTechLists = {}
	for i = 1, _RESEARCH_OTHER_ do
		laTechLists[i] = {}
	end

	-- Figure out what the AI can research
	for tech in CTechnologyDataBase.GetTechnologies() do
		if minister:CanResearch(tech) and tech:IsValid() then

			-- First get the tech folder and check that it's valid

			techFolder = tostring(tech:GetFolder():GetKey())
			if not (laTechFolders[techFolder] == nil) then

				index = laTechFolders[techFolder].Index
				local techName = tostring(tech:GetKey())

				if not (p_TechParams[techName] == nil) then

					-- There are global parameters for this tech

					laTechParams.Leadership = p_TechParams[techName].Leadership
					laTechParams.Priority = p_TechParams[techName].Priority
					laTechParams.EarlyOffset = p_TechParams[techName].EarlyOffset
					laTechParams.LateOffset = p_TechParams[techName].LateOffset
					laTechParams.EndYear = p_TechParams[techName].EndYear
					laTechParams.Attribute = p_TechParams[techName].Attribute
				else
					-- There are no global parameters so use the defaults

					laTechParams.Leadership = p_TechParams["default"].Leadership
					laTechParams.Priority = p_TechParams["default"].Priority
					laTechParams.EarlyOffset = p_TechParams["default"].EarlyOffset
					laTechParams.LateOffset = p_TechParams["default"].LateOffset
					laTechParams.EndYear = p_TechParams["default"].EndYear
					laTechParams.Attribute = p_TechParams["default"].Attribute
				end

				if not (laCountryParams[techName] == nil) then

					-- There are country-specific overrides so we use them instead

					laTechParams.Leadership = laCountryParams[techName].Leadership
					laTechParams.Priority = laCountryParams[techName].Priority
					laTechParams.EarlyOffset = laCountryParams[techName].EarlyOffset
					laTechParams.LateOffset = laCountryParams[techName].LateOffset
					laTechParams.EndYear = laCountryParams[techName].EndYear
					laTechParams.Attribute = laCountryParams[techName].Attribute
				end

				-- We will code for the early or late offset parameters being zero and default them here if they are

				if laTechParams.EarlyOffset < 0.01 then
					laTechParams.EarlyOffset = 1.0
				end
				if laTechParams.LateOffset < 0.01 then
					laTechParams.LateOffset = laTechParams.Priority * 0.5
				end

				-- A number of conditions that must be met before we accept a tech as a candidate for research
				
	 			if liLeadership >= laTechParams.Leadership			-- We have the requisite leadership
				and pYear <= laTechParams.EndYear				-- We haven't passed the end year
				and laTechGroups[index].Weight > 0				-- We want to research this tech group
				then
					-- The default priority will be adjusted if we are researching ahead of or behind time
					-- We will cap the priority bonus at 4 years behind time (with much smaller adjustments for older techs)

					local liTechLevel = ministerTech:GetLevel(tech) + 1
					local liTechYear = ministerTech:GetYear(tech, liTechLevel)

					local liYearDiff = pYear - liTechYear

					if liYearDiff > 0 then
						laTechParams.Priority = laTechParams.Priority + (math.min((liYearDiff), 4) * laTechParams.LateOffset)

						-- Techs more than 4 years old
						liYearDiff = liYearDiff - 4
						if liYearDiff > 0 then
							laTechParams.Priority = laTechParams.Priority + (math.min((liYearDiff), 4) * laTechParams.LateOffset * 0.25)
						end

						-- Techs more than 8 years old
						liYearDiff = liYearDiff - 4
						if liYearDiff > 0 then
							laTechParams.Priority = laTechParams.Priority + (math.min((liYearDiff), 10) * laTechParams.LateOffset * 0.10)
						end

					elseif liYearDiff < 0 then
						laTechParams.Priority = laTechParams.Priority + ((liYearDiff) * laTechParams.EarlyOffset)
					end

					-- Here we will check any special rules that are required for this tech

					if laTechParams.Attribute == "Naval" then

						-- We only research these techs if we have ports

						if liPorts < 1 then
							laTechParams.Priority = 0
						end

					-- SSmith (10/09/2013)
					-- Logic added for resource-based technologies

					elseif laTechParams.Attribute == "Resources" then

						-- We only research these techs if we have sufficient industrial resources

						-- Check Rare Materials
						local liCurrentStockpile = ministerCountry:GetPool():Get( CGoodsPool._RARE_MATERIALS_ ):Get()
						local liIdealStockpile = Support.GetEffectiveResourceLimit( ministerCountry, CGoodsPool._RARE_MATERIALS_ )

						if (liCurrentStockpile < (liIdealStockpile * 0.25)) then
							laTechParams.Priority = 0
						else
							-- Check Metals
							liCurrentStockpile = ministerCountry:GetPool():Get( CGoodsPool._METAL_ ):Get()
							liIdealStockpile = Support.GetEffectiveResourceLimit( ministerCountry, CGoodsPool._METAL_ )

							if (liCurrentStockpile < (liIdealStockpile * 0.25)) then
								laTechParams.Priority = 0
							else
								-- Check Energy
								liCurrentStockpile = ministerCountry:GetPool():Get( CGoodsPool._ENERGY_ ):Get()
								liIdealStockpile = Support.GetEffectiveResourceLimit( ministerCountry, CGoodsPool._ENERGY_ )

								if (liCurrentStockpile < (liIdealStockpile * 0.25)) then
									laTechParams.Priority = 0
								end
							end
						end

					elseif laTechParams.Attribute == "Energy" then

						-- We research these techs depending on our energy situation

						local liCurrentStockpile = ministerCountry:GetPool():Get( CGoodsPool._ENERGY_ ):Get()
						local liIdealStockpile = Support.GetEffectiveResourceLimit( ministerCountry, CGoodsPool._ENERGY_ )

						if (liCurrentStockpile > (liIdealStockpile * 0.5)) then
							laTechParams.Priority = 0
						end

					elseif laTechParams.Attribute == "Metals" then

						-- We research these techs depending on our metals situation

						local liCurrentStockpile = ministerCountry:GetPool():Get( CGoodsPool._METAL_ ):Get()
						local liIdealStockpile = Support.GetEffectiveResourceLimit( ministerCountry, CGoodsPool._METAL_ )

						if (liCurrentStockpile > (liIdealStockpile * 0.5)) then
							laTechParams.Priority = 0
						end

					elseif laTechParams.Attribute == "Rares" then

						-- We research these techs depending on our rares situation

						local liCurrentStockpile = ministerCountry:GetPool():Get( CGoodsPool._RARE_MATERIALS_ ):Get()
						local liIdealStockpile = Support.GetEffectiveResourceLimit( ministerCountry, CGoodsPool._RARE_MATERIALS_ )

						if (liCurrentStockpile > (liIdealStockpile * 0.5)) then
							laTechParams.Priority = 0
						end

					elseif laTechParams.Attribute == "Oil" then

						-- We research these techs depending on our oil situation

						local liCurrentStockpile = ministerCountry:GetPool():Get( CGoodsPool._CRUDE_OIL_):Get()
						local liIdealStockpile = Support.GetEffectiveResourceLimit( ministerCountry, CGoodsPool._CRUDE_OIL_)

						if (liCurrentStockpile > (liIdealStockpile * 0.5)) then
							laTechParams.Priority = 0
						end

					elseif laTechParams.Attribute == "Fuel" then

						-- We research these techs depending on our fuel situation

						local liCurrentStockpile = ministerCountry:GetPool():Get( CGoodsPool._FUEL_):Get()
						local liIdealStockpile = Support.GetEffectiveResourceLimit( ministerCountry, CGoodsPool._FUEL_)

						if (liCurrentStockpile > (liIdealStockpile * 0.5)) then
							laTechParams.Priority = 0
						end

					elseif laTechParams.Attribute == "InfantryTank" then

						-- We research infantry tank techs depending on our armour doctrine

						if CheckArmourDoctrine(ministerCountry) ~= "infantry_support_role" then
							laTechParams.Priority = 0
						end

					elseif laTechParams.Attribute == "LightTank" then

						-- We research light tank techs depending on our armour doctrine

						local lsDoctrine = CheckArmourDoctrine(ministerCountry)
						if lsDoctrine ~= "infantry_support_role" then
							if lsDoctrine == "" or pYear > 1939 then
								laTechParams.Priority = 0
							end
						end

					elseif laTechParams.Attribute == "MediumTank" then

						-- We research medium tank techs depending on our armour doctrine

						local lsDoctrine = CheckArmourDoctrine(ministerCountry)
						if lsDoctrine ~= "schwerpunkt" and lsDoctrine ~= "combined_arms" then
							laTechParams.Priority = 0
						end

					elseif laTechParams.Attribute == "HeavyTank" then

						-- We research heavy tank techs depending on our armour doctrine

						local lsDoctrine = CheckArmourDoctrine(ministerCountry)
						if lsDoctrine == "schwerpunkt" or lsDoctrine == "combined_arms" then
							if pYear < 1938 then
								laTechParams.Priority = 0
							end								
						else
							laTechParams.Priority = 0
						end

					elseif laTechParams.Attribute == "GrandBattlePlan" then

						-- We only research these techs if we use Grand Battle Plan doctrine

						if CheckOperationalDoctrine(ministerCountry) ~= "grand_battle_plan" then
							laTechParams.Priority = 0
						end

					elseif laTechParams.Attribute == "Blitzkrieg" then

						-- We only research these techs if we use Blitzkrieg doctrine

						if CheckOperationalDoctrine(ministerCountry) ~= "blitzkrieg" then
							laTechParams.Priority = 0
						end

					elseif laTechParams.Attribute == "SuperiorFirepower" then

						-- We only research these techs if we use Superior Firepower doctrine

						if CheckOperationalDoctrine(ministerCountry) ~= "superior_firepower" then
							laTechParams.Priority = 0
						end

					elseif laTechParams.Attribute == "HumanWave" then

						-- We only research these techs if we use Human Wave doctrine

						if CheckOperationalDoctrine(ministerCountry) ~= "human_wave" then
							laTechParams.Priority = 0
						end

					elseif laTechParams.Attribute == "ShipBuilding" then

						-- Unless we are are major power we don't start developing new classes of ship

						if liLeadership < 16 and ministerTech:GetLevel(tech) < 1 then
							laTechParams.Priority = 0
						end

					elseif laTechParams.Attribute == "CivilNuclear" then

						-- We only research civil nuclear to level 4

						if ministerTech:GetLevel(tech) > 3 then
							laTechParams.Priority = 0
						end

					end

					if laTechParams.Priority > 0 then

						-- We are only interested in techs with a positive priority
						-- techPair is the array of a tech and its research priority
						-- We will add a random factor between 0 and 0.5 to each priority

						local techPair = { tech, laTechParams.Priority + (math.random(0,25) * 0.01) }
						table.insert(laTechLists[index], techPair)

						if ministerTagString == tagString then
							if techName == "xsmallarms_technology"
							or techName == "xsupport_weapon_technology"
							or techName == "xlight_artillery_technology" then
								Utils.LUA_DEBUGOUT("Tech: " .. techName)
								Utils.LUA_DEBUGOUT("Leadership: " .. tostring(laTechParams.Leadership))
								Utils.LUA_DEBUGOUT("Priority: " .. tostring(laTechParams.Priority))
								Utils.LUA_DEBUGOUT("EarlyOffset: " .. tostring(laTechParams.EarlyOffset))
								Utils.LUA_DEBUGOUT("LateOffset: " .. tostring(laTechParams.LateOffset))
								Utils.LUA_DEBUGOUT("EndYear: " .. tostring(laTechParams.EndYear))
								Utils.LUA_DEBUGOUT("Attribute: " .. tostring(laTechParams.Attribute))
							end
							Utils.LUA_DEBUGOUT("Accepted: " .. techName .. "   Index: " .. tostring(index) .. "   Priority: " .. tostring(laTechParams.Priority))
						end
					else
						-- This tech is not required
						if ministerTagString == tagString then
							Utils.LUA_DEBUGOUT("Declined: " .. techName)
						end
					end
				else
					-- This tech has not met the pre-conditions
					if ministerTagString == tagString then
						Utils.LUA_DEBUGOUT("Rejected: " .. techName)
					end
				end
			else
				-- This tech is not valid
				if ministerTagString == tagString then
					Utils.LUA_DEBUGOUT("Invalid: " .. tostring(tech:GetKey()))
				end
			end
		end
	end

	if ministerTagString == tagString then
		Utils.LUA_DEBUGOUT("")
		for i = 1, _RESEARCH_OTHER_ do
			Utils.LUA_DEBUGOUT("Table[" .. tostring(i) .. "]: " .. tostring(table.getn(laTechLists[i])))
			for j = 1, table.getn(laTechLists[i]) do
				Utils.LUA_DEBUGOUT(tostring(laTechLists[i][j][1]:GetKey()) .. ": " .. tostring(laTechLists[i][j][2]))
			end
		end
		Utils.LUA_DEBUGOUT("")
	end

	-- All available techs have now been added to the lists table
	-- Now we must actually do the research
	-- This will be done in 3 stages...
	-- 1. Any tech group wanting a full slot will be serviced
	-- 2. Any tech groups remaining that still need a partial slot will be serviced randomly as long as there are spare slots available
	-- 3. Any free slots will be utilised by picking a random tech group according to its weight

	-- Step 1
	-- First we will create a table holding an entry for every full research slot we need

	local laSlotsNeeded = {}
	for i = 1, _RESEARCH_OTHER_ do
		while laTechGroups[i].NeededSlots >= 1 do
			table.insert(laSlotsNeeded, i)
			laTechGroups[i].NeededSlots = laTechGroups[i].NeededSlots - 1
		end
	end

	if ministerTagString == tagString then
		for i = 1, table.getn(laSlotsNeeded) do
			Utils.LUA_DEBUGOUT(tostring(laSlotsNeeded[i]))
		end
		Utils.LUA_DEBUGOUT("")
	end

	-- We will research until the table is empty

	local row
	while table.getn(laSlotsNeeded) > 0 do
		row = math.random(table.getn(laSlotsNeeded))
		index = laSlotsNeeded[row]

		if ministerTagString == tagString then
			Utils.LUA_DEBUGOUT("Researching: " .. tostring(row) .. " " .. tostring(index))
		end

		if table.getn(laTechLists[index]) < 1 then
			-- The tech list for this group is empty
			laTechGroups[index].NeededSlots = 0

			if ministerTagString == tagString then
				Utils.LUA_DEBUGOUT("Empty list...")
			end
		else
			-- Research the highest priority tech
			local maxpriority = 0
			local techindex = 0
			for i = 1, table.getn(laTechLists[index]) do
				if laTechLists[index][i][2] > maxpriority then
					maxpriority = laTechLists[index][i][2]
					techindex = i
				end
			end
			if techindex > 0 then
				local command = CStartResearchCommand(ministerTag, laTechLists[index][techindex][1])
				ai:Post(command)

				if ministerTagString == tagString then
					Utils.LUA_DEBUGOUT("Researched... " .. tostring(laTechLists[index][techindex][1]:GetKey()))
				end

				ResearchSlotsNeeded = ResearchSlotsNeeded - 1
				laTechLists[index][techindex][2] = -1
			end
		end
		table.remove(laSlotsNeeded, row)
		if ministerTagString == tagString then
			Utils.LUA_DEBUGOUT("Cleared: " .. tostring(row) .. " " .. tostring(table.getn(laSlotsNeeded)))
		end
	end

	if ministerTagString == tagString then
		Utils.LUA_DEBUGOUT("Step 1 completed")
		Utils.LUA_DEBUGOUT("")
	end

	-- Step 2 (only if we still have un-filled research slots)

	if ResearchSlotsNeeded > 0 then

		laSlotsNeeded = {}
		local maxpercent = 0
		for i = 1, _RESEARCH_OTHER_ do
			if laTechGroups[i].NeededSlots > 0.02 then
				table.insert(laSlotsNeeded, i)
				if laTechGroups[i].NeededSlots > maxpercent then
					maxpercent = laTechGroups[i].NeededSlots
				end
			end
		end
		maxpercent = math.ceil(maxpercent * 100)

		if ministerTagString == tagString then
			for i = 1, table.getn(laSlotsNeeded) do
				Utils.LUA_DEBUGOUT(tostring(laSlotsNeeded[i]))
			end
			Utils.LUA_DEBUGOUT("Sum: " .. tostring(maxpercent))
			Utils.LUA_DEBUGOUT("")
		end

		-- We will research until the table is empty or we have no free slots

		while table.getn(laSlotsNeeded) > 0 and ResearchSlotsNeeded > 0 do
			row = math.random(table.getn(laSlotsNeeded))
			index = laSlotsNeeded[row]

			if ministerTagString == tagString then
				Utils.LUA_DEBUGOUT("Testing: " .. tostring(row) .. " " .. tostring(index) .. " " .. tostring(laTechGroups[index].NeededSlots))
			end

			if math.random(maxpercent) < (laTechGroups[index].NeededSlots * 100) or table.getn(laSlotsNeeded) < 2 then

				if ministerTagString == tagString then
					Utils.LUA_DEBUGOUT("Researching: " .. tostring(row) .. " " .. tostring(index))
				end

				if table.getn(laTechLists[index]) < 1 then
					-- The tech list for this group is empty

					if ministerTagString == tagString then
						Utils.LUA_DEBUGOUT("Empty list...")
					end
				else
					-- Research the highest priority tech
					local maxpriority = 0
					local techindex = 0
					for i = 1, table.getn(laTechLists[index]) do
						if laTechLists[index][i][2] > maxpriority then
							maxpriority = laTechLists[index][i][2]
							techindex = i
						end
					end
					if techindex > 0 then
						local command = CStartResearchCommand(ministerTag, laTechLists[index][techindex][1])
						ai:Post(command)

						if ministerTagString == tagString then
							Utils.LUA_DEBUGOUT("Researched... " .. tostring(laTechLists[index][techindex][1]:GetKey()))
						end

						ResearchSlotsNeeded = ResearchSlotsNeeded - 1
						laTechLists[index][techindex][2] = -1
					end
				end
				table.remove(laSlotsNeeded, row)
				if ministerTagString == tagString then
					Utils.LUA_DEBUGOUT("Cleared: " .. tostring(row) .. " " .. tostring(table.getn(laSlotsNeeded)))
				end
			end
		end

		if ministerTagString == tagString then
			Utils.LUA_DEBUGOUT("Step 2 completed")
			Utils.LUA_DEBUGOUT("")
		end

	end

	-- Step 3 (only if we still have un-filled research slots)

	if ResearchSlotsNeeded > 0 then

		laSlotsNeeded = {}
		local maxpercent = 0
		for i = 1, _RESEARCH_OTHER_ do
			if laTechGroups[i].Weight > 0.02 then
				table.insert(laSlotsNeeded, i)
				if laTechGroups[i].Weight > maxpercent then
					maxpercent = laTechGroups[i].Weight
				end
			end
		end
		maxpercent = math.ceil(maxpercent * 100)

		if ministerTagString == tagString then
			for i = 1, table.getn(laSlotsNeeded) do
				Utils.LUA_DEBUGOUT(tostring(laSlotsNeeded[i]))
			end
			Utils.LUA_DEBUGOUT("Sum: " .. tostring(maxpercent))
			Utils.LUA_DEBUGOUT("")
		end

		-- We will research until the table is empty or we have no free slots

		while table.getn(laSlotsNeeded) > 0 and ResearchSlotsNeeded > 0 do
			row = math.random(table.getn(laSlotsNeeded))
			index = laSlotsNeeded[row]

			if ministerTagString == tagString then
				Utils.LUA_DEBUGOUT("Testing: " .. tostring(row) .. " " .. tostring(index) .. " " .. tostring(laTechGroups[index].Weight))
			end

			if math.random(maxpercent) < (laTechGroups[index].Weight * 100) or table.getn(laSlotsNeeded) < 2 then

				if ministerTagString == tagString then
					Utils.LUA_DEBUGOUT("Researching: " .. tostring(row) .. " " .. tostring(index))
				end

				if table.getn(laTechLists[index]) < 1 then
					-- The tech list for this group is empty

					if ministerTagString == tagString then
						Utils.LUA_DEBUGOUT("Empty list...")
					end
				else
					-- Research the highest priority tech
					local maxpriority = 0
					local techindex = 0
					for i = 1, table.getn(laTechLists[index]) do
						if laTechLists[index][i][2] > maxpriority then
							maxpriority = laTechLists[index][i][2]
							techindex = i
						end
					end
					if techindex > 0 then
						local command = CStartResearchCommand(ministerTag, laTechLists[index][techindex][1])
						ai:Post(command)

						if ministerTagString == tagString then
							Utils.LUA_DEBUGOUT("Researched... " .. tostring(laTechLists[index][techindex][1]:GetKey()))
						end

						ResearchSlotsNeeded = ResearchSlotsNeeded - 1
						laTechLists[index][techindex][2] = -1
					end
				end
				table.remove(laSlotsNeeded, row)
				if ministerTagString == tagString then
					Utils.LUA_DEBUGOUT("Cleared: " .. tostring(row) .. " " .. tostring(table.getn(laSlotsNeeded)))
				end
			end
		end


		if ministerTagString == tagString then
			Utils.LUA_DEBUGOUT("Step 3 completed")
			Utils.LUA_DEBUGOUT("")
		end

	end

	if ministerTagString == tagString then
		for i = 1, _RESEARCH_OTHER_ do
			Utils.LUA_DEBUGOUT("Table[" .. tostring(i) .. "]: " .. tostring(table.getn(laTechLists[i])))
			for j = 1, table.getn(laTechLists[i]) do
				Utils.LUA_DEBUGOUT(tostring(laTechLists[i][j][1]:GetKey()) .. ": " .. tostring(laTechLists[i][j][2]))
			end
		end
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("Research completed")
		Utils.LUA_DEBUGOUT("")
	end

end

--- Supporting Functions ---------------------------------------------------------------------------------------------------------------

function CheckArmourDoctrine(ministerCountry)

	-- SSmith (06/08/2013)
	-- This function will check the country flags to find our armour doctrine path

	local laFlags = ministerCountry:GetFlags()
	local laYears = { "46", "43", "40", "37", "30" }
	local doctrine_path = ""

	for i = 1, table.getn(laYears) do
		if doctrine_path == "" then
			if laFlags:IsFlagSet("infantry_support_role_" .. laYears[i]) then
				doctrine_path = "infantry_support_role"
			elseif laFlags:IsFlagSet("schwerpunkt_" .. laYears[i]) then
				doctrine_path = "schwerpunkt"
			elseif laFlags:IsFlagSet("combined_arms_" .. laYears[i]) then
				doctrine_path = "combined_arms"
			end
		end
	end

	return doctrine_path
end

function CheckOperationalDoctrine(ministerCountry)

	-- SSmith (06/08/2013)
	-- This function will check the country flags to find our operational doctrine path

	local laFlags = ministerCountry:GetFlags()
	local laYears = { "46", "45", "43", "42", "40", "37", "30" }
	local doctrine_path = ""

	for i = 1, table.getn(laYears) do
		if doctrine_path == "" then
			if laFlags:IsFlagSet("grand_battle_plan_" .. laYears[i]) then
				doctrine_path = "grand_battle_plan"
			elseif laFlags:IsFlagSet("superior_firepower_" .. laYears[i]) then
				doctrine_path = "superior_firepower"
			elseif laFlags:IsFlagSet("blitzkrieg_" .. laYears[i]) then
				doctrine_path = "blitzkrieg"
			elseif laFlags:IsFlagSet("human_wave_" .. laYears[i]) or laFlags:IsFlagSet("mechanized_wave_" .. laYears[i]) then
				doctrine_path = "human_wave"
			end
		end
	end

	return doctrine_path
end
