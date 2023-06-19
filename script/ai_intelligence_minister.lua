-----------------------------------------------------------
-- LUA Hearts of Iron 3 Spy File
-- Modified By: Calders
-----------------------------------------------------------

-- ###################################
-- # Main Method called by the EXE
-- #####################################
function IntelligenceMinister_Tick(minister)
	if math.mod( CCurrentGameState.GetAIRand(), 9) == 0 then
		local ministerTag = minister:GetCountryTag()
		local ministerCountry = minister:GetCountry()
		local ai = minister:GetOwnerAI() 
		ManageSpiesAtHome(ministerTag, ministerCountry, ai)
		ManageSpiesAbroad(ministerTag, ministerCountry, ai)
	end
end

function ManageSpiesAtHome(ministerTag, ministerCountry, ai)

	if ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( ministerCountry ) )
	or ( not Utils.ASSERT( ai ) )
	then
		return 0
	end

	local lbHasBadSpies = false
	local NoMissionSelected = true
	local liNationalUnity = ministerCountry:GetNationalUnity():Get()
	local liNeutrality = ministerCountry:GetNeutrality():Get()
	local liPartyPopularity = ministerCountry:AccessIdeologyPopularity():GetValue(ministerCountry:GetRulingIdeology()):Get()
	local liPartyOrganisation = ministerCountry:AccessIdeologyOrganization():GetValue( ministerCountry:GetRulingIdeology() ):Get()
	local domesticSpyPresence = ministerCountry:GetSpyPresence( ministerTag )
	local HomeMissions = {
		CounterEspionage = {
			MissionName = SpyMission.SPYMISSION_COUNTER_ESPIONAGE,  
			MissionValue = 0},
		BoostRulingParty = {
			MissionName = SpyMission.SPYMISSION_BOOST_RULING_PARTY,  
			MissionValue = 0},
		RaiseNationalUnity = {
			MissionName = SpyMission.SPYMISSION_RAISE_NATIONAL_UNITY,  
			MissionValue = 0}}
	
	-- Calculate if we have bad spies in our country
	for loCountry in ministerCountry:GetSpyingOnUs() do
		local loSpyPresence = loCountry:GetCountry():GetSpyPresence(ministerTag)
		local loSpyMission = loSpyPresence:GetPrimaryMission()
		
		if loSpyMission == SpyMission.SPYMISSION_LOWER_NATIONAL_UNITY
			or loSpyMission == SpyMission.SPYMISSION_TECH
			or loSpyMission == SpyMission.SPYMISSION_INCREASE_THREAT
			then
			
			lbHasBadSpies = true
			break
		end
	end
	
	if not (ministerCountry:IsAtWar()) then
		-- National Unity
		if liNationalUnity < 70 then
			HomeMissions["RaiseNationalUnity"].MissionValue = 3
			NoMissionSelected = false
		elseif liNationalUnity < 90 then
			HomeMissions["RaiseNationalUnity"].MissionValue = 1
			NoMissionSelected = false
		end
			
		-- Party Support
		if liPartyPopularity < 25 or liPartyOrganisation < 25 then
			HomeMissions["BoostRulingParty"].MissionValue = 3
			NoMissionSelected = false
		elseif liPartyPopularity < 40 or liPartyOrganisation < 40 then
			HomeMissions["BoostRulingParty"].MissionValue = 1
			NoMissionSelected = false				
		end
		
		-- Counter Espionage check (but no counter in first year - for bad starting spies)
		if lbHasBadSpies and not CCurrentGameState.GetCurrentDate():GetYear() == 1936 then 
			HomeMissions["CounterEspionage"].MissionValue = 2
			NoMissionSelected = false
		end
		
	else
		-- Make sure we are not close to surrendering
		if liNationalUnity < 75 then
			HomeMissions["RaiseNationalUnity"].MissionValue = 3
			NoMissionSelected = false
		elseif liNationalUnity < 90 then
			HomeMissions["RaiseNationalUnity"].MissionValue = 1
			NoMissionSelected = false
		end
	
		-- Bad Spies present so get rid of them
		if lbHasBadSpies then 
			HomeMissions["CounterEspionage"].MissionValue = 2
			NoMissionSelected = false
		end

		-- Party Support
		if liPartyPopularity < 25 or liPartyOrganisation < 25 then
			HomeMissions["BoostRulingParty"].MissionValue = 2
			NoMissionSelected = false
		elseif liPartyPopularity < 35 or liPartyOrganisation < 35 then
			HomeMissions["BoostRulingParty"].MissionValue = 1
			NoMissionSelected = false				
		end	
	end
	
	-- Country specific missions
	if Utils.HasCountryAIFunction(ministerTag, "Home_Spies") then
		local CountryScriptMission = Utils.CallCountryAI(ministerTag, "Home_Spies", ministerCountry)
		if CountryScriptMission ~= nil then
			if CountryScriptMission == "CounterEspionage" then
				HomeMissions["CounterEspionage"].MissionValue = 2
			end
			NoMissionSelected = false
		end
	end
	
	-- Default missions if nothing else is selected
	if NoMissionSelected == true then
		HomeMissions["CounterEspionage"].MissionValue = 1
		HomeMissions["BoostRulingParty"].MissionValue = 1
	end
			
	-- Assign the mission
	for k, v in pairs(HomeMissions) do
		if v.MissionValue ~= domesticSpyPresence:GetMissionPriority(v.MissionName) then
			ai:Post(CChangeSpyMission(ministerTag, ministerTag, v.MissionName, v.MissionValue))		
		end
    end
	
	-- Always set your home priority to the highest
	if domesticSpyPresence:GetPriority() < CSpyPresence.MAX_SPY_PRIORITY then
		ai:Post(CChangeSpyPriority( ministerTag, ministerTag, CSpyPresence.MAX_SPY_PRIORITY ))
	end
end

function ManageSpiesAbroad(ministerTag, ministerCountry, ai)

	if ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( ministerCountry ) )
	or ( not Utils.ASSERT( ai ) )
	then
		return 0
	end

	for TargetCountry in CCurrentGameState.GetCountries() do
		if TargetCountry:Exists() then
			-- Make sure its not the same country
			local TargetCountryTag = TargetCountry:GetCountryTag()
		
			if TargetCountryTag ~= ministerTag and TargetCountryTag:IsValid() and TargetCountryTag:IsReal() then			
				ForeignSpyPriorities(ai, ministerTag, ministerCountry, TargetCountry, TargetCountryTag)
				ForeignSpyMissions(ai, ministerTag, ministerCountry, TargetCountry, TargetCountryTag)
			end
		end
	end
end
	

function ForeignSpyPriorities(ai, ministerTag, ministerCountry, TargetCountry, TargetCountryTag)

	if ( not Utils.ASSERT( ai ) )
	or ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( ministerCountry ) )
	or ( not Utils.ASSERT( TargetCountry ) )
	or ( not Utils.ASSERT( TargetCountryTag ) )
	then
		return
	end

	-- SSmith (15/05/2013)
	-- The most important thing is to maintain full coverage at home
	-- So if we don't have 10 domestic spies we won't be sending any overseas for the moment!
		
	-- Don't spy on Undeveloped Minors or allies 
	if TargetCountry:GetTotalIC() >= 10 and TargetCountry:IsGovernmentInExile() == false 
	and TargetCountry:CalculateIsAllied( ministerTag ) == false
	and ministerCountry:GetSpyPresence(ministerTag):GetLevel():Get() >= 10 then
	
		local nSpyWeight = 0
		local isPuppet = false
	
		--is it our puppet
		if TargetCountry:IsPuppet() then
			if TargetCountry:GetOverlord() == ministerTag then
				isPuppet = true
			end
		end
		
		-- For our Puppets we need to stop revolts
		if isPuppet == true then
			nSpyWeight = 1
		-- are
		else
			
			local targetContinent = TargetCountry:GetActingCapitalLocation():GetContinent()
			local ministerContinent = ministerCountry:GetActingCapitalLocation():GetContinent()
			local areNeighbours = ministerCountry:IsNeighbour(TargetCountryTag)
			local cRelation = ministerCountry:GetRelation(TargetCountryTag)
			local isFriend = Utils.IsFriend(ai, ministerCountry:GetFaction(), TargetCountry)
			local CountryScriptSpyWeight = nil
			local sameContinent = false
			
			-- are we on the same continent
			if ministerContinent == targetContinent then
				sameContinent = true
			end
			
			-- Check country specific scripts			
			if Utils.HasCountryAIFunction(ministerTag, "SpyPriority") then
				CountryScriptSpyWeight = Utils.CallCountryAI(ministerTag, "SpyPriority", ministerTag, ministerCountry, TargetCountry, TargetCountryTag)
			end
			
			if CountryScriptSpyWeight ~= nil then
				nSpyWeight = CountryScriptSpyWeight
			-- only spy on neighbours or countries in same continent (unless major or scripted)
			elseif sameContinent == true or areNeighbours == true then
				
				nSpyWeight = 1
				
				-- a neighbour on our continent increase priority (avoids problems with territories)
				if sameContinent == true and areNeighbours == true then
					nSpyWeight = nSpyWeight + 1
				end
				
				-- If we are preparing for or at war with them
				if ministerCountry:GetStrategy():IsPreparingWarWith(TargetCountryTag) or cRelation:HasWar() then
					nSpyWeight = nSpyWeight + 1
				end

				-- if not a friend, priority dependent on threat
				if not isFriend then
					if cRelation:GetThreat():Get() > 75 then
						nSpyWeight = nSpyWeight + 2
					elseif cRelation:GetThreat():Get() > 50 then
						nSpyWeight = nSpyWeight + 1
					end
				end
							
				-- adjust for size of country
				if TargetCountry:GetTotalIC() < 25 then
					nSpyWeight = nSpyWeight - 2
				elseif TargetCountry:GetTotalIC() < 50 then
					nSpyWeight = nSpyWeight - 1
				end	
												
				nSpyWeight = math.min(math.max( nSpyWeight, 0), 3)
				
			-- Majors spy on each other
			elseif ministerCountry:GetTotalIC() >= 75 and TargetCountry:GetTotalIC() >= 75 then

				nSpyWeight = 1
				if ministerCountry:GetStrategy():IsPreparingWarWith(TargetCountryTag) or cRelation:HasWar() then
					nSpyWeight = nSpyWeight + 1
				end
			end
		end
		
		-- If priority changes then update it
		if ministerCountry:GetSpyPresence(TargetCountryTag):GetPriority() ~= nSpyWeight then
			ai:Post(CChangeSpyPriority( ministerTag, TargetCountryTag, nSpyWeight ))
		end
	
	elseif ministerCountry:GetSpyPresence(TargetCountryTag):GetPriority() > 0 then
		ai:Post(CChangeSpyPriority( ministerTag, TargetCountryTag, 0 ))
	end
end

function ForeignSpyMissions(ai, ministerTag, ministerCountry, TargetCountry, TargetCountryTag)

	if ( not Utils.ASSERT( ai ) )
	or ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( ministerCountry ) )
	or ( not Utils.ASSERT( TargetCountry ) )
	or ( not Utils.ASSERT( TargetCountryTag ) )
	then
		return
	end
	
	-- If we don't have any spies don't do anything
	if ministerCountry:GetSpyPresence(TargetCountryTag):GetLevel():Get() > 0 then
	
		local FgnMissions = {
			CounterEspionage = {
				MissionKey = SpyMission.SPYMISSION_COUNTER_ESPIONAGE,  
				MissionValue = 0},		
			Military = {
				MissionKey = SpyMission.SPYMISSION_MILITARY,  
				MissionValue = 0},
			Tech = {
				MissionKey = SpyMission.SPYMISSION_TECH,  
				MissionValue = 0},
			BoostRulingParty = {
				MissionKey = SpyMission.SPYMISSION_BOOST_RULING_PARTY,  
				MissionValue = 0},
			BoostOurParty = {
				MissionKey = SpyMission.SPYMISSION_BOOST_OUR_PARTY,  
				MissionValue = 0},
			LowerNationalUnity = {
				MissionKey = SpyMission.SPYMISSION_LOWER_NATIONAL_UNITY,  
				MissionValue = 0},
			IncreaseThreat = {
				MissionKey = SpyMission.SPYMISSION_INCREASE_THREAT,  
				MissionValue = 0}}

		-- should we set a mission
		local CheckForMission = "Check"
		local CurrentSpyWeight = ministerCountry:GetSpyPresence( TargetCountryTag ):GetPriority()
		local SpyPresence = ministerCountry:GetSpyPresence( TargetCountryTag )
		local changeMission = true
		
		if TargetCountry:GetTotalIC() < 10 or TargetCountry:IsGovernmentInExile() == true
		or TargetCountry:CalculateIsAllied( ministerTag ) == true then
			CheckForMission = "Default"
		elseif CurrentSpyWeight == 0 then
			CheckForMission = "Default"
		elseif CurrentSpyWeight > 1 then
			if (math.floor(SpyPresence:GetLevel():Get() + 0.5)) < ( CurrentSpyWeight * 2.0 ) and ministerCountry:GetTotalLeadership():Get() >= 10 then
				CheckForMission = "None"
			end
		end

		if CheckForMission == "Check" then
		
			local cRelation = ministerCountry:GetRelation(TargetCountryTag)
			local areNeighbours = ministerCountry:IsNeighbour(TargetCountryTag)
			local sameIdeology = Utils.SameIdeology(ministerCountry, TargetCountry, nil)
			local isPuppet = false
			
			--is it our puppet
			if TargetCountry:IsPuppet() then
				if TargetCountry:GetOverlord() == ministerTag then
					isPuppet = true
				end
			end	
				
			-- If they are our Puppet or there is no priority then just support our ideology
			if isPuppet == true then
				if sameIdeology == true then
					FgnMissions["BoostRulingParty"].MissionValue = 2
				else
					FgnMissions["BoostOurParty"].MissionValue = 2
				end
							
			else
				-- check country scripts
				local CountryScriptMission = nil
				if Utils.HasCountryAIFunction(ministerTag, "PickBestMission") then
					CountryScriptMission = Utils.CallCountryAI(ministerTag, "PickBestMission", ministerTag, ministerCountry, TargetCountry, TargetCountryTag)
				end
				
				if CountryScriptMission ~= nil then
					if CountryScriptMission == "BoostOurParty" then
						FgnMissions["BoostOurParty"].MissionValue = 3
						FgnMissions["Military"].MissionValue  = 1
					elseif CountryScriptMission == "BoostRulingParty" then
						FgnMissions["BoostRulingParty"].MissionValue = 3
					elseif CountryScriptMission == "LowerNationalUnity" then
						FgnMissions["LowerNationalUnity"].MissionValue = 3
						FgnMissions["Military"].MissionValue = 2
					elseif CountryScriptMission == "IncreaseThreat" then
						FgnMissions["IncreaseThreat"].MissionValue = 3
						FgnMissions["Military"].MissionValue  = 1
					end
			
				-- Are we at war with them or preparing for war
				elseif ministerCountry:GetStrategy():IsPreparingWarWith(TargetCountryTag) or cRelation:HasWar() then
					
					-- If we are neighbors and they are close to surrendering
					if areNeighbours == true and ( TargetCountry:GetSurrenderLevel():Get() > 0.5 ) then
						FgnMissions["LowerNationalUnity"].MissionValue = 3
						FgnMissions["Military"].MissionValue = 1
					
					-- Pick a random mission then
					else
						local currentDays = CCurrentGameState.GetCurrentDate():GetTotalDays()
						local LastMissionDate = SpyPresence:GetLastMissionChangeDate():GetTotalDays()
						
						-- If the missions is more than 180 days old change it
						if (LastMissionDate + 90) >= currentDays then
							changeMission = false
						else		
							
							local AtWar = {
								"LowerNationalUnity",
								"Tech",
								"IncreaseThreat",
								"CounterEspionage"}				
							
							-- Do military and 1 other
							FgnMissions[AtWar[math.random(4)]].MissionValue = 3
							FgnMissions["Military"].MissionValue = 2
						end
					end		
				
				-- if we are influencing them help our Ideology
				elseif ( TargetCountry:GetRelation(ministerTag):IsBeingInfluenced() ) then
						if sameIdeology == true then
							FgnMissions["BoostRulingParty"].MissionValue = 2
						else
							FgnMissions["BoostOurParty"].MissionValue = 2
						end
				-- If they are on the brink of having a Coup, then we should lend them a hand!
				elseif sameIdeology == false
					and ( TargetCountry:AccessIdeologyOrganization():GetValue(TargetCountry:GetRulingIdeology()):Get() < 20
					or 	TargetCountry:AccessIdeologyPopularity():GetValue(TargetCountry:GetRulingIdeology()):Get() < 15 )
					then
						FgnMissions["BoostOurParty"].MissionValue = 3
						FgnMissions["LowerNationalUnity"].MissionValue = 2
				-- if they are our friends
				elseif cRelation:GetValue():Get() >= 50 then
					if sameIdeology == true then
						FgnMissions["BoostRulingParty"].MissionValue = 3
					else
						FgnMissions["BoostOurParty"].MissionValue = 3
						FgnMissions["Military"].MissionValue  = 1
					end
				-- otherwise lets choose something nasty at random
				else
					local currentDays = CCurrentGameState.GetCurrentDate():GetTotalDays()
					local LastMissionDate = SpyPresence:GetLastMissionChangeDate():GetTotalDays()
					
					-- If the missions is more than 180 days old change it (chnging less often is more effective and random)
					if (LastMissionDate + 90) >= currentDays then
						changeMission = false
					else		
						
						local AtPeace = {
							"Military",
							"BoostOurParty",
							"Tech",
							"IncreaseThreat",
							"CounterEspionage"}				
						
						-- Pick two at random
						local FirstRandom = math.random(5)
						FgnMissions[AtPeace[FirstRandom]].MissionValue = 3
						table.remove(AtPeace, FirstRandom)
						FgnMissions[AtPeace[math.random(4)]].MissionValue = 2
					end		
				end
			end
		end
								
		-- Assign the mission
		if changeMission == true then
			for k, v in pairs(FgnMissions) do
				if CheckForMission == "None" or CheckForMission == "Default" then
					if tostring(k) == "BoostOurParty" and CheckForMission == "Default" then
						if SpyPresence:GetMissionPriority(v.MissionKey) ~= 2 then
							ai:Post(CChangeSpyMission(ministerTag, TargetCountryTag, v.MissionKey, 2))
						end
					else
						if SpyPresence:GetMissionPriority(v.MissionKey) ~= 0 then
							ai:Post(CChangeSpyMission(ministerTag, TargetCountryTag, v.MissionKey, 0))
						end
					end
				else
					if SpyPresence:GetMissionPriority(v.MissionKey) ~= v.MissionValue then
						ai:Post(CChangeSpyMission(ministerTag, TargetCountryTag, v.MissionKey, v.MissionValue))
					end
				end
			end
		end
	end
end
