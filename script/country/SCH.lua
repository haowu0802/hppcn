-----------------------------------------------------------
-- LUA Hearts of Iron 3 Switzerland File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 4/27/2010
-----------------------------------------------------------

local P = {}
AI_SCH = P

function P.HandleMobilization(minister, needsMobilization)
	return false
end

function P.DiploScore_InviteToFaction( score, ai, actor, recipient, observer)
	-- Stay out of the war, we do not care whats happening around us
	if not(recipient:GetCountry():IsAtWar()) then
		score = 0
	end
	
	return score
end

function P.DiploScore_Alliance(score, ai, actor, recipient, observer, action)
	-- Stay out of the war, we do not care whats happening around us
	if not(recipient:GetCountry():IsAtWar()) then
		score = 0
	end
	
	return score	
end

return AI_SCH
