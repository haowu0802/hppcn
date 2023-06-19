require('ai_diplomacy')

-- ##############################
-- Methods Called by the EXE

function ForeignMinister_OnWar( agent, countryTag1, countryTag2, war )
	-- if war:IsLimited() then
		-- dont pull anything else right now, lets wait until we need it
	-- end
end


function ForeignMinister_Tick( minister )
	-- Test.
	-- I put code here to test stuff out.

	--if CCurrentGameState.GetCurrentDate():GetDayOfMonth() == 0 or CCurrentGameState.GetCurrentDate():GetDayOfMonth() == 7
	--or CCurrentGameState.GetCurrentDate():GetDayOfMonth() == 14 or CCurrentGameState.GetCurrentDate():GetDayOfMonth() == 21 then
	--	local ministerCountry = minister:GetCountry()
	--	local ministerTag = minister:GetCountryTag()
	--	local ministerTagString = tostring(ministerTag)
	--	if ministerTagString == "ENG" or ministerTagString == "FRA" or ministerTagString == "GER" or ministerTagString == "ITA"
	--	or ministerTagString == "SOV" or ministerTagString == "JAP" or ministerTagString == "USA" then
	--		if ministerTagString == "GER" then
	--			Utils.LUA_DEBUGOUT("")
	--		end
	--		Utils.LUA_DEBUGOUT(ministerTagString .. " " .. tostring(ministerCountry:GetDiplomaticInfluence():Get()))
	--	end
	--end

	--if tostring(minister:GetCountryTag()) == "GER" then
	--	local engTag = CCountryDataBase.GetTag('ENG')
	--	local gerTag = CCountryDataBase.GetTag('GER')
	--	local sovTag = CCountryDataBase.GetTag('SOV')
	--	local usaTag = CCountryDataBase.GetTag('USA')
	--	local greTag = CCountryDataBase.GetTag('GRE')
	--	Utils.LUA_DEBUGOUT("ENG: " .. tostring(engTag:GetCountry():GetFaction():GetTag()))
	--	Utils.LUA_DEBUGOUT("GER: " .. tostring(gerTag:GetCountry():GetFaction():GetTag()))
	--	Utils.LUA_DEBUGOUT("SOV: " .. tostring(sovTag:GetCountry():GetFaction():GetTag()))
	--	Utils.LUA_DEBUGOUT("USA: " .. tostring(usaTag:GetCountry():GetFaction():GetTag()))
	--	for loTag in greTag:GetCountry():GetNeighbours() do
	--		Utils.LUA_DEBUGOUT("GRE: " .. tostring(loTag))
	--	end		
	--end


	local Work = {
		AI = minister:GetOwnerAI(),
		MinisterTag = minister:GetCountryTag(),
		MinisterCountry = minister:GetCountry(),
		Strategy,
		SurrenderLevel = 0,
		Diplomacy = 0
	}
	Work.Strategy = Work.MinisterCountry:GetStrategy()
	Work.SurrenderLevel = Work.MinisterCountry:GetSurrenderLevel():Get()
	Work.Diplomacy = Work.MinisterCountry:GetDiplomaticInfluence():Get()

	-- Manage any country variables we need

	local fnParams = {
		AI = Work.AI,
		MinisterTag = Work.MinisterTag,
		MinisterCountry = Work.MinisterCountry
	}
	ForeignMinister_ManageCountryVariables( fnParams )


	-- run any decisions available
	
	minister:ExecuteDiploDecisions()
	
	-- We need to check war-targets frequently.
	-- Log all the Strategy variables of this country. Shouldn't use too often because it appends the new entry to the end of the log!
	if CCurrentGameState.GetCurrentDate():GetDayOfMonth() == 0 then
		-- Log on the first day of each month!
		Utils.LOG_AI_STRATEGY( Work.MinisterTag, Work.AI )
		if tostring( Work.MinisterTag ) == 'GOD' then
			Utils.LOG_AI_GLOBAL_STRATEGY( Work.MinisterTag, Work.AI )
		end
	end

	if Work.Strategy:IsPreparingWar() then
		for country in CCurrentGameState.GetCountries() do
			local countryTag = country:GetCountryTag()
			if countryTag:IsValid() and countryTag:IsReal() and Work.Strategy:IsPreparingWarWith(countryTag) then
				if (
					( not country:Exists() )			-- They don't even exist!
					or Work.SurrenderLevel > 0.01			-- We are getting beaten already!
				)
			then								-- Then we should reconsider...
					Work.Strategy:CancelPrepareWar( countryTag )
				end
			end
		end
	end

	if math.mod( CCurrentGameState.GetAIRand(), 7) == 0 then
		if Work.SurrenderLevel < 0.01						-- Don't start a new war when we are getting beaten already,
		and not Work.MinisterCountry:IsSubject()				-- or as a puppet!
		then
			if Utils.HasCountryAIFunction( Work.MinisterTag, "ProposeDeclareWar" ) then
				Utils.CallCountryAI( Work.MinisterTag, "ProposeDeclareWar", minister )
			else
				local targetTag = ProposeDeclareWar( minister )				-- Check if we want to go to war with anyone!
				if not targetTag == nil then						-- If we do, then let's get down to business!
					Support.PrepareForWar( Work.MinisterTag, targetTag, score )
				end
			end
		end
		ForeignMinister_HandlePeace( minister )
	end
		
	if Work.MinisterCountry:IsAtWar() then
		if math.mod( CCurrentGameState.GetAIRand(), 7) == 0 then
			ForeignMinister_HandleWar( minister )
		end
	end

	-- SSmith (23/01/2014)
	-- We must stop influencing if our diplomacy falls too low!
	-- Moved this code out of the HandlePeace function so that it is called daily

	if Work.MinisterCountry:CalculateNumberOfActiveInfluences() > 0 then

		for loTargetCountry in CCurrentGameState.GetCountries() do

			if loTargetCountry:Exists() then

				local loTargetTag = loTargetCountry:GetCountryTag()

				if loTargetCountry:GetRelation(Work.MinisterTag):IsBeingInfluenced() then

					--Utils.LUA_DEBUGOUT(tostring(Work.MinisterTag) .. " influencing " .. tostring(loTargetTag) .. " " .. tostring(Work.MinisterCountry:CalculateNumberOfActiveInfluences()) .. " " .. tostring(Work.Diplomacy))

					if Work.Diplomacy < 6 or math.mod( CCurrentGameState.GetAIRand(), 30) == 0 then

						if not Work.MinisterCountry:HasDiplomatEnroute(loTargetTag) then

							local aiInfluenceCancel = CInfluenceNation(Work.MinisterTag, loTargetTag)
							aiInfluenceCancel:SetValue(false)

							--Utils.LUA_DEBUGOUT("Cancelling")

							Work.AI:PostAction( aiInfluenceCancel )
						end
					end

				end

				-- Note this code checks if anyone in our faction is influencing the target
				-- It also returns true if the target is aligning to our faction

				--if Work.AI:IsInfluencing(Work.MinisterTag, loTargetTag) then
				--	Utils.LUA_DEBUGOUT(tostring(Work.MinisterTag) .. ":" .. tostring(loTargetTag) .. " is influencing")
				--end
			end
		end
	end
	
end


-- SSmith (19/01/2014)
-- Create a new function to manage our country variables
function ForeignMinister_ManageCountryVariables( Params )

	if ( not Utils.ASSERT( Params.AI ) )
	or ( not Utils.ASSERT( Params.MinisterTag ) )
	or ( not Utils.ASSERT( Params.MinisterCountry ) )
	then
		return 0
	end

	-- SSmith (26/11/2013)
	-- We will set a country variable to hold each puppet's fuel reserves
	-- This will be used by the resources event file to return excess fuel to the master

	if Params.MinisterCountry:IsSubject() then
		if math.mod(CCurrentGameState.GetAIRand(), 7) == 0 then
			Params.AI:Post(CSetVariableCommand(Params.MinisterTag, CString("stored_fuel_in_puppet"), Params.MinisterCountry:GetPool():Get(CGoodsPool._FUEL_)))
		end
	end
	--if tostring(Params.MinisterTag) == "EGY" then
	--	Utils.LUA_DEBUGOUT("EGY Variable: " .. tostring(Params.MinisterCountry:GetVariables():GetVariable(CString("stored_fuel_in_puppet"))))
	--end

	-- SSmith (28/11/2013)
	-- We will update a country variable to handle the Soviet Bitter Peace decision here

	if tostring(Params.MinisterTag) == "SOV" and math.mod(CCurrentGameState.GetAIRand(), 7) == 0 then
		local gerTag = CCountryDataBase.GetTag('GER')
		if Params.MinisterCountry:GetRelation(gerTag):HasWar() then							-- Soviets are at war with Germany
			local variable = Params.MinisterCountry:GetVariables():GetVariable(CString("ai_bitter_peace")):Get()
			if variable < 50 then
				Params.AI:Post(CSetVariableCommand(Params.MinisterTag, CString("ai_bitter_peace"), CFixedPoint(60)))	-- Set the default value to 60
				Utils.LUA_DEBUGOUT("ai_bitter_peace: 60")
			else
				local score = Params.MinisterCountry:GetSurrenderLevel():Get() * 100			-- Get Soviet surrender progress
				if score > variable then								-- and check it exceeds the stored value
					score = score - 50								-- Surrender progress must be over 50%
					local playerTag = CCurrentGameState.GetPlayer()
					if tostring(playerTag) == "GER" then						-- Player is Germany so make it harder!
						score = score - 10
					elseif (playerTag:GetCountry():GetRelation(gerTag):HasAlliance()		-- Player is a German ally!
					and Params.MinisterCountry:IsNeighbour(playerTag)) then
						score = score - 5
					end
					if math.mod(CCurrentGameState.GetAIRand(), 50) < score then			-- Make the calculation
						variable = 100								-- Offer the Bitter Peace
					else
						variable = variable + 10						-- Keep fighting and increment the variable
					end
					Params.AI:Post(CSetVariableCommand(Params.MinisterTag, CString("ai_bitter_peace"), CFixedPoint(variable)))
					Utils.LUA_DEBUGOUT("ai_bitter_peace: " .. tostring(variable))
				end
			end
		end
	end

	-- SSmith (13/12/2013)
	-- We will set a country variable to give Germany a 20% chance to invade Switzerland
	-- We will set a country variable to give Nationalist Spain a 33% chance to join the Axis

	if CCurrentGameState.GetCurrentDate():GetDayOfMonth() == 0 then
		if tostring(Params.MinisterTag) == "GER" then
			local variable = Params.MinisterCountry:GetVariables():GetVariable(CString("ai_tannenbaum")):Get()
			if variable < 0.5 then
				variable = 1
				if math.mod(CCurrentGameState.GetAIRand(), 5) == 1 then
					variable = 2
				end
				Params.AI:Post(CSetVariableCommand(Params.MinisterTag, CString("ai_tannenbaum"), CFixedPoint(variable)))
				Utils.LUA_DEBUGOUT("ai_tannenbaum: " .. tostring(variable))
			end
		elseif tostring(Params.MinisterTag) == "SPA" then
			local variable = Params.MinisterCountry:GetVariables():GetVariable(CString("ai_hendaye")):Get()
			if variable < 0.5 then
				variable = 1
				if math.mod(CCurrentGameState.GetAIRand(), 3) == 1 then
					variable = 2
				end
				Params.AI:Post(CSetVariableCommand(Params.MinisterTag, CString("ai_hendaye"), CFixedPoint(variable)))
				Utils.LUA_DEBUGOUT("ai_hendaye: " .. tostring(variable))
			end
		end
	end

	-- SSmith (19/01/2014)
	-- We will set country variables to hold each country's calculated fuel needs
	-- This will save re-calculating it endlessly whenever we need to find the effective oil/fuel stockpile limits

	if math.mod(CCurrentGameState.GetAIRand(), 30) == 0 then
		--Utils.LUA_DEBUGOUT("Fuel: " .. tostring(Params.MinisterTag) .. ": " .. tostring(Params.MinisterCountry:GetVariables():GetVariable(CString("ai_fuel_limit"))))
		local fnParams = {
			MinisterCountry = Params.MinisterCountry
		}
		local variable = Support.GetFuelLimit( fnParams )
		Params.AI:Post(CSetVariableCommand(Params.MinisterTag, CString("ai_fuel_limit"), CFixedPoint(variable)))
	end

end


function ForeignMinister_EvaluateDecision(agent, decision, scope)

	--Utils.LUA_DEBUGOUT("Foreign Minister...")

	local score = 50 + math.random( 50 )
	local ministerCountry = agent:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	local decisionString = tostring(decision:GetKey())
	local dissent = ministerCountry:GetDissent():Get()
	local rulingPopularity = ministerCountry:AccessIdeologyPopularity():GetValue( ministerCountry:GetRulingIdeology() ):Get()
	local nationalUnity = ministerCountry:GetNationalUnity():Get()
	
	-- SSmith (13/09/2013)
	-- Don't let the AI fire the prohibition of new parties because it destroys national unity
	-- Allow the banning of individual parties

	if decisionString == "stop_silly_wars" then
		score = 100
	elseif decisionString == "stop_silly_wars_nap" then
		score = 100
	elseif decisionString == "introduction" or decisionString == "restructuring_the_army"
	or decisionString == "remove_guarantees_on" or decisionString == "remove_guarantees_off"
	or decisionString == "giving_back_territory_on" or decisionString == "giving_back_territory_off"
	or decisionString == "release_vassals_on" or decisionString == "release_vassals_off"
	or decisionString == "navy_models" or decisionString == "new_parties_prohibited"
	then	-- Non-AI decisions
		score = 0
	elseif decisionString == "outlaw_national_socialist" or decisionString == "outlaw_fascistic"
	or decisionString == "outlaw_paternal_autocrat" or decisionString == "outlaw_social_conservative"
	or decisionString == "outlaw_market_liberal" or decisionString == "outlaw_social_liberal"
	or decisionString == "outlaw_social_democrat" or decisionString == "outlaw_left_wing_radical"
	or decisionString == "outlaw_leninist" or decisionString == "outlaw_stalinist"
	then
		if math.mod( CCurrentGameState.GetAIRand(), 100) == 1 then
			score = 100
		else
			score = 0
		end
	elseif decisionString == "belgium_joins_the_allies" then

		-- SSmith (31/10/2013)
		-- The relationship check isn't working so we'll just use a random chance

		--local fraTag = CCountryDataBase.GetTag('FRA')
		--local rel = ministerCountry:GetRelation(fraTag):GetValue():Get() / 3
		if math.mod( CCurrentGameState.GetAIRand(), 10) == 1 then
			--score = math.mod( CCurrentGameState.GetAIRand(), rel)
			score = 100
		else
			score = 0
		end
	elseif decisionString == "the_war_is_escalating" then
		score = ministerCountry:GetRelation( ministerCountry:GetHighestThreat() ):GetThreat():Get() * 0.25
	elseif decisionString == "hold_early_elections_soc_dem" then
		-- If the requirements are met, then decide based on Dissent!

		-- SSmith (26/08/2013)
		-- Add a random factor so this doesn't fire instantly and just repeat endlessly

		if math.random( ministerCountry:GetDissent():GetTruncated() ) > 10
		and math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			score = 100
		else
			score = 0
		end
	elseif decisionString == "hold_early_elections_cons_mon" then
		-- This is always available, but only do it if the Ruling Party is doing very badly!

		-- SSmith (26/08/2013)
		-- Add a random factor so this doesn't fire instantly and just repeat endlessly

		if dissent > rulingPopularity
		and math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			score = 100
		else
			score = 0
		end
	elseif decisionString == "end_soc_dem_election"
	or decisionString == "end_soc_cons_election"
	or decisionString == "end_cons_mon_election"
	then
		score = 100
	elseif decisionString == "declare_war_on_germany" then		-- The Commonwealth will only join if they have good enough relations!
		local engTag = CCountryDataBase.GetTag('ENG')		-- It is easier from here than the individual scripts...

		-- SSmith (22/04/2013)
		-- Increase the base chance by halving the relationship (instead of /3)
		-- Code changed to convert the score calculated into a true (100) or false (0) at this point
		-- Otherwise the score won't be high enough to pass the check at the end of this function

		local rel = ministerCountry:GetRelation( engTag ):GetValue():Get() / 2
		score = 0
		if math.mod( CCurrentGameState.GetAIRand(), 7 ) == 1 then
			if rel > 0 then
				score = math.mod( CCurrentGameState.GetAIRand(), rel )
				if math.random(0,100) < score then
					score = 100
				end
			end
		end
	elseif decisionString == "war_with_peru" then				-- War between Peru and Equador
		local pruTag = CCountryDataBase.GetTag('PRU')
		score = Support.PrepareForWarDecision( ministerTag, pruTag, decision, Support.LinearFunction( 1.0, 2.0, Support.CompareMilitaryStrength( ministerTag, pruTag ) ) )
	elseif decisionString == "war_with_equador" then			-- War between Peru and Equador
		local ecuTag = CCountryDataBase.GetTag('ECU')
		score = Support.PrepareForWarDecision( ministerTag, ecuTag, decision, Support.LinearFunction( 1.0, 2.0, Support.CompareMilitaryStrength( ministerTag, ecuTag ) ) )
	elseif decisionString == "resistance_is_futile" then

		-- SSmith (18/05/2013)
		-- The Danish surrender didn't work very well
		-- It used to deduct 2 x the Danish divisions and then 2 x the individual units
		-- We will now just deduct the number of units so that Allied support could still make the difference!

		--score = 100 - ( ministerCountry:GetUnits():GetTotalAmountOfDivisions() * 2 )
		score = 100
		for provinceID in ministerCountry:GetControlledProvinces() do
			-- Also count the number of allied units!
			score = score - CCurrentGameState.GetProvince(provinceID):GetNumberOfUnits()
		end
	elseif decisionString == "mobilize_for_war" then			-- If the nation is mobilized already, then let's do this!

		-- SSmith (10/09/2013)
		-- The manpower function now returns two booleans (we want the first)

		if ministerCountry:IsMobilized()
		and not Support.HasEnoughManpower(ministerTag)[1]
		then
			score = 100
		else
			score = 0
		end
	elseif decisionString == "mobilize_reserves" then			-- If we are fighting a major or are desperate, then mobilize them!
		if Support.IsFightingMajor( ministerTag )
		or ministerCountry:CalcDesperation():Get() > 0.1
		or ministerCountry:GetManpower():Get() < 1
		then
			score = 100
		else
			score = 0
		end
	-- Constitution-changing decisions.
	-- There are special prerequisists for the AI so it should only be able to take these decisions when it is appropriate.
	elseif decisionString == "turn_into_r_w_republic" then
		if ministerCountry:GetRulingIdeology():GetGroup():GetKey() == "fascism" and not ( tostring( ministerTag ) == "GOD" ) then
			score = ( nationalUnity / 2 ) + rulingPopularity
		else
			score = 0
		end
	elseif decisionString == "turn_into_soc_dem" then
		if ( ministerCountry:GetRulingIdeology():GetKey() == "social_democrat"
		or ministerCountry:GetRulingIdeology():GetKey() == "social_liberal" ) and not ( tostring( ministerTag ) == "GOD" ) then
			score = ( nationalUnity / 2 ) + rulingPopularity
		else
			score = 0
		end
	elseif decisionString == "turn_into_soc_cons" then
		if ( ministerCountry:GetRulingIdeology():GetKey() == "social_conservative"
		or ministerCountry:GetRulingIdeology():GetKey() == "market_liberal" ) and not ( tostring( ministerTag ) == "GOD" ) then
			score = ( nationalUnity / 2 ) + rulingPopularity
		else
			score = 0
		end
	elseif decisionString == "turn_into_rev_gov" then
		if ministerCountry:GetRulingIdeology():GetGroup():GetKey() == "communism" and not ( tostring( ministerTag ) == "GOD" ) then
			score = ( nationalUnity / 2 ) + rulingPopularity
		else
			score = 0
		end
	elseif decisionString == "turn_into_const_mon" then
		if ministerCountry:GetRulingIdeology():GetGroup():GetKey() == "democracy" and not ( tostring( ministerTag ) == "GOD" ) then
			score = ( nationalUnity / 2 ) + rulingPopularity
		else
			score = 0
		end
	-- End of constitution-changing decisions.
	elseif decisionString == "go_into_exile" then			-- If we lost enough VPs, let's consider going into exile!
		score = Support.LinearFunction( ministerCountry:GetSurrenderLevel():Get(), 0.5, 0.90 )	-- Don't be too hasty, but do it before it's too late!
	elseif decisionString == "partition_of_yugoslavia_ita"
	or decisionString == "partition_of_yugoslavia_hun"
	or decisionString == "partition_of_yugoslavia_bul" then

		-- SSmith (08/12/2013)
		-- Several countries can call these so we'll put a random factor in here

		if math.mod( CCurrentGameState.GetAIRand(), 14 ) == 1 then
			score = 100
		else
			score = 0
		end
	end

	score = Utils.CallScoredCountryAI( ministerTag, 'ForeignMinister_EvaluateDecision', score, agent, decision, scope )

	if score > ( 50 + math.random( 45 ) ) then
		Utils.LOG_DECISION( ministerTag, decisionString )
		return 100
	else
		return 0
	end
end


-- End of Methods Called by the EXE
-- ##############################


function ForeignMinister_HandleWar( minister )
	local ministerTag = minister:GetCountryTag()
	local ministerCountry = minister:GetCountry()
	local ai = minister:GetOwnerAI()
	
	-- Request for Military Access
	for neighborTag in ministerCountry:GetNeighbours() do
		local loRelation = ai:GetRelation(ministerTag, neighborTag)
		
		-- Process all Neighbors as we may just need access through them even though
		-- they are not a neighbor with any of our enemies (Germany with Sweden for example)
		if not(loRelation:HasMilitaryAccess())
		and not(loRelation:HasAlliance()) then
			local loAction = CMilitaryAccessAction(ministerTag, neighborTag)

			if loAction:IsSelectable() then
				local liScore = DiploScore_DemandMilitaryAccess(ai, ministerTag, neighborTag, ministerTag)

				if liScore > 50
				and loAction:GetAIAcceptance() > 50
				and not ( neighborTag == CCurrentGameState.GetPlayer() )
				then
					minister:Propose(loAction, liScore)
				end
			end
		end
	end

	-- Asking to join into Factions, only consider if we are not too Neutral.
	if not ministerCountry:HasFaction() then
		local neutralityModifier = Support.LinearFunction(70, 90, ministerCountry:GetNeutrality():Get() )
		for faction in CCurrentGameState.GetFactions() do
			local factionLeaderTag = faction:GetFactionLeader()
			local loAction = CFactionAction(ministerTag, factionLeaderTag)
			loAction:SetValue(true)
			if loAction:IsSelectable() then
				local ourScore = DiploScore_InviteToFaction(ai, ministerTag, factionLeaderTag, ministerTag) * neutralityModifier
				local theirScore = DiploScore_InviteToFaction(ai, factionLeaderTag, ministerTag, ministerTag)
				if math.min(ourScore, theirScore) > 50 then
					ai:PostAction(loAction)
				end
			end
		end
	end
	
	-- Call our Allies in
	if Utils.HasCountryAIFunction( ministerTag, "CallAlly") then
		Utils.CallCountryAI(ministerTag, "CallAlly", minister)							
	else
		for loDiploStatus in ministerCountry:GetDiplomacy() do
			local loTargetTag = loDiploStatus:GetTarget()
			
			if loTargetTag:IsValid() and loDiploStatus:HasWar() then
				local loWar = loDiploStatus:GetWar()
				
				-- First of all, we should check if we can/want to make peace!
				--local loPeaceAction = CPeaceAction( ministerTag, loTargetTag )
				--if loPeaceAction:IsSelectable() then
				--	if DiploScore_PeaceAction(ministerTag, loTargetTag, ministerTag, loPeaceAction) > 49 then		-- We want it.
				--		if DiploScore_PeaceAction(loTargetTag, ministerTag, ministerTag, loPeaceAction) > 50 then	-- They may accept.
				--			ai:PostAction( loPeaceAction )
				--		end
				--	end
				--end
	
				-- Call in Puppets
				for loPuppetTag in ministerCountry:GetVassals() do
					if not(loPuppetTag:GetCountry():GetRelation(loTargetTag):HasWar()) then
						local loAction = CCallAllyAction( ministerTag, loPuppetTag, loTargetTag )
						loAction:SetValue( true ) -- limited
						
						if loAction:IsSelectable() and loAction:GetAIAcceptance() > 50 then
							ai:PostAction( loAction )
						end
					end
				end
	
				-- Call in our Master!
				if ministerCountry:IsSubject() then
					local masterTag = ministerCountry:GetOverlord()
					if not(masterTag:GetCountry():GetRelation(loTargetTag):HasWar()) then
						local loAction = CCallAllyAction( ministerTag, masterTag, loTargetTag )
						loAction:SetValue( true ) -- limited
						
						if loAction:IsSelectable() and loAction:GetAIAcceptance() > 50 then
							ai:PostAction( loAction )
						end
					end
				end
					
				if loWar:IsLimited() then
					
					-- If we don't have the Limited War rule, we might still end up with allies not fighting with us when they should.
					-- So let's call them to arms!
					if not ministerCountry:GetRules():GetValue(CRule._RULE_LIMITED_WAR_) then
						for allyTag in ministerCountry:GetAllies() do
							if not loWar:IsPartOfWar(allyTag) 		-- But don't call in Puppets this way, as they might be
							and not allyTag:GetCountry():IsSubject()	-- the puppets of other nations! They will be called by them.
							then
								local action = CCallAllyAction( ministerTag, allyTag, loTargetTag )
								action:SetValue( true )
								if action:IsSelectable() and action:GetAIAcceptance() > 50 then
									ai:PostAction( action )
								end
							end
						end
					end
					-- do we want to call in help?
					if ministerCountry:CalcDesperation():Get() > 0.25 then
						for loAllyTag in ministerCountry:GetAllies() do
							if not(loAllyTag:GetCountry():GetRelation(loTargetTag):HasWar())
							and not loAllyTag:GetCountry():IsSubject()			-- Don't call puppets this way!
							and loTargetTag:GetCountry():IsNeighbour(ministerTag)		-- Only call common neighbors,
							and loTargetTag:GetCountry():IsNeighbour(loAllyTag)		-- because others couldn't help anyway.
							then
								local loAction = CCallAllyAction( ministerTag, loAllyTag, loTargetTag )
								loAction:SetValue( true ) -- limited
								
								if loAction:IsSelectable() and loAction:GetAIAcceptance() > 50 then
									ai:PostAction( loAction )
								end
							end
						end
					end
				else
				-- Not a Limited War, so call in any allies we can, except for other nations' puppets!
				-- Although, this should never be the case, I guess...
					for loAllyTag in ministerCountry:GetAllies() do
						if not(loAllyTag:GetCountry():GetRelation(loTargetTag):HasWar())
						and not loAllyTag:GetCountry():IsSubject()
						then
							local loAction = CCallAllyAction( ministerTag, loAllyTag, loTargetTag )
							loAction:SetValue( true )
							
							if loAction:IsSelectable() and loAction:GetAIAcceptance() > 50 then
								ai:PostAction( loAction )
							end
						end
					end
				end
			end
		end
	end
	
end

function ForeignMinister_HandlePeace( minister )
	-- Invite to Faction
	-- Influence
	-- NAP (Non Aggression Pact)
	-- Guarantee 
	-- Allow Debt
	-- Alliance (Forming)
	-- Alliance (Breaking)
	-- Embargo (Making and Cancelling)	
	
	-- Join Faction (or exit)

	local ai = minister:GetOwnerAI()
	local ministerCountry = minister:GetCountry()
	local ministerTag = minister:GetCountryTag()
	local lbIsMajor = ministerCountry:IsMajor()
	local loFaction = ministerCountry:GetFaction()

	-- 0.15 is the default parm on ai_tech_minister.lua LEADERSHIP_DIPLOMACY
	local liDailyDiplomatic = math.floor((ministerCountry:GetTotalLeadership():Get() * 0.15) / 2)
	local liDailyActive = ministerCountry:CalculateNumberOfActiveInfluences()
	local liInfluenceLeft = math.max(0, (liDailyDiplomatic - liDailyActive))

	local tagString = "XXX"
	if tostring(ministerTag) == tagString then
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("ForeignMinister_HandlePeace")
		Utils.LUA_DEBUGOUT("DailyDiplo: " .. tostring(liDailyDiplomatic))
		Utils.LUA_DEBUGOUT("DailyActive: " .. tostring(liDailyActive))
		Utils.LUA_DEBUGOUT("InflLeft: " .. tostring(liInfluenceLeft))
	end
	
	-- Best Country to influece to join us
	local loInfluenceAction = nil
	local loInfluenceActionScore = 0
	
	-- Worst Neighbot to Influence to join us
	local loInfluenceActionWorst = nil
	
	local loInfluenceCountry = {}
	local loInfluenceScore = {}
	
	for loTargetCountryTag in ministerCountry:GetNeighbours() do		-- Only do NAP-s with neighbours, and not with the player!

		if not(ministerCountry:HasDiplomatEnroute(loTargetCountryTag))
		and not(loTargetCountryTag == ministerTag) 
		and loTargetCountryTag:GetCountry():Exists()
		and loTargetCountryTag:IsReal()
		and loTargetCountryTag:IsValid() then
		
			local playerTag = CCurrentGameState.GetPlayer()
			local loRelation = ai:GetRelation(ministerTag, loTargetCountryTag)
			if not(loRelation:HasNap()) and not playerTag == loTargetCountryTag then
				local loAction = CNapAction(ministerTag, loTargetCountryTag)	
				
				if loAction:IsSelectable() then
					if DiploScore_NonAgression( ai, ministerTag, loTargetCountryTag, ministerTag ) > 50 then
						local liScore = loAction:GetAIAcceptance()
					
						if liScore > 50 then
							ai:PostAction(loAction)
						end
					end
				end
			end
		end
	end
	
	-- Main Country processing loop
	for loTargetCountry in CCurrentGameState.GetCountries() do
		local loTargetCountryTag = loTargetCountry:GetCountryTag()

		if not(ministerCountry:HasDiplomatEnroute(loTargetCountryTag))
		and not(loTargetCountryTag == ministerTag) 
		and loTargetCountry:Exists()
		and loTargetCountryTag:IsReal()
		and loTargetCountryTag:IsValid() then
		
			local loRelation = ai:GetRelation(ministerTag, loTargetCountryTag)
			
			-- ONLY MAJOR POWERS CAN DO
			if lbIsMajor then
				-- Calls in here Require Major be in a faction and target is not in a faction
				if ministerCountry:HasFaction() and not(loTargetCountry:HasFaction()) then
					-- Invite into faction, if Faction Leader
					if ministerCountry:IsFactionLeader() then
						local loAction = CFactionAction(ministerTag, loTargetCountryTag)
						loAction:SetValue(false)

						if loAction:IsSelectable() then
							local liScore = loAction:GetAIAcceptance()
							
							-- We don't want everyone in our club, mind you!
							if DiploScore_InviteToFaction(ai, ministerTag, loTargetCountryTag, ministerTag) > 50 then
								if liScore > math.random(1,25) then		-- They can be more bold occasionally.
									minister:Propose(loAction, liScore )
								end
							end
						end
					end

					-- Influence a country
					local lbIsInfluencing = ai:IsInfluencing(ministerTag, loTargetCountryTag)

					if tostring(ministerTag) == tagString then
						Utils.LUA_DEBUGOUT("Influencing " .. tostring(loTargetCountryTag) .. ": " .. tostring(lbIsInfluencing))
					end
					
					-- Do we have any slots actually open
					--   Only do one influence per tick
					if liInfluenceLeft > 0 and not(lbIsInfluencing) then
						local liScore = DiploScore_InfluenceNation( ai, ministerTag, loTargetCountryTag, ministerTag )
						
						if liScore > loInfluenceActionScore then
							loInfluenceActionScore = liScore
							loInfluenceAction = CInfluenceNation(ministerTag, loTargetCountryTag)

							if tostring(ministerTag) == tagString then
								Utils.LUA_DEBUGOUT("InfluenceAction... " .. tostring(loInfluenceActionScore))
							end
						
						-- Help try and keep neighbors from joining my enemies
						elseif ministerCountry:IsNeighbour(loTargetCountryTag) and loInfluenceActionWorst == nil then
							if not(Utils.IsFriend(ai, loFaction, loTargetCountry)) then
								if Utils.CallScoredCountryAI(ministerTag, 'DiploScore_InfluenceNation', 100, ai, ministerTag, loTargetCountryTag, ministerTag) > 25 then
									loInfluenceActionWorst = CInfluenceNation(ministerTag, loTargetCountryTag)

									if tostring(ministerTag) == tagString then
										Utils.LUA_DEBUGOUT("InfluenceWorst...")
									end

								end		-- Otherwise we have nothing to worry about!
							end
						end
						
					-- Track who we are currently influencing
					elseif lbIsInfluencing then
						table.insert(loInfluenceCountry, loTargetCountry)
						table.insert(loInfluenceScore, DiploScore_InfluenceNation( ai, ministerTag, loTargetCountryTag, ministerTag ))

						if tostring(ministerTag) == tagString then
							Utils.LUA_DEBUGOUT("Influencing...")
						end
						
					-- Help try and keep neighbors from joining my enemies
					elseif ministerCountry:IsNeighbour(loTargetCountryTag) and loInfluenceActionWorst == nil then
						if not(Utils.IsFriend(ai, loFaction, loTargetCountry)) then
							if Utils.CallScoredCountryAI(ministerTag, 'DiploScore_InfluenceNation', 100, ai, ministerTag, loTargetCountryTag, ministerTag) > 25 then
								loInfluenceActionWorst = CInfluenceNation(ministerTag, loTargetCountryTag)

									if tostring(ministerTag) == tagString then
										Utils.LUA_DEBUGOUT("InfluenceWorst2...")
									end

							end		-- Otherwise we have nothing to worry about!
						end
					end
				end
			end
			-- END OF MAJOR POWER ONLY

			-- Form Alliance
			
			if not(loRelation:HasAlliance())										-- Don't bother if we already have an alliance!
			then																	-- The specific function will take care of the rest!
				local loAction = CAllianceAction(ministerTag, loTargetCountryTag)
				if loAction:IsValid() and loAction:IsSelectable() then
					if DiploScore_Alliance( ai, ministerTag, loTargetCountryTag, ministerTag, loAction ) > 50 then
						local liScore = loAction:GetAIAcceptance()
					
						if liScore > 50 then
							ai:PostAction(loAction)
						end
					end
				end
			end	

			-- Guarantee
			if not(loRelation:IsGuaranting()) then
				local loAction = CGuaranteeAction(ministerTag, loTargetCountryTag)	
				
				if loAction:IsSelectable() then
					local liScore = DiploScore_Guarantee(ai, ministerTag, loTargetCountryTag, ministerTag)
					
					if liScore > 50 then
						minister:Propose(loAction, liScore)
					end
				end
			end
			
			-- SSmith (29/04/2013)
			-- These lines of code were causing the game to crash!
			-- Functionality for Lend-Lease will need to be included but let's get the game stable first!

			-- Lend-Lease
			--if (not ministerCountry:HasActiveLendLeaseFrom(loTargetCountryTag))
			--and (not ministerCountry:IsGivingLendLeaseToTarget(loTargetCountryTag)) then
			--	local loAction = CRequestLendLeaseAction(ministerTag, loTargetCountryTag)	
			--	if loAction:IsSelectable() then
			--		if DiploScore_RequestLendLease(ai, ministerTag, loTargetCountryTag, loTargetCountryTag, loAction) > 50 then
			--			ai:PostAction(loAction)
			--		end
			--	end
			--end	

			-- Allow Debt
			if not(loRelation:AllowDebts()) then
				local loAction = CDebtAction(ministerTag, loTargetCountryTag)	
				
				if loAction:IsSelectable() then
					local liScore = DiploScore_Debt( ai, ministerTag, loTargetCountryTag, ministerTag )

					if liScore > 50 then
						minister:Propose(loAction, liScore)
					end
				end
			end		

			-- Embargo
			local loAction = CEmbargoAction( ministerTag, loTargetCountryTag )
			
			-- SSmith (31/05/2013)
			-- I think I have finally found the fatal flaw in the embargo logic (in the diplomacy script!)
			-- So I shouldn't need to fix it here after all...

			if loRelation:HasEmbargo() then
				-- Do we want to stop embargoing?

				loAction:SetValue( false )
				
				if loAction:IsSelectable() then
				--and (loRelation:GetValue():Get() > 0 or loTargetCountry:CalculateIsAllied(ministerTag)) then

					local liScore = DiploScore_Embargo( ai, ministerTag, loTargetCountryTag, ministerTag )

					-- SSmith (11/05/2013)
					-- There is too much of an embargo/un-embargo cycle going on!
					-- So let's try reducing the score for removing an embargo (it was 40)

					if liScore < 20 then

						--Utils.LUA_DEBUGOUT(tostring(ministerTag) .. " un-embargoed " .. tostring(loTargetCountryTag))

						minister:Propose( loAction, 100 )
					end
				end
				
			else
				-- Do we want to embargo?

				-- SSmith (01/06/2013)
				-- We won't embargo puppets as it doesn't appear to work correctly

				if loAction:IsSelectable() and not loTargetCountry:IsSubject() then
				--and loRelation:GetValue():Get() < 0 and not loTargetCountry:CalculateIsAllied(ministerTag) then

					local liScore = DiploScore_Embargo( ai, ministerTag, loTargetCountryTag, ministerTag )

					-- SSmith (31/05/2013)
					-- I will make the final decision in the if statement so I can keep the logging clean!

					if liScore > 50 and math.random(0,100) < liScore then

						--Utils.LUA_DEBUGOUT(tostring(ministerTag) .. " embargoed " .. tostring(loTargetCountryTag))

						minister:Propose( loAction, 100 )
						--minister:Propose( loAction, liScore )
					end
				end
			end
			
			-- Breaking NAPs
			
			if loRelation:HasNap() then

				local fightingOurFriends = false
				
				for allyTag in ministerCountry:GetAllies() do
					if allyTag:GetCountry():GetRelation(loTargetCountryTag):HasWar() then
						fightingOurFriends = true				-- One of our friends is at war with this nation!
						break									-- Don't check the rest, it would be useless anyway.
					end
				end
				
				if fightingOurFriends then
					-- If they are fighting one of our buddies, then we should break this NAP!
					local action = CNapAction(ministerTag, loTargetCountryTag)
					action:SetValue(false)
					if action:IsSelectable() then
						ai:PostAction( action )
					end
				end
			end
			
		end
	end
	-- END OF MAIN LOOP
	
	-- Break Alliance
	for loTargetCountryTag in ministerCountry:GetAllies() do
		local liScore = DiploScore_BreakAlliance(ai, ministerTag, loTargetCountryTag, ministerTag)

		if liScore >= 100 then
			local loAction = CAllianceAction(ministerTag, loTargetCountryTag)
			loAction:SetValue(false) -- cancel
			
			if loAction:IsSelectable() then
				minister:Propose(loAction, liScore )
			end
		end
	end

	
	if Utils.HasCountryAIFunction( ministerTag, "AlignToFaction") then
		Utils.CallCountryAI(ministerTag, "AlignToFaction", minister)	
	else
		if not ministerCountry:HasFaction()
		and not ministerCountry:IsSubject()
		and ( ministerCountry:IsAtWar() or ministerCountry:GetNeutrality():Get() < 75 )
		then		
			for loTargetCountry in CCurrentGameState.GetCountries() do	-- Check the countries!
				if loTargetCountry:IsFactionLeader() then				-- Only interested in Faction leaders.
					local loTargetCountryTag = loTargetCountry:GetCountryTag()
					local leaderThreat = ai:GetRelation(ministerTag, loTargetCountryTag):GetThreat():Get()
					local loAction = CInfluenceAllianceLeader(ministerTag, loTargetCountryTag)	-- Try aligning to our ideological faction!
					if leaderThreat < 25 or leaderThreat > 75 then								-- But only if they are not/too threatening!
						if loTargetCountryTag:GetCountry():GetFaction():GetIdeologyGroup() == ministerCountry:GetRulingIdeology():GetGroup() then
							loAction:SetValue(true)
						else
							loAction:SetValue(false)
						end
						if loAction:IsSelectable() then
							minister:Propose(loAction, 100 )
						end
					end
				end
				if loTargetCountry:GetRelation(ministerTag):HasWar() and loTargetCountry:HasFaction() then
					local loAction = CInfluenceAllianceLeader(ministerTag, loTargetCountry:GetFaction():GetFactionLeader())
					loAction:SetValue(false)
					minister:Propose(loAction, 100 )
				end
			end
		else			-- Otherwise stop aligning!
			for faction in CCurrentGameState.GetFactions() do
				local factionLeader = faction:GetFactionLeader()
				local leaderThreat = ai:GetRelation(ministerTag, factionLeader):GetThreat():Get()
				if faction:GetIdeologyGroup() ~= ministerCountry:GetRulingIdeology():GetGroup()		-- Wrong ideology
				or ( leaderThreat > 25 and leaderThreat < 75 )										-- or aggressive behaviour!
				then
					local loAction = CInfluenceAllianceLeader(ministerTag, factionLeader)
					loAction:SetValue(false)
					if loAction:IsSelectable() then
						minister:Propose(loAction, 100 )
					end
				end
			end
		end
	end
	
	-- Decide what to do with the Influence setup from main loop

	-- SSmith (25/06/2013)
	-- I caught Germany with no diplomacy points at all because it was running influences
	-- We need to make sure there is always some influence in reserve
	-- So we won't start influencing if unless we have 10 points available
	-- We will stop if we go below 6 points because we don't the AI throwing too much leadership into diplomacy

	local currentDiplomats = ministerCountry:GetDiplomaticInfluence():Get()
	local neededDiplomats = 20
	if ministerCountry:GetTotalIC() < 100 then
		neededDiplomats = 12
	end
	--local minDiplomats = 6

	if tostring(ministerTag) == tagString then
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("Diplomats: " .. tostring(currentDiplomats))
	end

	if lbIsMajor and currentDiplomats >= neededDiplomats then
		if table.getn(loInfluenceCountry) > 0 then

			if tostring(ministerTag) == tagString then
				Utils.LUA_DEBUGOUT("NoOfInfluences: " .. tostring(table.getn(loInfluenceCountry)))
			end

			local lbNeighborCheck = false -- Make sure atleast 1 influence is to prevent someone joining enemy
			
			for i = 1, table.getn(loInfluenceCountry) do
				if ministerCountry:IsNeighbour(loInfluenceCountry[i]:GetCountryTag()) then
					if not(Utils.IsFriend(ai, loFaction, loInfluenceCountry[i])) then
						lbNeighborCheck = true
					end
				end
			end
			
			-- We have a slot open and we have a bad neighbor and no influence is going 
			--  to another bad neighbor
			if not(lbNeighborCheck) and not(loInfluenceActionWorst == nil) and liInfluenceLeft > 0 then

				ai:PostAction(loInfluenceActionWorst)
			
			-- Cancel a random influence to effect one of our bad neighbors
			elseif not(lbNeighborCheck) and not(loInfluenceActionWorst == nil) and liInfluenceLeft <= 0 then

				loInfluenceAction = CInfluenceNation(ministerTag, loInfluenceCountry[math.random(table.getn(loInfluenceCountry))]:GetCountryTag())
				loInfluenceAction:SetValue(false)

				-- SSmith (25/06/2013)
				-- Use ai:PostAction instead

				ai:PostAction(loInfluenceAction)
				--minister:Propose(loInfluenceAction , 1000 )
				
				-- Send up the neighbor one
				ai:PostAction(loInfluenceActionWorst)
				--minister:Propose(loInfluenceActionWorst , 1000 )
				
			-- We are already influencing one bad neigbor (or dont have one) so do a regular influence
			elseif not(loInfluenceAction == nil) then

				ai:PostAction(loInfluenceAction)
			end
		
		elseif not(loInfluenceAction == nil) and liInfluenceLeft > 0 then

			ai:PostAction(loInfluenceAction)
			
		elseif not(loInfluenceActionWorst == nil) and liInfluenceLeft > 0 then

			-- SSmith (25/06/2013)
			-- Use ai:PostAction instead

			ai:PostAction(loInfluenceActionWorst)
			--minister:Propose(loInfluenceActionWorst , 1000 )
		end

		-- SSmith (29/05/2013)
		-- We must stop influencing if our diplomacy falls too low!

		--if currentDiplomats < minDiplomats then

		--	for i = 1, table.getn(loInfluenceCountry) do
		--		local loInfluenceCancel = CInfluenceNation(ministerTag, loInfluenceCountry[i]:GetCountryTag())
		--		loInfluenceCancel:SetValue(false)

		--		if tostring(ministerTag) == tagString then
		--			Utils.LUA_DEBUGOUT("Cancelling..." .. tostring(loInfluenceCountry[i]:GetCountryTag()))
		--		end

				-- SSmith (25/06/2013)
				-- Use ai:PostAction instead

		--		ai:PostAction(loInfluenceCancel)
		--		--minister:Propose(loInfluenceCancel, 1000)
		--	end
		--end
	end
end

function ProposeDeclareWar( minister )
	local ai = minister:GetOwnerAI()
	local ministerCountry = minister:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	local targetTag = nil
	
	for potentialTargetTag in ministerCountry:GetNeighbours() do					-- Check our neighbours!
		if not ministerCountry:CalculateIsAllied(potentialTargetTag) then			-- Only worry about non-allied ones!
			if CalculateWarDesirability(ai, ministerCountry, potentialTargetTag) > 50 then	-- Do we want to go to war with them?
				targetTag = potentialTargetTag
				break
			end
		end
	end
	
	return targetTag
end