local P = {}
AI_DEN = P


-- Production Weights
--   1.0 = 100% the total needs to equal 1.0
function P.ProductionWeights( minister )
	local laArray = {
		0.70,	-- Land
		0.00,	-- Air
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

return AI_DEN

