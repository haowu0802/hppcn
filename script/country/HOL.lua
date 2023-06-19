-----------------------------------------------------------
-- Netherlands
-----------------------------------------------------------

local P = {}
AI_HOL = P

function P.DiploScore_OfferTrade(score, ai, actor, recipient, observer, voTradedFrom, voTradedTo)
	if tostring(actor) == "JAP" then
		score = score + 30
	end
	
	return score
end

function P.HandlePuppets(minister)

	-- SSmith (22/11/2013)
	-- Add an exception for Indonesia

	local laCountryExceptions = { "INO" }
	return laCountryExceptions
end

function P.DiploScore_InviteToFaction(score, ai, actor, recipient, observer)
	-- Whatever their chance is lower it by 10 makes it harder to get them in
	return (score - 10)
end

function P.DiploScore_Embargo( score, ai, actor, recipient, observer)

	local japTag = CCountryDataBase.GetTag('JAP')
	local actorIdeologyGroup = actor:GetCountry():GetRulingIdeology():GetGroup()
	local recipientIdeologyGroup = recipient:GetCountry():GetRulingIdeology():GetGroup()

	if ( not actorIdeologyGroup == recipientIdeologyGroup )
	and	( recipient == japTag and CCurrentGameState.IsGlobalFlagSet( CString("us_oil_embargo") ) )	-- The Oil Embargo against Japan is supposed to be in effect
	then
		return 100
	end
	
	return score
end

return AI_HOL

