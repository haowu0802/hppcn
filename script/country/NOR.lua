local P = {}
AI_NOR = P


function P.ProductionWeights(minister)
	local laArray
	local ministerCountry = minister:GetCountry()
	
	if ministerCountry:IsAtWar() then
		-- War
		laArray = {
			0.80, -- Land
			0.10, -- Air
			0.10, -- Sea
			0.0}; -- Other
	else
		-- Peace
		laArray = {
			0.05, -- Land
			0.15, -- Air
			0.50, -- Sea
			0.3}; -- Other
	end
	
	return laArray
end

function P.ForeignMinister_EvaluateDecision(score, agent, decision, scope)
	local lsDecision = tostring(decision:GetKey())
	
	-- SSmith (26/08/2013)
	-- Added function to handle the surrender

	if lsDecision == "norwegian_surrender" then
		if agent:GetCountry():GetSurrenderLevel():Get() > 0.75
		and math.mod( CCurrentGameState.GetAIRand(), 10) == 1 then
			score = 100
		else
			score = 0
		end
	end

	return score
end

return AI_NOR
