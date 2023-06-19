require('utils')

-- Used to measure the "idelogical distance" of two countries.
-- If they are within 25 points on the triangle, then they are considered to be ideological allies.
-- If they are at least 200 points away (ie. for example one is in one corner and the other is at least in the middle) then they are ideological enemies.
function CalculateAlignmentFactor( ai, country1, country2)

	if ( not Utils.ASSERT( ai ) )
	or ( not Utils.ASSERT( country1 ) )
	or ( not Utils.ASSERT( country2 ) )
	then
		return 0
	end

	local dist = ai:GetCountryAlignmentDistance( country1, country2 ):Get()
	dist = math.max( dist, 0.0 )
	dist = math.min( dist, 400.0 )
	return Support.LinearFunction(200.0, 25.0, dist)
end

function DiploScore_InviteToFaction( ai, actor, recipient, observer )

	if ( not Utils.ASSERT( ai ) )
	or ( not Utils.ASSERT( actor ) )
	or ( not Utils.ASSERT( recipient ) )
	or ( not Utils.ASSERT( observer ) )
	then
		return 0
	end

	local recipientCountry = recipient:GetCountry()
	local relation = recipientCountry:GetRelation(actor):GetValue():Get()
	-- The base chance depends on our relations.
	-- If it is only 25 or lower, then we definitely don't want them.
	-- Anyone above 150 is always welcome!
	local score = 100 * Support.LinearFunction( 25, 150, relation )

	if observer == actor then -- Is the recipient worth inviting or accepting
	
		if recipientCountry:IsAtWar() then
			for diploStatus in recipientCountry:GetDiplomacy() do
				local target = diploStatus:GetTarget()
				if target:IsValid() and diploStatus:HasWar() then
					if target:GetCountry():HasFaction()
					and not actor:GetCountry():GetRelation(target):HasWar()
					then				-- If they are the enemy of a faction that we are not, then no.
						score = 0
					end
				end
			end
		end
		
		return Utils.CallScoredCountryAI(actor, 'DiploScore_InviteToFaction', score, ai, actor, recipient, observer )
	else -- Do we want to join a faction or accept an Invitation?
	-- TODO:
	-- Check for wars we might join by this action more carefully!
		if recipientCountry:IsAtWar() then		-- If we are at war, then let's join, no matter what! We need friends! If this is the wrong faction,
			return Utils.CallScoredCountryAI( recipient, 'DiploScore_InviteToFaction', 100, ai, actor, recipient, observer ) -- we can still switch!
		else
			-- High Neutrality means we don't want to join.
			-- Higher than 90 means no, regardless of anything, between 75 and 90, countries are a bit hesitant, lower than that won't cause any problems.
			score = score * Support.LinearFunction( 90, 75, recipientCountry:GetNeutrality():Get() )
			local actorIdeologyGroupString = actor:GetCountry():GetRulingIdeology():GetGroup():GetKey()
			local recipientIdeologyString = actor:GetCountry():GetRulingIdeology():GetKey()
			local recipientIdeologyGroupString = recipient:GetCountry():GetRulingIdeology():GetGroup():GetKey()
			if actorIdeologyGroupString == recipientIdeologyGroupString then
				-- That's the perfect faction for us!
				score = score * 1.15
			elseif ( actorIdeologyGroupString == 'axis' and recipientIdeologyString == 'social_conservative' )
			or ( actorIdeologyGroupString == 'comintern' and recipientIdeologyString == 'social_democratic' )
			or ( actorIdeologyGroupString == 'allies' and recipientIdeologyString == 'paternal_autocrat' )
			or ( actorIdeologyGroupString == 'allies' and recipientIdeologyString == 'left_wing_radical' )
			then
				-- Not perfect, but acceptable.
				score = score * 0.75
			else
				-- We don't want to join the wrong faction if we are not at war, only in the four special cases or if we really have to...
				score = score * 0.10
			end
		end
		--Utils.LUA_DEBUGOUT("-------------------------------------")
		--Utils.LUA_DEBUGOUT("DiploScore_InviteToFaction (" .. tostring( actor )  .. "->" .. tostring( recipient ) .. ")")
		local faction = actor:GetCountry():GetFaction()
		
		if recipientCountry:IsNeighbourToFactionHostile(faction, true) 
		and (not recipientCountry:HasNeighborInFaction(faction ))
		then	-- Ie. they have an enemy neighbouring us but we don't neighbour any members
			score = 0
		end
		
		-- Threat Factor
		score = score * Support.ThreatFactor( recipient, actor )
		
		-- Check if Faction progress is relatively low!
		local factionProgress = actor:GetCountry():GetFaction():GetNormalizedProgress():Get()
		if factionProgress < 0.5 then
			score = score * factionProgress * factionProgress
		elseif factionProgress < 0.75 then
			score = score * factionProgress
		end
		
		return Utils.CallScoredCountryAI( recipient, 'DiploScore_InviteToFaction', score, ai, actor, recipient, observer )
	end
end

function DiploScore_NonAgression( ai, actor, recipient, observer )

	if ( not Utils.ASSERT( ai ) )
	or ( not Utils.ASSERT( actor ) )
	or ( not Utils.ASSERT( recipient ) )
	or ( not Utils.ASSERT( observer ) )
	then
		return 0
	end
	
	local score = 100 * Support.LinearFunction( 50, 150, ai:GetRelation( recipient, actor):GetValue():Get() )
	local nObsNeut = observer:GetCountry():GetNeutrality():Get()
	local nAlignmentFactor = CalculateAlignmentFactor( ai, actor:GetCountry(), recipient:GetCountry() )
	local nNeutralityFactor
	if nObsNeut < 80 then
		-- Interventionist
		nNeutralityFactor = Support.LinearFunction( 65, 80, nObsNeut )
	else
		-- Neutral, this effects acceptance and offering differently!
		if observer == recipient then
			-- Highly neutral nations are keen on accepting NAPs, eventhough they wouln't offer them themselves.
			nNeutralityFactor = 2.0 * Support.LinearFunction( 65, 100, nObsNeut )
		else
			nNeutralityFactor = Support.LinearFunction( 95, 80, nObsNeut )
		end
	end
	
	local nNAPAcceptanceChance = score * nAlignmentFactor * nNeutralityFactor

	if observer == actor then -- we demand nap with recipient
		if nNeutralityFactor > 0.33 and ( nNAPAcceptanceChance * Support.ThreatFactor( actor, recipient ) ) > 50 then
			-- We are in the range of proposing NAPs and want one with these guys!
			return DiploScore_NonAgression( ai, recipient, actor, observer )
		else
			return 0
		end
	else -- actor demands nap with us
		nNAPAcceptanceChance = nNAPAcceptanceChance * Support.ThreatFactor( recipient, actor )

		return Utils.CallScoredCountryAI( recipient, 'DiploScore_NonAgression', nNAPAcceptanceChance, ai, actor, recipient, observer )
	end
end

function DiploScore_DemandMilitaryAccess( ai, actor, recipient, observer )

	if ( not Utils.ASSERT( ai ) )
	or ( not Utils.ASSERT( actor ) )
	or ( not Utils.ASSERT( recipient ) )
	or ( not Utils.ASSERT( observer ) )
	then
		return 0
	end
	
	if observer == actor then -- We want to go through their land.
		local actorCountry = actor:GetCountry()
		if actorCountry:IsAtWar() then
			-- We only need this at war
			if DiploScore_DemandMilitaryAccess( ai, recipient, actor, observer ) < 50 then
				-- They probably wouldn't accept anyway.
				return 0
			end
			
			local neighborOfOurEnemy = false
			for theirNeighbor in recipient:GetCountry():GetNeighbours() do
				if actorCountry:GetRelation(theirNeighbor):HasWar() then
					neighborOfOurEnemy = true
					break
				end
			end
			
			if neighborOfOurEnemy then
				-- Makes sense
				return Utils.CallScoredCountryAI( recipient, "DiploScore_DemandMilitaryAccess", 100, ai, actor, recipient, observer )
			else
				-- No need to
				return Utils.CallScoredCountryAI( recipient, "DiploScore_DemandMilitaryAccess", 0, ai, actor, recipient, observer )
			end
		else
			return Utils.CallScoredCountryAI( recipient, "DiploScore_DemandMilitaryAccess", 0, ai, actor, recipient, observer )
		end
		
	else -- actor wants access through our territory
		local rel = actor:GetCountry():GetRelation( recipient)
		local score = 100 * Support.LinearFunction( 25, 100, rel:GetValue():Get() )
		
		-- Neutrality and Threat
		score = score * Support.LinearFunction( 90, 75, recipient:GetCountry():GetNeutrality():Get() )
		score = score * Support.ThreatFactor( recipient, actor )
		
		return Utils.CallScoredCountryAI( recipient, "DiploScore_DemandMilitaryAccess", score, ai, actor, recipient, observer )
	end
	
end

function DiploScore_OfferMilitaryAccess( ai, actor, recipient, observer )

	if ( not Utils.ASSERT( ai ) )
	or ( not Utils.ASSERT( actor ) )
	or ( not Utils.ASSERT( recipient ) )
	or ( not Utils.ASSERT( observer ) )
	then
		return 0
	end
	
	local score = 0
	if observer == recipient then -- We shouldn't offer Military access! At all.
		-- Let's see if we would want to get Access from them!
		score = DiploScore_DemandMilitaryAccess( ai, recipient, actor, observer )
 	end

	return Utils.CallScoredCountryAI( recipient, 'DiploScore_OfferMilitaryAccess', score, ai, actor, recipient, observer )
end

function DiploScore_Alliance( ai, actor, recipient, observer, action )

	if ( not Utils.ASSERT( ai ) )
	or ( not Utils.ASSERT( actor ) )
	or ( not Utils.ASSERT( recipient ) )
	or ( not Utils.ASSERT( observer ) )
	--or ( not Utils.ASSERT( action ) )	-- It seems that this might actually be a nil value, and it's not called anywhere anyway...
	then
		return 0
	end
	
	local recipientCountry = recipient:GetCountry()
	local actorCountry = actor:GetCountry()
	local strategy = actorCountry:GetStrategy()
	local rel = ai:GetRelation( recipient, actor)
	local score = 100 * Support.LinearFunction( 50, 200, rel:GetValue():Get() )
	
	if observer == actor then 		-- Should we offer an alliance?
	
		if actorCountry:IsFactionLeader()
		or actorCountry:GetNeutrality():Get() > 80 
		or recipientCountry:IsAtWar()
		then
			-- We shouldn't really offer alliances, unless dictated by the country-specific AI
			return Utils.CallScoredCountryAI( observer, 'DiploScore_Alliance', 0, ai, actor, recipient, observer, action )
		end
		
		-- Should only start to forge alliances if threatened!
		local highestThreatTag = actorCountry:GetHighestThreat()
		local highestThreatValue = actorCountry:GetRelation(highestThreatTag):GetThreat():Get()
		
		if highestThreatValue < 50 then		-- We have nothing to really worry about.
			score = 0
		else								-- We should start to look for allies!

			-- SSmith (24/12/2013)
			-- The actor and recipient were reversed in these checks!
			-- Also changed the first check from < 5.0 (which makes no sense)

			if recipient == highestThreatTag and Support.ThreatFactor( actor, recipient ) < 0.5 then
				-- Don't try to ally with the most obvious threat unless they are VERY strong as well!
				score = 0
			else
				-- If we even want to consider to offer an alliance, then do it based on relations and the highest threat!
				score = score * Support.ThreatFactor( actor, recipient) * CalculateAlignmentFactor( ai, actorCountry, recipientCountry)
			end
		end
		
		return Utils.CallScoredCountryAI( observer, 'DiploScore_Alliance', score, ai, actor, recipient, observer, action )
	else
		-- Should we accept an alliance?

		if recipientCountry:IsFactionLeader()
		or recipientCountry:GetNeutrality():Get() > 80
		or actorCountry:IsAtWar()
		then
			return Utils.CallScoredCountryAI( observer, 'DiploScore_Alliance', 0, ai, actor, recipient, observer, action )
		end
		
		local rel = ai:GetRelation( recipient, actor)
		local relation = 100 + rel:GetValue():GetTruncated()
		
		-- If we are at war, then all help is welcome! (If it comes from a somewhat logical place, that is...)
		if recipientCountry:IsAtWar()				-- We are at war
		and actorCountry:IsNeighbour( recipient)		-- and they are our neighbours.	(Checking for enemies' neighbours would be too much work.)
		then
			return Utils.CallScoredCountryAI( observer, 'DiploScore_Alliance', 100, ai, actor, recipient, observer, action )
		end

		score = score * Support.ThreatFactor( recipient, actor) * CalculateAlignmentFactor( ai, actorCountry, recipientCountry)

		-- check location
		local nLocationFactor
		if recipientCountry:IsNeighbour(actor) then
			nLocationFactor = 1.0
		else
			-- check if on same continent first
			local recipientContinent = recipientCountry:GetActingCapitalLocation():GetContinent()
			local actorContinent = actorCountry:GetActingCapitalLocation():GetContinent()
			if recipientContinent == actorContinent then
				nLocationFactor = 0.75
			else
				nLocationFactor = 0.5
			end
		end
		score = score * nLocationFactor
		
		-- check their wars
		if actorCountry:IsAtWar() then
			local bMutualEnemies = false
			for enemy in actorCountry:GetCurrentAtWarWith() do
				if recipientCountry:IsEnemy(enemy) then
					bMutualEnemies = true
				elseif recipientCountry:IsFriend(enemy, false) then
					return Utils.CallScoredCountryAI( observer, 'DiploScore_Alliance', 0, ai, actor, recipient, observer, action )
				end
			end
			
			if bMutualEnemies then
				score = score * 1.5
			elseif not recipientCountry:IsAtWar() then
				score = score * 0.25	-- We don't want to join a war if we are still at peace!
			end
		end

		return Utils.CallScoredCountryAI( observer, 'DiploScore_Alliance', score, ai, actor, recipient, observer, action )
	end
end

function DiploScore_PeaceAction(actor, recipient, observer, action )

	if ( not Utils.ASSERT( actor ) )
	or ( not Utils.ASSERT( recipient ) )
	or ( not Utils.ASSERT( observer ) )
	or ( not Utils.ASSERT( action ) )
	then
		return 0
	end

	local actorCountry = actor:GetCountry()
	local recipientCountry = recipient:GetCountry()
	local observerCountry = observer:GetCountry()
	-- observerDesperation will be the average of Desperation and Surrender Progress.
	local observerDesperation = ( observerCountry:CalcDesperation():Get() + observerCountry:GetSurrenderLevel():Get() ) * 0.5
	local relativeStrength = 1
	local score = 0
	
	if actorCountry:GetNumberOfControlledProvinces() > recipientCountry:GetNumberOfControlledProvinces() * 5 then
		-- Don't accept peace from much smaller foes, we can beat them easily!
		return 0
	end
	
	-- Special case for Civil Wars which should never end in a brokered peace!
	if ( actor == CCountryDataBase.GetTag('CHI') and recipient == CCountryDataBase.GetTag('CHC') )
	or ( actor == CCountryDataBase.GetTag('CHC') and recipient == CCountryDataBase.GetTag('CHI') )
	or ( actor == CCountryDataBase.GetTag('SPR') and recipient == CCountryDataBase.GetTag('SPA') )
	or ( actor == CCountryDataBase.GetTag('SPA') and recipient == CCountryDataBase.GetTag('SPR') )
	or ( actor == CCountryDataBase.GetTag('SOV') and recipient == CCountryDataBase.GetTag('RUS') )
	or ( actor == CCountryDataBase.GetTag('RUS') and recipient == CCountryDataBase.GetTag('SOV') )
	or ( actor == CCountryDataBase.GetTag('PRK') and recipient == CCountryDataBase.GetTag('KOR') )
	or ( actor == CCountryDataBase.GetTag('KOR') and recipient == CCountryDataBase.GetTag('PRK') )
	or ( actor == CCountryDataBase.GetTag('ITA') and recipient == CCountryDataBase.GetTag('RSI') )
	or ( actor == CCountryDataBase.GetTag('RSI') and recipient == CCountryDataBase.GetTag('ITA') )
	or ( actor == CCountryDataBase.GetTag('GER') and recipient == CCountryDataBase.GetTag('DFR') )
	or ( actor == CCountryDataBase.GetTag('GER') and recipient == CCountryDataBase.GetTag('DDR') )
	or ( actor == CCountryDataBase.GetTag('DFR') and recipient == CCountryDataBase.GetTag('GER') )
	or ( actor == CCountryDataBase.GetTag('DFR') and recipient == CCountryDataBase.GetTag('DDR') )
	or ( actor == CCountryDataBase.GetTag('DDR') and recipient == CCountryDataBase.GetTag('GER') )
	or ( actor == CCountryDataBase.GetTag('DDR') and recipient == CCountryDataBase.GetTag('DFR') )
	then
		return 0
	end

	if observer == actor then
		-- Should we ask for peace?
		
		-- Check our desperation!
		if observerDesperation > 0.25 then
			-- If we are losing badly, we should consider asking for peace...
			score = observerDesperation * 100
		elseif observerDesperation < 0.05 then
			-- If we are winning, then check for our war-goals!
			if Support.OwnsAnyCores(actor, recipient) then
				-- If they are owning our cores, then we want those back!
				if not Support.HoldsAnyCores(actor, recipient) then
					-- Only offer if they don't control them!
					score = 100
				else
					-- Otherwise, we want to go all the way => don't offer anything!
					score = 0
				end
			end
		end
		
		-- Calculate relative strength!
		relativeStrength = Support.CompareMilitaryStrength(actor, recipient)
	else
		-- Should we accept the peace offer?
		
		-- Check our desperation!
		if observerDesperation < 0.05 then
			-- If we are winning, then we should check our war-goals!
			if Support.OwnsAnyCores( recipient, actor) then
			-- If they are owning our cores, then we want those back!
				if not Support.HoldsAnyCores( recipient, actor) then
					-- Only accept if they don't control them!
					score = 100
				else
					score = 0
				end
			else
				-- Otherwise, we want to go all the way.
				score = 0
			end
		elseif observerDesperation > 0.25 then
			-- If we are losing considerably, we should consider accepting.
			score = observerDesperation * 100
		end
		
		
		-- Calculate relative strength!
		relativeStrength = Support.CompareMilitaryStrength( recipient, actor)
	end
	
	-- Factor in relative strength!
	-- If we are much stronger, then we should be less
	-- likely to offer/accept a peace than if we are weaker.
	if relativeStrength > 2.0 then
		score = score * 0.0
	elseif relativeStrength > 1.5 then
		score = score * 0.5
	elseif relativeStrength < 0.75 then
		score = score * 1.5
	elseif relativeStrength < 0.25 then
		score = score * 5.0
	end
	
	return score
end

function DiploScore_SendExpeditionaryForce( ai, actor, recipient, observer, action )

	if ( not Utils.ASSERT( ai ) )
	or ( not Utils.ASSERT( actor ) )
	or ( not Utils.ASSERT( recipient ) )
	or ( not Utils.ASSERT( observer ) )
	or ( not Utils.ASSERT( action ) )
	then
		return 0
	end

	if observer == actor then
		return 0	-- The AI offers exp forces from the exe, this shouldn't be used
	else
		if not recipientCountry:IsAtWar() then
			-- No need for Exp while at peace!
			return 0
		end

		local recipientCountry = recipient:GetCountry()
		if recipientCountry:GetDailyBalance( CGoodsPool._SUPPLIES_ ):Get() > 1.0 then
			-- Supply surplus, shouldn't be any problem
			return 100
		else
			-- Supply deficit, but we may still have immense stockpiles
			local supplyStockpile = recipientCountry:GetPool():Get( CGoodsPool._SUPPLIES_ ):Get()
			local weeksSupplyUse = recipientCountry:GetDailyExpense( CGoodsPool._SUPPLIES_ ):Get() * 7
			if supplyStockpile > weeksSupplyUse * 24.0 then
				return 100
			elseif supplyStockpile > weeksSupplyUse * 12.0 then
				return 33
			else
				return 0
			end
		end
	end
end

function DiploScore_OfferLendLease(ai, actor, recipient, observer)
	if observer == recipient then
		return 100
	else
		return 0
	end
end

function DiploScore_RequestLendLease(ai, actor, recipient, observer, action)

	if ( not Utils.ASSERT( ai ) )
	or ( not Utils.ASSERT( actor ) )
	or ( not Utils.ASSERT( recipient ) )
	or ( not Utils.ASSERT( observer ) )
	or ( not Utils.ASSERT( action ) )
	then
		return 0
	end
	
	-- We always want more ic but this shouldn't really be called
	if observer == actor then
		return 100
	
	-- check if recipient wants to give actor LL. 
	else 
		local actorCountry = actor:GetCountry()
		local recipientCountry = recipient:GetCountry()
		local liScore = 0
		
		if recipientCountry:IsEnemy( actor ) then
			liScore = 0
		else
			-- is the player requesting?
			local lbActorIsPlayer = CCurrentGameState.IsPlayer( actor )
			local lvMaxRecipientIC = recipientCountry:GetMaxIC()
			local lvMaxActorIC = actorCountry:GetMaxIC() 
			
			-- Only share if we have enough IC and don't share with countries thatare too small to help
			if lvMaxRecipientIC > 100 and (lbActorIsPlayer or lvMaxActorIC > 30) then
				-- we wont share if we have less
				if (lvMaxRecipientIC * 0.8) > lvMaxActorIC then
					local voRecipientFaction = recipientCountry:GetFaction()
					-- if they don't have a faction find the closest one
					if not voRecipientFaction:IsValid() then
						
						local loClosestFaction = nil
						local vSmallestAlignment = 100000
						for loFaction in CCurrentGameState.GetFactions() do
								
							local liAlignment = ai:GetCountryAlignmentDistance(recipientCountry, loFaction:GetFactionLeader():GetCountry()):Get()
							if liAlignment < vSmallestAlignment then
								vSmallestAlignment = liAlignment
								loClosestFaction = loFaction
							end
						end
							
						if vSmallestAlignment < 75 then
							voRecipientFaction = loClosestFaction
						end
					end

					-- same faction?
					if voRecipientFaction:IsValid() then 
						if (actorCountry:GetFaction() == voRecipientFaction) then
							liScore = 100
						-- are they fighting a common enemy
						elseif actorCountry:HasFaction() then 
							for loEnemyTag in actorCountry:GetCurrentAtWarWith() do
								local loEnemyCountry = loEnemyTag:GetCountry()
								if loEnemyCountry:HasFaction() then
									if loEnemyCountry:IsEnemy( voRecipientFaction:GetFactionLeader() ) then
										liScore = 80
									end
									break
								end							
							end
						end
					end
				end
			end
		end

		return Utils.CallScoredCountryAI(recipient, "DiploScore_RequestLendLease", liScore, ai, actor )
	end
end

function DiploScore_CallAlly( ai, actor, recipient, observer, action )

	if ( not Utils.ASSERT( ai ) )
	or ( not Utils.ASSERT( actor ) )
	or ( not Utils.ASSERT( recipient ) )
	or ( not Utils.ASSERT( observer ) )
	or ( not Utils.ASSERT( action ) )
	then
		return 0
	end

	if observer == actor then
		return Utils.CallScoredCountryAI(actor, "DiploScore_CallAlly", 100, ai, actor, recipient, observer )
	else
		local actorCountry = actor:GetCountry()
		local recipientCountry = recipient:GetCountry()
		local liScore = 100

		-- SSmith (24/11/2013)
		-- Extensively re-written with new rules
		-- Do not join a war when in exile unless called by our faction leader (who effectively controls us)
		-- No longer apply the check about being at war with factions (which was bugged anyway)
		-- Do not join a war if we are losing or if our ally is already losing
		-- Check we don't go to war if the balance of power is heavily against us (especially against neighbours)
		
		-- Puppets should obey their masters
		if recipientCountry:IsSubject() then
			if recipientCountry:GetOverlord() == actor then
				return Utils.CallScoredCountryAI( recipient, "DiploScore_CallAlly", 100, ai, actor, recipient, observer )
			else
				return 0
			end
		end

		-- Do not join a war if we are a government-in-exile unless called by our faction leader
		if recipientCountry:IsGovernmentInExile() then
			if recipientCountry:HasFaction() and recipientCountry:GetFaction():GetFactionLeader() == actor then
				return Utils.CallScoredCountryAI( recipient, "DiploScore_CallAlly", 100, ai, actor, recipient, observer )
			else
				return 0
			end
		end

		-- Do not join another war if we are losing one already!
		local liProgress = recipientCountry:GetSurrenderLevel():Get()
		if liProgress > 0.00 then
			liScore = liScore - (2 * liProgress)
		end

		-- Do not join a war if our calling ally is losing badly!
		liProgress = actorCountry:GetSurrenderLevel():Get()
		if liProgress > 0.00 then
			liScore = liScore - (2 * liProgress)
		end

		-- Check our strength against any country we might go to war with
		-- Also check for NAPs, truces and alliances before 

		local targetExempt = false
		local liPlus = 0
		local liMinus = 0
		for loActorDiplomacy in actorCountry:GetDiplomacy() do
			local loTargetTag = loActorDiplomacy:GetTarget()
			if loTargetTag:IsValid()					-- This tag is valid
			and loActorDiplomacy:HasWar() then				-- This nation is at war with our buddy

				if not recipientCountry:GetRelation(loTargetTag):HasWar() then

					-- Check for NAPs, truces and alliances
					if recipientCountry:GetRelation(loTargetTag):HasNap()
					or recipientCountry:GetRelation(loTargetTag):HasTruce()
					or recipientCountry:GetRelation(loTargetTag):HasAlliance() then
						targetExempt = true
						break
					end	

					-- Compare the strength of our alliance against theirs
					local liStrength = Support.CompareRealMilitaryStrength(recipient, loTargetTag)
					if liStrength > 1 then
						-- We are stronger but be wary of war with our neighbours
						if recipientCountry:IsNeighbour(loTargetTag) then
							liPlus = math.max(liPlus, (liStrength - 1) * 25)
						else
							liPlus = math.max(liPlus, (liStrength - 1) * 50)
						end
					elseif liStrength < 1 then
						-- We are weaker and be wary of war with our neighbours
						liStrength = 1 / math.max(liStrength, 0.25)
						if recipientCountry:IsNeighbour(loTargetTag) then
							liMinus = math.min(liMinus, (liStrength - 1) * 50)
						else
							liMinus = math.min(liMinus, (liStrength - 1) * 25)
						end
					end
				end
			end
		end
		if liMinus < 0 then
			liScore = liScore - liMinus
		elseif liPlus > 0 then
			liScore = liScore + liPlus
		end

		-- We won't join a war if we have a NAP, truce or alliance against the target
		if targetExempt then
			-- Setting the score to zero will still allow country-specific functions to override it!
			liScore = 0
		end

		-- Tidy up the score
		if liScore > 75 then
			liScore = 100
		elseif liScore < 25 then
			liScore = 0
		end		

		return Utils.CallScoredCountryAI( recipient, "DiploScore_CallAlly", liScore, ai, actor, recipient, observer )
	end
end

function DiploScore_Debt( ai, actor, recipient, observer )

	if ( not Utils.ASSERT( ai ) )
	or ( not Utils.ASSERT( actor ) )
	or ( not Utils.ASSERT( recipient ) )
	or ( not Utils.ASSERT( observer ) )
	then
		return 0
	end
	
	local actorCountry = actor:GetCountry()
	local recipientCountry = recipient:GetCountry()

	-- SSmith (22/01/2014)
	-- This needs thinking about properly but let's put a fix so that the USA allows debt to the British

	if tostring(actor) == "ENG" and tostring(recipient) == "USA" and math.mod(CCurrentGameState.GetAIRand(), 6) == 0 then
		local gerTag = CCountryDataBase.GetTag('GER')
		if actorCountry:GetRelation(gerTag):HasWar()
		and (tostring(recipientCountry:GetFaction():GetTag()) == "allies"
		or recipientCountry:GetFlags():IsFlagSet("lend_lease_act")) then
			return 100
		end
	end

	if observer == actor then
		if actorCountry:IsAtWar() then		-- Allowing debt is for wartime only.
			if actorCountry:GetDailyBalance(CGoodsPool._MONEY_):Get() < 0		-- We are losing money
			and DiploScore_Debt( ai, actor, recipient, recipient) > 50			-- and they would probably accept to allow debt.
			then
				for trades in actorCountry:GetRelation( recipient):GetTradeRoutes() do	-- Check if we are actually buying from them or not!
					if trades:GetTradedFromOf(CGoodsPool._MONEY_):Get() > 0 then		-- If we are giving away money, we should ask for debt!
						return 100
					end
				end
			end
			return 0
		else
			return 0
		end
	else
		if recipientCountry:IsAtWar() then
			local recipientMoney = recipientCountry:GetPool():Get( CGoodsPool._MONEY_ ):Get()
			local actorMoney = actorCountry:GetPool():Get( CGoodsPool._MONEY_ ):Get()
			if ( recipientMoney * 5 > actorMoney ) 
			and ( recipientMoney > 200 ) then 
				for trades in actorCountry:GetRelation( recipient ):GetTradeRoutes() do	-- Check if we are actually selling to them or not!
					if trades:GetTradedFromOf(CGoodsPool._MONEY_):Get() > 0 then		-- If so, we might allow debt!
						return Support.LinearFunction( 0, 100, actorCountry:GetRelation( recipient ):GetValue():Get() )
					end
				end
			end
			return 0
		else
			return 0
		end
	end
end


-- ############################
--  Methods that do not use the GetAIAcceptance()
-- (ie. they don't need to be accepted)
-- ############################

function CalculateWarDesirability( ai, country, targetTag)

	if ( not Utils.ASSERT( ai ) )
	or ( not Utils.ASSERT( country ) )
	or ( not Utils.ASSERT( targetTag ) ) 
	then
		return 0
	end

	local score = 0
	local countryTag = country:GetCountryTag()
	local targetCountry = targetTag:GetCountry()
	
	-- Don't worry if we can't DoW, we can still prepare. We will attack when we can!
	--if not ai:CanDeclareWar( countryTag, targetTag ) then
	--  return 0
	--end

	-- no suicide :S
	if country:GetNumberOfControlledProvinces() < targetCountry:GetNumberOfControlledProvinces() / 4 then
		return 0
	end
	
	if not country:IsMajor()								-- If we are a major, then don't worry about Guarantees! We can deal with it.
	and Support.GuaranteedByMajor(countryTag, targetTag)	-- But if we aren't, then we shouldn't attack guaranteed nations!
	and not country:HasFaction()							-- Although if we are in a faction, that should make our chances much better!
	then
		return 0
	end
	
	local relation = country:GetRelation(targetTag)
	local strengthRatio = Support.CompareMilitaryStrength(countryTag, targetTag)
	local ideologyGroup = country:GetRulingIdeology():GetGroup()
	
	-- Wars of Aggression
	if Support.HoldsAnyCores(countryTag, targetTag) then		-- If they hold our cores, then we should take them back!
		score = score + 50
	end
	
	-- Wars of Reaction
	if relation:HasEmbargo() then								-- We don't like being Embargoed!
		score = score + 15
	end
	
	-- Preemptive Wars
	if relation:GetThreat():Get() > 100 then						-- They are REALLY threatening!
		score = score + 50
	elseif relation:GetThreat():Get() > 50 then						-- They are quite threatening!
		score = score + 25
	elseif relation:GetThreat():Get() > 25 then						-- They are somewhat threatening!
		score = score + 10
	else															-- They are not threatening at all.
		score = score - 25
	end
	
	-- Democracies are less aggressive.
	if ideologyGroup:GetKey() == "democracy" then
		score = score - 100
	end

	-- Factor in relations!
	if relation:GetValue():Get() > 150 then						-- If we like them, we shouldn't worry about them!
		score = score - 100
	elseif relation:GetValue():Get() > 100 then
		score = score - 50
	elseif relation:GetValue():Get() > 50 then
		score = score - 25
	end
	
	-- Factor in relative strength!
	if strengthRatio > 2.0 then			-- We are clearly stronger.
		score = score + 50
	elseif strengthRatio > 1.5 then		-- We are somewhat stronger.
		score = score + 25
	elseif strengthRatio < 0.75	then	-- We are somewhat weaker.
		score = score - 25
	elseif strengthRatio < 0.5	then	-- We are clearly weaker.
		score = 0
	end									-- Otherwise don't worry!
	
	return Utils.CallScoredCountryAI(countryTag, 'CalculateWarDesirability', score, ai, country, targetTag)

end

function DiploScore_InfluenceNation( ai, actor, recipient, observer )

	if ( not Utils.ASSERT( ai ) )
	or ( not Utils.ASSERT( actor ) )
	or ( not Utils.ASSERT( recipient ) )
	or ( not Utils.ASSERT( observer ) )
	then
		return 0
	end

	if observer == actor then
		local liScore = 100
	
		local recipientCountry = recipient:GetCountry()
		local actorCountry = actor:GetCountry()
		local actorFaction = actorCountry:GetFaction()
		local actorIdeologyGroup = actorFaction:GetIdeologyGroup()
		local recipientIdeologyGroup = recipientCountry:GetRulingIdeology():GetGroup()
		local dist = ai:GetNormalizedAlignmentDistance( recipientCountry, actorFaction ):Get()
		
		for allyTag in actorCountry:GetAllies() do
			if recipientCountry:GetRelation(allyTag):HasWar() then
				return 0	-- Don't influence anyone who is at war with one of our buddies, because we couldn't invite them anyway...
			end
		end
		
		if not ( recipientIdeologyGroup == actorIdeologyGroup ) and dist < 80.0 then
			-- We don't want people with different ideology, only keep them out of enemy factions, except if we have special plans, of course!
			return Utils.CallScoredCountryAI(actor, 'DiploScore_InfluenceNation', 0, ai, actor, recipient, observer )
		elseif dist < defines.alignment.FACTION_JOIN_DIST * 0.75 then
			-- We also don't want to influence people who are already close enough anyway.
			return 0
		end
		
		-- Calculate Importance based on IC
		---   Remember only Majors can Influence
		local maxIC = recipientCountry:GetMaxIC()
		local ourMaxIC = actorCountry:GetMaxIC()
		if maxIC > ourMaxIC then
			liScore = liScore + 70
		elseif maxIC > ourMaxIC * 0.5 then
			liScore = liScore + 40
		elseif maxIC > ourMaxIC * 0.3 then
			liScore = liScore + 30
		elseif maxIC > ourMaxIC * 0.2 then
			liScore = liScore + 20
		elseif maxIC > ourMaxIC * 0.1 then
			liScore = liScore + 10
		elseif maxIC > ourMaxIC * 0.05 then
			liScore = liScore + 5
		end
		
		-- factor neutrality
		if actorCountry:IsAtWar() then
			local effectiveNeutrality = recipientCountry:GetEffectiveNeutrality():Get()
			if effectiveNeutrality > 90 then
				liScore = liScore - 100
			elseif effectiveNeutrality > 80 then
				liScore = liScore - 70
			elseif effectiveNeutrality > 70 then
				liScore = liScore - 10
			elseif effectiveNeutrality < defines.diplomacy.JOIN_FACTION_NEUTRALITY + 10 then
				liScore = liScore + 50
			end
		end
		
		-- Political checks
		local loRelation = ai:GetRelation(actor, recipient)
		--local loStrategy = recipient:GetCountry():GetStrategy()
		
		--liScore = liScore - loStrategy:GetAntagonism(actor) / 15			
		--liScore = liScore + loStrategy:GetFriendliness(actor) / 10
		liScore = liScore - loRelation:GetThreat():Get() / 5
		liScore = liScore + loRelation:GetValue():GetTruncated() / 3
		
		if loRelation:IsGuaranteed() then
			liScore = liScore + 10
		end
		if loRelation:HasFriendlyAgreement() then
			liScore = liScore + 10
		end
		if loRelation:AllowDebts() then
			liScore = liScore + 50
		end
		if actorCountry:IsNeighbour( recipient) then
			liScore = liScore + 50
		elseif recipientCountry:GetActingCapitalLocation():GetContinent() == actorCountry:GetActingCapitalLocation():GetContinent() then
			liScore = liScore + 40
		end
		if Utils.IsFriend( ai, actorCountry:GetFaction(), recipientCountry) then
			liScore = liScore + 20
		else
			liScore = liScore - 20
		end
		if recipientCountry:IsMajor() then
			liScore = liScore + 10
		end
		if recipientCountry:HasNeighborInFaction(actorFaction ) then
			liScore = liScore + 20
		end
		
		return Utils.CallScoredCountryAI(actor, 'DiploScore_InfluenceNation', liScore, ai, actor, recipient, observer )
	else
		return 100 -- we cant respond to this
	end
end

function DiploScore_Embargo( ai, actor, recipient, observer )

	if ( not Utils.ASSERT( ai ) )
	or ( not Utils.ASSERT( actor ) )
	or ( not Utils.ASSERT( recipient ) )
	or ( not Utils.ASSERT( observer ) )
	then
		return 0
	end
	
	if observer == actor then
		local actorCountry = actor:GetCountry()
		local recipientCountry = recipient:GetCountry()
		local rel = actorCountry:GetRelation( recipient)

		-- SSmith (31/05/2013)
		-- This is the code that was causing all the on/off embargo nonsense!
		-- Basically if we didn't have enough diplomatic influence the function returned zero... which removed the embargo!
		-- So instead we will return a neutral value that won't affect anything
		-- Also we'll set a higher threshold before wasting influence on embargoes

		-- Don't use up the last of our points for this
		if actorCountry:GetDiplomaticInfluence():Get() < (defines.diplomacy.EMBARGO_INFLUENCE_COST + 5) then
			return 25
		end
		
		-- Base score comes from relations. Anyone with a positive relation won't be embargoed.
		local score = 100 * Support.LinearFunction( 0, -200, rel:GetValue():Get() )

		-- SSmith (31/05/2013)
		-- We really shouldn't embargo a country we are allied with!

		if recipientCountry:CalculateIsAllied(actor) then
			score = score - 50
		end

		-- Factor in Threat and Ideological Distance.
		-- Note that in normal cases the higher these values are, the closer the two countries are.
		-- So the result is subtracted from 1 to adapt the factors to this situation where the closer you are, the
		-- lower the chance for an Embargo should be.
		score = score * ( 1.0 - CalculateAlignmentFactor( ai, actorCountry, recipientCountry ) )
		-- Actually, 0 Threat should not make it completely sure that we won't embargo, but the higher it is, the higher the chance should be!
		score = score * ( 0.5 + Support.ThreatFactor( actor, recipient ) )
			
		return Utils.CallScoredCountryAI(actor, 'DiploScore_Embargo', score, ai, actor, recipient, observer )
	else
		return 0
	end
end

function DiploScore_Guarantee( ai, actor, recipient, observer )

	if ( not Utils.ASSERT( ai ) )
	or ( not Utils.ASSERT( actor ) )
	or ( not Utils.ASSERT( recipient ) )
	or ( not Utils.ASSERT( observer ) )
	then
		return 0
	end

	if observer == actor then
		-- Shouldn't really do this just randomly, the game is not THAT sandbox...
		return Utils.CallScoredCountryAI(actor, 'DiploScore_Guarantee', 0, ai, actor, recipient, observer )
	else
		return 0
	end
end

function DiploScore_BreakAlliance( ai, actor, recipient, observer )

	if ( not Utils.ASSERT( ai ) )
	or ( not Utils.ASSERT( actor ) )
	or ( not Utils.ASSERT( recipient ) )
	or ( not Utils.ASSERT( observer ) )
	then
		return 0
	end

	-- Why would we do that, exactly?...
	return 0
end