-----------------------------------------------------------
-- LUA Hearts of Iron 3 Belgium File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 5/22/2010
-----------------------------------------------------------

local P = {}
AI_BEL = P

function P.DiploScore_InviteToFaction(score, ai, actor, recipient, observer)
	-- Whatever their chance is lower it by 10 makes it harder to get them in
	return (score - 10)
end

function P.HandleMobilization( minister, needsMobilization )

	-- SSmith (01/05/2013)
	-- Customer mobilization function added
	-- Belgium should mobilize if Holland is attacked

	local gerTag = CCountryDataBase.GetTag('GER')
	local holTag = CCountryDataBase.GetTag('HOL')

	if gerTag:GetCountry():GetRelation( holTag ):HasWar() or Support.IsDefeated( gerTag, holTag ) then
		needsMobilization = true
	end

	return needsMobilization
end

return AI_BEL

