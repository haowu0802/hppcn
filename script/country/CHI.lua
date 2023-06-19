-----------------------------------------------------------
-- Nationalist China
-----------------------------------------------------------

local P = {}
AI_CHI = P

-- Tech weights
--   1.0 = 100% the total needs to equal 1.0
function P.TechWeights(minister)

	-- SSmith (20/08/2013)
	-- New format custom tech weights function

	local liYear = CCurrentGameState.GetCurrentDate():GetYear()
	local ministerCountry = minister:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	local njgTag = CCountryDataBase.GetTag('NJG')
	local laTechWeights

	if liYear < 1940
	or ministerCountry:GetSurrenderLevel():Get() > 0.60
	or (not Support.IsDefeated(ministerTag, njgTag) and njgTag:GetCountry():GetSurrenderLevel():Get() < 0.10)
	then
		-- It is early in the war or we are losing badly to Japan

		laTechWeights = {
			0.65, -- Land
			0.00, -- Air
			0.00, -- Naval
			0.35}; -- Other

	elseif ministerCountry:GetSurrenderLevel():Get() > 0.35
	or (not Support.IsDefeated(ministerTag, njgTag) and njgTag:GetCountry():GetSurrenderLevel():Get() < 0.50)
	then
		-- We are not doing well

		laTechWeights = {
			0.55, -- Land
			0.15, -- Air
			0.05, -- Naval
			0.25}; -- Other

	else	-- Default weights for a regional power

		laTechWeights = {
			0.45, -- Land
			0.15, -- Air
			0.15, -- Naval
			0.25}; -- Other	
	end

	return laTechWeights
end

function P.Get_TechParams(minister)

	-- SSmith (25/08/2013)
	-- This is a new function to return a table of country-specific research config

	local liYear = CCurrentGameState.GetCurrentDate():GetYear()
	local ministerCountry = minister:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	local njgTag = CCountryDataBase.GetTag('NJG')

	local laTechParams = {}

	if liYear < 1940
	or ministerCountry:GetSurrenderLevel():Get() > 0.60
	or (not Support.IsDefeated(ministerTag, njgTag) and njgTag:GetCountry():GetSurrenderLevel():Get() < 0.10)
	then
		laTechParams = {
			mountain_infantry 		= { Leadership =  7, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
			mortorised_infantry 		= { Leadership =  7, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
			artillery 			= { Leadership =  5, Priority = 0.60, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
			anti_tank 			= { Leadership =  7, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
			anti_air_activation 		= { Leadership =  7, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
			anti_air_guns 			= { Leadership =  7, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

			truck_engine 			= { Leadership =  7, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
			truck_towed_support_brigade_tech = { Leadership = 7, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
			lighttank_brigade 		= { Leadership = 10, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "LightTank" },

			heavy_aa_guns 			= { Leadership =  7, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
			electronic_mechanical_egineering = { Leadership = 7, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
			radio_technology 		= { Leadership =  7, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
			radio 				= { Leadership =  7, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
			radar 				= { Leadership =  7, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
			census_tabulation_machine 	= { Leadership =  7, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
			mechnical_computing_machine 	= { Leadership =  7, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },

			security_training 		= { Leadership =  7, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
			artillery_training 		= { Leadership =  5, Priority = 0.70, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
			tank_crew_training 		= { Leadership = 10, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
			special_forces_training 	= { Leadership =  7, Priority = 0.40, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
			officer_training		= { Leadership =  5, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
			shock_1930 			= { Leadership =  3, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
			shock_1937 			= { Leadership =  3, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
			shock_1940			= { Leadership =  3, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
			shock_1943 			= { Leadership =  3, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
			shock_1946 			= { Leadership =  3, Priority = 0.90, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
			infantry_support_role_1930 	= { Leadership = 10, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
			infantry_support_role_1937	= { Leadership = 10, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
			infantry_support_role_1940 	= { Leadership = 10, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
			infantry_support_role_1943 	= { Leadership = 10, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
			infantry_support_role_1946 	= { Leadership = 10, Priority = 0.50, EarlyOffset = 0.00, LateOffset = 0.00, EndYear = 1999, Attribute = "" },
			human_wave_1930 		= { Leadership =  3, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
			human_wave_1937 		= { Leadership =  3, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
			human_wave_1940 		= { Leadership =  5, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
			human_wave_1943 		= { Leadership =  5, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
			human_wave_1946 		= { Leadership =  5, Priority = 0.80, EarlyOffset = 0.00, LateOffset = 0.50, EndYear = 1999, Attribute = "" },
		}
	end

	return laTechParams
end

-- SSmith (10/05/2013)
-- I have removed the custom TechSliders function

-- END OF TECH RESEARCH OVERIDES
-- #######################################


-- #######################################
-- Production Overides the main LUA with country specific ones

-- Production Weights
--   1.0 = 100% the total needs to equal 1.0
function P.ProductionWeights(minister)
	local rValue
	local lbAtWar = minister:GetCountry():IsAtWar()
	local liCYear = CCurrentGameState.GetCurrentDate():GetYear()

	-- SSmith (22/06/2013)
	-- The production weights need to respond to circumstances

	local ministerCountry = minister:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	local japTag = CCountryDataBase.GetTag('JAP')
	local njgTag = CCountryDataBase.GetTag('NJG')

	if not lbAtWar then

		-- We are at peace in 1936-1939

		if liCYear < 1940 then
			local laArray = {
				0.70,	-- Land
				0.10,	-- Air
				0.05,	-- Sea
				0.15};	-- Other
			rValue = laArray

		-- We are at peace from 1940 onwards

		else
			local laArray = {
				0.40,	-- Land
				0.20,	-- Air
				0.20,	-- Sea
				0.20};	-- Other
			rValue = laArray
		end

	elseif ministerCountry:GetRelation(japTag):HasWar() then

		-- We are losing badly to Japan

		if ministerCountry:GetSurrenderLevel():Get() > 0.60
		or (not Support.IsDefeated(ministerTag, njgTag) and njgTag:GetCountry():GetSurrenderLevel():Get() < 0.10) then

			local laArray = {
				1.00,	-- Land
				0.00,	-- Air
				0.00,	-- Sea
				0.00};	-- Other
			rValue = laArray

		-- We are not doing well

		elseif ministerCountry:GetSurrenderLevel():Get() > 0.35
		or (not Support.IsDefeated(ministerTag, njgTag) and njgTag:GetCountry():GetSurrenderLevel():Get() < 0.50) then

			local laArray = {
				0.80,	-- Land
				0.15,	-- Air
				0.00,	-- Sea
				0.05};	-- Other
			rValue = laArray

		-- We are doing well (from 1940)

		elseif ministerCountry:GetSurrenderLevel():Get() < 0.05 and liCYear > 1939
		and (Support.IsDefeated(ministerTag, njgTag) or njgTag:GetCountry():GetSurrenderLevel():Get() > 0.50) then
			local laArray = {
				0.40,	-- Land
				0.25,	-- Air
				0.25,	-- Sea
				0.10};	-- Other
			rValue = laArray

		-- Otherwise

		else
			local laArray = {
				0.65,	-- Land
				0.20,	-- Air
				0.10,	-- Sea
				0.05};	-- Other
			rValue = laArray
		end

	-- We are losing badly to someone

	elseif ministerCountry:GetSurrenderLevel():Get() > 0.35 then
		local laArray = {
			0.85,	-- Land
			0.15,	-- Air
			0.00,	-- Sea
			0.00};	-- Other
		rValue = laArray

	-- We are at war in 1936-1939

	elseif liCYear < 1940 then
		local laArray = {
			0.70,	-- Land
			0.15,	-- Air
			0.05,	-- Sea
			0.10};	-- Other
		rValue = laArray

	-- We are at war from 1940

	else
		local laArray = {
			0.50,	-- Land
			0.25,	-- Air
			0.20,	-- Sea
			0.05};	-- Other
		rValue = laArray
	end

	return rValue
end
-- Land ratio distribution
function P.LandRatio(minister)
	local laArray
	
	local isAtWar = minister:GetCountry():IsAtWar()
	local year = CCurrentGameState.GetCurrentDate():GetYear()

	-- SSmith (22/06/2013)
	-- The production weights need to respond to circumstances

	local ministerCountry = minister:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	local japTag = CCountryDataBase.GetTag('JAP')
	local njgTag = CCountryDataBase.GetTag('NJG')

	if not isAtWar then

		-- We are at peace in 1936-1939

		if year < 1940 then
			laArray = {
				5, -- Garrison
				12, -- Infantry
				0, -- Motorized
				0, -- Mechanized
				0, -- Armor
				5, -- Militia
				3}; -- Cavalry

		-- We are at peace from 1940 onwards

		else
			laArray = {
				5, -- Garrison
				12, -- Infantry
				2, -- Motorized
				1, -- Mechanized
				1, -- Armor
				2, -- Militia
				2}; -- Cavalry

		end

	elseif ministerCountry:GetRelation(japTag):HasWar() then

		-- We are losing badly to Japan (before 1940)

		-- SSmith (14/09/2013)
		-- The militia spam needs to stop if the army gets big enough!

		if ((ministerCountry:GetSurrenderLevel():Get() > 0.35 and year < 1940)
		or (not Support.IsDefeated(ministerTag, njgTag) and njgTag:GetCountry():GetSurrenderLevel():Get() < 0.10))
		and ministerCountry:GetUnits():GetTotalAmountOfDivisions() < 125 then

			laArray = {				-- If we don't have tons of Militia yet, then build more!
				2, -- Garrison
				6, -- Infantry
				0, -- Motorized
				0, -- Mechanized
				0, -- Armor
				15, -- Militia
				2}; -- Cavalry

		-- We are doing well (from 1940)

		elseif ministerCountry:GetSurrenderLevel():Get() < 0.05 and year > 1939
		and (Support.IsDefeated(ministerTag, njgTag) or njgTag:GetCountry():GetSurrenderLevel():Get() > 0.50) then

			laArray = {
				3, -- Garrison
				14, -- Infantry
				2, -- Motorized
				1, -- Mechanized
				1, -- Armor
				2, -- Militia
				2}; -- Cavalry

		-- Otherwise

		else
			laArray = {
				2, -- Garrison
				8, -- Infantry
				1, -- Motorized
				1, -- Mechanized
				1, -- Armor
				10, -- Militia
				2}; -- Cavalry
		end

	-- We are losing badly to someone (before 1940)

	elseif ministerCountry:GetSurrenderLevel():Get() > 0.35 and year < 1940
	and ministerCountry:GetUnits():GetTotalAmountOfDivisions() < 125 then
		laArray = {
			2, -- Garrison
			8, -- Infantry
			0, -- Motorized
			0, -- Mechanized
			0, -- Armor
			12, -- Militia
			2}; -- Cavalry

	-- We are at war in 1936-1939

	elseif year < 1940 then
		laArray = {
			5, -- Garrison
			10, -- Infantry
			0, -- Motorized
			0, -- Mechanized
			0, -- Armor
			7, -- Militia
			3}; -- Cavalry

	-- We are at war from 1940

	else
		laArray = {
			3, -- Garrison
			14, -- Infantry
			2, -- Motorized
			1, -- Mechanized
			1, -- Armor
			2, -- Militia
			2}; -- Cavalry
	end

	return laArray
end

-- SSmith (08/06/2013)
-- Custom special forces ratio removed

-- Special Forces ratio distribution
--function P.SpecialForcesRatio(minister)
--	local laArray = {
--		25, -- Land
--		1}; -- Special Forces Unit
--	
--	return laArray
--end

-- Air ratio distribution
function P.AirRatio(minister)

	-- SSmith (22/06/2013)
	-- Configure this for a more balanced force

	local laArray = {
		12, -- Fighter
		5, -- CAS
		5, -- Tactical
		3, -- Naval Bomber
		0}; -- Strategic
	
	return laArray
end
-- Transport to Land unit distribution
function P.TransportLandRatio(minister)

	-- SSmith (05/10/2013)
	-- Reduced because the army could get very large

	local laArray = {
		60, -- Land
		1}; -- Transport
	
	return laArray
end

-- SSmith (22/06/2013)
-- Infantry, Militia and Garrison build functions fixed to remove brigade/IC restrictions

-- Build Infantry units -> Don't attach support brigades!
function P.Build_Infantry(ic, minister, infantry_brigade, vbGoOver)

	-- SSmith (05/10/2013)
	-- Allow a proportion of support brigades to be added from 1940

	if CCurrentGameState.GetCurrentDate():GetYear() < 1940 or math.random(100) < 75 then
		ic, infantry_brigade = Utils.CreateDivision_nominor(minister, "infantry_brigade", 0, ic, infantry_brigade, 3, vbGoOver)
	else
		ic, infantry_brigade = Utils.CreateDivision(minister, "infantry_brigade", 0, ic, infantry_brigade, 3, Utils.BuildLegUnitArray(minister:GetCountry()), 1, vbGoOver)
	end

	return ic, infantry_brigade
end

-- Build Militia units -> Don't attach support brigades!
function P.Build_Militia(ic, minister, militia_brigade, vbGoOver)

	ic, militia_brigade = Utils.CreateDivision_nominor(minister, "militia_brigade", 0, ic, militia_brigade, 3, vbGoOver)

	return ic, militia_brigade
end

-- Build Garrison units -> Don't attach support brigades!
function P.Build_Garrison(ic, minister, garrison_brigade, vbGoOver)

	ic, garrison_brigade = Utils.CreateDivision_nominor(minister, "garrison_brigade", 0, ic, garrison_brigade, 3, vbGoOver)

	return ic, garrison_brigade
end

-- Do not build coastal forts
function P.Build_CoastalFort(ic, minister, vbGoOver)
	return ic
end

function P.DontBuildBuilding(minister, building)

	-- SSmith (30/06/2013)
	-- Don't fill up the production queue with buildings before the war with Japan!

	if minister:GetOwnerAI():GetCurrentDate():GetYear() < 1940
	and minister:GetCountry():GetOfficerRatio():Get() > 0.70 then
		return true
	else
		return false
	end

end

-- END OF PRODUTION OVERIDES
-- #######################################



function P.ForeignMinister_EvaluateDecision(score, agent, decision, scope)
	local lsDecision = tostring(decision:GetKey())
	local country = agent:GetCountry()
	local ministerTag = country:GetCountryTag()
	local chcTag = CCountryDataBase.GetTag('CHC')
	local japTag = CCountryDataBase.GetTag('JAP')
	
	if lsDecision == "forge_the_unified_front" then				-- By the time we can do this, we will already need it!
		if math.mod( CCurrentGameState.GetAIRand(), 10) == 1 then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == "chi_continues_the_civil_war" then
		score = 0
		if Support.IsDefeated(ministerTag, japTag) then
			score = Support.PrepareForWarDecision( ministerTag, chcTag, decision, 2.0 )
		end
	elseif lsDecision == "china_demands_bases_in_indochine" then
		if math.mod( CCurrentGameState.GetAIRand(), 100) == 1 then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == "china_puts_pressure_on_siam" then
		if math.mod( CCurrentGameState.GetAIRand(), 100) == 1 then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == "ask_for_admission_to_the_allies" then
		if math.mod( CCurrentGameState.GetAIRand(), 30) == 1 then
			score = 100
		else
			score = 0
		end
	elseif lsDecision == "chinese_industry_transfer" then
		if math.mod( CCurrentGameState.GetAIRand(), 20) == 1 then
			score = 100
		else
			score = 0
		end
	end
	
	return score
end

function P.ProposeDeclareWar( minister )
	local ai = minister:GetOwnerAI()
	local ministerCountry = minister:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	local strategy = ministerCountry:GetStrategy()

	local chcTag = CCountryDataBase.GetTag('CHC')
	local cxbTag = CCountryDataBase.GetTag('CXB')
	local csxTag = CCountryDataBase.GetTag('CSX')
	local cgxTag = CCountryDataBase.GetTag('CGX')
	local sikTag = CCountryDataBase.GetTag('SIK')
	local tibTag = CCountryDataBase.GetTag('TIB')

	if not ministerCountry:IsAtWar() and chcTag:GetCountry():Exists()
	and ( ministerCountry:HasFaction() or ( not chcTag:GetCountry():HasFaction() ) )
	and ( not ministerCountry:IsSubject() or ( not chcTag:GetCountry():HasFaction() ) )
	and not ministerCountry:GetFaction() == chcTag:GetCountry():GetFaction()
	then
		Support.PrepareForWar( ministerTag, chcTag, 100 )
	end

	if not chcTag:GetCountry():Exists() and not ministerCountry:IsAtWar() and cgxTag:GetCountry():Exists()
	and ( ministerCountry:HasFaction() or ( not cgxTag:GetCountry():HasFaction() ) )
	and ( not ministerCountry:IsSubject() or ( not cgxTag:GetCountry():HasFaction() ) )
	and not ministerCountry:GetFaction() == cgxTag:GetCountry():GetFaction()
	then
		Support.PrepareForWar( ministerTag, cgxTag, 100 )
	end

	if not cgxTag:GetCountry():Exists() and not ministerCountry:IsAtWar() and csxTag:GetCountry():Exists()
	and ( ministerCountry:HasFaction() or ( not csxTag:GetCountry():HasFaction() ) )
	and ( not ministerCountry:IsSubject() or ( not csxTag:GetCountry():HasFaction() ) )
	and not ministerCountry:GetFaction() == csxTag:GetCountry():GetFaction()
	then
		Support.PrepareForWar( ministerTag, csxTag, 100 )
	end

	if not csxTag:GetCountry():Exists() and not ministerCountry:IsAtWar() and cxbTag:GetCountry():Exists()
	and ( ministerCountry:HasFaction() or ( not cxbTag:GetCountry():HasFaction() ) )
	and ( not ministerCountry:IsSubject() or ( not cxbTag:GetCountry():HasFaction() ) )
	and not ministerCountry:GetFaction() == cxbTag:GetCountry():GetFaction()
	then
		Support.PrepareForWar( ministerTag, cxbTag, 100 )
	end

	if not cxbTag:GetCountry():Exists() and not ministerCountry:IsAtWar() and sikTag:GetCountry():Exists()
	and ( ministerCountry:HasFaction() or ( not sikTag:GetCountry():HasFaction() ) )
	and ( not ministerCountry:IsSubject() or ( not sikTag:GetCountry():HasFaction() ) )
	and not ministerCountry:GetFaction() == sikTag:GetCountry():GetFaction()
	then
		Support.PrepareForWar( ministerTag, sikTag, 100 )
	end

	if not sikTag:GetCountry():Exists() and not ministerCountry:IsAtWar() and tibTag:GetCountry():Exists()
	and ( ministerCountry:HasFaction() or ( not tibTag:GetCountry():HasFaction() ) )
	and ( not ministerCountry:IsSubject() or ( not tibTag:GetCountry():HasFaction() ) )
	and not ministerCountry:GetFaction() == tibTag:GetCountry():GetFaction()
	then
		Support.PrepareForWar( ministerTag, tibTag, 100 )
	end


end

function P.AlignToFaction(minister)
	local ministerCountry = minister:GetCountry()
	local ministerTag = ministerCountry:GetCountryTag()
	
	local japTag = CCountryDataBase.GetTag('JAP')
	local axisFaction = CCurrentGameState.GetFaction("axis")
	local alliesFaction = CCurrentGameState.GetFaction("allies")
	
	if ministerCountry:GetRelation(japTag):HasWar()			-- If at war with an Axis Japan
	and japTag:GetCountry():HasFaction()
	and japTag:GetCountry():GetFaction() == axisFaction
	then
		local startAction = CInfluenceAllianceLeader(ministerTag, alliesFaction:GetFactionLeader())
		startAction:SetValue(true)				-- and align to the Allies instead!
		if startAction:IsSelectable() then
			minister:Propose(startAction, 1000 )
		end
		local stopAction = CInfluenceAllianceLeader(ministerTag, axisFaction:GetFactionLeader())
		stopAction:SetValue(false)			-- then stop aligning to the Axis,
		minister:Propose(stopAction, 1000 )
	else
		local startAction = CInfluenceAllianceLeader(ministerTag, axisFaction:GetFactionLeader())
		startAction:SetValue(true)				-- and align to the Axis instead!
		if startAction:IsSelectable() then
			minister:Propose(startAction, 1000 )
		end
		local stopAction = CInfluenceAllianceLeader(ministerTag, alliesFaction:GetFactionLeader())
		stopAction:SetValue(false)			-- Otherwise stop aligning to the Allies,
		minister:Propose(stopAction, 1000 )
	end

end

--function P.HandleMobilization( minister, needsMobilization )
	
	-- SSmith (30/06/2013)
	-- China simply can't afford to mobilize!
	-- So rely instead on the generic function

	--local ministerTag = minister:GetCountryTag()
	--local ministerCountry = minister:GetCountry()
	--local ai = minister:GetOwnerAI()

	-- Special check for Japan.
	--local japTag = CCountryDataBase.GetTag('JAP')
	
	--if japTag:GetCountry():IsMobilized()			-- Mobilize if Japan is mobilized!
	--or ai:GetCurrentDate():GetYear() > 1936		-- Or if it is already '37. Japan will attack soon.
	--then
	--	needsMobilization = true
	--end
	
	--return needsMobilization
--end

--function P.DiploScore_Alliance( score, ai, actor, recipient, observer, action)

	-- SSmith (02/07/2013)
	-- Function added (but wouldn't be called due to neutrality)
	-- If Guangxi/Yunnan have joined the Unified Front then we will seek alliances with them

	--if not observer:GetCountry():IsSubject() then 
	--	if tostring(recipient) == 'CGX' or tostring(recipient) == 'CYN' then
	--		if recipient:GetCountry():GetFlags():IsFlagSet("unified_front") then
	--			return 100
	--		end
	--	end
	--end

	--return score
--end

function P.DiploScore_InviteToFaction(score, ai, actor, recipient, observer)
	local japTag = CCountryDataBase.GetTag('JAP')
	
	if observer == recipient then	-- We are being invited
		if japTag:GetCountry():HasFaction()
		and actor:GetCountry():GetFaction() == japTag:GetCountry():GetFaction()	-- Don't join the same faction as Japan!
		then
			score = 0
		end
	end
	
	return score
end

function P.HandlePuppets(minister)

	-- SSmith (22/11/2013)
	-- Add exceptions for Communist China, ROC-Nanjing and Tibet

	local laCountryExceptions = { "CHC", "NJG", "TIB" }
	return laCountryExceptions
end

-- Want more troops, let them learn on the battlefield.
--   helps them produce troops faster
function P.CallLaw_training_laws(minister, voCurrentLaw)
	local _MINIMAL_TRAINING_ = 28
	return CLawDataBase.GetLaw(_MINIMAL_TRAINING_)
end

return AI_CHI

