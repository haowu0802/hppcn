-----------------------------------------------------------
-- LUA Hearts of Iron 3 Shanxi File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 5/4/2010
-----------------------------------------------------------

local P = {}
AI_CSX = P

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
			0.85, -- Land
			0.15, -- Air
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
	local laArray = {
		1, -- Garrison
		1, -- Infantry
		0, -- Motorized
		0, -- Mechanized
		0, -- Armor
		5, -- Militia
		0}; -- Cavalry

	
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

function P.ForeignMinister_EvaluateDecision(score, agent, decision, scope)
	local lsDecision = tostring(decision:GetKey())
	local liYear = CCurrentGameState.GetCurrentDate():GetYear()
	local liMonth = CCurrentGameState.GetCurrentDate():GetMonthOfYear()
	local liDay = CCurrentGameState.GetCurrentDate():GetDayOfMonth()
	local country = agent:GetCountry()
	local countryTag = country:GetCountryTag()
	local strategy = country:GetStrategy()

	local japTag = CCountryDataBase.GetTag('JAP')
	local chiTag = CCountryDataBase.GetTag('CHI')
	local csxTag = CCountryDataBase.GetTag('CSX')
	local cxbTag = CCountryDataBase.GetTag('CXB')
	local cgxTag = CCountryDataBase.GetTag('CGX')
	local cynTag = CCountryDataBase.GetTag('CYN')
	local chcTag = CCountryDataBase.GetTag('CHC')
	
	if lsDecision == "join_the_unified_front" then				-- Do we want to join the Unified Front?
		score = chiTag:GetCountry():GetSurrenderLevel():Get() * 50
		if country:GetRelation(japTag):HasWar() then			-- If we are already fighting Japan, then certainly!
			score = score + 50
		end
		if country:GetRelation(chiTag):HasAlliance() then		-- If we are already in an alliance with China, then make it 'formal'! (Bonus relations!)
			score = score + 25
		end
		if country:GetRelation(chiTag):GetValue():Get() > 100 then			-- Good relations with China
			score = score + 25
		end
		if country:GetRelation(chiTag):GetValue():Get() < 0 then			-- Bad relations with China
			score = score - 25
		end
		if country:GetRelation(japTag):GetThreat():Get() > 30 then	-- Japan is threatening!
			score = score + 10
		end
		if country:GetRelation(japTag):GetThreat():Get() > 50 then	-- Japan is really threatening!
			score = score + 20
		end
		if not cxbTag:GetCountry():Exists() then					-- Xibei San Ma is gone!
			score = score + 25
		end
		if not cgxTag:GetCountry():Exists() then					-- Guanxi is gone!
			score = score + 25
		end
		if not cynTag:GetCountry():Exists() then					-- Yunnan is gone!
			score = score + 25
		end
		if not chcTag:GetCountry():Exists() then					-- The Commies are gone!
			score = score + 25
		end
	end
	
	return score
end

-- Want more troops, let them learn on the battlefield.
--   helps them produce troops faster
function P.CallLaw_training_laws(minister, voCurrentLaw)
	local _MINIMAL_TRAINING_ = 28
	return CLawDataBase.GetLaw(_MINIMAL_TRAINING_)
end

return AI_CSX 

