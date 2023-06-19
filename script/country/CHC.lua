-----------------------------------------------------------
-- Communist China
-----------------------------------------------------------

local P = {}
AI_CHC = P

-- SSmith (23/07/2013)
-- I have removed the custom tech weights function

-- Tech weights
--   1.0 = 100% the total needs to equal 1.0
--function P.TechWeights(minister)
--	local laTechWeights = {
--		0.30, -- landBasedWeight
--		0.15, -- landDoctrinesWeight
--		0.20, -- airBasedWeight
--		0.15, -- airDoctrinesWeight
--		0.0, -- navalBasedWeight
--		0.0, -- navalDoctrinesWeight
--		0.15, -- industrialWeight
--		0.0, -- secretWeaponsWeight
--		0.05, -- otherWeight
--		true}; -- lbLandBased
--	
--	return laTechWeights
--end

-- SSmith (10/05/2013)
-- I have replaced this with a new function

function P.TechSliders(ministerCountry, techSliderArray)

	local LEADERSHIP_RESEARCH = techSliderArray[1]
	local LEADERSHIP_ESPIONAGE = techSliderArray[2]
	local LEADERSHIP_DIPLOMACY = techSliderArray[3]
	local LEADERSHIP_NCO = techSliderArray[4]

	-- The PRC needs a custom officer ratio to be competitive despite it's small size

	local officer_ratio = ministerCountry:GetOfficerRatio():Get()

	if officer_ratio < 0.75 then
		LEADERSHIP_NCO = 0.50
	elseif officer_ratio < 1.00 then
		LEADERSHIP_NCO = 0.25
	elseif officer_ratio < 1.25 then
		LEADERSHIP_NCO = 0.10
	else
		LEADERSHIP_NCO = 0.00
	end

	techSliderArray = {
		LEADERSHIP_RESEARCH,
		LEADERSHIP_ESPIONAGE,
		LEADERSHIP_DIPLOMACY,
		LEADERSHIP_NCO};

	return techSliderArray

end

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
		
	if liCYear <= 1938 and not(lbAtWar) then
		local laArray = {
			1.0, -- Land
			0.0, -- Air
			0.0, -- Sea
			0.0}; -- Other
		
		rValue = laArray
	elseif lbAtWar and liCYear <= 1942 then
		local laArray = {
			0.85, -- Land
			0.15, -- Air
			0.0, -- Sea
			0.0}; -- Other
		
		rValue = laArray		
	elseif minister:GetCountry():GetNumOfPorts() > 0 then
		local laArray = {
			0.40, -- Land
			0.25, -- Air
			0.25, -- Sea
			0.10}; -- Other
		
		rValue = laArray
	else
		local laArray = {
			0.50, -- Land
			0.35, -- Air
			0.0, -- Sea
			0.15}; -- Other
		
		rValue = laArray		
	end
	
	return rValue
end
-- Land ratio distribution
function P.LandRatio(minister)
	local laArray
	
	local isAtWar = minister:GetCountry():IsAtWar()
	local year = CCurrentGameState.GetCurrentDate():GetYear()
	
	if year <= 1938 and not(isAtWar) then		-- Before the Sino-Japanese War, concentrate on Garrisons, Infantry some Cavalry and Militia.
		laArray = {
			5, -- Garrison
			4, -- Infantry
			0, -- Motorized
			0, -- Mechanized
			0, -- Armor
			2, -- Militia
			2}; -- Cavalry
	elseif isAtWar and year < 1945 then			-- During the Sino-Japanese War, concentrate heavily on Militia!
		laArray = {
			0, -- Garrison
			3, -- Infantry
			0, -- Motorized
			0, -- Mechanized
			0, -- Armor
			10, -- Militia
			0}; -- Cavalry
	elseif year > 1944 then						-- We might start to modernize!
		laArray = {
			2, -- Garrison
			7, -- Infantry
			2, -- Motorized
			2, -- Mechanized
			1, -- Armor
			0, -- Militia
			0}; -- Cavalry
	else										-- Default composition. Mainly Infantry, but Militia can go as well.
		laArray = {
			2, -- Garrison
			10, -- Infantry
			0, -- Motorized
			0, -- Mechanized
			0, -- Armor
			5, -- Militia
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
	local laArray = {
		3, -- Fighter
		1, -- CAS
		2, -- Tactical
		0, -- Naval Bomber
		0}; -- Strategic
	
	return laArray
end
-- Transport to Land unit distribution
function P.TransportLandRatio(minister)
	local laArray = {
		40, -- Land
		1}; -- Transport
	
	return laArray
end

-- Build Infantry units -> Don't attach support brigades!
function P.Build_Infantry(ic, minister, infantry_brigade, vbGoOver)
	if infantry_brigade >= 2 and ic > 2 then
		ic, infantry_brigade = Utils.CreateDivision_nominor(minister, "infantry_brigade", 0, ic, infantry_brigade, 2, vbGoOver)
	end

	return ic, infantry_brigade
end

-- Build Militia units -> Don't attach support brigades!
function P.Build_Militia(ic, minister, militia_brigade, vbGoOver)
	if militia_brigade >= 3 and ic > 2 then
		ic, militia_brigade = Utils.CreateDivision_nominor(minister, "militia_brigade", 0, ic, militia_brigade, 3, vbGoOver)
	end

	return ic, militia_brigade
end

-- Build Garrison units -> Don't attach support brigades!
function P.Build_Garrison(ic, minister, garrison_brigade, vbGoOver)
	if garrison_brigade >= 3 and ic > 2 then
		ic, garrison_brigade = Utils.CreateDivision_nominor(minister, "garrison_brigade", 0, ic, garrison_brigade, 3, vbGoOver)
	end

	return ic, garrison_brigade
end

-- Do not build coastal forts
function P.Build_CoastalFort(ic, minister, vbGoOver)
	return ic
end

-- END OF PRODUTION OVERIDES
-- #######################################

function P.HandleMobilization( minister, needsMobilization )
	
	local ministerTag = minister:GetCountryTag()
	local ministerCountry = minister:GetCountry()
	local ai = minister:GetOwnerAI()
	
	local japTag = CCountryDataBase.GetTag('JAP')
	local chiTag = CCountryDataBase.GetTag('CHI')
	local chcTag = CCountryDataBase.GetTag('CHC')
	
	-- Special check for Japan.
	
	if ( japTag:GetCountry():IsAtWar()		-- War in China
	or chiTag:GetCountry():IsAtWar()
	or chcTag:GetCountry():IsAtWar() )
	and CCurrentGameState.GetCurrentDate():GetYear() > 1936
	then
		needsMobilization = true
	end
	
	return needsMobilization
end

function P.ProposeDeclareWar( minister )
	local ai = minister:GetOwnerAI()
	local ministerCountry = minister:GetCountry()
	local strategy = ministerCountry:GetStrategy()
	local year = ai:GetCurrentDate():GetYear()

	local chiTag = CCountryDataBase.GetTag('CHI')
	local cxbTag = CCountryDataBase.GetTag('CXB')
	local csxTag = CCountryDataBase.GetTag('CSX')
	local cgxTag = CCountryDataBase.GetTag('CGX')
	local sikTag = CCountryDataBase.GetTag('SIK')
	local tibTag = CCountryDataBase.GetTag('TIB')

	if not ministerCountry:IsAtWar() and chiTag:GetCountry():Exists()
	and ( not ministerCountry:GetRelation(chiTag):HasTruce() )
	and ( ministerCountry:HasFaction() or ( not chiTag:GetCountry():HasFaction() ) )
	and not ministerCountry:GetFaction() == chiTag:GetCountry():GetFaction()
	and not ministerCountry:IsSubject()
	then
		Support.PrepareForWar( ministerTag, chiTag, 100 )
	end

	if (  ( not chiTag:GetCountry():Exists() ) or ministerCountry:GetRelation(chiTag):HasTruce() )
	and ( not ministerCountry:IsAtWar() ) and cgxTag:GetCountry():Exists()
	and ( ministerCountry:HasFaction() or ( not cgxTag:GetCountry():HasFaction() ) )
	and not ministerCountry:GetFaction() == cgxTag:GetCountry():GetFaction()
	and not ministerCountry:IsSubject()
	then
		Support.PrepareForWar( ministerTag, cgxTag, 100 )
	end

	if not cgxTag:GetCountry():Exists() and not ministerCountry:IsAtWar() and csxTag:GetCountry():Exists()
	and ( ministerCountry:HasFaction() or ( not csxTag:GetCountry():HasFaction() ) )
	and not ministerCountry:GetFaction() == csxTag:GetCountry():GetFaction()
	and not ministerCountry:IsSubject()
	then
		Support.PrepareForWar( ministerTag, csxTag, 100 )
	end

	if not csxTag:GetCountry():Exists() and not ministerCountry:IsAtWar() and cxbTag:GetCountry():Exists()
	and ( ministerCountry:HasFaction() or ( not cxbTag:GetCountry():HasFaction() ) )
	and not ministerCountry:GetFaction() == cxbTag:GetCountry():GetFaction()
	and not ministerCountry:IsSubject()
	then
		Support.PrepareForWar( ministerTag, cxbTag, 100 )
	end

	if not cxbTag:GetCountry():Exists() and not ministerCountry:IsAtWar() and sikTag:GetCountry():Exists()
	and ( ministerCountry:HasFaction() or ( not sikTag:GetCountry():HasFaction() ) )
	and not ministerCountry:GetFaction() == sikTag:GetCountry():GetFaction()
	and not ministerCountry:IsSubject()
	then
		Support.PrepareForWar( ministerTag, sikTag, 100 )
	end

	if not sikTag:GetCountry():Exists() and not ministerCountry:IsAtWar() and tibTag:GetCountry():Exists()
	and ( ministerCountry:HasFaction() or ( not tibTag:GetCountry():HasFaction() ) )
	and not ministerCountry:GetFaction() == tibTag:GetCountry():GetFaction()
	and not ministerCountry:IsSubject()
	then
		Support.PrepareForWar( ministerTag, tibTag, 100 )
	end
end

function P.ForeignMinister_EvaluateDecision(score, agent, decision, scope)
	local lsDecision = tostring(decision:GetKey())
	local liYear = CCurrentGameState.GetCurrentDate():GetYear()
	local liMonth = CCurrentGameState.GetCurrentDate():GetMonthOfYear()
	local liDay = CCurrentGameState.GetCurrentDate():GetDayOfMonth()
	local country = agent:GetCountry()
	local ministerTag = country:GetCountryTag()
	local countryTag = country:GetCountryTag()
	local strategy = country:GetStrategy()

	local japTag = CCountryDataBase.GetTag('JAP')
	local chiTag = CCountryDataBase.GetTag('CHI')
	local csxTag = CCountryDataBase.GetTag('CSX')
	local cxbTag = CCountryDataBase.GetTag('CXB')
	local cgxTag = CCountryDataBase.GetTag('CGX')
	local cynTag = CCountryDataBase.GetTag('CYN')
	local chcTag = CCountryDataBase.GetTag('CXB')
	
	if lsDecision == "join_the_unified_front_chc" then				-- Do we want to join the Unified Front?
		score = chiTag:GetCountry():GetSurrenderLevel():Get() * 50
		if country:GetRelation(japTag):HasWar() then			-- If we are already fighting Japan, then certainly!
			score = score + 50
		end
		if country:GetRelation(chiTag):HasAlliance() then		-- If we are already in an alliance with China, then make it 'formal'! (Bonus relations!)
			score = score + 25
		end
		if country:GetRelation(chiTag):GetValue():Get() > 100 then	-- Good relations with China
			score = score + 10
		end
		if country:GetRelation(chiTag):GetValue():Get() < 0 then	-- Bad relations with China
			score = score - 25
		end
		if country:GetRelation(japTag):GetThreat():Get() > 30 then	-- Japan is threatening!
			score = score + 10
		end
		if country:GetRelation(japTag):GetThreat():Get() > 50 then	-- Japan is really threatening!
			score = score + 15
		end
		if not csxTag:GetCountry():Exists() then					-- Shanxi is gone!
			score = score + 25
		end
		if not cgxTag:GetCountry():Exists() then					-- Guanxi is gone!
			score = score + 25
		end
		if not cynTag:GetCountry():Exists() then					-- Yunnan is gone!
			score = score + 25
		end
		if not cxbTag:GetCountry():Exists() then					-- The Muslims are gone!
			score = score + 25
		end
	elseif lsDecision == "chc_continues_the_civil_war" then			-- Prepare against the Kuomintang before continuing the Civil War.
		score = 0
		if Support.IsDefeated(ministerTag, japTag) then
			score = Support.PrepareForWarDecision( ministerTag, chiTag, decision, 2.0 )
		end
	end
	
	return score
end

function P.HandlePuppets(minister)

	-- SSmith (22/11/2013)
	-- Add exceptions for Nationalist China, ROC-Nanjing and Tibet

	local laCountryExceptions = { "CHI", "NJG", "TIB" }
	return laCountryExceptions
end

-- Want more troops, let them learn on the battlefield.
--   helps them produce troops faster
function P.CallLaw_training_laws(minister, voCurrentLaw)
	local _MINIMAL_TRAINING_ = 28
	return CLawDataBase.GetLaw(_MINIMAL_TRAINING_)
end

return AI_CHC
