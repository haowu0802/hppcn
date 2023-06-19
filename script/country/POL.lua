local P = {}
AI_POL = P

-- Tech weights
--   1.0 = 100% the total needs to equal 1.0
function P.TechWeights(minister)

	-- SSmith (23/07/2013)
	-- Tech weights changed to new format

	local laTechWeights = {
		0.55, -- Land
		0.25, -- Air
		0.00, -- Naval
		0.20}; -- Other
	
	return laTechWeights
end

function P.ProductionWeights(minister)
	local laArray
	local ministerCountry = minister:GetCountry()
	
	if ministerCountry:IsAtWar() then
		laArray = {
			0.70, 	-- Land
			0.30, 	-- Air
			0.0, 	-- Sea
			0.0}; 	-- Other
	else
		laArray = {
			0.70, 	-- Land
			0.15, 	-- Air
			0.0, 	-- Sea
			0.15};	-- Other
	end
	
	return laArray
end
-- Land ratio distribution
function P.LandRatio(minister)

	-- SSmith (21/06/2013)
	-- Bring this more in line with the defaults

	local laArray = {
		2, -- Garrison
		15, -- Infantry
		3, -- Motorized
		0, -- Mechanized
		3, -- Armor
		0, -- Militia
		2}; -- Cavalry
	
	return laArray
end

-- SSmith (08/06/2013)
-- Custom special forces ratio removed

-- Special Forces ratio distribution
--function P.SpecialForcesRatio(minister)
--	local laArray = {
--		50, -- Land
--		1}; -- Special Forces Unit
--	
--	return laArray
--end

-- Air ratio distribution
function P.AirRatio(minister)
	local laArray = {
		3, -- Fighter
		0, -- CAS
		1, -- Tactical
		0, -- Naval Bomber
		0}; -- Strategic
	
	return laArray
end
-- Naval ratio distribution
function P.NavalRatio(minister)
	local laArray = {
		3, -- Destroyers
		2, -- Submarines
		3, -- Cruisers
		1, -- Capital
		0, -- Escort Carrier
		0}; -- Carrier
	
	return laArray
end
-- Transport to Land unit distribution
function P.TransportLandRatio(minister)
	laArray = {
		120, -- Land
		1}; -- Transport	
	
	return laArray
end

function P.ForeignMinister_EvaluateDecision(score, agent, decision, scope)
	local lsDecision = decision:GetKey():GetString()
	
	-- SSmith (26/08/2013)
	-- Add random chance to make the decision realistic

	if lsDecision == "ask_to_join_allies" then
		if CCurrentGameState.GetCurrentDate():GetYear() < 1940 then
			-- Don't try this before '40! They probably wouldn't accept us anyway.
			score = 0
		else
			score = 100
		end
	elseif lsDecision == "ultimatum_to_lithuania" then
		if math.mod( CCurrentGameState.GetAIRand(), 10) == 1 then
			score = 100
		else
			score = 0
		end
	end
	
	return score
end

function P.AlignToFaction(minister)
	-- Don't align to anyone, for the moment. SHOULD THINK ABOUT THIS!
end

return AI_POL
