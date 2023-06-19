-----------------------------------------------------------
-- LUA Hearts of Iron 3 Turkey File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 6/9/2010
-----------------------------------------------------------

local P = {}
AI_TUR = P

function P.DiploScore_OfferTrade(score, ai, actor, recipient, observer, voTradedFrom, voTradedTo)
	if tostring(actor) == "GER" then
		score = score + 15
	end
	
	return score
end

return AI_TUR
