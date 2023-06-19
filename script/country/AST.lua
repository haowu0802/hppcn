-----------------------------------------------------------
-- LUA Hearts of Iron 3 Australia File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 5/7/2010
-----------------------------------------------------------

local P = {}
AI_AST = P

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

-- Have Germany Fortify the French Line
function P.Build_AirBase(ic, minister, vbGoOver)
	-- Only build the airbases if its 1940 or less
	if minister:GetOwnerAI():GetCurrentDate():GetYear() <= 1940 then
		ic = Support.Build_AirBase(ic, minister, 7823, 2, vbGoOver) -- Cooktown
		ic = Support.Build_AirBase(ic, minister, 7842, 4, vbGoOver) -- Townsville
	end
	
	return ic
end

function P.DiploScore_OfferTrade(score, ai, actor, recipient, observer, voTradedFrom, voTradedTo)
	local lsActorTag = tostring(actor)
	
	if lsActorTag == "ENG" 
	or lsActorTag == "CAN" 
	or lsActorTag == "SAF" 
	or lsActorTag == "NZL" 
	or lsActorTag == "FRA" then
		score = score + 20
	end
	
	return score
end

return AI_AST

