--Reference for the index numbers of laws
--
local _OPEN_SOCIETY_ = 1
local _LIMITED_RESTRICTIONS_ = 2
local _LEGALISTIC_RESTRICTIONS_ = 3
local _REPRESSION_ = 4
local _TOTALITARIAN_SYSTEM_ = 5

local _FREE_PRESS_ = 6
local _CENSORED_PRESS_ = 7
local _STATE_PRESS_ = 8
local _PROPAGANDA_PRESS_ = 9

local _FULL_CIVILIAN_ECONOMY_ = 10
local _BASIC_MOBILISATION_ = 11
local _FULL_MOBILISATION_ = 12
local _WAR_ECONOMY_ = 13
local _TOTAL_ECONOMIC_MOBILISATION_ = 14

local _CONSUMER_PRODUCT_ORIENTATION_ = 15
local _MIXED_INDUSTRY_ = 16
local _HEAVY_INDUSTRY_EMPHASIS_ = 17

local _NEGLIGIBLE_TAXES_ = 18
local _SMALL_TAXES_ = 19
local _ACCEPTABLE_TAXES_ = 20
local _HIGH_TAXES_ = 21
local _EXPLOITIVE_TAXES_ = 22

local _VOLUNTEER_ARMY_ = 23
local _ONE_YEAR_DRAFT_ = 24
local _TWO_YEAR_DRAFT_ = 25
local _THREE_YEAR_DRAFT_ = 26
local _SERVICE_BY_REQUIREMENT_ = 27

local _MINIMAL_TRAINING_ = 28
local _BASIC_TRAINING_ = 29
local _ADVANCED_TRAINING_ = 30
local _SPECIALIST_TRAINING_ = 31

local _UNDEVELOPED_MINOR_ = 32
local _DEVELOPED_MEDIUM_ = 33
local _REGIONAL_POWER_ = 34
local _MAJOR_POWER_ = 35
local _GREAT_POWER_ = 36
local _SUPERPOWER_ = 37

local _HEAD_OF_STATE_ = 1
local _HEAD_OF_GOVERNMENT_ = 2
local _FOREIGN_MINISTER_ = 3
local _ARMAMENT_MINISTER_ = 4
local _MINISTER_OF_SECURITY_ = 5
local _MINISTER_OF_INTELLIGENCE_ = 6
local _CHIEF_OF_STAFF_ = 7
local _CHIEF_OF_ARMY_ = 8
local _CHIEF_OF_NAVY_ = 9
local _CHIEF_OF_AIR_ = 10

-- ###################################
-- # Main Method called by the EXE
-- ###################################

function PoliticsMinister_Tick( minister )
	
	if not ( Utils.ASSERT( minister ) )
	then
		return
	end

	--Check laws and ministers in every tick, the functions will only change one anyway.

	HPP_Laws( minister )
	OfficeManagement( minister )
	
	-- SSmith (21/11/2013)
	-- Puppets and liberations don't need to be checked so often

	if math.mod( CCurrentGameState.GetAIRand(), 7) == 0 then
		Mobilization( minister )
	elseif math.mod( CCurrentGameState.GetAIRand(), 14) == 0 then
		local ministerTag = minister:GetCountryTag()
		local ministerCountry = minister:GetCountry()
		Puppets( minister, ministerTag, ministerCountry )
		Liberation( minister:GetOwnerAI(), minister, ministerTag, ministerCountry )
	end
end

-- #####################
-- # Puppets
-- #####################

function Puppets(minister, ministerTag, ministerCountry)
	
	if not ( Utils.ASSERT( minister ) )
	or not ( Utils.ASSERT( ministerTag ) )
	or not ( Utils.ASSERT( ministerCountry ) )
	then
		return
	end
	
	-- SSmith (21/11/2013)
	-- Re-written to allow puppets to be created more freely by democratic/communist governments
	-- At this point I'm still not allowing fascist regimes to release puppets

	if ministerCountry:CanCreatePuppet() and not ministerCountry:IsSubject() then

		-- Certain unlikely countries could cause problems if they started releasing puppets!
		-- So we will just exit the function now and ignore them!

		local ministerTagString = tostring(ministerTag)
		local laIgnoreList = { "DDR", "DFR", "RUS", "RSI", "IND", "KOR", "PRK", "SER" }
		local lbIgnore = false

		local tagString = "XXX"
		if ministerTagString == tagString then
			Utils.LUA_DEBUGOUT("")
			Utils.LUA_DEBUGOUT("Checking puppets: " .. tagString)
		end

		for i = 1, table.getn(laIgnoreList) do
			if ministerTagString == tagString then
				Utils.LUA_DEBUGOUT("Ignoring: " .. laIgnoreList[i])
			end
			if laIgnoreList[i] == ministerTagString then
				lbIgnore = true
				break
			end
		end
		if lbIgnore then
			return
		end

		-- These countries will never be released as puppets
		local laGlobalExceptions = { "ICL", "SCO", "SLO", "ISR", "CGX", "CSX", "CXB", "CYN", "MAN", "MEN", "SIK",
			"CRO", "SER", "BOS", "MAC", "MTN", "SLV", "CAL", "CSA", "SIU", "SIB" }

		-- These countries will not be released by incompatible ideologies
		local laIdeologyExceptions = { }
		local ministerIdeologyGroup = ministerCountry:GetRulingIdeology():GetGroup():GetKey():GetString()
		if ministerIdeologyGroup == "democracy" then
			laIdeologyExceptions = { "GER", "DDR", "SOV", "ITA", "VIC", "SPA", "PRK", "CHC", "NJG" }
		elseif ministerIdeologyGroup == "communism" then
			laIdeologyExceptions = { "GER", "DFR", "ITA", "VIC", "SPA", "KOR", "CHI", "NJG" }
		elseif ministerIdeologyGroup == "fascism" then
			laIdeologyExceptions = { "DDR", "DFR", "SOV", "FRA", "RSI", "SPR", "PRK", "CHC", "NJG" }
			-- For now the fascist ideology group will not release puppets
			return
		end

		-- Call the country-specific AI function for any custom exceptions
		local laCountryExceptions = { }
		if Utils.HasCountryAIFunction( ministerTag, 'HandlePuppets' ) then
			-- Note the called function must return at least 2 elements to be recognised as a list!
			laCountryExceptions = Utils.CallCountryAI( ministerTag, "HandlePuppets", minister )
		end

		local ai = minister:GetOwnerAI()
		for puppetTag in ministerCountry:GetPossiblePuppets() do

			-- Check this puppet is not listed as an exception

			local puppetTagString = tostring(puppetTag)
			local lbOK = true

			if ministerTagString == tagString then
				Utils.LUA_DEBUGOUT("Puppeting: " .. puppetTagString)
			end

			-- Check global exceptions
			for i = 1, table.getn(laGlobalExceptions) do
				if ministerTagString == tagString then
					Utils.LUA_DEBUGOUT("Global exceptions: " .. laGlobalExceptions[i])
				end
				if laGlobalExceptions[i] == puppetTagString then
					lbOK = false
					break
				end
			end

			if lbOK then
				-- Check ideology exceptions
				for i = 1, table.getn(laIdeologyExceptions) do
					if ministerTagString == tagString then
						Utils.LUA_DEBUGOUT("Ideology exceptions: " .. laIdeologyExceptions[i])
					end
					if laIdeologyExceptions[i] == puppetTagString then
						lbOK = false
						break
					end
				end

				if lbOK then
					-- Check country exceptions
					for i = 1, table.getn(laCountryExceptions) do
						if ministerTagString == tagString then
							Utils.LUA_DEBUGOUT("Country exceptions: " .. laCountryExceptions[i])
						end
						if laCountryExceptions[i] == puppetTagString then
							lbOK = false
							break
						end
					end

					if lbOK then

						-- SSmith (20/11/2013)
						-- Reversed the order of the tags!

						local command = CCreateVassalCommand( puppetTag, ministerTag )
						ai:Post( command)
					end
				end
			end
		end
	end
end

-- #####################
-- # Liberation
-- #####################

function Liberation( ai, minister, ministerTag, ministerCountry )
	
	if not ( Utils.ASSERT( ai ) )
	or not ( Utils.ASSERT( minister ) )
	or not ( Utils.ASSERT( ministerTag ) )
	or not ( Utils.ASSERT( ministerCountry ) )
	then
		return
	end
	
	-- liberate countries if we can
    	if ministerCountry:MayLiberateCountries() then
        	for loMember in ministerCountry:GetPossibleLiberations() do

			-- SSmith (22/09/2013)
			-- The "is capital safe" check doesn't always work for countries with overseas territories
			-- So we will rely on the support function only

	            	--if minister:IsCapitalSafeToLiberate( loMember ) and 
		 	if Support.ShouldLiberateCountry( ministerTag, loMember ) then
               			ai:Post( CLiberateCountryCommand( loMember, ministerTag ) )
            		end
        	end
	end	
end

-- #####################
-- # Mobilization
-- #####################

function Mobilization( minister )
	
	if not ( Utils.ASSERT( minister ) )
	then
		return
	end
	
	local ministerCountry = minister:GetCountry()
	local ministerTag = minister:GetCountryTag()
	local ai = minister:GetOwnerAI()
	
	if ministerCountry:IsAtWar() then
		-- No need to consider anything, we can't demobilize anyway.
		return
	end

	local tagstring = "XXX"
	if tostring(ministerTag) == tagstring then
		Utils.LUA_DEBUGOUT("Mobilization: " .. tostring(ministerTag))
		Utils.LUA_DEBUGOUT("IC: " .. tostring(ministerCountry:GetTotalIC() * 0.25))
		Utils.LUA_DEBUGOUT("CG: " .. tostring(ministerCountry:GetProductionDistributionAt( CDistributionSetting._PRODUCTION_CONSUMER_ ):GetNeeded():Get()))
	end

	-- SSmith (27/04/2013)
	-- The check for high consumer goods demand has been moved further down this function
	-- It no longer exits the function because it shouldn't!  The code must continue or it won't be able to de-mobilize!
	-- For the sake of efficiency calculate some values here that will be re-used
	
	local need_mobilization = false
	local isMobilized = ministerCountry:IsMobilized()
	local totalIC = ministerCountry:GetTotalIC()
	local dissent = ministerCountry:GetDissent():Get()
	
	if ministerCountry:HasFaction() or ministerCountry:GetNumOfAllies() > 0 then
	-- We have allies who may be at war. If so, then we can be called in at any moment, so let's mobilize!
		local hasFightingAlly = false

		for allyTag in ministerCountry:GetAllies() do
			if allyTag:GetCountry():IsAtWar() then
				for enemyTag in allyTag:GetCountry():GetCurrentAtWarWith() do
					if enemyTag:GetCountry():GetTotalIC() > totalIC then
						hasFightingAlly = true
						break
					end
				end
			end
		end
		if ministerCountry:HasFaction() then	-- Only check the faction if we have one!
			for factionBuddyTag in ministerCountry:GetFaction():GetMembers() do
				if factionBuddyTag:GetCountry():IsAtWar() then
					for enemyTag in factionBuddyTag:GetCountry():GetCurrentAtWarWith() do
						if enemyTag:GetCountry():GetTotalIC() > totalIC then
							hasFightingAlly = true
							break
						end
					end
				end
			end
		end
		
		if hasFightingAlly then	-- If one of our buddies is fighting someone stronger than us, then we should mobilize!
			need_mobilization = true
		end
	end

	if tostring(ministerTag) == tagstring then
		Utils.LUA_DEBUGOUT("Allies: " .. tostring(need_mobilization))
	end

	-- Note: we are automatically mobilized when war breaks out, so this is for kicking off mobilization early.
	if ministerCountry:GetStrategy():IsPreparingWar() then
		need_mobilization = true

		if tostring(ministerTag) == tagstring then
			Utils.LUA_DEBUGOUT("Preparing for war")
		end

	elseif not need_mobilization then

		-- SSmith (27/04/2013)
		-- For efficiency we will only run this code if we haven't yet decided to mobilize
		-- Strength will now be calculated using a new support function so we get sensible and consistent results

		-- check if a neighbor is starting to look threatening
		local neutrality = ministerCountry:GetNeutrality():Get()
		for neighborTag in ministerCountry:GetNeighbours() do
			local threat = ministerCountry:GetRelation( neighborTag ):GetThreat():Get()
			local strength = Support.CompareRealMilitaryStrength( ministerTag, neighborTag )

			if tostring(ministerTag) == tagstring then
				Utils.LUA_DEBUGOUT("Threat: " .. tostring(neighborTag) .. ": " .. tostring(threat))
				Utils.LUA_DEBUGOUT("Strength: " .. tostring(neighborTag) .. ": " .. tostring(strength))
			end

			-- SSmith (27/04/2013)
			-- This used to dismiss threat if we think we are 1.5 times as strong as the other country
			-- Now it will scale our reponse according to our relative strength
			-- It will also increase threat a little if we are mobilized to discourage us from de-mobilizing arbitrarily

			-- We should play it safer and consider if the threat is mobilized or not
			-- Then again mobilizing can really cripple the economy!!
			--if neighborTag:GetCountry():IsMobilized() or neighborTag:GetCountry():IsAtWar() then
			--	threat = threat + 20
			--end
			if strength > 5 then
				threat = threat - 20
			elseif strength > 3 then
				threat = threat - 15
			elseif strength > 2 then
				threat = threat - 10
			elseif strength > 1.5 then
				threat = threat - 5
			end
			if isMobilized then
				threat = threat + 5
			end

			if ( neutrality < threat or neighborTag:GetCountry():GetNeutrality():Get() < threat )
			and ( not ministerCountry:GetRelation( neighborTag ):HasTruce() )	-- Don't worry if we have a truce or NAP
			and ( not ministerCountry:GetRelation( neighborTag ):HasNap() )
			and ( not ministerCountry:CalculateIsAllied( neighborTag ) )
			then

				if tostring(ministerTag) == tagstring then
					Utils.LUA_DEBUGOUT("Threat: " .. tostring(neighborTag) .. ": " .. tostring(threat))
					Utils.LUA_DEBUGOUT("Strength: " .. tostring(strength))
					Utils.LUA_DEBUGOUT("Our Neutrality: " .. tostring(neutrality))
					Utils.LUA_DEBUGOUT("Their Neutrality: " .. tostring(neighborTag:GetCountry():GetNeutrality():Get()))
				end

				need_mobilization = true
			end
		end
	end

	if tostring(ministerTag) == tagstring then
		Utils.LUA_DEBUGOUT("Threat: " .. tostring(need_mobilization))
	end

	-- SSmith (26/04/2013)
	-- I thought about removing this but on second thoughts it may help prevent unwise mobilizations!

	if need_mobilization and not isMobilized then
		local currentNeutrality = ministerCountry:GetNeutrality():Get() * 0.01
		currentNeutrality = currentNeutrality * currentNeutrality		-- The square of a number lower than 1 is lower than the number.
		-- Check for Neutrality! If it is too high, then maybe we shouldn't do this, because Mobilization is very costly!
		local random_factor = ( math.random() * 0.5 ) + 0.5				-- Random real number between 0.5 and 1.
		if random_factor * currentNeutrality > 0.5 then
			need_mobilization = false
		end
	end

	if tostring(ministerTag) == tagstring then
		Utils.LUA_DEBUGOUT("Neutrality: " .. tostring(need_mobilization))
	end

	-- SSmith (25/04/2013)
	-- It seems that the consumer goods check is of paramount importance
	-- So the country-specific check is being moved here to be evaluated first

	if Utils.HasCountryAIFunction( ministerTag, 'HandleMobilization' ) then

		if tostring(ministerTag) == tagstring then
			Utils.LUA_DEBUGOUT("Calling AI...")
		end

		need_mobilization = Utils.CallCountryAI( ministerTag, "HandleMobilization", minister, need_mobilization )
	end

	if tostring(ministerTag) == tagstring then
		Utils.LUA_DEBUGOUT("Country: " .. tostring(need_mobilization))
	end

	-- SSmith (23/04/2013)
	-- The consumer goods check has been moved here
	-- It will reset the mobilization flag to false unless we are already mobilized
	-- I want this to persuade us against mobilizing but not to de-mobilize us!

	if totalIC * 0.25 < ministerCountry:GetProductionDistributionAt( CDistributionSetting._PRODUCTION_CONSUMER_ ):GetNeeded():Get()
	and not isMobilized then
		-- We are spending at least 25% of our IC on Consumer Goods and we are not mobilized
		need_mobilization = false
	end

	if tostring(ministerTag) == tagstring then
		Utils.LUA_DEBUGOUT("Consumer: " .. tostring(need_mobilization))
	end
	
	-- SSmith (15/06/2013)
	-- These is a new safeguard to check for dissent
	-- If dissent is high then the mobilization flag will be cleared so that we can deal with the dissent
	-- If any dissent exists then the mobilization flag will be cleared unless we are already mobilized
	
	if dissent > 10 then
		need_mobilization = false
	elseif dissent > 0.01 and not isMobilized then
		need_mobilization = false
	end

	if tostring(ministerTag) == tagstring then
		Utils.LUA_DEBUGOUT("Dissent: " .. tostring(dissent))
		Utils.LUA_DEBUGOUT("Dissent: " .. tostring(need_mobilization))
	end

	-- SSmith (23/04/2013)
	-- I am putting some longer term debugging in here so I can check how the AI is using this function

	if need_mobilization and not isMobilized then

		Utils.LUA_DEBUGOUT(tostring(ministerTag) .. " has mobilized")

		local command = CToggleMobilizationCommand( ministerTag, true )
		ai:Post( command )
	elseif not need_mobilization and isMobilized then

		Utils.LUA_DEBUGOUT(tostring(ministerTag) .. " has de-mobilized")

		local command = CToggleMobilizationCommand( ministerTag, false )
		ai:Post( command )
	end
end

-- #####################
-- # Laws
-- #####################

function Laws( minister )
	return
end

function HPP_Laws( minister )
	
	if not ( Utils.ASSERT( minister ) )
	then
		return
	end
	
	local ministerCountry = minister:GetCountry()
	local ministerTag = minister:GetCountryTag()
	local ai = minister:GetOwnerAI()
	local nLawToChange = math.mod( CCurrentGameState.GetAIRand(), 8)
	
	for loGroup in CLawDataBase.GetGroups() do
		local loGroupName = tostring(loGroup:GetKey() )
		local loNewLaw = nil
		local loCurrentLaw = ministerCountry:GetLaw(loGroup)
		local lsMethodCall = "CallLaw_" .. loGroupName
		
		if Utils.HasCountryAIFunction( ministerTag, lsMethodCall) then
			loNewLaw = Utils.CallCountryAI( ministerTag, lsMethodCall, minister, loCurrentLaw )
			
		elseif loGroupName == "civil_law" and nLawToChange == 0 then
			loNewLaw = CivilLaw( ministerTag, ministerCountry, loCurrentLaw )

		elseif loGroupName == "conscription_law" and nLawToChange == 1 then
			loNewLaw = ConscriptionLaw( ministerTag, ministerCountry, loCurrentLaw)
			
		elseif loGroupName == "economic_law" and nLawToChange == 2 then
			loNewLaw = EconomicLaw( ministerTag, ministerCountry, loCurrentLaw )
			
		elseif loGroupName == "industrial_policy_laws" and nLawToChange == 3 then
			loNewLaw = IndustrialPolicies( ministerTag, ministerCountry, loCurrentLaw )
			
		elseif loGroupName == "press_laws" and nLawToChange == 4 then
			loNewLaw = PressLaws( ministerTag, ministerCountry, loCurrentLaw )
			
		elseif loGroupName == "training_laws" and nLawToChange == 5 then
			loNewLaw = TrainingLaws( ministerTag, ministerCountry, loCurrentLaw )
			
		elseif loGroupName == "taxation_law" and nLawToChange == 6 then
			loNewLaw = TaxationLaw( ministerTag, ministerCountry, loCurrentLaw )
			
		elseif loGroupName == "international_status" and nLawToChange == 7 then
			loNewLaw = InternationalStatus( ministerTag, ministerCountry, loCurrentLaw )
			
		-- Unknown Law so leave it alone!
		else
			loNewLaw = nil
		end        

		-- Execute the new law
		if not( loNewLaw == nil ) then
			if not( loNewLaw:GetIndex() == loCurrentLaw:GetIndex() ) then
				ai:Post( CChangeLawCommand( ministerTag, loNewLaw, loGroup ) )
			end
		end
	end
end

function OfficeManagement( minister )
	
	if not ( Utils.ASSERT( minister ) )
	then
		return
	end
	
	local ai = minister:GetOwnerAI()
	local ministerCountry = minister:GetCountry()
	local ministerTag = minister:GetCountryTag()
	local loGroup = ministerCountry:GetRulingIdeology():GetGroup()
	local nMinisterToChange = math.mod( CCurrentGameState.GetAIRand(), 8 )
	
	local laDummy = {}
	local laPositions = { laDummy, laDummy, laDummy, laDummy, laDummy, laDummy, laDummy, laDummy, laDummy, laDummy }
	
	local loChiefOfAir = CGovernmentPositionDataBase.GetGovernmentPositionByIndex( _CHIEF_OF_AIR_ )
	local loChiefOfNavy = CGovernmentPositionDataBase.GetGovernmentPositionByIndex( _CHIEF_OF_NAVY_ )
	local loChiefOfArmy = CGovernmentPositionDataBase.GetGovernmentPositionByIndex( _CHIEF_OF_ARMY_ )
	local loChiefOfStaff = CGovernmentPositionDataBase.GetGovernmentPositionByIndex( _CHIEF_OF_STAFF_ )
	local loMinisterOfIntelligence = CGovernmentPositionDataBase.GetGovernmentPositionByIndex( _MINISTER_OF_INTELLIGENCE_ )
	local loMinisterOfSecurity = CGovernmentPositionDataBase.GetGovernmentPositionByIndex( _MINISTER_OF_SECURITY_ )
	local loArmamentMinister = CGovernmentPositionDataBase.GetGovernmentPositionByIndex( _ARMAMENT_MINISTER_ )
	local loForeignMinister = CGovernmentPositionDataBase.GetGovernmentPositionByIndex( _FOREIGN_MINISTER_ )
	
	-- Organize the ministers by positions they can take
	for loMinister in ministerCountry:GetPossibleMinisters() do
		if IsIdeologyAcceptable( ministerCountry, loMinister:GetIdeology() ) and loMinister:CanTakePosition( loChiefOfAir ) then
			table.insert( laPositions[ _CHIEF_OF_AIR_ ], loMinister )
		end
		
		if IsIdeologyAcceptable( ministerCountry, loMinister:GetIdeology() )  and loMinister:CanTakePosition( loChiefOfNavy ) then
			table.insert( laPositions[ _CHIEF_OF_NAVY_ ], loMinister )
		end
		
		if IsIdeologyAcceptable( ministerCountry, loMinister:GetIdeology() )  and loMinister:CanTakePosition( loChiefOfArmy ) then
			table.insert( laPositions[ _CHIEF_OF_ARMY_ ], loMinister )
		end
		
		if IsIdeologyAcceptable( ministerCountry, loMinister:GetIdeology() )  and loMinister:CanTakePosition( loChiefOfStaff ) then
			table.insert( laPositions[ _CHIEF_OF_STAFF_ ], loMinister )
		end
		
		if IsIdeologyAcceptable( ministerCountry, loMinister:GetIdeology() )  and loMinister:CanTakePosition( loMinisterOfIntelligence ) then
			table.insert( laPositions[ _MINISTER_OF_INTELLIGENCE_ ], loMinister )
		end
		
		if IsIdeologyAcceptable( ministerCountry, loMinister:GetIdeology() )  and loMinister:CanTakePosition( loMinisterOfSecurity ) then
			table.insert( laPositions[ _MINISTER_OF_SECURITY_ ], loMinister )
		end
		
		if IsIdeologyAcceptable( ministerCountry, loMinister:GetIdeology() )  and loMinister:CanTakePosition( loArmamentMinister ) then
			table.insert( laPositions[ _ARMAMENT_MINISTER_ ], loMinister )
		end
		
		if IsIdeologyAcceptable( ministerCountry, loMinister:GetIdeology() )  and loMinister:CanTakePosition( loForeignMinister ) then
			table.insert( laPositions[ _FOREIGN_MINISTER_ ], loMinister )
		end
	end

	if nMinisterToChange == 0 then
		MinisterOfSecurity( ai, ministerTag, ministerCountry, laPositions[ _MINISTER_OF_SECURITY_ ], loMinisterOfSecurity )
	elseif nMinisterToChange == 1 then
		ArmamentMinister( ai, ministerTag, ministerCountry, laPositions[ _ARMAMENT_MINISTER_ ], loArmamentMinister )
	elseif nMinisterToChange == 2 then
		ForeignMinister( ai, ministerTag, ministerCountry, laPositions[ _FOREIGN_MINISTER_ ], loForeignMinister )
	elseif nMinisterToChange == 3 then
		ChiefOfStaff( ai, ministerTag, ministerCountry, laPositions[ _CHIEF_OF_STAFF_ ], loChiefOfStaff )
	elseif nMinisterToChange == 4 then
		MinisterOfIntelligence( ai, ministerTag, ministerCountry, laPositions[ _MINISTER_OF_INTELLIGENCE_ ], loMinisterOfIntelligence )
	elseif nMinisterToChange == 5 then
		ChiefOfArmy( ai, ministerTag, ministerCountry, laPositions[ _CHIEF_OF_ARMY_ ], loChiefOfArmy )
	elseif nMinisterToChange == 6 then
		ChiefOfNavy( ai, ministerTag, ministerCountry, laPositions[ _CHIEF_OF_NAVY_ ], loChiefOfNavy )
	else 
		ChiefOfAir( ai, ministerTag, ministerCountry, laPositions[ _CHIEF_OF_AIR_ ], loChiefOfAir )
	end
end

-- #####################
-- # Office Management
-- #####################

function MinisterOfSecurity( ai, ministerTag, ministerCountry, vaMinisters, voPosition )

	if ( not Utils.ASSERT( ai ) )
	or ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( ministerCountry ) )
	or ( not Utils.ASSERT( vaMinisters ) )
	or ( not Utils.ASSERT( voPosition ) )
	then
		return
	end

	local loMinister = nil
	local loCurrentMinsiter = ministerCountry:GetMinister( voPosition )
	local liCurrentScore = 0
	
	if table.getn( vaMinisters ) > 0 then
		if Utils.HasCountryAIFunction( ministerTag, "Call_MinisterOfSecurity" ) then
			loMinister = Utils.CallCountryAI( ministerTag, "Call_MinisterOfSecurity", ministerCountry, vaMinisters )
		else
			for i = 1, table.getn( vaMinisters ) do
				local liScore = 0


				local lsMinisterType = vaMinisters[ i ]:GetPersonality( voPosition )

				if tostring( lsMinisterType:GetKey() ) == "man_of_the_people" then
					liScore = 70
				elseif tostring( lsMinisterType:GetKey() ) == "efficient_sociopath" then
					liScore = 60
				elseif tostring( lsMinisterType:GetKey() ) == "crime_fighter" then
					liScore = 50
				elseif tostring( lsMinisterType:GetKey() ) == "compassionate_gentleman" then
					liScore = 40
				elseif tostring( lsMinisterType:GetKey() ) == "silent_lawyer" then
					liScore = 30
				elseif tostring( lsMinisterType:GetKey() ) == "prince_of_terror" then
					liScore = 20
				elseif tostring( lsMinisterType:GetKey() ) == "back_stabber" then
					liScore = 10
				elseif tostring( lsMinisterType:GetKey() ) == "mostly_harmless" then
					liScore = 5
				end
				
				liScore = liScore * GetCabinetCountModifier( ministerCountry, vaMinisters[ i ]:GetIdeology() )

				if liScore > liCurrentScore then
					liCurrentScore = liScore
					loMinister = vaMinisters[ i ]
				end
			end
		end
	end

	if not( loMinister == nil ) then
		if not( loCurrentMinsiter == loMinister ) then
			ai:Post( CChangeMinisterCommand( ministerTag, loMinister, voPosition ) )
		end
	end
end

function ArmamentMinister( ai, ministerTag, ministerCountry, vaMinisters, voPosition )

	if ( not Utils.ASSERT( ai ) )
	or ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( ministerCountry ) )
	or ( not Utils.ASSERT( vaMinisters ) )
	or ( not Utils.ASSERT( voPosition ) )
	then
		return
	end

	local loMinister = nil
	local loCurrentMinsiter = ministerCountry:GetMinister( voPosition )
	local liCurrentScore = 0
	
	if table.getn( vaMinisters ) > 0 then
		if Utils.HasCountryAIFunction( ministerTag, "Call_ArmamentMinister") then
			loMinister = Utils.CallCountryAI( ministerTag, "Call_ArmamentMinister", ministerCountry, vaMinisters )
		else
			for i = 1, table.getn( vaMinisters ) do
				local liScore = 0
				local lsMinisterType = vaMinisters[ i ]:GetPersonality( voPosition )
				
				if tostring( lsMinisterType:GetKey() ) == "administrative_genius" then
					liScore = 150
				elseif tostring( lsMinisterType:GetKey() ) == "resource_industrialist" then
					liScore = 140
				elseif tostring( lsMinisterType:GetKey() ) == "laissez_faires_capitalist" then
					liScore = 130
				elseif tostring( lsMinisterType:GetKey() ) == "military_entrepreneu" then
					liScore = 120
				elseif tostring( lsMinisterType:GetKey() ) == "theoretical_scientist" then
					liScore = 110
				elseif tostring( lsMinisterType:GetKey() ) == "infantry_proponent" then
					liScore = 100
				elseif tostring( lsMinisterType:GetKey() ) == "air_to_ground_proponent" then
					liScore = 90
				elseif tostring( lsMinisterType:GetKey() ) == "air_superiority_proponent" then
					liScore = 80
				elseif tostring( lsMinisterType:GetKey() ) == "battle_fleet_proponent" then
					liScore = 70
				elseif tostring( lsMinisterType:GetKey() ) == "air_to_sea_proponent" then
					liScore = 60
				elseif tostring( lsMinisterType:GetKey() ) == "strategic_air_proponent" then
					liScore = 50
				elseif tostring( lsMinisterType:GetKey() ) == "submarine_proponent" then
					liScore = 40
				elseif tostring( lsMinisterType:GetKey() ) == "tank_proponent" then
					liScore = 30
				elseif tostring( lsMinisterType:GetKey() ) == "corrupt_kleptocrat" then
					liScore = 20
				elseif tostring( lsMinisterType:GetKey() ) == "crooked_kleptocrat" then
					liScore = 10
				elseif tostring( lsMinisterType:GetKey() ) == "mostly_harmless" then
					liScore = 5
				end
				
				liScore = liScore * GetCabinetCountModifier( ministerCountry, vaMinisters[ i ]:GetIdeology() )

				if liScore > liCurrentScore then
					liCurrentScore = liScore
					loMinister = vaMinisters[ i ]
				end
			end
		end
	end
	
	if not ( loMinister == nil ) then
		if not ( loCurrentMinsiter == loMinister) then
			ai:Post( CChangeMinisterCommand( ministerTag, loMinister, voPosition ) )
		end
	end
end

function ForeignMinister( ai, ministerTag, ministerCountry, vaMinisters, voPosition )

	if ( not Utils.ASSERT( ai ) )
	or ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( ministerCountry ) )
	or ( not Utils.ASSERT( vaMinisters ) )
	or ( not Utils.ASSERT( voPosition ) )
	then
		return
	end

	local loMinister = nil
	local loCurrentMinsiter = ministerCountry:GetMinister( voPosition )
	local isInFaction = ministerCountry:HasFaction()
	local ideologyGroupString = tostring( ministerCountry:GetRulingIdeology():GetGroup():GetKey() )
	local lbIsArwar = ministerCountry:IsAtWar()
	local liCurrentScore = 0
	
	if table.getn( vaMinisters ) > 0 then
		if Utils.HasCountryAIFunction( ministerTag, "Call_ForeignMinister") then
			loMinister = Utils.CallCountryAI( ministerTag, "Call_ForeignMinister", ministerCountry, vaMinisters )
		else
			for i = 1, table.getn( vaMinisters ) do
				local liScore = 0
				local lsMinisterType = vaMinisters[ i ]:GetPersonality( voPosition )
				
				if isInFaction then		-- The drifting ministers are less useful.
					if tostring( lsMinisterType:GetKey() ) == "biased_intellectual" then
						liScore = 50 - ministerCountry:GetNationalUnity():Get() / 2	-- The lower our National Unity is, the more we want him!
					elseif tostring( lsMinisterType:GetKey() ) == "apologetic_clerk" then
						liScore = ministerCountry:GetNationalUnity():Get() / 2		-- The higher our National Unity is, the more we want him!
					elseif tostring( lsMinisterType:GetKey() ) == "the_cloak_n_dagger_schemer" then
						liScore = 100 - ministerCountry:GetNeutrality():Get()		-- The lower our Neutrality is, the more we want him!
					elseif tostring( lsMinisterType:GetKey() ) == "great_compromiser" then
						liScore = ministerCountry:GetNeutrality():Get() / 2			-- The lower our Neutrality is, the less we want him!
					elseif tostring( lsMinisterType:GetKey() ) == "ideological_crusader" then
						liScore = 30
					elseif tostring( lsMinisterType:GetKey() ) == "general_staffer"
					or tostring( lsMinisterType:GetKey() ) == "iron_fisted_brute" then
						if not lbIsArwar then										-- They are more useful at peace.
							liScore = 30
						else
							liScore = 20
						end
					elseif tostring( lsMinisterType:GetKey() ) == "mostly_harmless" then
						liScore = 5
					end
					
				else
					if ideologyGroupString == "comunism"
					and tostring( lsMinisterType:GetKey() ) == "biased_intellectual" then
						liScore = 50
					elseif ideologyGroupString == "fascism" 
					and tostring( lsMinisterType:GetKey() ) == "the_cloak_n_dagger_schemer" then
						liScore = 50
					elseif ideologyGroupString == "democracy"
					and tostring( lsMinisterType:GetKey() ) == "great_compromiser" then	-- Only good if we have low Neutrality!
						liScore = 75 - ministerCountry:GetNeutrality():Get()
					elseif tostring( lsMinisterType:GetKey() ) == "ideological_crusader" then
						liScore = 40
					elseif tostring( lsMinisterType:GetKey() ) == "apologetic_clerk" then
						liScore = 30
					elseif tostring( lsMinisterType:GetKey() ) == "general_staffer"
					or tostring( lsMinisterType:GetKey() ) == "iron_fisted_brute" then
						if not lbIsArwar then											-- They are more useful at peace.
							liScore = 20
						else
							liScore = 15
						end
					elseif tostring( lsMinisterType:GetKey() ) == "mostly_harmless" then
						liScore = 5
					end
				end
				
				liScore = liScore * GetCabinetCountModifier( ministerCountry, vaMinisters[ i ]:GetIdeology() )

				if liScore > liCurrentScore then
					liCurrentScore = liScore
					loMinister = vaMinisters[ i ]
				end
			end
		end
	end
	
	if not ( loMinister == nil ) then
		if not ( loCurrentMinsiter == loMinister) then
			ai:Post( CChangeMinisterCommand( ministerTag, loMinister, voPosition ) )
		end
	end
end

function ChiefOfStaff( ai, ministerTag, ministerCountry, vaMinisters, voPosition )

	if ( not Utils.ASSERT( ai ) )
	or ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( ministerCountry ) )
	or ( not Utils.ASSERT( vaMinisters ) )
	or ( not Utils.ASSERT( voPosition ) )
	then
		return
	end

	local loMinister = nil
	local loCurrentMinsiter = ministerCountry:GetMinister( voPosition )
	local liCurrentScore = 0
	
	if table.getn( vaMinisters ) > 0 then
		if Utils.HasCountryAIFunction( ministerTag, "Call_ChiefOfStaff") then
			loMinister = Utils.CallCountryAI( ministerTag, "Call_ChiefOfStaff", ministerCountry, vaMinisters )
		else
			for i = 1, table.getn( vaMinisters ) do
				local liScore = 0
				local lsMinisterType = vaMinisters[ i ]:GetPersonality( voPosition )
				if tostring( lsMinisterType:GetKey() ) == "school_of_mass_combat" then
					liScore = 60
				elseif tostring( lsMinisterType:GetKey() ) == "school_of_psychology" then
					liScore = 50
				elseif tostring( lsMinisterType:GetKey() ) == "logistics_specialist" then
					liScore = 40
				elseif tostring( lsMinisterType:GetKey() ) == "school_of_fire_support" then
					liScore = 30
				elseif tostring( lsMinisterType:GetKey() ) == "school_of_defence" then
					liScore = 20
				elseif tostring( lsMinisterType:GetKey() ) == "school_of_manoeuvre" then
					liScore = 10
				elseif tostring( lsMinisterType:GetKey() ) == "mostly_harmless" then
					liScore = 5
				end
				
				liScore = liScore * GetCabinetCountModifier( ministerCountry, vaMinisters[ i ]:GetIdeology() )

				if liScore > liCurrentScore then
					liCurrentScore = liScore
					loMinister = vaMinisters[ i ]
				end
			end
		end
	end
	
	if not ( loMinister == nil ) then
		if not ( loCurrentMinsiter == loMinister) then
			ai:Post( CChangeMinisterCommand( ministerTag, loMinister, voPosition ) )
		end
	end
end

function MinisterOfIntelligence( ai, ministerTag, ministerCountry, vaMinisters, voPosition )

	if ( not Utils.ASSERT( ai ) )
	or ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( ministerCountry ) )
	or ( not Utils.ASSERT( vaMinisters ) )
	or ( not Utils.ASSERT( voPosition ) )
	then
		return
	end

	local loMinister = nil
	local loCurrentMinsiter = ministerCountry:GetMinister( voPosition )
	local liCurrentScore = 0
	
	if table.getn( vaMinisters ) > 0 then
		if Utils.HasCountryAIFunction( ministerTag, "Call_MinisterOfIntelligence") then
			loMinister = Utils.CallCountryAI( ministerTag, "Call_MinisterOfIntelligence", ministerCountry, vaMinisters )
		else
			for i = 1, table.getn( vaMinisters ) do
				local liScore = 0
				local lsMinisterType = vaMinisters[ i ]:GetPersonality( voPosition )
				
				if tostring( lsMinisterType:GetKey() ) == "dismal_enigma" then
					liScore = 60
				elseif tostring( lsMinisterType:GetKey() ) == "research_specialist" then
					liScore = 50
				elseif tostring( lsMinisterType:GetKey() ) == "naval_intelligence_specialist" then
					liScore = 40
				elseif tostring( lsMinisterType:GetKey() ) == "technical_specialist" then
					liScore = 30
				elseif tostring( lsMinisterType:GetKey() ) == "industrial_specialist" then
					liScore = 20
				elseif tostring( lsMinisterType:GetKey() ) == "political_specialist" then
					liScore = 10
				elseif tostring( lsMinisterType:GetKey() ) == "mostly_harmless" then
					liScore = 5
				end
				
				liScore = liScore * GetCabinetCountModifier( ministerCountry, vaMinisters[ i ]:GetIdeology() )

				if liScore > liCurrentScore then
					liCurrentScore = liScore
					loMinister = vaMinisters[ i ]
				end
			end
		end
	end
	
	if not ( loMinister == nil ) then
		if not ( loCurrentMinsiter == loMinister) then
			ai:Post( CChangeMinisterCommand( ministerTag, loMinister, voPosition ) )
		end
	end
end

function ChiefOfArmy( ai, ministerTag, ministerCountry, vaMinisters, voPosition )

	if ( not Utils.ASSERT( ai ) )
	or ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( ministerCountry ) )
	or ( not Utils.ASSERT( vaMinisters ) )
	or ( not Utils.ASSERT( voPosition ) )
	then
		return
	end

	local loMinister = nil
	local loCurrentMinsiter = ministerCountry:GetMinister( voPosition )
	local liCurrentScore = 0
	
	if table.getn( vaMinisters ) > 0 then
		if Utils.HasCountryAIFunction( ministerTag, "Call_ChiefOfArmy") then
			loMinister = Utils.CallCountryAI( ministerTag, "Call_ChiefOfArmy", ministerCountry, vaMinisters )
		else
			for i = 1, table.getn( vaMinisters ) do
				local liScore = 0
				local lsMinisterType = vaMinisters[ i ]:GetPersonality( voPosition )
				
				if tostring( lsMinisterType:GetKey() ) == "guns_and_butter_doctrine" then
					liScore = 50
				elseif tostring( lsMinisterType:GetKey() ) == "static_defence_doctrine" then
					liScore = 40
				elseif tostring( lsMinisterType:GetKey() ) == "decisive_battle_doctrine" then
					liScore = 30
				elseif tostring( lsMinisterType:GetKey() ) == "elastic_defence_doctrine" then
					liScore = 20
				elseif tostring( lsMinisterType:GetKey() ) == "armoured_spearhead_doctrine" then
					liScore = 10
				elseif tostring( lsMinisterType:GetKey() ) == "mostly_harmless" then
					liScore = 5
				end
				
				liScore = liScore * GetCabinetCountModifier( ministerCountry, vaMinisters[ i ]:GetIdeology() )

				if liScore > liCurrentScore then
					liCurrentScore = liScore
					loMinister = vaMinisters[ i ]
				end
			end
		end
	end
	
	if not ( loMinister == nil ) then
		if not ( loCurrentMinsiter == loMinister) then
			ai:Post( CChangeMinisterCommand( ministerTag, loMinister, voPosition ) )
		end
	end
end

function ChiefOfNavy( ai, ministerTag, ministerCountry, vaMinisters, voPosition )

	if ( not Utils.ASSERT( ai ) )
	or ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( ministerCountry ) )
	or ( not Utils.ASSERT( vaMinisters ) )
	or ( not Utils.ASSERT( voPosition ) )
	then
		return
	end

	local loMinister = nil
	local loCurrentMinsiter = ministerCountry:GetMinister( voPosition )
	local liCurrentScore = 0
	
	if table.getn( vaMinisters ) > 0 then
		if Utils.HasCountryAIFunction( ministerTag, "Call_ChiefOfNavy") then
			loMinister = Utils.CallCountryAI( ministerTag, "Call_ChiefOfNavy", ministerCountry, vaMinisters )
		else
			for i = 1, table.getn( vaMinisters ) do
				local liScore = 0
				local lsMinisterType = vaMinisters[ i ]:GetPersonality( voPosition )

				if tostring( lsMinisterType:GetKey() ) == "decisive_naval_battle_doctrine" then
					liScore = 50
				elseif tostring( lsMinisterType:GetKey() ) == "indirect_approach_doctrine" then
					liScore = 40
				elseif tostring( lsMinisterType:GetKey() ) == "open_seas_doctrine" then
					liScore = 30
				elseif tostring( lsMinisterType:GetKey() ) == "base_control_doctrine" then
					liScore = 20
				elseif tostring( lsMinisterType:GetKey() ) == "power_projection_doctrine" then
					liScore = 10
				elseif tostring( lsMinisterType:GetKey() ) == "mostly_harmless" then
					liScore = 5
				end
				
				liScore = liScore * GetCabinetCountModifier( ministerCountry, vaMinisters[ i ]:GetIdeology() )

				if liScore > liCurrentScore then
					liCurrentScore = liScore
					loMinister = vaMinisters[ i ]
				end
			end
		end
	end
	
	if not ( loMinister == nil ) then
		if not ( loCurrentMinsiter == loMinister) then
			ai:Post( CChangeMinisterCommand( ministerTag, loMinister, voPosition ) )
		end
	end
end

function ChiefOfAir( ai, ministerTag, ministerCountry, vaMinisters, voPosition )

	if ( not Utils.ASSERT( ai ) )
	or ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( ministerCountry ) )
	or ( not Utils.ASSERT( vaMinisters ) )
	or ( not Utils.ASSERT( voPosition ) )
	then
		return
	end

	local loMinister = nil
	local loCurrentMinsiter = ministerCountry:GetMinister( voPosition )
	local liCurrentScore = 0
	
	if table.getn( vaMinisters ) > 0 then
		if Utils.HasCountryAIFunction( ministerTag, "Call_ChiefOfAir") then
			loMinister = Utils.CallCountryAI( ministerTag, "Call_ChiefOfAir", ministerCountry, vaMinisters )
		else
			for i = 1, table.getn( vaMinisters ) do
				local liScore = 0
				local lsMinisterType = vaMinisters[ i ]:GetPersonality( voPosition )
				
				if tostring( lsMinisterType:GetKey() ) == "air_superiority_doctrine" then
					liScore = 50
				elseif tostring( lsMinisterType:GetKey() ) == "army_aviation_doctrine" then
					liScore = 40
				elseif tostring( lsMinisterType:GetKey() ) == "naval_aviation_doctrine" then
					liScore = 30
				elseif tostring( lsMinisterType:GetKey() ) == "carpet_bombing_doctrine" then
					liScore = 20
				elseif tostring( lsMinisterType:GetKey() ) == "vertical_envelopment_doctrine" then
					liScore = 10
				elseif tostring( lsMinisterType:GetKey() ) == "mostly_harmless" then
					liScore = 5
				end
				
				liScore = liScore * GetCabinetCountModifier( ministerCountry, vaMinisters[ i ]:GetIdeology() )

				if liScore > liCurrentScore then
					liCurrentScore = liScore
					loMinister = vaMinisters[ i ]
				end
			end
		end
	end
	
	if not ( loMinister == nil ) then
		if not ( loCurrentMinsiter == loMinister) then
			ai:Post( CChangeMinisterCommand( ministerTag, loMinister, voPosition ) )
		end
	end
end

-- ####################
-- # Law sub-methods
-- ####################

function ConscriptionLaw( ministerTag, ministerCountry, voCurrentLaw )

	if ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( ministerCountry ) )
	or ( not Utils.ASSERT( voCurrentLaw ) )
	then
		return
	end

	local loNewLaw = nil
	local liIndex = voCurrentLaw:GetIndex()
	-- Desperation, should be between 0..1, and the higher it is, the more desperate the nation.
	local desperation = ministerCountry:CalcDesperation():Get()

	-- SSmith (10/09/2013)
	-- The manpower check now returns two values
	-- The first is the minimum we need to bring our units up to strength and to cover losses
	-- The second is the ideal manpower reserve we want if we are to hold back on extending drafts
	
	if voCurrentLaw:GetIndex() == _VOLUNTEER_ARMY_			-- Standing Army
	then
		if not Support.HasEnoughManpower(ministerTag)[1]	-- We need more men
		then
			liIndex = _ONE_YEAR_DRAFT_			-- Mobilize for War!
		end
	elseif voCurrentLaw:GetIndex() == _TWO_YEAR_DRAFT_		-- Drafted Army
	then
		local result = Support.HasEnoughManpower(ministerTag)
		if (not result[1] or desperation > 0.05)		-- We need more men or we are at least somewhat desperate
		and not result[2]					-- and we don't have the "ideal" manpower reserve
		then
			liIndex = _THREE_YEAR_DRAFT_			-- Enact the Extended Draft!
		end
	elseif voCurrentLaw:GetIndex() == _ONE_YEAR_DRAFT_		-- Mobilized Standing Army or
	or voCurrentLaw:GetIndex() == _THREE_YEAR_DRAFT_		-- Extended Draft
	then
		local result = Support.HasEnoughManpower(ministerTag)
		if not result[2]					-- We need more men
		and desperation > 0.15					-- and we are pretty desperate.
		then
			liIndex = _SERVICE_BY_REQUIREMENT_		-- Enact the Emergency Draft!
		end
	else								-- Emergency Draft: Do nothing. Can't revert back. Emergency Draft is permanent.
		return nil
	end
	
	if liIndex < CLawDataBase.GetNumberOfLaws() then
		loNewLaw = CLawDataBase.GetLaw(liIndex)
		if not ( voCurrentLaw:GetGroup():GetIndex() == loNewLaw:GetGroup():GetIndex() ) then 
			return nil
		end
	end

	if loNewLaw:ValidFor( ministerTag ) then
		return loNewLaw
	else
		return nil
	end
end

function CivilLaw( ministerTag, ministerCountry, voCurrentLaw )

	if ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( ministerCountry ) )
	or ( not Utils.ASSERT( voCurrentLaw ) )
	then
		return
	end
	
	if not ( ministerCountry:IsAtWar() ) and tostring( ministerCountry:GetRulingIdeology():GetGroup():GetKey() ) == "democracy" then
		-- Switch Democracies back to Open Society if no longer atwar!
		return CLawDataBase.GetLaw( _OPEN_SOCIETY_ )
	end

	-- Otherwise try to go higher!
	local loNewLaw = nil
	local liIndex = voCurrentLaw:GetIndex() + 1
	
	if liIndex < CLawDataBase.GetNumberOfLaws() then
		loNewLaw = CLawDataBase.GetLaw(liIndex)
		if not ( voCurrentLaw:GetGroup():GetIndex() == loNewLaw:GetGroup():GetIndex() ) then 
			return nil
		end
	end

	-- SSmith (22/09/2013)
	-- Democratic parties shouldn't go beyond Legalistic Restrictions

	if tostring(ministerCountry:GetRulingIdeology():GetGroup():GetKey()) == "democracy"
	and liIndex > _LEGALISTIC_RESTRICTIONS_ then
		return nil
	end

	if loNewLaw:ValidFor( ministerTag ) then
		return loNewLaw
	else
		return nil
	end
end

function EconomicLaw( ministerTag, ministerCountry, voCurrentLaw )

	if ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( ministerCountry ) )
	or ( not Utils.ASSERT( voCurrentLaw ) )
	then
		return
	end

	local loNewLaw = nil
	local isDemocracy = tostring( ministerCountry:GetRulingIdeology():GetGroup():GetKey() ) == "democracy"

	if voCurrentLaw:GetIndex() == _FULL_CIVILIAN_ECONOMY_
	or voCurrentLaw:GetIndex() == _BASIC_MOBILISATION_
	then
		if ministerCountry:IsAtWar() then
			loNewLaw = CLawDataBase.GetLaw( _FULL_MOBILISATION_ )
		else
			local liIndex = voCurrentLaw:GetIndex() + 1
			loNewLaw = CLawDataBase.GetLaw(liIndex)
		end
	else	
		-- Don't check the rest too often!
		local randomFactor = math.mod( CCurrentGameState.GetAIRand(), CCurrentGameState.GetCurrentDate():GetDayOfMonth() )
		if randomFactor < 15 then
			return nil
		end
		
		--local goodsPool = ministerCountry:GetPool()
		--local days_of_energy = 100							-- Let's assume, that we have a lot of resources!
		--local days_of_metal  = 100
		--local days_of_rare   = 100
		--local energyBalance = ministerCountry:GetDailyBalance( CGoodsPool._ENERGY_ ):Get()
		--local metalBalance = ministerCountry:GetDailyBalance( CGoodsPool._METAL_ ):Get()
		--local rareBalance = ministerCountry:GetDailyBalance( CGoodsPool._RARE_MATERIALS_ ):Get()
		
		--if energyBalance < 0 then							-- Unfortunately, we are in a deficit of energy
		--	days_of_energy = goodsPool:Get( CGoodsPool._ENERGY_ ):Get() / ( 0 - energyBalance )
		--end
		--if metalBalance < 0 then							-- Unfortunately, we are in a deficit of metal
		--	days_of_metal = goodsPool:Get( CGoodsPool._METAL_ ):Get() / ( 0 - metalBalance )
		--end
		--if rareBalance < 0 then								-- Unfortunately, we are in a deficit of rares
		--	days_of_metal = goodsPool:Get( CGoodsPool._RARE_MATERIALS_ ):Get() / ( 0 - rareBalance )
		--end

		--local surplus = ( energyBalance > 0 and metalBalance > 0 and rareBalance > 0 )			-- We are producing a surplus of everything.
		--local enough_resources = ( days_of_energy > 60 and days_of_metal > 60 and days_of_rare > 60 )	-- We might not produce a surplus, but at

		-- SSmith (29/09/2013)
		-- We will calculate our resource requirements based on our current stockpiles
		-- We need to know when we can expand our production and when we must cut back to conserve resources

		local max_resources = true
		local min_resources = true

		local goodsPool = ministerCountry:GetPool()

		local liCurrentStockpile = goodsPool:Get(CGoodsPool._ENERGY_):Get()					-- Check the energy stockpile
		local liIdealStockpile = Support.GetEffectiveResourceLimit(ministerCountry, CGoodsPool._ENERGY_)
		if (liCurrentStockpile < (liIdealStockpile * 0.25)) then						-- We can expand production
			max_resources = false
		end
		if (liCurrentStockpile < (liIdealStockpile * 0.10)) then						-- We should cut back production
			min_resources = false
		end

		liCurrentStockpile = goodsPool:Get(CGoodsPool._METAL_):Get()						-- Check the metal stockpile
		liIdealStockpile = Support.GetEffectiveResourceLimit(ministerCountry, CGoodsPool._METAL_)
		if (liCurrentStockpile < (liIdealStockpile * 0.25)) then						-- We can expand production
			max_resources = false
		end
		if (liCurrentStockpile < (liIdealStockpile * 0.10)) then						-- We should cut back production
			min_resources = false
		end

		liCurrentStockpile = goodsPool:Get(CGoodsPool._RARE_MATERIALS_):Get()					-- Check the rares stockpile
		liIdealStockpile = Support.GetEffectiveResourceLimit(ministerCountry, CGoodsPool._RARE_MATERIALS_)
		if (liCurrentStockpile < (liIdealStockpile * 0.25)) then						-- We can expand production
			max_resources = false
		end
		if (liCurrentStockpile < (liIdealStockpile * 0.10)) then						-- We should cut back production
			min_resources = false
		end
																										-- least we have reserves.
		if voCurrentLaw:GetIndex() == _FULL_MOBILISATION_ then
			if ( ministerCountry:IsAtWar() or not isDemocracy ) and max_resources then	-- We are at war or non-democracy and have a surplus.
				loNewLaw = CLawDataBase.GetLaw( _WAR_ECONOMY_ )				-- Try harder!
			end
		elseif voCurrentLaw:GetIndex() == _WAR_ECONOMY_ then
			if ministerCountry:IsAtWar() and max_resources then			-- We are at war and have a surplus.

				-- SSmith (22/09/2013)
				-- We will not have the AI go to Total Ecomomic Mobilisation
				-- Land units would cost 67% more and we would only get 20% extra IC

				--loNewLaw = CLawDataBase.GetLaw( _TOTAL_ECONOMIC_MOBILISATION_ )	-- Go for the most IC!
				return nil
			elseif not ( ministerCountry:IsAtWar() or not isDemocracy ) then	-- We are neither at war nor a non-democracy.
				loNewLaw = CLawDataBase.GetLaw( _FULL_CIVILIAN_ECONOMY_ )	-- We should go back to the begining!
			elseif not min_resources then						-- Neither of the above, and we don't even have
				loNewLaw = CLawDataBase.GetLaw( _FULL_MOBILISATION_ )		-- enough resources to sustain our current production-rate,
			end																		-- so go back to Full Mobilization!
		elseif voCurrentLaw:GetIndex() == _TOTAL_ECONOMIC_MOBILISATION_ then
			if not ministerCountry:IsAtWar() and isDemocracy then			-- The war is over, and we are a democracy.
				loNewLaw = CLawDataBase.GetLaw( _FULL_CIVILIAN_ECONOMY_ )	-- Go back to Civilian!
			elseif not ministerCountry:IsAtWar() and not isDemocracy then		-- The war is over, and we are not a democracy.
				loNewLaw = CLawDataBase.GetLaw( _WAR_ECONOMY_ )			-- Go back to War Economy. We will decide where to go from there
			elseif not min_resources then						-- We don't have enough reserves to keep up our production.
				loNewLaw = CLawDataBase.GetLaw( _WAR_ECONOMY_ )			-- Take one step back!
			end
		else
			return nil
		end

	end

	if loNewLaw and loNewLaw:ValidFor( ministerTag ) then
		return loNewLaw
	else
		return nil
	end
end

function InternationalStatus( ministerTag, ministerCountry, voCurrentLaw )

	if ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( ministerCountry ) )
	or ( not Utils.ASSERT( voCurrentLaw ) )
	then
		return
	end

	local liIndex = voCurrentLaw:GetIndex() + 1
	local loNewLaw = nil
	
	-- Always pick the lowest one!
	
	if liIndex < CLawDataBase.GetNumberOfLaws() then
		loNewLaw = CLawDataBase.GetLaw(liIndex)
		if not ( voCurrentLaw:GetGroup():GetIndex() == loNewLaw:GetGroup():GetIndex() ) then 
			return nil
		end
	end

	if loNewLaw and loNewLaw:ValidFor( ministerTag ) then
		return loNewLaw
	else
		return nil
	end
end

function IndustrialPolicies( ministerTag, ministerCountry, voCurrentLaw )

	if ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( ministerCountry ) )
	or ( not Utils.ASSERT( voCurrentLaw ) )
	then
		return
	end

	-- Performance Check do we really need to do anything?
	if voCurrentLaw:GetIndex() == _HEAVY_INDUSTRY_EMPHASIS_ and ministerCountry:IsAtWar() then
		return nil
	end

	-- Peace get the break from the CG hit
	if not ( ministerCountry:IsAtWar() ) then
		return CLawDataBase.GetLaw( _CONSUMER_PRODUCT_ORIENTATION_ )
	else
		-- Try Heavy first if not then try Mixed
		local loNewLaw = CLawDataBase.GetLaw( _HEAVY_INDUSTRY_EMPHASIS_ )
		
		if loNewLaw:ValidFor( ministerTag ) then
			return loNewLaw
		else
			loNewLaw = CLawDataBase.GetLaw( _MIXED_INDUSTRY_ )
			
			if loNewLaw:ValidFor( ministerTag ) then
				return loNewLaw
			end
		end
	end
	
	return nil
end

function PressLaws( ministerTag, ministerCountry, voCurrentLaw )

	if ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( ministerCountry ) )
	or ( not Utils.ASSERT( voCurrentLaw ) )
	then
		return
	end

	-- Switch Democracies back to Free Press if no longer atwar!
	if not ( ministerCountry:IsAtWar() ) and tostring( ministerCountry:GetRulingIdeology():GetGroup():GetKey() ) == "democracy" then
		return CLawDataBase.GetLaw( _FREE_PRESS_ )
	end

	-- Otherwise try to go higher!
	local liIndex = voCurrentLaw:GetIndex() + 1
	local loNewLaw = nil
	
	if liIndex < CLawDataBase.GetNumberOfLaws() then
		loNewLaw = CLawDataBase.GetLaw(liIndex)
		if not ( voCurrentLaw:GetGroup():GetIndex() == loNewLaw:GetGroup():GetIndex() ) then 
			return nil
		end
	end

	-- SSmith (22/09/2013)
	-- Democratic parties shouldn't go beyond Censored Press

	if tostring(ministerCountry:GetRulingIdeology():GetGroup():GetKey()) == "democracy"
	and liIndex > _CENSORED_PRESS_ then
		return nil
	end

	if loNewLaw:ValidFor( ministerTag ) then
		return loNewLaw
	else
		return nil
	end
end

function TrainingLaws( ministerTag, ministerCountry, voCurrentLaw )

	if ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( ministerCountry ) )
	or ( not Utils.ASSERT( voCurrentLaw ) )
	then
		return
	end

	-- Performance Check do we really need to do anything?
	if voCurrentLaw:GetIndex() == _BASIC_TRAINING_ then
		return nil
	else
		local loNewLaw = CLawDataBase.GetLaw( _BASIC_TRAINING_ )
		
		if loNewLaw:ValidFor( ministerTag ) then
			return loNewLaw
		end	
	end
	
	return nil
end

function TaxationLaw( ministerTag, ministerCountry, voCurrentLaw )

	if ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( ministerCountry ) )
	or ( not Utils.ASSERT( voCurrentLaw ) )
	then
		return
	end

	local money = ministerCountry:GetPool():Get(CGoodsPool._MONEY_ ):Get() 				-- Our current cash reserves
	local moneyBalance = ministerCountry:GetDailyBalance(CGoodsPool._MONEY_ ):Get()		-- The average amount of Money we get
	--moneyBalance = math.min( moneyBalance, ministerCountry:GetMoneyBalanceAverage():Get() )
	local countryIC = ministerCountry:GetTotalIC()										-- The IC we have
	local moneyFromICDifference = countryIC * defines.economy.IC_TO_MONEY * 0.25		-- 25% of our current domestic Money production
	
	local index = voCurrentLaw:GetIndex()
	local group = voCurrentLaw:GetGroup()
	local newLaw = nil
	
	if moneyBalance - moneyFromICDifference > 0.0				-- If we can keep our economy running with 25% less money from our IC,
	and money > countryIC * 20									-- and we have some reserves (having some buffer is good!)
	then														-- then we should roll back one level.
		index = index - 1
		if index > 0 then
			newLaw = CLawDataBase.GetLaw( index )
			if not (group:GetIndex() == newLaw:GetGroup():GetIndex() ) then 
				newLaw = nil
			end
		end
	elseif moneyBalance < 0.0 then								-- If we need more money, 
		index = index + 1										-- we should go up a level.
		if index < CLawDataBase.GetNumberOfLaws() then
			newLaw = CLawDataBase.GetLaw( index )
			if not (group:GetIndex() == newLaw:GetGroup():GetIndex() ) then 
				newLaw = nil
			end
		end	
	end

	if newLaw and newLaw:ValidFor( ministerTag ) then
		return newLaw
	else
		return nil
	end
end

-- ##################
-- # Miscellaneous
-- ##################

-- Returns true if the ideology is acceptable to the ruling party as a partner, otherwise returns false.
function IsIdeologyAcceptable( ministerCountry, pMinisterIdeology )
	
	if not ( Utils.ASSERT( ministerCountry ) )
	or not ( Utils.ASSERT( pMinisterIdeology ) )
	then
		return false
	end
	
	local RulingIdeology = ministerCountry:GetRulingIdeology()
	
	if RulingIdeology:GetGroup():GetKey() == pMinisterIdeology:GetGroup():GetKey() then
		-- Same ideology group, so it is acceptable.
		return true
	elseif ( tostring( RulingIdeology:GetGroup():GetKey() ) == 'democracy' and tostring( pMinisterIdeology:GetKey() ) == 'paternal_autocrat' )
	or ( tostring( RulingIdeology:GetGroup():GetKey() ) == 'democracy' and tostring( pMinisterIdeology:GetKey() ) == 'left_wing_radical' )
	or ( tostring( RulingIdeology:GetGroup():GetKey() ) == 'fascism' and tostring( pMinisterIdeology:GetKey() ) == 'social_conservative' )
	or ( tostring( RulingIdeology:GetGroup():GetKey() ) == 'communism' and tostring( pMinisterIdeology:GetKey() ) == 'social_democrat' )
	then
		-- Different group, but still close enough
		return true
	else
		return false
	end
	
end

-- If the minister's Party is elligible for more positions than they currently hold,
-- then the minister should get a bonus for his chance for office!
function GetCabinetCountModifier( ministerCountry, pMinisterIdeology )

	local rMultiplier = 1.0
	
	if not ( Utils.ASSERT( ministerCountry ) )
	or not ( Utils.ASSERT( pMinisterIdeology ) )
	then
		return rMultiplier
	end
	
	if pMinisterIdeology:GetKey() == ministerCountry:GetRulingIdeology():GetKey() then
		-- The Ruling Party should always take precedence, but only to some extent!
		return 1.25
	end
	
	local PopularityData = ministerCountry:AccessIdeologyPopularity()
	
	if PopularityData:GetValue( pMinisterIdeology ):Get() < defines.country.PARTY_POPULARITY_CUTOFF * 100 then
		-- They are not elligible for cabinet positions!
		return rMultiplier
	end

	local nHeldCabinetPositions = 0
	local nTotalCabinetPositions = 0
	
	for pPosition in CGovernmentPositionDataBase.GetGovernmentPositionList() do
		if tostring( pPosition:GetKey() ) == 'noGovernmentPosition' then
			-- There should be an 'IsValid()' function for this class...
		else
			if pPosition:IsChangeable() then
				nTotalCabinetPositions = nTotalCabinetPositions + 1
			end
			if ministerCountry:GetMinister( pPosition ):GetIdeology():GetKey() == pMinisterIdeology:GetKey() then
				nHeldCabinetPositions = nHeldCabinetPositions + 1
			end
		end
	end
	
	local nPromisedCabinetPositions = math.floor( PopularityData:GetValue( pMinisterIdeology ):Get() * 0.01 * nTotalCabinetPositions )

	-- For every promised but unfilled Cabinet position, give +50% to the minister's score!
	if nPromisedCabinetPositions > nHeldCabinetPositions then
		rMultiplier = rMultiplier + ( 0.50 * ( nPromisedCabinetPositions - nHeldCabinetPositions ) )
	end
	
	return rMultiplier
end