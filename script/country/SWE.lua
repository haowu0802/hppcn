-----------------------------------------------------------
-- LUA Hearts of Iron 3 Sweden File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 5/22/2010
-----------------------------------------------------------

local P = {}
AI_SWE = P

function P.DiploScore_OfferTrade(score, ai, actor, recipient, observer, voTradedFrom, voTradedTo)
	if tostring(actor) == "GER" then
		score = score + 20
	end
	
	return score
end

function P.ForeignMinister_EvaluateDecision( score, agent, decision, scope )
	
	-- SSmith (26/08/2013)
	-- Add random chances to make the decisions more realistic

	if decision:GetKey():GetString() == 'finnish_winter_war_swedish_intervention' then
		if math.mod( CCurrentGameState.GetAIRand(), 20) == 1 then
			score = 100
		else
			score = 0
		end
	elseif decision:GetKey():GetString() == 'finnish_winter_war_swedish_direct_intervention' then
		-- This might not sound too bright but we are assuming that if the AI manages to get the requirements, then they should always want to DoW. They couldn't prepare properly anyway. It's basically just for fun.
		if math.mod( CCurrentGameState.GetAIRand(), 20) == 1 then
			score = 100
		else
			score = 0
		end
	end

	return score
end

function P.DiploScore_LicenceTechnology( score, ai, actor, recipient, observer)
	return score + 25
end

-- Production Weights
--   1.0 = 100% the total needs to equal 1.0
function P.ProductionWeights( minister )
	local laArray = {
		0.60,	-- Land
		0.10,	-- Air
		0.20,	-- Sea
		0.10};	-- Other
	
	return laArray
end

-- Naval ratio distribution
function P.NavalRatio( minister )
	local laArray = {
		3, -- Destroyers
		1, -- Submarines
		3, -- Cruisers
		0, -- Capital
		0, -- Escort Carrier
		0}; -- Carrier
	
	return laArray
end

return AI_SWE

