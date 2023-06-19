-----------------------------------------------------------
-- LUA Hearts of Iron 3 New Zealand File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 5/5/2010
-----------------------------------------------------------

local P = {}
AI_NZL = P

-- Production Weights
--   1.0 = 100% the total needs to equal 1.0
function P.ProductionWeights(minister)
	local rValue
	
	-- SSmith (28/05/2013)
	-- Custom production weights

	if minister:GetCountry():IsAtWar() then
		local laArray = {
			0.60, -- Land
			0.20, -- Air
			0.10, -- Sea
			0.10}; -- Other
		
		rValue = laArray	
	else
		local laArray = {
			0.25, -- Land
			0.25, -- Air
			0.15, -- Sea
			0.35}; -- Other
		
		rValue = laArray
	end
	
	return rValue
end

-- Transport to Land unit distribution
function P.TransportLandRatio(minister)

	-- SSmith (28/05/2013)
	-- Custom transport ratios

	if minister:GetCountry():IsAtWar() then
		local laArray = {
			8, -- Land
			1}; -- Transport
		return laArray
	else
		local laArray = {
			20, -- Land
			1}; -- Transport
		return laArray
	end
end

function P.DiploScore_OfferTrade(score, ai, actor, recipient, observer, voTradedFrom, voTradedTo)
	local lsActorTag = tostring(actor)
	
	if lsActorTag == "AST" 
	or lsActorTag == "CAN" 
	or lsActorTag == "SAF" 
	or lsActorTag == "ENG" 
	or lsActorTag == "FRA" then
		score = score + 20
	end
	
	return score
end

return AI_NZL

