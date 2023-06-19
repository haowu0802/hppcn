local P = {}
AI_HUN = P

function P.ForeignMinister_EvaluateDecision(score, agent, decision, scope)
	local lsDecision = tostring(decision:GetKey())
	
	if not agent:GetCountry():IsSubject() then
		if lsDecision == 'give_back_territory_to_ROM' then
			score = 0
		elseif lsDecision == 'give_back_territory_to_YUG' then
			score = 0
		elseif lsDecision == 'give_back_territory_to_SLO' then
			score = 0
		elseif lsDecision == 'give_back_territory_to_CZE' then
			score = 0
		end
	end

	-- SSmith (26/08/2013)
	-- Added random chance to make the decision realistic

	if lsDecision == "the_second_vienna_award" then
		if math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			score = 100
		else
			score = 0
		end
	end

	
	return score
end

function P.SpyPriority(ministerTag, ministerCountry, TargetCountry, TargetCountryTag)

	if ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( ministerCountry ) ) 
	or ( not Utils.ASSERT( TargetCountry ) )
	or ( not Utils.ASSERT( TargetCountryTag ) )
	then
		return nil
	end
	
	-- this is a bit of a cheat to get Hungary into the Axis (and then let it calm down)
	if tostring(TargetCountryTag) == "ROM" and CCurrentGameState.GetCurrentDate():GetYear() < 1941
	and not ministerCountry:GetRelation(TargetCountryTag):HasWar() and not ministerCountry:HasFaction() then
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
	
	-- this is a bit of a cheat to get Hungary into the Axis (and then let it calm down)
	if tostring(TargetCountryTag) == "ROM" and CCurrentGameState.GetCurrentDate():GetYear() < 1941
	and not ministerCountry:GetRelation(TargetCountryTag):HasWar() and not ministerCountry:HasFaction() then
		CountryScriptMission = "IncreaseThreat"
	end

	return CountryScriptMission	
end

function P.HandleMobilization( minister, needsMobilization )
	
	-- SSmith (28/11/2013)
	-- Function added to mobilize before Barbarossa

	local ministerCountry = minister:GetCountry()
	local gerTag = CCountryDataBase.GetTag('GER')
	local sovTag = CCountryDataBase.GetTag('SOV')
	local fraTag = CCountryDataBase.GetTag('FRA')
	local month = CCurrentGameState.GetCurrentDate():GetMonthOfYear()

	if ministerCountry:GetRelation(gerTag):HasAlliance()
	and ministerCountry:IsNeighbour(sovTag)
	and (gerTag:GetCountry():GetRelation(sovTag):HasWar()
	  or (Support.IsDefeated(gerTag, fraTag) and not Support.IsDefeated(gerTag, sovTag)))
	and (ministerCountry:IsMobilized()
	  or (month > 2 and month < 8))
	then
		needsMobilization = true
	end
	
	return needsMobilization
end

return AI_HUN
