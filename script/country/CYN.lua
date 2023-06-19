-----------------------------------------------------------
-- LUA Hearts of Iron 3 Yunnan File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 4/16/2010
-----------------------------------------------------------

local P = {}
AI_CYN = P

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

-- Build Infantry units -> Don't attach support brigades!
function P.Build_Infantry(ic, minister, infantry_brigade, vbGoOver)
	if infantry_brigade >= 3 and ic > 2 then
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

	-- SSmith (02/07/2013)
	-- We no longer need this logic as we will join the Unified Front immediately

	--local lsDecision = tostring(decision:GetKey())
	--local liYear = CCurrentGameState.GetCurrentDate():GetYear()
	--local liMonth = CCurrentGameState.GetCurrentDate():GetMonthOfYear()
	--local liDay = CCurrentGameState.GetCurrentDate():GetDayOfMonth()
	--local country = agent:GetCountry()
	--local countryTag = country:GetCountryTag()
	--local strategy = country:GetStrategy()

	--local japTag = CCountryDataBase.GetTag('JAP')
	--local chiTag = CCountryDataBase.GetTag('CHI')
	--local csxTag = CCountryDataBase.GetTag('CSX')
	--local cxbTag = CCountryDataBase.GetTag('CXB')
	--local cgxTag = CCountryDataBase.GetTag('CGX')
	--local cynTag = CCountryDataBase.GetTag('CYN')
	--local chcTag = CCountryDataBase.GetTag('CHC')
	--local njgTag = CCountryDataBase.GetTag('NJG')
	
	-- SSmith (27/05/2013)
	-- Added a new factor to encourage joining the Unified Front if ROC-Nanjing has been created (but reduce the chance if not)
	-- And also if the Japanese are getting too close

	--if lsDecision == "join_the_unified_front_cyn" then				-- Do we want to join the Unified Front?
	--	score = chiTag:GetCountry():GetSurrenderLevel():Get() * 50
	--	if njgTag:GetCountry():Exists() then				-- ROC-Nanjing has been created!
	--		score = score + 25
	--	else
	--		score = score - 15
	--	end
	--	if country:GetRelation(japTag):HasWar() then			-- If we are already fighting Japan, then certainly!
	--		score = score + 50
	--	end
	--	if country:GetRelation(chiTag):HasAlliance() then		-- If we are already in an alliance with China, then make it 'formal'! (Bonus relations!)
	--		score = score + 25
	--	end
	--	if country:GetRelation(chiTag):GetValue():Get() > 100 then			-- Good relations with China
	--		score = score + 10
	--	end
	--	if country:GetRelation(chiTag):GetValue():Get() < 0 then			-- Bad relations with China
	--		score = score - 25
	--	end
	--	if country:GetRelation(japTag):GetThreat():Get() > 30 then	-- Japan is threatening!
	--		score = score + 10
	--	end
	--	if country:GetRelation(japTag):GetThreat():Get() > 50 then	-- Japan is really threatening!
	--		score = score + 15
	--	end
	--	if not csxTag:GetCountry():Exists() then					-- Shanxi is gone!
	--		score = score + 25
	--	end
	--	if not cxbTag:GetCountry():Exists() then					-- Xibei San Ma is gone!
	--		score = score + 25
	--	end
	--	if not cgxTag:GetCountry():Exists() then					-- Guanxi is gone!
	--		score = score + 25
	--	end
	--	if not chcTag:GetCountry():Exists() then					-- The Commies are gone!
	--		score = score + 25
	--	end
	--	if CCurrentGameState.GetProvince(9478):GetController() == japTag		-- Chongqing
	--	or CCurrentGameState.GetProvince(7520):GetController() == japTag		-- Changsha
	--	or CCurrentGameState.GetProvince(5834):GetController() == japTag then		-- Guangzhou
	--		score = score + 25
	--	end
	--end
	
	return score
end

--function P.DiploScore_Alliance( score, ai, actor, recipient, observer, action)

	-- SSmith (02/07/2013)
	-- Function added (but wouldn't be called because of neutrality)
	-- If we have joined the Unified Front then we will accept alliances with China

	--if not observer:GetCountry():IsSubject() then 
	--	if tostring(actor) == 'CHI' then
	--		if recipient:GetCountry():GetFlags():IsFlagSet("unified_front") then
	--			return 100
	--		end
	--	end
	--end

	--return score
--end

function P.DiploScore_CallAlly(liScore, ai, actor, recipient, observer)

	-- SSmith (02/07/2013)
	-- Function added to control Yunnan's response to a Chinese call to arms

	if observer == recipient and tostring(actor) == "CHI" then
		local japTag = CCountryDataBase.GetTag('JAP')
		local njgTag = CCountryDataBase.GetTag('NJG')

		if actor:GetCountry():GetRelation(japTag):HasWar()		-- China is at war with Japan
		and actor:GetCountry():GetSurrenderLevel():Get() < 0.65		-- China has a moderate Surrender Progress
		and not njgTag:GetCountry():Exists()				-- ROC-Nanjing hasn't been created
		then
			liScore = 0
		else
			liScore = 100
		end
	end
	
	return liScore
end


-- Want more troops, let them learn on the battlefield.
--   helps them produce troops faster
function P.CallLaw_training_laws(minister, voCurrentLaw)
	local _MINIMAL_TRAINING_ = 28
	return CLawDataBase.GetLaw(_MINIMAL_TRAINING_)
end

return AI_CYN 

