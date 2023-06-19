-----------------------------------------------------------
-- LUA Hearts of Iron 3 Vichy File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 4/27/2010
-----------------------------------------------------------

local P = {}
AI_VIC = P

function P.HandleMobilization(minister, needsMobilization)
	return false
end

function P.DiploScore_CallAlly(score, ai, actor, recipient, observer)
	return 0
end

function P.DiploScore_InviteToFaction(score, ai, actor, recipient, observer)
	-- Stay out of the war, we do not care whats happening around us
	if not(observer:GetCountry():IsAtWar()) then
		score = 0
	end
	
	return score
end

function P.DiploScore_Alliance(score, ai, actor, recipient, observer, action)
	-- Stay out of the war, we do not care whats happening around us
	if not(observer:GetCountry():IsAtWar()) then
		score = 0
	end
	
	return score	
end

function P.CallLaw_conscription_law(minister, voCurrentLaw)
	local _VOLUNTEER_ARMY_ = 23
	return CLawDataBase.GetLaw(_VOLUNTEER_ARMY_)
end

function P.CallLaw_economic_law(minister, voCurrentLaw)
	local _FULL_CIVILIAN_ECONOMY_ = 10
	return CLawDataBase.GetLaw(_FULL_CIVILIAN_ECONOMY_)
end

function P.CallLaw_industrial_policy_laws(minister, voCurrentLaw)
	local _CONSUMER_PRODUCT_ORIENTATION_ = 15
	return CLawDataBase.GetLaw(_CONSUMER_PRODUCT_ORIENTATION_)
end

return AI_VIC
