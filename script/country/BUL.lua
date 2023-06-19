-----------------------------------------------------------
-- LUA Hearts of Iron 3 Bulgaria File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 7/26/2010
-----------------------------------------------------------

local P = {}
AI_BUL = P

function P.Call_ForeignMinister(minister)
	local ministerTag = minister:GetCountryTag()
	local ministerCountry = ministerTag:GetCountry()

	if not(ministerCountry:HasFaction()) and not(ministerCountry:IsAtWar()) then
		-- If Bulgaria controls the border provinces with Romania assume it was due to German influence and align with them
		if CCurrentGameState.GetProvince(4058):GetOwner() == ministerTag then
			local loAction = CInfluenceAllianceLeader(ministerTag, CCountryDataBase.GetTag("GER"))
			
			if loAction:IsSelectable() then
				minister:GetOwnerAI():PostAction(loAction)
			end
		end
	end
end

function P.ForeignMinister_EvaluateDecision(score, agent, decision, scope)
	local lsDecision = decision:GetKey():GetString()
	
	-- SSmith (26/08/2013)
	-- Function added to handle the claim on Constanta

	if lsDecision == "bulgarian_claims_for_constanta" then
		if math.mod( CCurrentGameState.GetAIRand(), 10) == 1 then
			score = 100
		else
			score = 0
		end
	end
	
	return score
end

return AI_BUL
