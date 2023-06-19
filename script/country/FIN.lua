-----------------------------------------------------------
-- Finland
-----------------------------------------------------------

local P = {}
AI_FIN = P

-- Have Finland Fortify the Soviet border
function P.Build_Fort(ic, minister, vbGoOver)
	-- Let's build up the Mannerheim Line!
	ic = Support.Build_Fort(ic, minister, 45, 1, vbGoOver) -- Vaalesjoki
	ic = Support.Build_Fort(ic, minister, 58, 1, vbGoOver) -- Nautsi
	
	ic = Support.Build_Fort(ic, minister, 164, 1, vbGoOver) -- Alakurtti
	
	ic = Support.Build_Fort(ic, minister, 267, 1, vbGoOver) -- Kostomuksha

	ic = Support.Build_Fort(ic, minister, 472, 1, vbGoOver) -- Suojärvi
	ic = Support.Build_Fort(ic, minister, 543, 1, vbGoOver) -- Salmi
	
	ic = Support.Build_Fort(ic, minister, 59, 1, vbGoOver) -- Valkjärvi
	ic = Support.Build_Fort(ic, minister, 740, 1, vbGoOver) -- Terijoki
	
	return ic
end

function P.HandleMobilization( minister, needsMobilization )
	
	local ministerCountry = minister:GetCountry()

	-- SSmith (28/11/2013)
	-- Also mobilize if Germany invades Poland
	
	local sovTag = CCountryDataBase.GetTag('SOV')
	local estTag = CCountryDataBase.GetTag('EST')
	local litTag = CCountryDataBase.GetTag('LIT')
	local latTag = CCountryDataBase.GetTag('LAT')
	local gerTag = CCountryDataBase.GetTag('GER')
	local polTag = CCountryDataBase.GetTag('POL')
	
	-- If the Soviets got the Baltic States, and the Winter War didn't just end, then we are next!
	if not ministerCountry:GetRelation(sovTag):HasNap()
	and not ministerCountry:GetRelation(sovTag):HasTruce()
	and ( Support.IsDefeated(sovTag, estTag)
	or Support.IsDefeated(sovTag, litTag)
	or Support.IsDefeated(sovTag, latTag)
	or Support.IsDefeated(gerTag, polTag) or gerTag:GetCountry():GetRelation(polTag):HasWar() )
	then
		needsMobilization = true
	end

	-- SSmith (28/11/2013)
	-- Also mobilize for Barbarossa

	local fraTag = CCountryDataBase.GetTag('FRA')
	local month = CCurrentGameState.GetCurrentDate():GetMonthOfYear()

	if ministerCountry:GetRelation(gerTag):HasAlliance()
	and ministerCountry:IsNeighbour(sovTag)
	and (gerTag:GetCountry():GetRelation(sovTag):HasWar()
	  or (Support.IsDefeated(gerTag, fraTag) and not Support.IsDefeated(gerTag, sovTag)))
	and (ministerCountry:IsMobilized()
	  or (month > 2 and month < 8))
	then
		needsMobilization = true
	end
	
	return needsMobilization
end

-- SSmith (31/08/2013)
-- New function to handle decisions
function P.ForeignMinister_EvaluateDecision(score, agent, decision, scope)
	local lsDecision = tostring(decision:GetKey())
	
	if not agent:GetCountry():IsSubject() then
		if lsDecision == 'give_back_territory_to_RUS' then
			score = 0
		end
	end
	
	return score
end

function P.AlignToFaction(minister)

	-- SSmith (10/11/2013)
	-- New function
	-- We will align to Germany if we have an alliance

	local ministerCountry = minister:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	
	local axisFaction = CCurrentGameState.GetFaction("axis")
	local axisLeader = axisFaction:GetFactionLeader()
	local alliesFaction = CCurrentGameState.GetFaction("allies")
	local alliesLeader = alliesFaction:GetFactionLeader()
	
	local targetLeader = nil	-- We will try to align towards them
	local stopLeader = nil		-- We will stop aligning towards them if we did previously
	
	if ministerCountry:GetRelation(axisLeader):HasAlliance() then
		-- Alliance with Germany
		stopLeader = alliesLeader
		targetLeader = axisLeader
	elseif ministerCountry:GetRelation(axisLeader):HasWar() and not ministerCountry:GetRelation(alliesLeader):HasWar() then
		-- War with the Axis but not with the Allies
		stopLeader = axisLeader
		targetLeader = alliesLeader
	end
	
	if stopLeader ~= nil then
		local stopAction = CInfluenceAllianceLeader(ministerTag, stopLeader)
		stopAction:SetValue(false)
		if stopAction:IsSelectable() then
			minister:Propose(stopAction, 1000 )
		end
	end
	if targetLeader ~= nil and ministerCountry:GetRelation(targetLeader):GetValue():Get() > 50 then
		-- Still don't align to people we don't like. It's better to be neutral.
		local startAction = CInfluenceAllianceLeader(ministerTag, targetLeader)
		startAction:SetValue(true)
		if startAction:IsSelectable() then
			minister:Propose(startAction, 1000 )
		end
	end
end

function P.DiploScore_Alliance( score, ai, actor, recipient, observer, action)

	-- SSmith (01/06/2013)
	-- Finland allies with Germany rather too early
	-- So we will check that the Soviets are on the ropes first and that we don't like them!

	local finTag = CCountryDataBase.GetTag('FIN')
	local sovTag = CCountryDataBase.GetTag('SOV')
	local gerTag = CCountryDataBase.GetTag('GER')
	local fraTag = CCountryDataBase.GetTag('FRA')
	local loRelation = ai:GetRelation(finTag, sovTag)
	local actorCountry = actor:GetCountry()
	local recipientCountry = recipient:GetCountry()

	if not observer:GetCountry():IsSubject() then
		if tostring(actor) == 'FIN' then
			if recipientCountry:GetRelation(sovTag):HasWar()				-- We should actually check if the Soviets hold any territory,
			and sovTag:GetCountry():GetSurrenderLevel():Get() > 0.10			-- but let's just assume they do. Actually, they start with some
			and Support.OwnsAnyCores( actor, sovTag )					-- provinces with Finnish cores anyway.
			and loRelation:GetValue():Get() < 0 then
				return 100
			else
				return 0
			end
		elseif tostring(recipient) == 'FIN' then
			if actorCountry:GetRelation(sovTag):HasWar()					-- We should actually check if the Soviets hold any territory,
			and sovTag:GetCountry():GetSurrenderLevel():Get() > 0.10			-- but let's just assume they do. Actually, they start with some
			and Support.OwnsAnyCores( recipient, sovTag )					-- provinces with Finnish cores anyway.
			and loRelation:GetValue():Get() < 0 then
				return 100
			else
				return 0
			end
		end
	end

	return score
end

function P.DiploScore_CallAlly(liScore, ai, actor, recipient, observer)

	-- SSmith (03/07/2013)
	-- We need to be sure we will accept Germany's call to arms against the Soviets

	if observer == recipient then
		local sovTag = CCountryDataBase.GetTag('SOV')
		-- Don't join a war against the Soviets unless they appear to be losing

		if tostring(actor) == "GER"						-- Caller is Germany
		and actor:GetCountry():GetRelation(sovTag):HasWar() then		-- Germany is at war with Soviets
			if sovTag:GetCountry():GetSurrenderLevel():Get() < 0.10 then	-- USSR has a low Surrender Progress
				liScore = 0
			else
				liScore = 100
			end
		end
	end
	
	return liScore

end

-- Finland has very highly trained forces
function P.CallLaw_training_laws(minister, voCurrentLaw)
	local _SPECIALIST_TRAINING_ = 31
	return CLawDataBase.GetLaw(_SPECIALIST_TRAINING_)
end

return AI_FIN
