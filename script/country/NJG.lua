-----------------------------------------------------------
-- ROC-Nanjing
-----------------------------------------------------------

local P = {}
AI_NJG = P

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
		
	if lbAtWar then
		local laArray = {
			0.95,	-- Land
			0.05,	-- Air
			0.0,	-- Sea
			0.0};	-- Other
		
		rValue = laArray
	else
		local laArray = {
			0.75,	-- Land
			0.15,	-- Air
			0.0,	-- Sea
			0.10};	-- Other
		
		rValue = laArray	
	end
	
	return rValue
end
-- Land ratio distribution
function P.LandRatio(minister)
	local laArray = {
		1, -- Garrison
		2, -- Infantry
		0, -- Motorized
		0, -- Mechanized
		0, -- Armor
		5, -- Militia
		1}; -- Cavalry
	
	return laArray
end
-- Air ratio distribution
function P.AirRatio(minister)
	local laArray = {
		2, -- Fighter
		0, -- CAS
		1, -- Tactical
		0, -- Naval Bomber
		0}; -- Strategic
	
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

function P.HandlePuppets(minister)

	-- SSmith (22/11/2013)
	-- Add exceptions for Nationalist China, Communist China and Tibet

	local laCountryExceptions = { "CHI", "CHC", "TIB" }
	return laCountryExceptions
end

-- Want more troops, let them learn on the battlefield.
--   helps them produce troops faster
function P.CallLaw_training_laws(minister, voCurrentLaw)
	local _MINIMAL_TRAINING_ = 28
	return CLawDataBase.GetLaw(_MINIMAL_TRAINING_)
end

return AI_NJG 

