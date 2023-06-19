-----------------------------------------------------------
-- Nationalist Spain
-----------------------------------------------------------

local P = {}
AI_SPA = P

-- SSmith (10/05/2013)
-- I have removed the custom TechSliders function

function P.DiploScore_OfferTrade(score, ai, actor, recipient, observer, voTradedFrom, voTradedTo)
	if tostring(actor) == "GER" or tostring(actor) == "ITA" then
		score = score + 15
	end
	
	return score
end

function P.HandlePuppets(minister)

	-- SSmith (22/11/2013)
	-- Add exceptions for Spanish Republic and Morocco

	local laCountryExceptions = { "SPR", "MOR" }
	return laCountryExceptions
end

function P.DiploScore_InviteToFaction(score, ai, actor, recipient, observer)

	-- SSmith (15/11/2013)
	-- New function to handle the Spanish reaction to a German faction invite
	
	if observer == recipient then			-- We are being invited
		if tostring(actor) == "GER" then	-- by Germany

			score = 100						-- Assume we will say yes!
			local actorCountry = actor:GetCountry()			-- But there might be reasons to say no!
			local fraTag = CCountryDataBase.GetTag('FRA')
			local usaTag = CCountryDataBase.GetTag('USA')
			local sovTag = CCountryDataBase.GetTag('SOV')
			if actorCountry:IsAtWar() then
				if recipient:GetCountry():GetVariables():GetVariable(CString("ai_hendaye")):Get() < 1.5		-- Hendaye AI flag is not set!
				or (actorCountry:GetRelation(fraTag):HasWar() and not Support.IsDefeated(actor, fraTag))	-- Germany hasn't beaten France!
				or actorCountry:GetRelation(usaTag):HasWar()							-- Germany is at war with the USA!
				or (actorCountry:GetRelation(sovTag):HasWar() and not Support.IsDefeated(actor, sovTag)		-- Germany isn't beating the Soviets!
				    and sovTag:GetCountry():GetSurrenderLevel():Get() < 0.25)
				or actorCountry:GetSurrenderLevel():Get() > 0.01 then						-- Germany is losing!
					score = 0
				end
			end
		end
	end
	
	return score
end

return AI_SPA
