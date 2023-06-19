-----------------------------------------------------------
-- LUA Hearts of Iron 3 Romania File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 4/23/2010
-----------------------------------------------------------

local P = {}
AI_ROM = P

function P.DiploScore_OfferTrade(score, ai, actor, recipient, observer, voTradedFrom, voTradedTo)
	if tostring(actor) == "GER" or tostring(actor) == "ITA" then
		score = score + 10
	elseif tostring(actor) == "SOV" then
		score = score - 10
	end
	
	return score
end

function P.ForeignMinister_EvaluateDecision(score, agent, decision, scope)
	local lsDecision = tostring(decision:GetKey())
	local country = agent:GetCountry()
	
	if lsDecision == "bow_to_soviet_demands" then
		score = country:GetSurrenderLevel():Get() * 100
	elseif lsDecision == 'give_back_territory_to_HUN' then
		score = 0
	end
	
	return score
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

return AI_ROM

