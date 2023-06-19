-----------------------------------------------------------
-- Spanish Republic
-----------------------------------------------------------

local P = {}
AI_SPR = P

-- SSmith (10/05/2013)
-- I have removed the custom TechSliders function

function P.DiploScore_OfferTrade(score, ai, actor, recipient, observer, voTradedFrom, voTradedTo)
	if tostring(actor) == "SOV" then
		score = score + 15
	end
	
	return score
end

function P.HandlePuppets(minister)

	-- SSmith (22/11/2013)
	-- Add exceptions for Nationalist Spain and Morocco

	local laCountryExceptions = { "SPA", "MOR" }
	return laCountryExceptions
end

return AI_SPR
