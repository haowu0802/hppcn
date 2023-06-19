local P = {}
Support = P

function P.Build_Standard_Armor( ic, minister, armor_brigade, vbGoOver )
	if ( not Utils.ASSERT( ic ) )
	or ( not Utils.ASSERT( minister ) )
	or ( not Utils.ASSERT( armor_brigade ) )
	or ( not Utils.ASSERT( vbGoOver ) )
	then
		return 0, 0
	end
	return Utils.CreateDivision(minister, "armor_brigade", 2, ic, armor_brigade, 2, Utils.BuildArmorUnitArray(minister:GetCountry()), 1, vbGoOver)
end

function P.Build_Standard_Motorized( ic, minister, motorized_brigade, vbGoOver )
	if ( not Utils.ASSERT( ic ) )
	or ( not Utils.ASSERT( minister ) )
	or ( not Utils.ASSERT( motorized_brigade ) )
	or ( not Utils.ASSERT( vbGoOver ) )
	then
		return 0, 0
	end
	return Utils.CreateDivision(minister, "motorized_brigade", 2, ic, motorized_brigade, 3, Utils.BuildMotorizedUnitArray(minister:GetCountry()), 1, vbGoOver)
end

function P.Build_Fort( ic, minister, viProvinceID, viMax, vbGoOver )

	if ( not Utils.ASSERT( ic ) )
	or ( not Utils.ASSERT( minister ) )
	or ( not Utils.ASSERT( viProvinceID ) )
	or ( not Utils.ASSERT( viMax ) )
	or ( not Utils.ASSERT( vbGoOver ) )
	then
		return 0
	end
	
	local ministerTag = minister:GetCountryTag()
	local land_fort = CBuildingDataBase.GetBuilding( "land_fort" )
	local loProvince = CCurrentGameState.GetProvince(viProvinceID)
	local loBuilding = loProvince:GetBuilding(land_fort)

	if loBuilding:GetMax():Get() <= viMax and loProvince:GetCurrentConstructionLevel(land_fort) == 0 then
		local land_fortCost = ministerTag:GetCountry():GetBuildCost(land_fort):Get()
		
		if (ic - land_fortCost) >= 0 or vbGoOver then
			local constructCommand = CConstructBuildingCommand( ministerTag, land_fort, viProvinceID, 1 )
			
			if constructCommand:IsValid() then
				minister:GetOwnerAI():Post( constructCommand )
				ic = ic - land_fortCost -- Upodate IC total
			end
		end
	end
	
	return ic
end

function P.Build_AirBase( ic, minister, viProvinceID, viMax, vbGoOver )

	if ( not Utils.ASSERT( ic ) )
	or ( not Utils.ASSERT( minister ) )
	or ( not Utils.ASSERT( viProvinceID ) )
	or ( not Utils.ASSERT( viMax ) )
	or ( not Utils.ASSERT( vbGoOver ) )
	then
		return 0
	end
	
	local ministerTag = minister:GetCountryTag()
	local air_base = CBuildingDataBase.GetBuilding("air_base")
	local loProvince = CCurrentGameState.GetProvince(viProvinceID)
	local loBuilding = loProvince:GetBuilding(air_base)

	if loBuilding:GetMax():Get() <= viMax and loProvince:GetCurrentConstructionLevel(air_base) == 0 then
		local land_fortCost = ministerTag:GetCountry():GetBuildCost(air_base):Get()
		
		if (ic - land_fortCost) >= 0 or vbGoOver then
			local constructCommand = CConstructBuildingCommand( ministerTag, air_base, viProvinceID, 1 )
			
			if constructCommand:IsValid() then
				minister:GetOwnerAI():Post( constructCommand )
				ic = ic - land_fortCost -- Upodate IC total
			end
		end
	end
	
	return ic
end

-- SSmith (01/05/2013)
-- New function to handle radar station construction

function P.Build_Radar( ic, minister, viProvinceID, viMax, vbGoOver )

	if ( not Utils.ASSERT( ic ) )
	or ( not Utils.ASSERT( minister ) )
	or ( not Utils.ASSERT( viProvinceID ) )
	or ( not Utils.ASSERT( viMax ) )
	or ( not Utils.ASSERT( vbGoOver ) )
	then
		return 0
	end
	
	local ministerTag = minister:GetCountryTag()
	local radar_station = CBuildingDataBase.GetBuilding("radar_station")
	local loProvince = CCurrentGameState.GetProvince(viProvinceID)
	local loBuilding = loProvince:GetBuilding(radar_station)

	if loBuilding:GetMax():Get() <= viMax and loProvince:GetCurrentConstructionLevel(radar_station) == 0 then
		local radar_stationCost = ministerTag:GetCountry():GetBuildCost(radar_station):Get()
		
		if (ic - radar_stationCost) >= 0 or vbGoOver then
			local constructCommand = CConstructBuildingCommand( ministerTag, radar_station, viProvinceID, 1 )
			
			if constructCommand:IsValid() then
				minister:GetOwnerAI():Post( constructCommand )
				ic = ic - radar_stationCost -- Update IC total
			end
		end
	end
	
	return ic
end

-- A simple function to compare the military strength of two nations.
-- The returned value is the strength of the first divided by the second.
-- If that value is higher than 1.5, then the first nation should be considered relevantly stronger.
-- If that value is lower than 0.75, then the second nation should be considered relevantly stronger.
function P.CompareMilitaryStrength( ministerTag, targetTag )

	if ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( targetTag ) ) then
		return 1
	end

	local intel = CAIIntel(ministerTag, targetTag)		-- Get the intel of ministerTag on targetTag
	
	if intel:GetFactor() < 0.1 then			-- If we don't have enough Intel, then don't we should check our relative size!
		return ministerTag:GetCountry():GetNumberOfOwnedProvinces() / targetTag:GetCountry():GetNumberOfOwnedProvinces()
	end
	
	local theirStrength = intel:CalculateTheirPercievedMilitaryStrengh() * P.LandOrgModifier( ministerTag )
	local ourStrength = intel:CalculateOurMilitaryStrength() * P.LandOrgModifier( targetTag )
	local allyIntel
	local allyStrength
	
	for friendlyAllyTag in ministerTag:GetCountry():GetAllies() do
		allyIntel = CAIIntel(ministerTag, friendlyAllyTag)
		allyStrength = allyIntel:CalculateTheirPercievedMilitaryStrengh() * P.LandOrgModifier( friendlyAllyTag )
		ourStrength = ourStrength + allyStrength
	end	
	
	-- factor in their allies they can call for
	
	for hostileAllyTag in targetTag:GetCountry():GetAllies() do
		allyIntel = CAIIntel(ministerTag, hostileAllyTag)
		allyStrength = allyIntel:CalculateTheirPercievedMilitaryStrengh() * P.LandOrgModifier( hostileAllyTag )
		theirStrength = theirStrength + allyStrength
	end	
	
	if theirStrength > 0.01 then			-- Don't divide with a very low number!
		return ourStrength / theirStrength
	else
		return 10							-- If their strength is very low, then we are clearly much stronger!
	end
end

-- SSmith (27/04/2013)
-- This is a new function to compare the military strength of two nations copied from CompareMilitaryStrength above
-- The problem with the original function is that it return wildly different results every time which makes it useless for AI decision-making
-- The returned value is the strength of the first divided by the second.
-- If that value is higher than 1.5, then the first nation should be considered relevantly stronger.
-- If that value is lower than 0.75, then the second nation should be considered relevantly stronger.
function P.CompareRealMilitaryStrength( ministerTag, targetTag )

	if ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( targetTag ) ) then
		return 1
	end

	local ourIntel = CAIIntel(ministerTag, targetTag)	-- Get the intel of ministerTag on targetTag
	local theirIntel = CAIIntel(targetTag, ministerTag)	-- Get the intel of targetTag on ministerTag
		
	local ourStrength = ourIntel:CalculateOurMilitaryStrength() * P.LandOrgModifier( ministerTag )
	local theirStrength = theirIntel:CalculateOurMilitaryStrength() * P.LandOrgModifier( targetTag )

	local allyIntel
	local allyStrength
	
	-- Factor in our allies

	for friendlyAllyTag in ministerTag:GetCountry():GetAllies() do
		allyIntel = CAIIntel(friendlyAllyTag, ministerTag)
		allyStrength = allyIntel:CalculateOurMilitaryStrength() * P.LandOrgModifier( friendlyAllyTag )
		ourStrength = ourStrength + allyStrength
	end	
	
	-- Factor in their allies
	
	for hostileAllyTag in targetTag:GetCountry():GetAllies() do
		allyIntel = CAIIntel(hostileAllyTag, ministerTag)
		allyStrength = allyIntel:CalculateOurMilitaryStrength() * P.LandOrgModifier( hostileAllyTag )
		theirStrength = theirStrength + allyStrength
	end	
	
	if theirStrength > 0.01 then			-- Don't divide with a very low number!
		return ourStrength / theirStrength
	else
		return 10				-- If their strength is very low, then we are clearly much stronger!
	end
end

-- SSmith (23/01/2014)
-- For performance this new function will do a very simple estimation
function P.CompareEstimatedMilitaryStrength( Params )

	if ( not Utils.ASSERT( Params.MinisterTag ) )
	or ( not Utils.ASSERT( Params.TargetTag ) ) then
		return 1
	end

	local Work = {
		MinisterCountry = Params.MinisterTag:GetCountry(),
		TargetCountry = Params.TargetTag:GetCountry(),
		MinisterIC = 0,
		AllyIC = 0,
		TargetIC = 0,
		HostileIC = 0,
		OurStrength = 0,
		TheirStrength = 0
	}
	Work.MinisterIC = Work.MinisterCountry:GetTotalIC()
	Work.TargetIC = Work.TargetCountry:GetTotalIC()

	-- We will only compare the IC and total number of divisions of both countries

	Work.OurStrength = Work.MinisterIC * Work.MinisterCountry:GetUnits():GetTotalAmountOfDivisions()
	Work.TheirStrength = Work.TargetIC * Work.TargetCountry:GetUnits():GetTotalAmountOfDivisions()

	-- For allies we will only consider their IC in comparison to the principal countries

	for loAllyTag in Work.MinisterCountry:GetAllies() do
		Work.AllyIC = Work.AllyIC + loAllyTag:GetCountry():GetTotalIC()
	end
	Work.OurStrength = Work.OurStrength * (1 + ((Work.AllyIC / Work.MinisterIC) * 0.5))

	for loHostileTag in Work.TargetCountry:GetAllies() do
		Work.HostileIC = Work.HostileIC + loHostileTag:GetCountry():GetTotalIC()
	end
	Work.TheirStrength = Work.TheirStrength * (1 + ((Work.HostileIC / Work.TargetIC) * 0.5))

	if Work.TheirStrength > 0.01 then
		return Work.OurStrength / Work.TheirStrength
	else
		return 100
	end
end


function P.LandOrgModifier( ministerTag )

	if ( not Utils.ASSERT( ministerTag ) ) then
		return 1.0
	end
	
	return 1.0 + ministerTag:GetCountry():GetGlobalModifier():GetValue( CModifier._MODIFIER_LAND_ORGANISATION_ )
end

function P.CompareObservedMilitaryStrength( firstTag, secondTag, observerTag )

	if ( not Utils.ASSERT( firstTag ) )
	or ( not Utils.ASSERT( secondTag ) )
	or ( not Utils.ASSERT( observerTag ) )
	then
		return 1
	end


	local firstIntel = CAIIntel(observerTag, firstTag)			-- Get the intel of observerTag on firstTag
	local secondIntel = CAIIntel(observerTag, secondTag)		-- Get the intel of observerTag on secondTag
	local firstStrength = firstIntel:CalculateTheirPercievedMilitaryStrengh()
	local secondStrength = secondIntel:CalculateTheirPercievedMilitaryStrengh()
	local firstAllyIntel
	local firstAllyStrength
	
	if firstIntel:GetFactor() < 0.1 or secondIntel:GetFactor() < 0.1 then
		return firstTag:GetCountry():GetNumberOfOwnedProvinces() / secondTag:GetCountry():GetNumberOfOwnedProvinces()
	end
	
	for firstFriendlyAllyTag in firstTag:GetCountry():GetAllies() do
		firstAllyIntel = CAIIntel(observerTag, firstFriendlyAllyTag)
		firstAllyStrength = firstAllyIntel:CalculateTheirPercievedMilitaryStrengh()
		firstStrength = firstStrength + firstAllyStrength
	end	
	
	local secondAllyIntel
	local secondAllyStrength

	for secondFriendlyAllyTag in secondTag:GetCountry():GetAllies() do
		secondAllyIntel = CAIIntel(observerTag, secondFriendlyAllyTag)
		secondAllyStrength = secondAllyIntel:CalculateTheirPercievedMilitaryStrengh()
		secondStrength = secondStrength + secondAllyStrength
	end	

	if secondStrength > 0.01 then		-- Don't divide with a very low number!
		return firstStrength / secondStrength
	else
		return 2
	end
end

-- SSmith (25/12/2013)
-- This function will check for a military alliance or common faction membership between two countries
function P.IsMilitaryAlly( Params )

	if ( not Utils.ASSERT( Params.MinisterTag ) )
	or ( not Utils.ASSERT( Params.MinisterCountry ) )
	or ( not Utils.ASSERT( Params.TargetTag ) )
	or ( not Utils.ASSERT( Params.TargetCountry ) )
	then
		return false
	end

	if Params.MinisterCountry:GetRelation(Params.TargetTag):HasAlliance() then
		return true
	elseif Params.MinisterCountry:HasFaction() and Params.TargetCountry:HasFaction()
	and Params.MinisterCountry:GetFaction() == Params.TargetCountry:GetFaction() then
		return true
	else
		return false
	end
end

-- Function to determine if 'targetTag' is already defeated by 'ministerTag' (or at least no longer a possible threat)!
function P.IsDefeated( ministerTag, targetTag )

	if ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( targetTag ) )
	then
		return false
	end
	
	if tostring( ministerTag ) == 'GOD' then
		-- GOD is not a threat to anyone, so should be considered defeated at all times.
		return true
	end

	local target = targetTag:GetCountry()

	-- SSmith (02/06/2013)
	-- The truce check was put in for the Bitter Peace but it only works for Germany
	-- If the Soviets have a truce with Germany then they've lost and shouldn't consider Germany defeated!

	local hasTruce = target:GetRelation( ministerTag ):HasTruce()
	if tostring(ministerTag) == "SOV" and tostring(targetTag) == "GER" then
		hasTruce = false
	end

	if not target:Exists() 				-- They don't even exist anymore.
	or target:IsGovernmentInExile()
	or hasTruce					-- We have a truce, so they can't do anything against us for a while (mostly required for a Bitter Peaced USSR)
	or target:CalculateIsAllied( ministerTag )	-- We are allied. (In which case they are as good as defeated, because they don't pose a threat!)
	then
		return true
	elseif target:IsPuppet() then
		if target:GetOverlord() == ministerTag
		or target:GetOverlord():GetCountry():CalculateIsAllied( ministerTag )
		then
			return true									-- They are a puppet of us or one of our allies
		end
	end
	return false	
end

-- Function to determine if the country has enough Manpower at the moment
-- to fill its reserves, and to fill in possible casualties in the near future.
function P.HasEnoughManpower( ministerTag )

	if not Utils.ASSERT( ministerTag ) then
		return { false, false }
	end

	-- SSmith (10/09/2013)
	-- This function has been re-worked
	-- The AI will estimate the manpower reserve it needs to bring its army up to strength
	-- It will only set manpower aside to replace combat losses if it has mobilized manpower
	-- Two boolean values will now be returned
	-- The second boolean will check for an "ideal" manpower reserve that can be checked before extending drafts

	local ministerCountry = ministerTag:GetCountry()
	local isMobilized = ministerCountry:IsMobilized()
	local isAtWar = ministerCountry:IsAtWar()
	local currentManpower = ministerCountry:GetManpower():Get()
	local currentNumberOfUnits = ministerCountry:GetUnits():GetTotalAmountOfDivisions()
	local totalIC = ministerCountry:GetTotalIC()
	
	-- Calculate the number of divisions under construction
	local unitsCurrentlyBuilt = 0
	for Construction in ministerCountry:GetConstructions() do
		if Construction:IsMilitary() then
			local MilitaryConstruction = Construction:GetMilitary()
			if  MilitaryConstruction:IsLand() then
				unitsCurrentlyBuilt = unitsCurrentlyBuilt + 1
			end
		end
	end

	local totalNumberOfUnits = currentNumberOfUnits + unitsCurrentlyBuilt

	-- Get the current strength of reserve units
	local ministerModifier = ministerCountry:GetGlobalModifier()
	local reserveStrength = ministerModifier:GetValue(CModifier._MODIFIER_RESERVES_PENALTY_SIZE_) * -1

	-- Calculate the minimum "needed" manpower to be checked before we build more land units
	local neededManpower = 0
	if not isMobilized then
		neededManpower = totalNumberOfUnits * 8 * reserveStrength			-- We need to keep a reserve for mobilization
		--Utils.LUA_DEBUGOUT("Mobilizing: " .. tostring(neededManpower))
	end
	if isMobilized or isAtWar then
		neededManpower = neededManpower + (unitsCurrentlyBuilt * 8 * reserveStrength)	-- We will need to bring our new units up to strength
		--Utils.LUA_DEBUGOUT("Replenish:  " .. tostring(neededManpower))
	end
	if ministerCountry:GetFlags():IsFlagSet("manpower_mobilized") then
		neededManpower = neededManpower + (totalNumberOfUnits * 5)			-- We must keep a reserve to replenish combat losses
		--Utils.LUA_DEBUGOUT("Losses:     " .. tostring(neededManpower))
	end

	-- Calculate the "ideal" manpower reserve to be checked before extending drafts
	local idealManpower = math.max((totalIC * 10), (totalNumberOfUnits * 10))

	local tagString = "XXX"
	if tostring(ministerTag) == tagstring then
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("HasEnoughManpower: " .. tagString)
		Utils.LUA_DEBUGOUT("Mobilized:  " .. tostring(isMobilized))
		Utils.LUA_DEBUGOUT("At War:     " .. tostring(isAtWar))
		Utils.LUA_DEBUGOUT("Manpower:   " .. tostring(currentManpower))
		Utils.LUA_DEBUGOUT("Total IC:   " .. tostring(totalIC))
		Utils.LUA_DEBUGOUT("Units:      " .. tostring(currentNumberOfUnits))
		Utils.LUA_DEBUGOUT("Building:   " .. tostring(unitsCurrentlyBuilt))
		Utils.LUA_DEBUGOUT("Total:      " .. tostring(totalNumberOfUnits))
		Utils.LUA_DEBUGOUT("Strength:   " .. tostring(reserveStrength))
		Utils.LUA_DEBUGOUT("Needed:     " .. tostring(neededManpower))
		Utils.LUA_DEBUGOUT("Ideal:      " .. tostring(idealManpower))
	end

	local hasEnough = (currentManpower > neededManpower)
	local hasIdeal = (currentManpower > idealManpower)

	return { hasEnough, hasIdeal }
end

-- Function to determine if a target nation is guaranteed by any major
-- powers other than the current nation or its allies.
function P.GuaranteedByMajor( ministerTag, targetTag )

	if ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( targetTag ) )
	then
		return false
	end

	local ministerCountry = ministerTag:GetCountry()
	local targetCountry = targetTag:GetCountry()
	local guaranteed = false
	
	for country in CCurrentGameState.GetCountries() do
		local countryTag = country:GetCountryTag()
		if countryTag ~= nil and countryTag:IsValid() and countryTag:IsReal()
		and ministerTag ~= countryTag and targetTag ~= countryTag
		then
			if ( country:IsMajor() or country:GetTotalIC() > ministerCountry:GetTotalIC() ) then
				local diplomacy = country:GetRelation(targetTag)
				if diplomacy:IsGuaranting()
				and not country:CalculateIsAllied(ministerTag)
				and not country:GetRelation(ministerTag):HasWar()	-- Don't worry if we are at war already!
				then
					guaranteed = true
					break
				end
			end
		end
	end
	
	return guaranteed
end

-- Function to decide whether targetTag controls
-- any core provinces of ministerTag!
function P.HoldsAnyCores( ministerTag, targetTag )

	if ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( targetTag ) )
	then
		return false
	end

	local ministerCountry = ministerTag:GetCountry()
	local targetCountry = targetTag:GetCountry()
	local holdsCore = false
	
	for coreProvinceID in ministerCountry:GetCoreProvinces() do
		local province = CCurrentGameState.GetProvince(coreProvinceID)
		if province:GetController() == targetTag then
			holdsCore = true
			break
		end
	end
	
	return holdsCore
end

-- Function to decide whether targetTag owns
-- any core provinces of ministerTag!
function P.OwnsAnyCores( ministerTag, targetTag )

	if ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( targetTag ) )
	then
		return false
	end

	local ministerCountry = ministerTag:GetCountry()
	local targetCountry = targetTag:GetCountry()
	local holdsCore = false
	
	for coreProvinceID in ministerCountry:GetCoreProvinces() do
		local province = CCurrentGameState.GetProvince(coreProvinceID)
		if province:GetOwner() == targetTag then
			holdsCore = true
			break
		end
	end
	
	return holdsCore
end

-- Returns true if the nation is fighting an enemy
-- that is stronger (based on IC) or is a Major.
function P.IsFightingMajor( ministerTag )

	if not Utils.ASSERT( ministerTag ) then
		return false
	end

	local fightingMajor = false
	local ministerCountry = ministerTag:GetCountry()
	
	if ministerCountry:IsAtWar() then
		for enemyTag in ministerCountry:GetCurrentAtWarWith() do
			if enemyTag:GetCountry():GetTotalIC() > ministerCountry:GetTotalIC()
			or enemyTag:GetCountry():IsMajor()
			then
				fightingMajor = true
				break
			end
		end
	else
		return false
	end

	return fightingMajor
	
end

-- Returns with a list of province IDs that are on a specific continent from provinceIDList.
function P.ProvincesOnContient( provinceIDList, continent )

	if ( not Utils.ASSERT( provinceIDList ) )
	or ( not Utils.ASSERT( continent ) )
	then
		return {}
	end

	local listLength = table.getn(provinceIDList)
	local returnList = {}
	local i = 0
	
	while i < listLength do
		i = i + 1
		if tostring( CCurrentGameState.GetProvince( provinceIDList[i] ):GetContinent():GetTag() ) == continent then
			table.insert(returnList, provinceIDList[i])
		end
	end

	return returnList	
end

-- Returns the effective resource stockpile limit for the given country from the given resource type.
-- This value is based on IC. If the country has more of the resource than this value, then an event
-- will make its production much less effective.
function P.GetEffectiveResourceLimit( ministerCountry, resourceType )

	if ( not Utils.ASSERT( ministerCountry ) )
	or ( not Utils.ASSERT( resourceType ) )
	then
		return 0
	end
	
	-- SSmith (30/12/2013)
	-- Adjusted the logic for puppets
	-- Handled governments-in-exile
	-- Increased the money stockpiles for the trade logic

	local Params = {
		MinisterCountry = ministerCountry,
		Goods = resourceType
	}

	local Work = {
		Limit = 100,
		TotalIC = Params.MinisterCountry:GetTotalIC(),
		IsSubject = Params.MinisterCountry:IsSubject()
	}

	if Params.Goods == CGoodsPool._SUPPLIES_ then

		-- Supplies
		-- Estimated based on industrial capacity
		-- Puppets should build to these requirements in case they have lots of troops but the events will ship surpluses to the master
		
		Work.Limit = math.min(50000, (Work.TotalIC * 200))
		
		-- Governments in exile don't have a supply stockpile so need to be capped

		if Params.MinisterCountry:IsGovernmentInExile() then
			Work.Limit = math.min( Work.Limit, 1000 )
		end

		-- If we are not at war and don't plan going to war either, we can cut back on supply stockpiles

		if not ( Params.MinisterCountry:IsAtWar() ) and not ( Params.MinisterCountry:GetStrategy():IsPreparingWar() ) then
			Work.Limit = Work.Limit * 0.75
		end

	elseif Params.Goods == CGoodsPool._FUEL_ then

		-- Fuel
		-- Estimated according to the number of fuel-consuming units
		-- Get the fuel limit from the country variable

		Work.Limit = Params.MinisterCountry:GetVariables():GetVariable(CString("ai_fuel_limit")):Get()

		-- If no country variable has been set then we will have to do the calculation here

		if Work.Limit < 0.25 then
			local fnParams = {
				MinisterCountry = Params.MinisterCountry
			}
			Work.Limit = P.GetFuelLimit( fnParams )
		end

		-- Puppets shouldn't keep too much

		if Work.IsSubject then
			Work.Limit = math.min( Work.Limit, 1500 )
		end
		
	elseif Params.Goods == CGoodsPool._MONEY_ then

		-- Money
		-- Estimated based on industrial capacity
		
		Work.Limit = math.min(Work.TotalIC, 100) * 50
		if Work.TotalIC > 100 then
			Work.Limit = Work.Limit + ((Work.TotalIC - 100) * 25)
		end

		-- Puppets shouldn't keep too much

		if Work.IsSubject then
			Work.Limit = math.min( Work.Limit, 500 )
		end
		
	elseif Params.Goods == CGoodsPool._CRUDE_OIL_ then
		
		-- Crude Oil
		-- Set limits to fit the resource storage events

		if Work.IsSubject then
			Work.Limit = 1000
		elseif Work.TotalIC < 20 then
			Work.Limit = 3500
		elseif Work.TotalIC < 50 then
			Work.Limit = 7000
		elseif Work.TotalIC < 100 then
			Work.Limit = 10000
		elseif Work.TotalIC < 200 then
			Work.Limit = 15000
		elseif Work.TotalIC < 350 then
			Work.Limit = 25000
		else
			Work.Limit = 50000
		end
		
		-- SSmith (30/12/2013)
		-- We should only build up oil reserves if we use fuel
		-- Oil gets refined into fuel and is cheaper to buy!
		-- But we don't want to go over our stockpile limits

		Work.Limit = math.min( Work.Limit, (P.GetEffectiveResourceLimit( Params.MinisterCountry, CGoodsPool._FUEL_ ) / 0.75) )
		
	elseif Params.Goods == CGoodsPool._METAL_ then

		-- Metal
		-- Set limits to fit the resource storage events
		
		if Work.IsSubject then
			Work.Limit = 1000
		elseif Work.TotalIC < 20 then
			Work.Limit = 4500
		elseif Work.TotalIC < 50 then
			Work.Limit = 8000
		elseif Work.TotalIC < 100 then
			Work.Limit = 10000
		elseif Work.TotalIC < 200 then
			Work.Limit = 15000
		elseif Work.TotalIC < 350 then
			Work.Limit = 25000
		else
			Work.Limit = 50000
		
		end
		
	elseif Params.Goods == CGoodsPool._ENERGY_ then

		-- Energy
		-- Set limits to fit the resource storage events
		
		if Work.IsSubject then
			Work.Limit = 1500
		elseif Work.TotalIC < 20 then
			Work.Limit = 10000
		elseif Work.TotalIC < 50 then
			Work.Limit = 15000
		elseif Work.TotalIC < 100 then
			Work.Limit = 20000
		elseif Work.TotalIC < 200 then
			Work.Limit = 30000
		elseif Work.TotalIC < 350 then
			Work.Limit = 50000
		else
			Work.Limit = 75000
		
		end
		
	elseif Params.Goods == CGoodsPool._RARE_MATERIALS_ then
		
		-- Rares
		-- Set limits to fit the resource storage events

		if Work.IsSubject then
			Work.Limit = 500
		elseif Work.TotalIC < 20 then
			Work.Limit = 2500
		elseif Work.TotalIC < 50 then
			Work.Limit = 4000
		elseif Work.TotalIC < 100 then
			Work.Limit = 5000
		elseif Work.TotalIC < 200 then
			Work.Limit = 7500
		elseif Work.TotalIC < 350 then
			Work.Limit = 12500
		else
			Work.Limit = 25000
		
		end 
	end

	-- Set an absolute minimum of 100 units for everyone
	
	Work.Limit = math.max( Work.Limit, 100 )

	return Work.Limit * 0.75
end

-- SSmith (19/01/2014)
-- All the code for the complex fuel calculation has been moved to a separate function
-- The value it returns will now be stored in a country variable by the foreign minister code
-- For efficiency this function will only be called periodically

function P.GetFuelLimit ( Params )

	if ( not Utils.ASSERT( Params.MinisterCountry ) )
	then
		return 0
	end

	local Work = {
		Limit = 0,
		AirforceNeeds = 0,
		NavyNeeds = 0,
		ArmyNeeds = 0,
		UnitList = Params.MinisterCountry:GetUnits()
	}

	-- SSmith (29/05/2013)
	-- There were a lot of problems with this calculation!
	-- First it was returning tiny fuel needs (which also meant the AI didn't care about crude oil either!)
	-- Second there was an imbalance between the services with the navy scoring high and the land forces very low
	-- Third the AI was not stockpiling for the airforce at all during peace and cutting back on the navy
	-- The pre-war years are important for building stockpiles for the war!

	if Params.MinisterCountry:GetNumOfAirfields() > 0 then

		-- SSmith (29/05/2013)
		-- The airforce multiplier will be increased for balance (was 25)

		Work.AirforceNeeds = Work.UnitList:GetTotalNumOfPlanes() * 40.0
	end
	if Params.MinisterCountry:GetNumOfPorts() > 0 then

		-- SSmith (29/05/2013)
		-- The navy was asking for too much so we will reduce the multiplier (was 25.0)

		Work.NavyNeeds = Work.UnitList:GetTotalNumOfWarShips() * 20.0
	end

	-- SSmith (29/05/2013)
	-- The army component was tiny so I am increasing the factors a lot for balance

	Work.ArmyNeeds = Work.ArmyNeeds + Work.UnitList:GetCount( CSubUnitDataBase.GetSubUnit( "armor_brigade" ) ) * 25.0
	Work.ArmyNeeds = Work.ArmyNeeds + Work.UnitList:GetCount( CSubUnitDataBase.GetSubUnit( "heavy_armor_brigade" ) ) * 30.0
	Work.ArmyNeeds = Work.ArmyNeeds + Work.UnitList:GetCount( CSubUnitDataBase.GetSubUnit( "light_armor_brigade" ) ) * 20.0
	Work.ArmyNeeds = Work.ArmyNeeds + Work.UnitList:GetCount( CSubUnitDataBase.GetSubUnit( "mechanized_brigade" ) ) * 20.0
	Work.ArmyNeeds = Work.ArmyNeeds + Work.UnitList:GetCount( CSubUnitDataBase.GetSubUnit( "motorized_brigade" ) ) * 20.0
	Work.ArmyNeeds = Work.ArmyNeeds + Work.UnitList:GetCount( CSubUnitDataBase.GetSubUnit( "self_propelled_towed_support_brigade" ) ) * 15.0
	Work.ArmyNeeds = Work.ArmyNeeds + Work.UnitList:GetCount( CSubUnitDataBase.GetSubUnit( "super_heavy_armor_brigade" ) ) * 20.0
	Work.ArmyNeeds = Work.ArmyNeeds + Work.UnitList:GetCount( CSubUnitDataBase.GetSubUnit( "tank_destroyer_brigade" ) ) * 15.0
	Work.ArmyNeeds = Work.ArmyNeeds + Work.UnitList:GetCount( CSubUnitDataBase.GetSubUnit( "truck_towed_support_brigade" ) ) * 15.0
		
	Work.Limit = Work.AirforceNeeds + Work.NavyNeeds + Work.ArmyNeeds
	Work.Limit = Work.Limit * 10

	-- SSmith (29/05/2013)
	-- I want to put in a country-specific exception for Japan
	-- Before the war we are moving fuel to our strategic reserve so there's no point trying to build up our stockpile too much
	-- We also don't need to worry when we're fighting a major so long as we can still draw on our strategic reserve

	local ministerTag = Params.MinisterCountry:GetCountryTag()
	if tostring(ministerTag) == "JAP" then
		local usaTag = CCountryDataBase.GetTag('USA')
		local engTag = CCountryDataBase.GetTag('ENG')
		local sovTag = CCountryDataBase.GetTag('SOV')
		if not Params.MinisterCountry:IsAtWar() then
			Work.Limit = Work.Limit * 0.5
		elseif Params.MinisterCountry:GetRelation(usaTag):HasWar() or Params.MinisterCountry:GetRelation(engTag):HasWar()
		or Params.MinisterCountry:GetRelation(sovTag):HasWar() then
			if Params.MinisterCountry:GetVariables():GetVariable(CString("stored_fuel_in_japan")) > CFixedPoint(0.05) then
				Work.Limit = Work.Limit * 0.5
			end
		end
	end

	return Work.Limit
end


-- This can be used for Diplomatic scores to scale them in an analog way between two extreme points.
-- Returns with a value on the linear line between the points (0,a) and (1,b), forcing extremal values to [0,1].
function P.LinearFunction( a, b, x )

	if ( not Utils.ASSERT( a ) )
	or ( not Utils.ASSERT( b ) )
	or ( not Utils.ASSERT( x ) )
	then
		return 0.0
	end

	if a == b then	-- There's no such function, so return 1 instead.
		return 1.0
	end
	
	local rValue = ( 1 / ( b - a ) ) * x - ( a / ( b - a ) )
	
	return math.min( math.max( rValue, 0.0 ), 1.0 )
end

-- Threat effects Diplomatic actions in a special way. It's no problem as long as it stays low.
-- As it gets higher, people start to distance themselves from you. But if it gets high enough,
-- they may start to fear you, bringing strength ratio into the equation!
-- The return value is close to 1.0 if they are causing no problem;
-- close to 0.0 if we don't want to associate with them and
-- close 1.0 if we don't want to antagonize them.
function P.ThreatFactor( ministerTag, targetTag )

	if ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( targetTag ) )
	then
		return 0.0
	end
	
	local nThreatFactor = 1.0
	local targetThreat = ministerTag:GetCountry():GetRelation( targetTag ):GetThreat():Get()
	
	-- SSmith (23/01/2014)
	-- For efficiency call the new CompareEstimatedMilitaryStrength function!
	-- The way the military strength was factored caused the opposite result from intended!
	-- We will now return a value between 1.0 (good) and 0.0 (bad)

	local nDislikeFactor = P.LinearFunction( 100, 25, targetThreat )
	local nFearFactor = 1.0
	local fnParams = {
		MinisterTag = ministerTag,
		TargetTag = targetTag
	}
	local nStrengthFactor = P.CompareEstimatedMilitaryStrength( fnParams )

	if nStrengthFactor < 1.0 then
		nFearFactor = 1 / math.max( nStrengthFactor, 0.1 )			-- We are weaker so the fear factor is scaled up
	elseif nStrengthFactor > 1 then
		nFearFactor = 1 / nStrengthFactor					-- We are stronger so the fear factor is scaled down
	end
	nFearFactor = P.LinearFunction( 25, 100, targetThreat ) * ( nFearFactor / 2 )	-- We will only take half the fear factor

	nThreatFactor = math.min(math.max(nDislikeFactor + nFearFactor, 0.0), 1.0)	-- The final factor adds the fear element back to offset our dislike
	return nThreatFactor
end

-- Checks the relative strength of the supposed target. Returns with 100 if the target country is sufficiently weaker,
-- and 0 if it is not, and in this case the country starts to prepare for war against this country (if not preparing already).
-- What's sufficient depends on the requiredRatio variable: the strength ratio needs to be higher than that.
function P.PrepareForWarDecision( ministerTag, targetTag, decision, requiredRatio )

	if ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( targetTag ) )
	or ( not Utils.ASSERT( decision ) )
	or ( not Utils.ASSERT( requiredRatio ) )
	then
		return 0
	end
	
	local ministerCountry = ministerTag:GetCountry()
	local targetCountry = targetTag:GetCountry()
	
	-- A requiredRatio of less than 1.0 would mean that we are more eager to fight them without preparing if they are stronger than if we are stronger...
	requiredRatio = math.max( requiredRatio, 1.0 )

	-- SSmith (02/05/2013)
	-- This would be improved if it used my CompareRealMilitaryStrength function
	-- It would more efficient also to evaluate that function once only

	local strength = P.CompareRealMilitaryStrength( ministerTag, targetTag )

	if strength > requiredRatio then
		return 100
	elseif strength < ( 1.0 - 1 / requiredRatio ) then
		-- If we are reeeeally not suited to fight them, we shouldn't even prepare, just let it go...
		-- Say we want to attack them automatically if we are twice as strong. Then if we are half as strong, then we won't even try to prepare.
		-- If we want to attack them only if we are five times as strong, then we won't even try if we are 80% as strong.
		return 0
	else
		local strategy = ministerCountry:GetStrategy()
		-- Here comes the interesting part: naval invasions.

		-- SSmith (08/12/2013)
		-- First we will check if the target is our neighbour or if we are at war with one of its neighbours
		local isNeighbour = ministerCountry:IsNeighbour( targetTag )
		if not isNeighbour then
			for neighbourTag in targetCountry:GetNeighbours() do
				if ministerCountry:GetRelation(neighbourTag):HasWar() then
					isNeighbour = true
					break
				end
			end
		end

		if not isNeighbour
		and ministerCountry:GetNumOfPorts() > 0
		and targetCountry:GetNumOfPorts() > 0
		then
			-- If we are not neighbours and we both have ports then we will have to invade them! We will need warships and transports for that!

			-- SSmith (18/05/2013)
			-- It is probably unlikely this will ever be called and its effects could be unpredictable!
			-- For consistency, we will make the same change as in the PrepareForWar function below

			local nMinisterTransportCount = ministerCountry:GetUnits():GetTotalNumOfTransports()
			--local nMinisterUnitCount = ministerCountry:GetUnits():GetTotalAmountOfDivisions()
			local nTargetUnitCount = targetCountry:GetUnits():GetTotalAmountOfDivisions()

			local nMinisterWarshipCount = ministerCountry:GetUnits():GetTotalNumOfWarShips()
			local nTargetWarshipCount = targetCountry:GetUnits():GetTotalNumOfWarShips()

			-- SSmith (24/11/2013)
			-- Reduce the warship ratio from 0.75 as it's too restrictive

			if ( nMinisterTransportCount / nTargetUnitCount ) < 0.2 or ( nMinisterWarshipCount / nTargetWarshipCount ) < 0.50 then
				-- If our transport to unit ratio is very low or our warship ratio is very low, we shouldn't do that, it would be suicide!
				-- The method is not perfect of course since it won't take the size of ships into account but the AI shouldn't know that information in the first place.
				return 0
			end
		end
		
		if not strategy:IsPreparingWarWith( targetTag ) then
			strategy:PrepareWarDecision( targetTag, 100, decision, false )
		end
		return 0
	end
end

-- Checks a few things before allowing the AI to do unwise DoWs.
function P.PrepareForWar( ministerTag, targetTag, score )

	if ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( targetTag ) )
	or ( not Utils.ASSERT( score ) )
	then
		return
	end
	
	local ministerCountry = ministerTag:GetCountry()
	local targetCountry = targetTag:GetCountry()
	local strategy = ministerCountry:GetStrategy()

	-- SSmith (02/05/2013)
	-- This would be improved if it used my CompareRealMilitaryStrength function

	if P.CompareRealMilitaryStrength( ministerTag, targetTag ) < 50 / score then
		-- If we are reeeeally not suited to fight them, we shouldn't even prepare, just let it go...
		return
	else
		-- Here comes the interesting part: naval invasions.

		-- SSmith (08/12/2013)
		-- First we will check if the target is our neighbour or if we are at war with one of its neighbours
		local isNeighbour = ministerCountry:IsNeighbour( targetTag )
		if not isNeighbour then
			for neighbourTag in targetCountry:GetNeighbours() do
				if ministerCountry:GetRelation(neighbourTag):HasWar() then
					isNeighbour = true
					break
				end
			end
		end

		if not isNeighbour and ministerCountry:GetNumOfPorts() > 0 and targetCountry:GetNumOfPorts() > 0
		then
			-- If we are not neighbours and we both have ports then we will have to invade them! We will need warships and transports for that!

			-- SSmith (18/05/2013)
			-- Requiring the attacker to have enough transports to carry 20% of its divisions prevented Germany from invading Norway
			-- A more sensible check is for 20% of the enemy's divisions (i.e. can we land enough units to threaten them?)

			local nMinisterTransportCount = ministerCountry:GetUnits():GetTotalNumOfTransports()
			--local nMinisterUnitCount = ministerCountry:GetUnits():GetTotalAmountOfDivisions()
			local nTargetUnitCount = targetCountry:GetUnits():GetTotalAmountOfDivisions()

			local nMinisterWarshipCount = ministerCountry:GetUnits():GetTotalNumOfWarShips()
			local nTargetWarshipCount = targetCountry:GetUnits():GetTotalNumOfWarShips()

			-- SSmith (24/11/2013)
			-- Reduce the warship ratio from 0.75 as it's too restrictive

			if ( nMinisterTransportCount / nTargetUnitCount ) < 0.2 or ( nMinisterWarshipCount / nTargetWarshipCount ) < 0.50 then
				-- If our transport to unit ratio is very low or our warship ratio is very low, we shouldn't do that, it would be suicide!
				-- The method is not perfect of course since it won't take the size of ships into account but the AI shouldn't know that information in the first place.
				return
			end
		end
	end
		
	if not strategy:IsPreparingWarWith( targetTag ) then
		strategy:PrepareWar( targetTag, score )
	end
end

-- Checks if any of the owned provinces of targetTag are under enemy occupation.
-- If that is the case, then it shouldn't be liberated, otherwise it's alright.
-- The purpose of this is to avoid the situation where the liberated country gets
-- all the provinces from any other countries yet to be liberated.
-- (Shouldn't matter that much in FtM though...)
function P.ShouldLiberateCountry( ministerTag, targetTag )

	if not ( Utils.ASSERT( ministerTag ) )
	or not ( Utils.ASSERT( targetTag ) )
	then
		return false
	end
	
	local targetCountry = targetTag:GetCountry()

	-- SSmith (22/09/2013)
	-- We need this to check just the provinces in the same continent as the capital

	local capitalContinent = targetCountry:GetCapitalLocation():GetContinent():GetTag()
	
	for provinceID in targetCountry:GetOwnedProvinces() do
		local province = CCurrentGameState.GetProvince( provinceID )
		if province:GetContinent():GetTag() == capitalContinent then		-- Check this is a home province
			local controllerTag = province:GetController()
			if not ( controllerTag == targetTag )				-- Not occupied by the owner
			and targetCountry:GetRelation( controllerTag ):HasWar()		-- and the occupier is at war with the owner
			then
				return false						-- Then we should wait a little longer
			end
		end
	end
	
	return true
end

-- There's no way to directly check how many aircraft, divisions and ships a country is building at the moment,
-- so this function will do it the hard way.
function P.GatherBrancProduction( ministerCountry, ProducedDivisions, ProducedAircraft, ProducedShips )

	if not ( Utils.ASSERT( ministerCountry ) )
	or not ( Utils.ASSERT( ProducedDivisions ) )
	or not ( Utils.ASSERT( ProducedAircraft ) )
	or not ( Utils.ASSERT( ProducedShips ) )
	then
		return
	end
	
	-- Note that the function will count Transpor Ships under construction but not already deployed
	
	ProducedDivisions = ministerCountry:GetUnits():GetTotalAmountOfDivisions()
	ProducedAircraft = ministerCountry:GetUnits():GetTotalNumOfPlanes()
	ProducedShips = ministerCountry:GetUnits():GetTotalNumOfWarShips()
	
	for Construction in ministerCountry:GetConstructions() do
		if Construction:IsMilitary() then
			local MilitaryConstruction = Construction:GetMilitary()
			if MilitaryConstruction:IsNaval() then
				ProducedShips = ProducedShips + 1
			elseif MilitaryConstruction:IsLand() then
				ProducedDivisions = ProducedDivisions + 1
			elseif MilitaryConstruction:IsAir() then
				ProducedAircraft = ProducedAircraft + 1
			end
		end
	end
	
	return
end

-- Adjusts the Production Weights to take the current ratio of units into account.
function P.AdjustProductionWeights( minister, ProdWeightArray )

	if not ( Utils.ASSERT( minister ) )
	or not ( Utils.ASSERT( ProdWeightArray ) )
	then	
		return {}
	end
	
	local ministerCountry = minister:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	local sMinisterTag = tostring(ministerCountry:GetCountryTag())
	local sPlayerTag = tostring(CCurrentGameState.GetPlayer())
	
	local landAlloc = math.min( math.max( ProdWeightArray[ 1 ], 0.0 ), 1.0 )
	local airAlloc = math.min( math.max( ProdWeightArray[ 2 ], 0.0 ), 1.0 )
	local navalAlloc = math.min( math.max( ProdWeightArray[ 3 ], 0.0 ), 1.0 )
	local buildingAlloc = math.min( math.max( ProdWeightArray[ 4 ], 0.0 ), 1.0 )
	
	if minister:GetCountry():GetNumOfPorts() < 1 then
		-- No ports, no Navy!
		navalAlloc = 0
	end
	if minister:GetCountry():GetNumOfAirfields() < 1 then
		-- No airfields, no Air Force!
		airAlloc = 0
	end
	
	local totalIC = 0
	local Divisions = 0
	local DivisionsBuilding = 0
	local Aircraft = 0
	local Ships = 0

	-- SSmith (26/05/2013)
	-- The function below doesn't actually work because we don't return anything from it!
	-- Instead we'll apply the logic below because we don't actually use it anywere else!
	
	--P.GatherBrancProduction( ministerCountry, Divisions, Aircraft, Ships )

	totalIC = ministerCountry:GetTotalIC()
	Divisions = ministerCountry:GetUnits():GetTotalAmountOfDivisions()
	Aircraft = ministerCountry:GetUnits():GetTotalNumOfPlanes()
	Ships = ministerCountry:GetUnits():GetTotalNumOfWarShips()
	
	for Construction in ministerCountry:GetConstructions() do
		if Construction:IsMilitary() then
			local MilitaryConstruction = Construction:GetMilitary()
			if MilitaryConstruction:IsNaval() then
				Ships = Ships + 1
			elseif MilitaryConstruction:IsLand() then
				DivisionsBuilding = DivisionsBuilding + 1
			elseif MilitaryConstruction:IsAir() then
				Aircraft = Aircraft + 1
			end
		end
	end
	
	-- SSmith (28/05/2013)
	-- We will do some adjustments for countries with less than 50 IC (I used to check for default production weights)
	-- Majors will only be affected if they lose a lot of land!
	-- This will encourage more air/naval spending if those arms are under-invested
	-- We will adjust officer ratio for the units building and reduce the land allocation if we are short of officers

	--if not Utils.HasCountryAIFunction(ministerTag, "ProductionWeights") then
	if totalIC < 50 then
		local airRatio = (Divisions + DivisionsBuilding) / math.max(Aircraft, 1)
		local navalRatio = (Divisions + DivisionsBuilding) / math.max(Ships, 1)
		local officerRatio = ministerCountry:GetOfficerRatio():Get()
		officerRatio = officerRatio * (math.max(Divisions, 1) / math.max((Divisions + DivisionsBuilding), 1))

		if airRatio > 10 then
			airAlloc = airAlloc * 1.10
		elseif airRatio > 8 then
			airAlloc = airAlloc * 1.20
		elseif airRatio > 6 then
			airAlloc = airAlloc * 1.35
		elseif airRatio > 5 then
			airAlloc = airAlloc * 1.50
		end

		if navalRatio > 10 then
			navalAlloc = navalAlloc * 1.10
		elseif navalRatio > 8 then
			navalAlloc = navalAlloc * 1.20
		elseif navalRatio > 6 then
			navalAlloc = navalAlloc * 1.35
		elseif navalRatio > 5 then
			navalAlloc = navalAlloc * 1.50
		end

		if officerRatio < 0.75 then
			landAlloc = landAlloc * 0.4
		elseif officerRatio < 0.85 then
			landAlloc = landAlloc * 0.6
		elseif officerRatio < 0.95 then
			landAlloc = landAlloc * 0.8
		end
	end

	-- This is pretty much country-specific, but at least gathered into a single place...

	-- SSmith (02/06/2013)
	-- The country-specific overrides are useful to prevent imbalances
	-- So let's start using them...

	if sMinisterTag == "SOV" then

		-- SSmith (02/06/2013)
		-- The USSR is capable of building huge amounts of land forces
		-- We want to regulate that so the Red Army doesn't get too big
		-- The main problem here is officer ratio
		-- Low quality is fine early in the war but we need greater efficiency later to defeat Germany

		local officerRatio = ministerCountry:GetOfficerRatio():Get()
		local year = CCurrentGameState.GetCurrentDate():GetYear()
		local threshold = 0.90 + (math.max((year - 1941), 0) / 10)
		local scalar = math.min(math.max((threshold - officerRatio), 0), 0.5) * 2

		--Utils.LUA_DEBUGOUT("Officers: " .. tostring(officerRatio))
		--Utils.LUA_DEBUGOUT("Year: " .. tostring(year))
		--Utils.LUA_DEBUGOUT("Threshold: " .. tostring(threshold))
		--Utils.LUA_DEBUGOUT("Scalar: " .. tostring(scalar))
		--Utils.LUA_DEBUGOUT("Land: " .. tostring(landAlloc))
		--Utils.LUA_DEBUGOUT("Air: " .. tostring(airAlloc))
		--Utils.LUA_DEBUGOUT("Naval: " .. tostring(navalAlloc))
		--Utils.LUA_DEBUGOUT("Other: " .. tostring(buildingAlloc))

		local curtail = landAlloc * scalar
		landAlloc = landAlloc - curtail
		airAlloc = airAlloc + (curtail * 0.15)
		navalAlloc = navalAlloc + (curtail * 0.25)
		buildingAlloc = buildingAlloc + (curtail * 0.60)

		--Utils.LUA_DEBUGOUT("Land: " .. tostring(landAlloc))
		--Utils.LUA_DEBUGOUT("Air: " .. tostring(airAlloc))
		--Utils.LUA_DEBUGOUT("Naval: " .. tostring(navalAlloc))
		--Utils.LUA_DEBUGOUT("Other: " .. tostring(buildingAlloc))

		--local DivisionLimit = totalIC * 2
		--if Divisions > totalIC * 3 then
		--	landAlloc = landAlloc * 0.25
		--elseif Divisions > totalIC * 2.5 then
		--	landAlloc = landAlloc * 0.50
		--elseif Divisions > totalIC * 2 then
		--	landAlloc = landAlloc * 0.75
		--end

	elseif sMinisterTag == "ALB" and sPlayerTag ~= "ITA" then

		-- SSmith (02/06/2013)
		-- Who would have thought it would be necessary to nerf Albania!!!
		-- Any we will only let them build one more division unless they're at war
		-- That should stop them embarrassing Mussolini!

		if not ministerCountry:IsAtWar() and Divisions > 1 then
			landAlloc = 0.0
		end
	end

	-- SSmith (03/07/2013)
	-- We will cap the unit builds of puppet states

	if ministerCountry:IsSubject() then
		local landcap = (totalIC / 2) + 1
		local airseacap = totalIC / 5
		if sMinisterTag == "IND" then		-- India has a crown colony IC malus
			landcap = totalIC
			airseacap = totalIC / 2.5
		end

		if (Divisions + DivisionsBuilding) > landcap then
			landAlloc = 0.0
		end
		if Aircraft > airseacap then
			airAlloc = 0.0
		end
		if Ships > airseacap then
			navalAlloc = 0.0
		end
	end



	-- SSmith (13/05/2013)
	-- These original country-specific adjustments are useful in principle
	-- But I'm going to disable them for now until I know how I want to re-work them!
	
	if sMinisterTag == "XUSA" then
		-- The US will only have 75 Divisions plus 10 for every year in the game.
		-- In '40, they may have 115, by the end of the war they may have up to 155, easily allowing them Superpower status!
		local DivisionLimit = 75 + ( ( CCurrentGameState.GetCurrentDate():GetYear() - 1936 ) * 10 )
		if Ships < 100 then
			-- If running low on Ships, let's build some more!
			navalAlloc = navalAlloc * 1.5
		end
		if Divisions > DivisionLimit then
			-- Don't overproduce ground forces!
			landAlloc = landAlloc * 0.25
		end
	elseif sMinisterTag == "XENG" then
		if Ships < 110 then
			-- If running low on Ships, let's build some more!
			navalAlloc = navalAlloc * 1.5
		end
	elseif sMinisterTag == "XJAP" then

		-- SSmith (04/05/2013)
		-- Adjusted the most extreme cases to be a little more balanced (factors were 2.0 and 0.25)

		--if CCurrentGameState.GetCurrentDate():GetDayOfMonth() < 1 then
		--	Utils.LUA_DEBUGOUT("JAP Army/Navy Struggle")
		--	if CCurrentGameState.IsGlobalFlagSet( CString( "strong_jap_navy_influence" ) ) then
		--		Utils.LUA_DEBUGOUT("Strong Navy Influence")
 		--	elseif CCurrentGameState.IsGlobalFlagSet( CString( "jap_navy_influence" ) ) then
		--		Utils.LUA_DEBUGOUT("Navy Influence")
 		--	elseif CCurrentGameState.IsGlobalFlagSet( CString( "jap_army_influence" ) ) then
		--		Utils.LUA_DEBUGOUT("Army Influence")
 		--	elseif CCurrentGameState.IsGlobalFlagSet( CString( "strong_jap_army_influence" ) ) then
		--		Utils.LUA_DEBUGOUT("Strong Army Influence")
		--	end
 		--end

		if CCurrentGameState.IsGlobalFlagSet( CString( "strong_jap_navy_influence" ) ) then
			-- Lower Land investment
			landAlloc = landAlloc * 0.50
			-- Higher Naval investment
			navalAlloc = navalAlloc * 1.50
		elseif CCurrentGameState.IsGlobalFlagSet( CString( "jap_navy_influence" ) ) then
			-- Lower Land investment
			landAlloc = landAlloc * 0.75
			-- Higher Naval investment
			navalAlloc = navalAlloc * 1.25
		elseif CCurrentGameState.IsGlobalFlagSet( CString( "jap_army_influence" ) ) then
			-- Higher Land investment
			landAlloc = landAlloc * 1.25
			-- Lower Naval investment
			navalAlloc = navalAlloc * 0.75
		elseif CCurrentGameState.IsGlobalFlagSet( CString( "strong_jap_army_influence" ) ) then
			-- Higher Land investment
			landAlloc = landAlloc * 1.50
			-- Lower Naval investment
			navalAlloc = navalAlloc * 0.50
		end
		if Ships < 75 then
			-- If running low on Ships, let's build some more!
			navalAlloc = navalAlloc * 1.5
		end
	elseif sMinisterTag == "XITA" then
		if Ships < 50 then
			-- If running low on Ships, let's build some more!
			navalAlloc = navalAlloc * 1.5
		end
	elseif sMinisterTag == "XGER" then
		if ministerCountry:GetTechnologyStatus():IsUnitAvailable( CSubUnitDataBase.GetSubUnit( "armor_brigade" ) )
		and ministerCountry:GetUnits():GetCount( CSubUnitDataBase.GetSubUnit( "armor_brigade" ) ) < 20 then
			-- If we could build tanks but don't have that many yet (say 10 Divisions' worth), then build up a nice starting amount ASAP!
			landAlloc = landAlloc * 2.0
			navalAlloc = navalAlloc * 0.05
			airAlloc = airAlloc * 0.05
		elseif not ( Support.IsDefeated( ministerCountry:GetCountryTag(), CCountryDataBase.GetTag( "SOV" ) ) ) then
			-- The USSR is still standing, so let's focus on the historical Strategy!
			if Divisions < ( 25 + 35 ) then
				-- Securing the Western and Eastern borders are of utmost importance!
				landAlloc = landAlloc * 2.0
				navalAlloc = navalAlloc * 0.25
			elseif Aircraft < 25 then
				-- Then we will need a strong Luftwaffe!
				airAlloc = airAlloc * 2.0
				navalAlloc = navalAlloc * 0.25
			elseif Divisions < 80 then
				-- When that's also done, we could build some more Divisions for a while
				landAlloc = landAlloc * 2.0
				navalAlloc = navalAlloc * 0.25
			elseif Ships < 35 then
				-- Then it's finally time to build some ships!
				navalAlloc = navalAlloc * 1.5
			end
		end
	end
	
	-- Normalize
	local sumAlloc = landAlloc + airAlloc + navalAlloc + buildingAlloc
	
	if sumAlloc > 0.0 then
		-- Again, it shouldn't be necessary to check, but just in case...
		ProdWeightArray[ 1 ] = landAlloc / sumAlloc
		ProdWeightArray[ 2 ] = airAlloc / sumAlloc
		ProdWeightArray[ 3 ] = navalAlloc / sumAlloc
		ProdWeightArray[ 4 ] = buildingAlloc / sumAlloc
	end
	
	return ProdWeightArray
end

return Support