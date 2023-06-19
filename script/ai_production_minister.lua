-- ######################
-- Default parameters for countries 
-- ######################

-- Countries Default build weights for land based only

-- SSmith (25/05/2013)
-- This will now be the default logic for all countries that don't have custom AI functions

local DefaultProdLand = {}

function DefaultProdLand.ProductionWeights( minister )

	if ( not Utils.ASSERT( minister ) )
	then
		return {}
	end

	local laArray
	local ministerCountry = minister:GetCountry()
	local totalIC = ministerCountry:GetTotalIC()
	--local numOfPorts = ministerCountry:GetNumOfPorts()

	-- SSmith (25/05/2013)
	-- The number of ports check is superfluous
	-- But we do need more categories
	
	if totalIC < 10 then		-- We are a minor!
		if ministerCountry:IsAtWar() then
			laArray = {
				0.75, 	-- Land
				0.00, 	-- Air
				0.10, 	-- Sea
				0.15}; 	-- Other
		else
			laArray = {
				0.60, 	-- Land
				0.00, 	-- Air
				0.10, 	-- Sea
				0.30}; 	-- Other
		end
	elseif totalIC < 30 then	-- We are a developed nation!
		if ministerCountry:IsAtWar() then
			laArray = {
				0.60, 	-- Land
				0.20, 	-- Air
				0.10, 	-- Sea
				0.10}; 	-- Other
		else
			laArray = {
				0.55, 	-- Land
				0.20, 	-- Air
				0.10, 	-- Sea
				0.15}; 	-- Other
		end
	elseif totalIC < 100 then	-- We are a medium power!
		if ministerCountry:IsAtWar() then
			laArray = {
				0.55, 	-- Land
				0.20, 	-- Air
				0.15, 	-- Sea
				0.10}; 	-- Other
		else
			laArray = {
				0.50, 	-- Land
				0.20, 	-- Air
				0.15, 	-- Sea
				0.15}; 	-- Other
		end
	else				-- We are a major power!
		if ministerCountry:IsAtWar() then
			laArray = {
				0.55, 	-- Land
				0.20, 	-- Air
				0.15, 	-- Sea
				0.10}; 	-- Other
		else
			laArray = {
				0.50, 	-- Land
				0.20, 	-- Air
				0.15, 	-- Sea
				0.15}; 	-- Other
		end
	end
	
	return laArray
end
-- Land ratio distribution

function DefaultProdLand.LandRatio( minister )

	if ( not Utils.ASSERT( minister ) )
	then
		return {}
	end

	local ministerCountry = minister:GetCountry()
	local totalIC = ministerCountry:GetTotalIC()
	local laArray
	
	-- SSmith (03/07/2013)
	-- We need more categories to balance this
	-- And we will cut down the militia spam!

	if totalIC < 10 then	-- We are a minor.
		if ministerCountry:IsAtWar() then
			laArray = {
				2, -- Garrison
				15, -- Infantry
				0, -- Motorized
				0, -- Mechanized
				0, -- Armor
				4, -- Militia
				4}; -- Cavalry
		else
			laArray = {
				4, -- Garrison
				17, -- Infantry
				0, -- Motorized
				0, -- Mechanized
				0, -- Armor
				0, -- Militia
				4}; -- Cavalry
		end
	elseif totalIC < 30 then	-- We are a developed nation!
		if ministerCountry:IsAtWar() then
			laArray = {
				2, -- Garrison
				17, -- Infantry
				2, -- Motorized
				0, -- Mechanized
				0, -- Armor
				0, -- Militia
				4}; -- Cavalry
		else
			laArray = {
				4, -- Garrison
				15, -- Infantry
				2, -- Motorized
				0, -- Mechanized
				0, -- Armor
				0, -- Militia
				4}; -- Cavalry
		end
	elseif totalIC < 100 then	-- We are a medium power!
		if ministerCountry:IsAtWar() then
			laArray = {
				2, -- Garrison
				15, -- Infantry
				3, -- Motorized
				0, -- Mechanized
				2, -- Armor
				0, -- Militia
				3}; -- Cavalry
		else
			laArray = {
				4, -- Garrison
				13, -- Infantry
				3, -- Motorized
				0, -- Mechanized
				2, -- Armor
				0, -- Militia
				3}; -- Cavalry
		end
	else				-- We are a major power!
		if ministerCountry:IsAtWar() then
			laArray = {
				2, -- Garrison
				14, -- Infantry
				4, -- Motorized
				2, -- Mechanized
				3, -- Armor
				0, -- Militia
				0}; -- Cavalry
		else
			laArray = {
				3, -- Garrison
				12, -- Infantry
				4, -- Motorized
				2, -- Mechanized
				2, -- Armor
				0, -- Militia
				2}; -- Cavalry
		end
	end
	
	return laArray
end
-- Special Forces ratio distribution

function DefaultProdLand.SpecialForcesRatio( minister )

	if ( not Utils.ASSERT( minister ) )
	then
		return {}
	end

	-- SSmith (08/06/2013)
	-- This will now return separate ratios for mountain, marine and airborne brigades

	local laArray = {
		20, -- Mountain
		25, -- Marine
		30}; -- Airborne
	
	return laArray
end
-- Air ratio distribution

function DefaultProdLand.AirRatio( minister )

	if ( not Utils.ASSERT( minister ) )
	then
		return {}
	end

	-- SSmith (25/05/2013)
	-- We need default air ratios to reflect the country's IC

	local laArray
	local ministerCountry = minister:GetCountry()
	local totalIC = ministerCountry:GetTotalIC()

	if totalIC < 30 then		-- We are a developed nation!
		laArray = {
			16, -- Fighter
			9, -- CAS
			0, -- Tactical
			0, -- Naval Bomber
			0}; -- Strategic
	elseif totalIC < 100 then	-- we are a medium power!
		laArray = {
			12, -- Fighter
			6, -- CAS
			5, -- Tactical
			2, -- Naval Bomber
			0}; -- Strategic
	else				-- We are a major power!
		laArray = {
			11, -- Fighter
			5, -- CAS
			5, -- Tactical
			2, -- Naval Bomber
			2}; -- Strategic
	end

	return laArray
end
-- Flying Bomb/Rocket distribution against total Air Power

function DefaultProdLand.RocketRatio( minister )

	if ( not Utils.ASSERT( minister ) )
	then
		return {}
	end

	local laArray = {
		10, -- Air
		1}; -- Bomb/Rockety
	
	return laArray
end

-- Naval ratio distribution
function DefaultProdLand.NavalRatio( minister )

	if ( not Utils.ASSERT( minister ) )
	then
		return {}
	end

	-- SSmith (25/05/2013)
	-- We need to define the ratios better

	local laArray
	local ministerCountry = minister:GetCountry()
	local totalIC = ministerCountry:GetTotalIC()
	
	if totalIC < 10 then		-- We are minor power!
		laArray = {
			0, -- Destroyers
			0, -- Submarines
			0, -- Cruisers
			0, -- Capitals
			0, -- Escort Carriers
			0}; -- Carriers
	elseif totalIC < 20 then	-- We are a developed nation!
		laArray = {
			18, -- Destroyers
			7, -- Submarines
			0, -- Cruisers
			0, -- Capitals
			0, -- Escort Carriers
			0}; -- Carriers
	elseif totalIC < 30 then	-- We are a larger developed nation!
		laArray = {
			15, -- Destroyers
			5, -- Submarines
			5, -- Cruisers
			0, -- Capitals
			0, -- Escort Carriers
			0}; -- Carriers
	elseif totalIC < 50 then	-- We are a medium power!
		laArray = {
			13, -- Destroyers
			5, -- Submarines
			7, -- Cruisers
			0, -- Capitals
			0, -- Escort Carriers
			0}; -- Carriers
	elseif totalIC < 100 then	-- We are a larger medium power!
		if CCurrentGameState.GetCurrentDate():GetYear() < 1942 then
			laArray = {
				13, -- Destroyers
				4, -- Submarines
				8, -- Cruisers
				0, -- Capitals
				0, -- Escort Carriers
				0}; -- Carriers
		else
			laArray = {
				13, -- Destroyers
				3, -- Submarines
				8, -- Cruisers
				0, -- Capitals
				1, -- Escort Carriers
				0}; -- Carriers
		end
	else				-- We are a major power!
		if CCurrentGameState.GetCurrentDate():GetYear() < 1942 then
			laArray = {
				11, -- Destroyers
				4, -- Submarines
				8, -- Cruisers
				2, -- Capitals
				0, -- Escort Carriers
				0}; -- Carriers
		else
			laArray = {
				11, -- Destroyers
				4, -- Submarines
				8, -- Cruisers
				0, -- Capitals
				1, -- Escort Carriers
				1}; -- Carriers
		end
	end
	return laArray
end

function DefaultProdLand.TransportLandRatio( minister )

	if ( not Utils.ASSERT( minister ) )
	then
		return {}
	end

	-- SSmith (25/05/2013)
	-- We need a ratio here

	local laArray = {
		20, -- Land
		1}; -- Transport
	
	return laArray
end



-- ######################
-- END OF Default parameters for countries 
-- ######################

-- ######################
-- Global Variables
--    CAREFUL: Variables are remembered from country to country
-- ######################
local laUnitNeeds -- Gets reset each time the tick starts
local lbBuiltRocketSite -- Gets reset each time the tick starts

local _GARRISON_BRIGADE_ = 1
local _MILITIA_BRIGADE_ = 2

-- SSmith (19/05/2013)
-- I am switching cavalry and infantry round because I don't want cavalry grouping in the infantry count!

local _CAVALRY_BRIGADE_ = 3
local _INFANTRY_BRIGADE_ = 4
local _BERGSJAEGER_BRIGADE_ = 5
local _MARINE_BRIGADE_ = 6
local _PARATROOPER_BRIGADE_ = 7

local _LIGHT_ARMOR_BRIGADE_ = 8
local _ARMOR_BRIGADE_ = 9
local _HEAVY_ARMOR_BRIGADE_ = 10
local _SUPER_HEAVY_ARMOR_BRIGADE_ = 11

local _MECHANIZED_BRIGADE_ = 12

local _MOTORIZED_BRIGADE_ = 13

local _BATTLECRUISER_ = 14
local _BATTLESHIP_ = 15
local _CARRIER_ = 16
local _DESTROYER_ = 17
local _ESCORT_CARRIER_ = 18
local _LIGHT_CRUISER_ = 19
local _HEAVY_CRUISER_ = 20
local _SUBMARINE_ = 21
local _TRANSPORT_SHIP_ = 22

local _CAG_ = 23
local _CAS_ = 24
local _INTERCEPTOR_ = 25
local _MULTI_ROLE_ = 26
local _ROCKET_INTERCEPTOR_ = 27
local _NAVAL_BOMBER_ = 28
local _STRATEGIC_BOMBER_ = 29
local _TACTICAL_BOMBER_ = 30
local _TRANSPORT_PLANE_ = 31
local _FLYING_BOMB_ = 32
local _FLYING_ROCKET_ = 33

local _ENGINEER_BRIGADE_ = 34
local _TANK_DESTROYER_BRIGADE_ = 35

local _HQ_BRIGADE_ = 36
local _PARTISAN_BRIGADE_ = 37

-- ###################################
-- # Main Method called by the EXE
-- #####################################
function ProductionMinister_Tick( minister )
	ManageProduction( minister )
end

-- ###################################
-- # Main Method for sliders, called by the EXE
-- #####################################
function BalanceProductionSliders(ai, ministerCountry, OrigPrio, vLendLease, vConsumer, vProduction, vSupply, vReinforce, vUpgrade, ReinforceBonus)

	if ( not Utils.ASSERT( ai ) )
	or ( not Utils.ASSERT( ministerCountry ) )
	or ( not Utils.ASSERT( OrigPrio ) )
	or ( not Utils.ASSERT( vLendLease ) )
	or ( not Utils.ASSERT( vConsumer ) )
	or ( not Utils.ASSERT( vProduction ) )
	or ( not Utils.ASSERT( vSupply ) )
	or ( not Utils.ASSERT( vReinforce ) )
	or ( not Utils.ASSERT( vUpgrade ) )
	or ( not Utils.ASSERT( ReinforceBonus ) )
	then
		return nil
	end
	
	-- SSmith (14/06/2013)
	-- This function struggles to balance priorities when the economy is over-committed
	-- So it's time for a re-write!

	-- Note the AI-assist priorities are...
	-- 1. Production
	-- 2. Upgrades
	-- 3. Reinforcement

	local tagString = "XXX"
	--local dd = CCurrentGameState.GetCurrentDate():GetDayOfMonth() + 1
	--if dd == 1 then
	--	tagString = "GER"
	--elseif dd == 2 then
	--	tagString = "ITA"
	--elseif dd == 3 then
	--	tagString = "ENG"
	--elseif dd == 4 then
	--	tagString = "FRA"
	--elseif dd == 5 then
	--	tagString = "SOV"
	--elseif dd == 6 then
	--	tagString = "USA"
	--elseif dd == 7 then
	--	tagString = "JAP"
	--elseif dd == 8 then
	--	tagString = "CHI"
	--end

	if tostring( ministerCountry:GetCountryTag() ) == tagString then
		Utils.LUA_DEBUGOUT( " " )
		Utils.LUA_DEBUGOUT( tagString .. " Sliders..." )
		Utils.LUA_DEBUGOUT( "OrigPrio: " .. tostring(OrigPrio))
		Utils.LUA_DEBUGOUT( "vUpgrade: " .. tostring(vUpgrade))
		Utils.LUA_DEBUGOUT( "vReinforce: " .. tostring(vReinforce))
		Utils.LUA_DEBUGOUT( "vSupply: " .. tostring(vSupply))
		Utils.LUA_DEBUGOUT( "vProduction: " .. tostring(vProduction))
		Utils.LUA_DEBUGOUT( "vConsumer: " .. tostring(vConsumer))
		Utils.LUA_DEBUGOUT( "vLendLease: " .. tostring(vLendLease))
		Utils.LUA_DEBUGOUT( "ReinforceBonus: " .. tostring(ReinforceBonus))
	end

	-- SSmith (14/06/2013)
	-- The priority will now be expressed as a decimal value
	-- Anything with priority 1.00 will never face cuts
	-- Lower priorities will be cut back if the IC is over-committed

	local ministerTag = ministerCountry:GetCountryTag()

	-- Set the default priorities

	local vUpgradePrio = 0.75	-- Upgrades are more important that current production but can be cut back!
	local vReinforcePrio = 0.45	-- Reinforcements are not important during peace-time!
	local vSupplyPrio = 0.90	-- Supply is important but can be curtailed in an emergency!
	local vProductionPrio = 0.60	-- Production is desirable but can be cut back sharply if necessary!
	local vConsumerPrio = 1.00	-- Consumer goods is an imperative because dissent must be handled!
	local vLendLeasePrio = 0.60	-- I will worry about Lend-Lease when I code for it!

	-- Reinforcements are very important if we are at war!
	-- A bit less so if we are at peace but mobilized...

	if ministerCountry:IsAtWar() then
		vReinforcePrio = 0.90
	elseif ministerCountry:IsMobilized() then
		vReinforcePrio = 0.75
	end

	-- The requirement for production will be zero if there is nothing in the queue
	-- So we will always put in a request for at least 50%
	-- And to make sure we bid for our share of the cake we will add 25% to our current needs!

	if not (OrigPrio == 1) then
		vProduction = math.max(0.50, (vProduction + 0.25))
	end

	-- There are country-specific limits for reinforcements and upgrades
	-- We will apply them now (but only under full AI control)

	if OrigPrio == 0 then

		-- SSmith (15/06/2013)
		-- The requirement should be multiplied by the country AI functions!

		if Utils.HasCountryAIFunction(ministerTag, "MaxReinforcements") then
			vReinforce = vReinforce * Utils.CallCountryAI(ministerTag, "MaxReinforcements", ministerTag)
		end
		if Utils.HasCountryAIFunction(ministerTag, "MaxUpgrade") then
			vUpgrade = vUpgrade * Utils.CallCountryAI(ministerTag, "MaxUpgrade", ministerTag)
		end
	end

	-- Set the chosen priority if we are not under full AI control
	-- But always give priority to reinforcements if we are mobilizing!
	
	if ReinforceBonus then
		vReinforcePrio = 1.00
	end
	if OrigPrio == 1 then			-- Production
		vProductionPrio = 1.00
	elseif OrigPrio == 2 then		-- Upgrades
		vUpgradePrio = 1.00
	elseif OrigPrio == 3 then		-- Reinforcement
		vReinforcePrio = 1.00
	end

	-- The consumer goods demand is a minimum
	-- If dissent is present add 10% to the production of consumer goods
	local vDissent = ministerCountry:GetDissent():Get()

	if tostring( ministerTag ) == tagString then
		Utils.LUA_DEBUGOUT("Dissent: " .. tostring(vDissent))
	end

	if vDissent > 0.0001 then

		-- SSmith (15/06/2013)
		-- This calculation wrongly assumed dissent was a decimal so the response always maxed out!

		-- plus 5% for any dissent, increasing 1% per 0.1 dissent point to a max of 25%
		vConsumer = vConsumer + math.min( (vDissent / 10) + 0.05, 0.25 )
	end
	if vConsumer > 1.00 then
		vConsumer = 1.00
	end

	-- The supply demand is a target
	-- We will plan on spending more or less depending on our current stockpile

	-- SSmith (29/06/2013)
	-- There is a bug where the AI can think it needs no supplies because it thinks it is trading for them!!
	-- To fix this we will set a minimum IC contribution if the supply stockpile is running low
	
	local supplyStockpile = ministerCountry:GetPool():Get( CGoodsPool._SUPPLIES_ ):Get()
	local supplyPreference = Support.GetEffectiveResourceLimit( ministerCountry, CGoodsPool._SUPPLIES_ )
	
	if tostring( ministerTag ) == tagString then
		Utils.LUA_DEBUGOUT( "Supply..." )
		Utils.LUA_DEBUGOUT( "supplyStockpile: " .. tostring ( supplyStockpile ) )
		Utils.LUA_DEBUGOUT( "supplyPreference: " .. tostring ( supplyPreference ) )
		Utils.LUA_DEBUGOUT( "Supply (before): " .. tostring (vSupply) )
	end

	-- We will scale the supply demand based on the ratio between the current stockpile and our target
		
	local vRatio = supplyStockpile / supplyPreference
	local vMinSupply = math.max(0, (0.5 - vRatio))
	if vRatio < 1 then
		vRatio = 1 + ((1 - vRatio) * 0.5)
	else
		vRatio = math.max(0, (2 - vRatio))
	end
	vSupply = math.max(vMinSupply, (vSupply * vRatio))
	
	if tostring( ministerTag ) == tagString then
		Utils.LUA_DEBUGOUT( "Min Supply: " .. tostring (vMinSupply) )
		Utils.LUA_DEBUGOUT( "Supply (after): " .. tostring (vSupply) )
	end

	-- SSmith (14/06/2013)
	-- I will comment out the Lend-Lease handling until I'm ready for it

	-- Lend-Lease priority, if not using full auto we let player set this slider completely
	--if (OrigPrio == 0) then
	--	if ministerCountry:HasActiveLendLeaseToAnyone() then 
	--		local liMaxGivenLL = 0.3
	--		if lbAtWar then
	--			if ministerTag == CCountryDataBase.GetTag("USA") then
	--				if vManpower < 50 then
	--					liMaxGivenLL = 0.5
	--				elseif vManpower < 100 then
	--					liMaxGivenLL = 0.4
	--				end
	--			else
	--				liMaxGivenLL = 0.1
	--			end
	--		end
	--		local liPreferredLL = ministerCountry:GetMaxLendLeaseFraction():Get() * liMaxGivenLL
	--		if vLendLease == 0 then
	--			vLendLease = liPreferredLL
	--		elseif vLendLease < liPreferredLL * 0.95 then
	--			vLendLease = vLendLease * 1.05
	--		elseif vLendLease > liPreferredLL then
	--			vLendLease = vLendLease * 0.95
	--		end
	--	else
	--		vLendLease = 0
	--	end
	--end

	-- Reinforcement requires manpower
	-- Production requires manpower and officers
	-- If these are lacking then we should scale back our priority
	-- But only if those sliders are under AI control
	-- And we will still try to reinforce if we are mobilizing

	local vManpower = ministerCountry:GetManpower():Get()

	-- SSmith (10/09/2013)
	-- The manpower check now returns two values (we want the first)

	local vEnoughManpower = Support.HasEnoughManpower(ministerTag)[1]
	local vOfficers = ministerCountry:GetOfficerRatio():Get()
	local vTotalIC = ministerCountry:GetTotalIC()

	if not OrigPrio == 3 then
		if not vEnoughManpower then
			if ReinforceBonus then			-- We are supposed to be reinforcing!
				if vManpower < 1 then		-- But we have got no manpower so spending is futile!
					vReinforcePrio = 0.05
					vReinforce = 0.05
				end
			elseif vManpower > vTotalIC then
				vReinforcePrio = math.min(vReinforcePrio, 0.75)
			elseif vManpower > (vTotalIC * 0.25) then
				vReinforcePrio = math.min(vReinforcePrio, 0.50)
			elseif vManpower > (vTotalIC * 0.10) then
				vReinforcePrio = 0.25
			else
				vReinforcePrio = 0.05
				vReinforce = 0.05		-- We have got no manpower so spending is futile even if we can
			end
		end
	end

	if not OrigPrio == 1 then
		if not vEnoughManpower or vOfficers < 0.75 then
			if vEnoughManpower then
				vProductionPrio = 0.40
			elseif vManpower > vTotalIC then
				vProductionPrio = 0.30
			elseif vManpower > (vTotalIC * 0.25) then
				vProductionPrio = 0.20
			elseif vManpower > (vTotalIC * 0.10) then
				vProductionPrio = 0.10
			else
				vProductionPrio = 0.05
			end
		end
	end

	-- If there is an AI assist in use then this is an absolute priority after consumer goods
	-- So we must honour it if we can!

	local vSpare = math.max(0, (1 - vConsumer))
	if OrigPrio == 1 then		-- Production
		vProduction = math.min(vProduction, vSpare)
		vSpare = vSpare - vProduction
	elseif OrigPrio == 2 then	-- Upgrades
		vUpgrade = math.min(vUpgrade, vSpare)
		vSpare = vSpare - vUpgrade
	elseif OrigPrio == 3 then	-- Reinforcement
		vReinforce = math.min(vReinforce, vSpare)
	end

	-- Now give absolute priority to reinforcements if we are mobilizing

	if ReinforceBonus and not (OrigPrio == 3) then
		vReinforce = math.min(vReinforce, vSpare)
	end

	if tostring( ministerTag ) == tagString then
		Utils.LUA_DEBUGOUT( "Setup..." )
		Utils.LUA_DEBUGOUT( "Upgrade: " .. tostring(vUpgrade))
		Utils.LUA_DEBUGOUT( "Reinforce: " .. tostring(vReinforce))
		Utils.LUA_DEBUGOUT( "Supply: " .. tostring(vSupply))
		Utils.LUA_DEBUGOUT( "Production: " .. tostring(vProduction))
		Utils.LUA_DEBUGOUT( "Consumer: " .. tostring(vConsumer))
		Utils.LUA_DEBUGOUT( "LendLease: " .. tostring(vLendLease))
	end

	-- All production demands are now calculated and all priorities are set
	-- Now we can work out how to allocate the IC we have available

	local vTotalNeeded = vLendLease + vConsumer + vSupply + vReinforce + vProduction + vUpgrade

	-- I need to make sure the code exits this loop! (which could be a problem because of rounding issues...)
	-- In theory it should only be necessary to make 5 passes anyway...

	local vEscape = false
	local vLoops = 0

	while vTotalNeeded > 1.00 and not vEscape and vLoops < 5 do

		-- Calculate how much excess demand we need to cut

		local vExcess = vTotalNeeded - 1.00

		-- Find the total amount we can cut based on the priorities
		-- Then calculate the multiplier required to achieve the necessary savings

		local vReduction = (vLendLease * (1 - vLendLeasePrio)) + (vSupply * (1 - vSupplyPrio)) + (vReinforce * (1 - vReinforcePrio))
		vReduction = vReduction + (vProduction * (1 - vProductionPrio)) + (vUpgrade * (1 - vUpgradePrio))
		local vMultiplier = vExcess / vReduction

		if tostring( ministerTag ) == tagString then
			Utils.LUA_DEBUGOUT("Excess: " .. tostring(vExcess))
			Utils.LUA_DEBUGOUT("Reduction: " .. tostring(vReduction))
			Utils.LUA_DEBUGOUT("Multiplier: " .. tostring(vMultiplier))
		end

		-- Apply the cuts to each category

		vLendLease = math.max(0, (vLendLease - (vMultiplier * (vLendLease * (1 - vLendLeasePrio)))))
		vSupply = math.max(0, (vSupply - (vMultiplier * (vSupply * (1 - vSupplyPrio)))))
		if vReinforcePrio < 1.00 then
			vReinforce = math.max(0, (vReinforce - (vMultiplier * (vReinforce * (1 - vReinforcePrio)))))
		end
		if vProductionPrio < 1.00 then
			vProduction = math.max(0, (vProduction - (vMultiplier * (vProduction * (1 - vProductionPrio)))))
		end
		if vUpgradePrio < 1.00 then
			vUpgrade = math.max(0, (vUpgrade - (vMultiplier * (vUpgrade * (1 - vUpgradePrio)))))
		end

		if tostring( ministerTag ) == tagString then
			Utils.LUA_DEBUGOUT( "Loop..." )
			Utils.LUA_DEBUGOUT( "Upgrade: " .. tostring(vUpgrade))
			Utils.LUA_DEBUGOUT( "Reinforce: " .. tostring(vReinforce))
			Utils.LUA_DEBUGOUT( "Supply: " .. tostring(vSupply))
			Utils.LUA_DEBUGOUT( "Production: " .. tostring(vProduction))
			Utils.LUA_DEBUGOUT( "Consumer: " .. tostring(vConsumer))
			Utils.LUA_DEBUGOUT( "LendLease: " .. tostring(vLendLease))
		end

		vTotalNeeded = vLendLease + vConsumer + vSupply + vReinforce + vProduction + vUpgrade

		if vTotalNeeded < 1.01 then

			-- Most of the work is done so this is here to round things off and exit the loop!

			if vLendLease > 0.01 then
				vLendLease = vLendLease + 1 - vTotalNeeded
			elseif vProduction > 0.01 and vProductionPrio < 1.00 then
				vProduction = vProduction + 1 - vTotalNeeded
			elseif vSupply > 0.01 then
				vSupply = vSupply + 1 - vTotalNeeded
			elseif vUpgrade > 0.01 and vUpgradePrio < 1.00 then
				vUpgrade = vUpgrade + 1 - vTotalNeeded
			elseif vReinforce > 0.01 and vReinforcePrio < 1.00 then
				vReinforce = vReinforce + 1 - vTotalNeeded
			end
			vEscape = true
		end

		-- We should only need 5 loops before everything has been cut that can be cut

		vLoops = vLoops + 1
	end

	-- If there is any surplus capacity we will give it to production

	if (vTotalNeeded < 1) then
		vProduction = vProduction + (1 - vTotalNeeded)
	end

	if tostring( ministerTag ) == tagString then
		Utils.LUA_DEBUGOUT( "Output..." )
		Utils.LUA_DEBUGOUT( "Upgrade: " .. tostring(vUpgrade))
		Utils.LUA_DEBUGOUT( "Reinforce: " .. tostring(vReinforce))
		Utils.LUA_DEBUGOUT( "Supply: " .. tostring(vSupply))
		Utils.LUA_DEBUGOUT( "Production: " .. tostring(vProduction))
		Utils.LUA_DEBUGOUT( "Consumer: " .. tostring(vConsumer))
		Utils.LUA_DEBUGOUT( "LendLease: " .. tostring(vLendLease))
	end
	
	local command = CChangeInvestmentCommand( ministerTag, vLendLease, vConsumer, vProduction, vSupply, vReinforce, vUpgrade )
	ai:Post( command )
end

-- ###################################
-- # Main Method for Lend Lease, called by the EXE
-- #####################################
function BalanceLendLeaseSliders(ai, ministerCountry, countryTags, values)

	-- This distributes the lendlease amount between countries, or something like that!

	if ( not Utils.ASSERT( ai ) )
	or ( not Utils.ASSERT( ministerCountry ) )
	or ( not Utils.ASSERT( countryTags ) )
	or ( not Utils.ASSERT( values ) )
	then
		return nil
	end
	
	local ministerTag = ministerCountry:GetCountryTag()
	
	-- Country specific settings
	if Utils.HasCountryAIFunction(ministerTag, "BalanceLendLeaseSliders") then
		Utils.CallCountryAI(ministerTag, "BalanceLendLeaseSliders", ai, ministerCountry, countryTags, values)
	else
		
		-- Not sure what this is achieving, it just seems to get the total IC for all countries
		-- and return those values to the main game, but I guess its needed!
		for i=0, countryTags:GetSize()-1 do
    		local ToTag = countryTags:GetAt(i)
    		values:SetAt( i, CFixedPoint( ToTag:GetCountry():GetTotalIC() ) )
  		end

		-- Do this to confirm LL sliders distribution
		local command = CChangeLendLeaseDistributionCommand( ministerTag )
		command:SetData( countryTags, values )
		ai:Post( command )
	end
end

-- Main method for doing production, all other methods are called from this one.
function ManageProduction( minister )
	-- Reset Arrays since global variables are remembered from country to country
	local prodArrayCounts = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
	local currentArrayCounts = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
	--local theaterArrayCounts = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
	laUnitNeeds = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
	lbBuiltRocketSite = false
	
	-- SSmith (18/05/2013)
	-- The production logic is producing some seriously bad outcomes
	-- It needs some fundamental re-working!
	-- What I don't want is going to be stripped out to try to keep this tidy!
	-- However for necessity I'm going to be putting in a lot of logging to see what's going on!

	local ministerTag = minister:GetCountryTag()
	local ministerCountry = minister:GetCountry()
	local icProdAllocated = ministerCountry:GetICPart( CDistributionSetting._PRODUCTION_PRODUCTION_ ):Get()
	local ai = minister:GetOwnerAI()	
	local ic = icProdAllocated - ministerCountry:GetUsedIC():Get()
	local totalIC = ministerCountry:GetTotalIC()
	
	local ministerTagString = tostring(ministerTag)
	--Utils.LUA_DEBUGOUT("")
	--Utils.LUA_DEBUGOUT("ManageProduction starting: " .. ministerTagString)

	local tagString = "XXX"
	if ministerTagString == tagString then
		--Utils.LUA_DEBUGOUT("")
		--Utils.LUA_DEBUGOUT("ManageProduction: " .. tagString)
		Utils.LUA_DEBUGOUT("icProdAllocated: " .. tostring(icProdAllocated))
		Utils.LUA_DEBUGOUT("ic: " .. tostring(ic))
		Utils.LUA_DEBUGOUT("totalIC: " .. tostring(totalIC))
	end

	-- Performance check
	--   if no IC just exit completely so no objects get created
	if ic <= 0.2 then
		return
	end
	
	-- First build Convoys and Escorts!

	if ministerTagString == tagString then
		Utils.LUA_DEBUGOUT("Building convoys...")
	end
	
	local icForConvoys = ic * 0.2	-- Only build Convoys and Escorts from 20% of the available IC
	ic = ic - icForConvoys		-- Subtract the amount we would like to spend on Convoys
	-- Build what we need
	icForConvoys = ConstructConvoys(ai, minister, ministerTag, ministerCountry, icForConvoys )
	ic = ic + icForConvoys		-- Add back what we didn't spend on Convoys
	
	if ministerTagString == tagString then
		Utils.LUA_DEBUGOUT("ic: " .. tostring(ic))
	end

	-- SSmith (18/05/2013)
	-- We will set some booleans for unit availability which we will need later
	-- This is also a good point to implement the naval treaties

	local techStatus = ministerCountry:GetTechnologyStatus()

	local lbMilitia = techStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("militia_brigade"))
	local lbGarrison = techStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("garrison_brigade"))
	local lbInfantry = techStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("infantry_brigade"))
	local lbMountain = techStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("bergsjaeger_brigade"))

	-- SSmith (08/06/2013)
	-- For marines/paratroopers we must have a port/airfield!

	local lbMarine = techStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("marine_brigade"))
	if ministerCountry:GetNumOfPorts() < 1 then
		lbMarine = false
	end
	local lbAirborne = techStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("paratrooper_brigade"))
	if ministerCountry:GetNumOfAirfields() < 1 then
		lbAirborne = false
	end
	local lbCavalry = techStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("cavalry_brigade"))
	local lbMotorized = techStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("motorized_brigade"))
	local lbMechanized = techStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("mechanized_brigade"))

	local lbLightArmour = techStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("light_armor_brigade"))
	local lbArmour = techStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("armor_brigade"))
	local lbHeavyArmour = techStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("heavy_armor_brigade"))
	local lbIST = techStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("super_heavy_armor_brigade"))
	
	local lbLightFighter = techStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("interceptor"))
	local lbHeavyFighter = techStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("multi_role"))
	local lbLightBomber = techStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("cas"))
	local lbCAG = techStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("cag"))
	local lbMediumBomber = techStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("tactical_bomber"))
	local lbPatrolBomber = techStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("naval_bomber"))
	local lbHeavyBomber = techStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("strategic_bomber"))
	local lbAirTransport = techStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("transport_plane"))

	local lbRocketInterceptor = techStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("rocket_interceptor"))
	local lbFlyingBomb = techStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("flying_bomb"))
	local lbFlyingRocket = techStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("flying_rocket"))
	
	local lbBattleship = techStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("battleship"))
	local lbBattlecruiser = techStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("battlecruiser"))
	local lbCarrier = techStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("carrier"))
	local lbLightCarrier = techStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("escort_carrier"))
	local lbHeavyCruiser = techStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("heavy_cruiser"))
	local lbLightCruiser = techStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("light_cruiser"))
	local lbDestroyer = techStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("destroyer"))
	local lbSubmarine = techStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("submarine"))
	local lbTransport = techStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("transport_ship"))

	-- SSmith (04/06/2013)
	-- The escalator clause now allows new ship construction
	-- However we want the AI to behave fairly historically
	-- So I'm allowing the UK and USA to build carriers from 1937 and battleships from 1939
	-- Heavy Cruisers will continue to be prohibited	

	if ministerCountry:GetFlags():IsFlagSet("washington_treaty")
	or ministerCountry:GetFlags():IsFlagSet("london_treaty")
	or ministerCountry:GetFlags():IsFlagSet("second_london_treaty")
	or ministerCountry:GetFlags():IsFlagSet("escalator_clause_invoked") then

		-- We are a treaty signatory

		lbHeavyCruiser = false
		if ministerCountry:GetFlags():IsFlagSet("escalator_clause_invoked") then

			-- The escalator clause has been invoked (new construction permitted)

			if ministerTagString == "ENG" or ministerTagString == "USA" then

				-- Special restrictions for the UK and USA

				if CCurrentGameState.GetCurrentDate():GetYear() < 1939 then
					lbBattleship = false
					lbBattlecruiser = false
					--if CCurrentGameState.GetCurrentDate():GetYear() > 1937 then
					--	lbCarrier = false
					--	lbLightCarrier = false
					--end
				end
			end
		else

			-- Otherwise ship construction is prohibited

			lbBattleship = false
			lbBattlecruiser = false
			lbCarrier = false
			lbLightCarrier = false
		end
	end

	-- Check we can build CAGs
	if not lbCAG then
		lbCarrier = false
		lbLightCarrier = false
	end

	if ministerTagString == tagString then
		Utils.LUA_DEBUGOUT("Technology...")
		Utils.LUA_DEBUGOUT("Militia: " .. tostring(lbMilitia))
		Utils.LUA_DEBUGOUT("Garrison: " .. tostring(lbGarrison))
		Utils.LUA_DEBUGOUT("Infantry: " .. tostring(lbInfantry))
		Utils.LUA_DEBUGOUT("Mountain: " .. tostring(lbMountain))
		Utils.LUA_DEBUGOUT("Marine: " .. tostring(lbMarine))
		Utils.LUA_DEBUGOUT("Airborne: " .. tostring(lbAirborne))
		Utils.LUA_DEBUGOUT("Cavalry: " .. tostring(lbCavalry))
		Utils.LUA_DEBUGOUT("Motorized: " .. tostring(lbMotorized))
		Utils.LUA_DEBUGOUT("Mechanized: " .. tostring(lbMechanized))
		Utils.LUA_DEBUGOUT("LightArmour: " .. tostring(lbLightArmour))
		Utils.LUA_DEBUGOUT("Armour: " .. tostring(lbArmour))
		Utils.LUA_DEBUGOUT("HeavyArmour: " .. tostring(lbHeavyArmour))
		Utils.LUA_DEBUGOUT("IST: " .. tostring(lbIST))
		Utils.LUA_DEBUGOUT("LightFighter: " .. tostring(lbLightFighter))
		Utils.LUA_DEBUGOUT("HeavyFighter: " .. tostring(lbHeavyFighter))
		Utils.LUA_DEBUGOUT("LightBomber: " .. tostring(lbLightBomber))
		Utils.LUA_DEBUGOUT("CAG: " .. tostring(lbCAG))
		Utils.LUA_DEBUGOUT("MediumBomber: " .. tostring(lbMediumBomber))
		Utils.LUA_DEBUGOUT("PatrolBomber: " .. tostring(lbPatrolBomber))
		Utils.LUA_DEBUGOUT("HeavyBomber: " .. tostring(lbHeavyBomber))
		Utils.LUA_DEBUGOUT("AirTransport: " .. tostring(lbAirTransport))
		Utils.LUA_DEBUGOUT("RocketInterceptor: " .. tostring(lbRocketInterceptor))
		Utils.LUA_DEBUGOUT("FlyingBomb: " .. tostring(lbFlyingBomb))
		Utils.LUA_DEBUGOUT("FlyingRocket: " .. tostring(lbFlyingRocket))
		Utils.LUA_DEBUGOUT("Battleship: " .. tostring(lbBattleship))
		Utils.LUA_DEBUGOUT("Battlecruiser: " .. tostring(lbBattlecruiser))
		Utils.LUA_DEBUGOUT("Carrier: " .. tostring(lbCarrier))
		Utils.LUA_DEBUGOUT("LightCarrier: " .. tostring(lbLightCarrier))
		Utils.LUA_DEBUGOUT("HeavyCruiser: " .. tostring(lbHeavyCruiser))
		Utils.LUA_DEBUGOUT("LightCruiser: " .. tostring(lbLightCruiser))
		Utils.LUA_DEBUGOUT("Destroyer: " .. tostring(lbDestroyer))
		Utils.LUA_DEBUGOUT("Submarine: " .. tostring(lbSubmarine))
		Utils.LUA_DEBUGOUT("Transport: " .. tostring(lbTransport))
	end

	-- Only build units if we have at least some manpower and only build Land units if we have enough to mobilize, too!
	-- Plus we will need at least a decent Officer Ratio.

	-- SSmith (10/09/2013)
	-- The manpower check now returns two values (we want the first)

	local canBuildLand = Support.HasEnoughManpower(ministerTag)[1]

	-- SSmith (18/05/2013)
	-- We need to determine if we are able to build ships or aircraft
	-- So will check the base models and whether we have ports and airfields

	local canBuildAir = (lbLightFighter or lbMediumBomber) and ministerCountry:GetNumOfAirfields() > 0
	local canBuildNaval = (lbDestroyer or lbTransport) and ministerCountry:GetNumOfPorts() > 0

	-- SSmith (18/05/2013)
	-- We should be able to build non-land units provided we have a small cushion of manpower
	-- Requiring at least 100 is a nonsense for smaller nations
	-- So we will demand at least 5 manpower and 25% of total IC if higher

	local canBuildUnits = canBuildLand or (ministerCountry:GetManpower():Get() > 5 and ministerCountry:GetManpower():Get() > (totalIC * 0.25))

	if ministerTagString == tagString then
		Utils.LUA_DEBUGOUT("Checks...")
		Utils.LUA_DEBUGOUT("canBuildLand: "  .. tostring(canBuildLand))
		Utils.LUA_DEBUGOUT("canBuildAir: " .. tostring(canBuildAir))
		Utils.LUA_DEBUGOUT("canBuildNaval: " .. tostring(canBuildNaval))
	end

	if canBuildUnits and ministerCountry:GetOfficerRatio():Get() > 0.75 then

		-- SSmith (18/05/2013)
		-- This is the main section of logic if we are capable of building any units at all
		-- We will now get the IC production weights
		
		local laProdWeights = GetBuildRatio(minister, ministerTag, canBuildNaval, "ProductionWeights")

		-- If we are unable to build any category then set the weighting to zero
		if not canBuildLand then
			laProdWeights[1] = 0
		end
		if not canBuildAir then
			laProdWeights[2] = 0
		end
		if not canBuildNaval then
			laProdWeights[3] = 0
		end

		-- SSmith (18/05/2013)
		-- This support function can be used for country-specific checks that I might put back in later
		-- It now applies some generic re-distribution to balance air/sea/land production for default countries

		Support.AdjustProductionWeights( minister, laProdWeights )

		-- Finally convert the weightings to percentages
		laProdWeights = GetPercentageRatio(laProdWeights)

		if ministerTagString == tagString then
			Utils.LUA_DEBUGOUT("Production Weights....")
			Utils.LUA_DEBUGOUT("laProdWeights[land]: " .. tostring(laProdWeights[1]))
			Utils.LUA_DEBUGOUT("laProdWeights[air]: " .. tostring(laProdWeights[2]))
			Utils.LUA_DEBUGOUT("laProdWeights[naval]: " .. tostring(laProdWeights[3]))
			Utils.LUA_DEBUGOUT("laProdWeights[other]: " .. tostring(laProdWeights[4]))
		end

		-- SSmith (19/05/2013)
		-- We will now get the unit ratios
		-- We will then need to zeroise anything we can't build
		-- And then we will convert the ratios to percentages before we use them

		local laLandRatio = GetBuildRatio(minister, ministerTag, canBuildNaval, "LandRatio")
		local laSpecialForcesRatio = GetBuildRatio(minister, ministerTag, canBuildNaval, "SpecialForcesRatio")
		local laAirRatio = GetBuildRatio(minister, ministerTag, canBuildNaval, "AirRatio")
		local laRocketRatio = GetBuildRatio(minister, ministerTag, canBuildNaval, "RocketRatio")
		local laNavalRatio = GetBuildRatio(minister, ministerTag, canBuildNaval, "NavalRatio")
		local laTransportLandRatio = GetBuildRatio(minister, ministerTag, canBuildNaval, "TransportLandRatio")

		-- Land ratios

		if ministerTagString == tagString then
			Utils.LUA_DEBUGOUT("Land Ratio...")
			Utils.LUA_DEBUGOUT("laLandRatio[gar]: " .. tostring(laLandRatio[1]))
			Utils.LUA_DEBUGOUT("laLandRatio[inf]: " .. tostring(laLandRatio[2]))
			Utils.LUA_DEBUGOUT("laLandRatio[mot]: " .. tostring(laLandRatio[3]))
			Utils.LUA_DEBUGOUT("laLandRatio[mec]: " .. tostring(laLandRatio[4]))
			Utils.LUA_DEBUGOUT("laLandRatio[arm]: " .. tostring(laLandRatio[5]))
			Utils.LUA_DEBUGOUT("laLandRatio[mil]: " .. tostring(laLandRatio[6]))
			Utils.LUA_DEBUGOUT("laLandRatio[cav]: " .. tostring(laLandRatio[7]))
		end

		if not lbGarrison then
			laLandRatio[1] = 0
		end
		if not lbInfantry then
			laLandRatio[2] = 0
		end
		if not lbMotorized then
			laLandRatio[3] = 0
		end
		if not lbMechanized then
			laLandRatio[4] = 0
		end
		if not lbLightArmour and not lbArmour then
			laLandRatio[5] = 0
		end
		if not lbMilitia then
			laLandRatio[6] = 0
		end
		if not lbCavalry then
			laLandRatio[7] = 0
		end
		laLandRatio = GetPercentageRatio(laLandRatio)

		if ministerTagString == tagString then
			Utils.LUA_DEBUGOUT("Land Ratio...")
			Utils.LUA_DEBUGOUT("laLandRatio[gar]: " .. tostring(laLandRatio[1]))
			Utils.LUA_DEBUGOUT("laLandRatio[inf]: " .. tostring(laLandRatio[2]))
			Utils.LUA_DEBUGOUT("laLandRatio[mot]: " .. tostring(laLandRatio[3]))
			Utils.LUA_DEBUGOUT("laLandRatio[mec]: " .. tostring(laLandRatio[4]))
			Utils.LUA_DEBUGOUT("laLandRatio[arm]: " .. tostring(laLandRatio[5]))
			Utils.LUA_DEBUGOUT("laLandRatio[mil]: " .. tostring(laLandRatio[6]))
			Utils.LUA_DEBUGOUT("laLandRatio[cav]: " .. tostring(laLandRatio[7]))
		end

		if ministerTagString == tagString then
			Utils.LUA_DEBUGOUT("Air Ratio...")
			Utils.LUA_DEBUGOUT("laAirRatio[ftr]: " .. tostring(laAirRatio[1]))
			Utils.LUA_DEBUGOUT("laAirRatio[cas]: " .. tostring(laAirRatio[2]))
			Utils.LUA_DEBUGOUT("laAirRatio[tac]: " .. tostring(laAirRatio[3]))
			Utils.LUA_DEBUGOUT("laAirRatio[nav]: " .. tostring(laAirRatio[4]))
			Utils.LUA_DEBUGOUT("laAirRatio[str]: " .. tostring(laAirRatio[5]))
		end

		-- Air ratios
		if not lbLightFighter and not lbHeavyFighter then
			laAirRatio[1] = 0
		end
		if not lbLightBomber then
			laAirRatio[2] = 0
		end
		if not lbMediumBomber then
			laAirRatio[3] = 0
		end
		if not lbPatrolBomber then
			laAirRatio[4] = 0
		end
		if not lbHeavyBomber then
			laAirRatio[5] = 0
		end
		laAirRatio = GetPercentageRatio(laAirRatio)

		if ministerTagString == tagString then
			Utils.LUA_DEBUGOUT("Air Ratio...")
			Utils.LUA_DEBUGOUT("laAirRatio[ftr]: " .. tostring(laAirRatio[1]))
			Utils.LUA_DEBUGOUT("laAirRatio[cas]: " .. tostring(laAirRatio[2]))
			Utils.LUA_DEBUGOUT("laAirRatio[tac]: " .. tostring(laAirRatio[3]))
			Utils.LUA_DEBUGOUT("laAirRatio[nav]: " .. tostring(laAirRatio[4]))
			Utils.LUA_DEBUGOUT("laAirRatio[str]: " .. tostring(laAirRatio[5]))
		end

		if ministerTagString == tagString then
			Utils.LUA_DEBUGOUT("Naval Ratio...")
			Utils.LUA_DEBUGOUT("laNavalRatio[dd]: " .. tostring(laNavalRatio[1]))
			Utils.LUA_DEBUGOUT("laNavalRatio[ss]: " .. tostring(laNavalRatio[2]))
			Utils.LUA_DEBUGOUT("laNavalRatio[cc]: " .. tostring(laNavalRatio[3]))
			Utils.LUA_DEBUGOUT("laNavalRatio[bb]: " .. tostring(laNavalRatio[4]))
			Utils.LUA_DEBUGOUT("laNavalRatio[cvl]: " .. tostring(laNavalRatio[5]))
			Utils.LUA_DEBUGOUT("laNavalRatio[cv]: " .. tostring(laNavalRatio[6]))
		end

		-- Naval ratios
		if not lbDestroyer then
			laNavalRatio[1] = 0
		end
		if not lbSubmarine then
			laNavalRatio[2] = 0
		end
		if not lbLightCruiser and not lbHeavyCruiser then
			laNavalRatio[3] = 0
		end
		if not lbBattleship and not lbBattlecruiser then
			laNavalRatio[4] = 0
		end
		if not lbLightCarrier then
			laNavalRatio[5] = 0
		end
		if not lbCarrier then
			laNavalRatio[6] = 0
		end
		laNavalRatio = GetPercentageRatio(laNavalRatio)


		if ministerTagString == tagString then
			Utils.LUA_DEBUGOUT("Naval Ratio...")
			Utils.LUA_DEBUGOUT("laNavalRatio[dd]: " .. tostring(laNavalRatio[1]))
			Utils.LUA_DEBUGOUT("laNavalRatio[ss]: " .. tostring(laNavalRatio[2]))
			Utils.LUA_DEBUGOUT("laNavalRatio[cc]: " .. tostring(laNavalRatio[3]))
			Utils.LUA_DEBUGOUT("laNavalRatio[bb]: " .. tostring(laNavalRatio[4]))
			Utils.LUA_DEBUGOUT("laNavalRatio[cvl]: " .. tostring(laNavalRatio[5]))
			Utils.LUA_DEBUGOUT("laNavalRatio[cv]: " .. tostring(laNavalRatio[6]))
		end
		
		-- Figure out how much IC is suppose to be designated in the appropriate area
		local liPotentialLandIC = icProdAllocated * laProdWeights[1]
		local liPotentialAirIC = icProdAllocated * laProdWeights[2]
		local liPotentialNavalIC = icProdAllocated * laProdWeights[3]
		local liPotentialOtherIC = icProdAllocated * laProdWeights[4]
		
		local liNeededLandIC = 0
		local liNeededAirIC = 0
		local liNeededNavalIC = 0
		local liNeededOtherIC = 0
		
		-- Figure out what the AI is currently producing in each category
		for loBuildItem in ministerCountry:GetConstructions() do
			if loBuildItem:IsMilitary() then
				if loBuildItem:GetMilitary():IsLand() then
					liNeededLandIC = liNeededLandIC + loBuildItem:GetCost()
				elseif loBuildItem:GetMilitary():IsAir() then
					liNeededAirIC = liNeededAirIC + loBuildItem:GetCost()
				elseif loBuildItem:GetMilitary():IsNaval() then
					liNeededNavalIC = liNeededNavalIC + loBuildItem:GetCost()
				end
			else
				liNeededOtherIC = liNeededOtherIC + loBuildItem:GetCost()
			end
		end
		
		if ministerTagString == tagString then
			Utils.LUA_DEBUGOUT("IC totals...")
			Utils.LUA_DEBUGOUT("liPotentialLandIC: " .. tostring(liPotentialLandIC))
			Utils.LUA_DEBUGOUT("liPotentialAirIC: " .. tostring(liPotentialAirIC))
			Utils.LUA_DEBUGOUT("liPotentialNavalIC: " .. tostring(liPotentialNavalIC))
			Utils.LUA_DEBUGOUT("liPotentialOtherIC: " .. tostring(liPotentialOtherIC))
			Utils.LUA_DEBUGOUT("liUsedLandIC: " .. tostring(liNeededLandIC))
			Utils.LUA_DEBUGOUT("liUsedAirIC: " .. tostring(liNeededAirIC))
			Utils.LUA_DEBUGOUT("liUsedNavalIC: " .. tostring(liNeededNavalIC))
			Utils.LUA_DEBUGOUT("liUsedOtherIC: " .. tostring(liNeededOtherIC))
		end

		-- These will now hold the amount of IC we can still spend on that category
		liNeededLandIC = liPotentialLandIC - liNeededLandIC
		liNeededAirIC = liPotentialAirIC - liNeededAirIC
		liNeededNavalIC = liPotentialNavalIC - liNeededNavalIC
		liNeededOtherIC = liPotentialOtherIC - liNeededOtherIC

		if ministerTagString == tagString then
			Utils.LUA_DEBUGOUT("liNeededLandIC: " .. tostring(liNeededLandIC))
			Utils.LUA_DEBUGOUT("liNeededAirIC: " .. tostring(liNeededAirIC))
			Utils.LUA_DEBUGOUT("liNeededNavalIC: " .. tostring(liNeededNavalIC))
			Utils.LUA_DEBUGOUT("liNeededOtherIC: " .. tostring(liNeededOtherIC))
		end
		
		-- SSmith (19/05/2013)
		-- I am re-working the part that handles overfunding because I want the other categories scaled properly
		-- Basically if we are over-funding somewhere then we must spend less elsewhere

		local overfund = 0
		if liNeededLandIC < 0 then
			overfund = overfund - liNeededLandIC
			liNeededLandIC = 0
		end
		if liNeededAirIC < 0 then
			overfund = overfund - liNeededAirIC
			liNeededAirIC = 0
		end
		if liNeededNavalIC < 0 then
			overfund = overfund - liNeededNavalIC
			liNeededNavalIC = 0
		end
		if liNeededOtherIC < 0 then
			overfund = overfund - liNeededOtherIC
			liNeededOtherIC = 0
		end

		local underfund = liNeededLandIC + liNeededAirIC + liNeededNavalIC + liNeededOtherIC
		if underfund > 0 then
			liNeededLandIC = liNeededLandIC - (overfund * (liNeededLandIC / underfund))
			liNeededAirIC = liNeededAirIC - (overfund * (liNeededAirIC / underfund))
			liNeededNavalIC = liNeededNavalIC - (overfund * (liNeededNavalIC / underfund))
			liNeededOtherIC = liNeededOtherIC - (overfund * (liNeededOtherIC / underfund))
		end

		if ministerTagString == tagString then
			Utils.LUA_DEBUGOUT("overfund: " .. tostring(overfund))
			Utils.LUA_DEBUGOUT("underfund: " .. tostring(underfund))
		end

		if liNeededLandIC < 0 then
			liNeededLandIC = 0
		end
		if liNeededAirIC < 0 then
			liNeededAirIC = 0
		end
		if liNeededNavalIC < 0 then
			liNeededNavalIC = 0
		end
		if liNeededOtherIC < 0 then
			liNeededOtherIC = 0
		end
		
		if ministerTagString == tagString then
			Utils.LUA_DEBUGOUT("liNeededLandIC: " .. tostring(liNeededLandIC))
			Utils.LUA_DEBUGOUT("liNeededAirIC: " .. tostring(liNeededAirIC))
			Utils.LUA_DEBUGOUT("liNeededNavalIC: " .. tostring(liNeededNavalIC))
			Utils.LUA_DEBUGOUT("liNeededOtherIC: " .. tostring(liNeededOtherIC))
		end

		-- Get the counts of the unit types currently being produced
		local laTempProd = ai:GetProductionSubUnitCounts()
		local laTempCurrent = ai:GetDeployedSubUnitCounts()
		
		for subUnit in CSubUnitDataBase.GetSubUnitList() do
			local nIndex = subUnit:GetIndex()
			local lsUnitType = subUnit:GetKey():GetString() 

			if lsUnitType == "infantry_brigade" then
				prodArrayCounts[_INFANTRY_BRIGADE_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_INFANTRY_BRIGADE_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "light_armor_brigade" then
				prodArrayCounts[_LIGHT_ARMOR_BRIGADE_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_LIGHT_ARMOR_BRIGADE_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "armor_brigade" then
				prodArrayCounts[_ARMOR_BRIGADE_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_ARMOR_BRIGADE_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "bergsjaeger_brigade" then
				prodArrayCounts[_BERGSJAEGER_BRIGADE_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_BERGSJAEGER_BRIGADE_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "cavalry_brigade" then
				prodArrayCounts[_CAVALRY_BRIGADE_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_CAVALRY_BRIGADE_] = laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "garrison_brigade" then
				prodArrayCounts[_GARRISON_BRIGADE_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_GARRISON_BRIGADE_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "heavy_armor_brigade" then
				prodArrayCounts[_HEAVY_ARMOR_BRIGADE_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_HEAVY_ARMOR_BRIGADE_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "marine_brigade" then
				prodArrayCounts[_MARINE_BRIGADE_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_MARINE_BRIGADE_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "mechanized_brigade" then
				prodArrayCounts[_MECHANIZED_BRIGADE_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_MECHANIZED_BRIGADE_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "militia_brigade" then
				prodArrayCounts[_MILITIA_BRIGADE_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_MILITIA_BRIGADE_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "motorized_brigade" then
				prodArrayCounts[_MOTORIZED_BRIGADE_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_MOTORIZED_BRIGADE_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "paratrooper_brigade" then
				prodArrayCounts[_PARATROOPER_BRIGADE_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_PARATROOPER_BRIGADE_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "super_heavy_armor_brigade" then
				prodArrayCounts[_SUPER_HEAVY_ARMOR_BRIGADE_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_SUPER_HEAVY_ARMOR_BRIGADE_] =  laTempCurrent:GetAt(nIndex)
			
			-- Start Naval Unit counts
			elseif lsUnitType == "battlecruiser" then
				prodArrayCounts[_BATTLECRUISER_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_BATTLECRUISER_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "battleship" then
				prodArrayCounts[_BATTLESHIP_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_BATTLESHIP_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "carrier" then
				prodArrayCounts[_CARRIER_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_CARRIER_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "destroyer" then
				prodArrayCounts[_DESTROYER_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_DESTROYER_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "escort_carrier" then
				prodArrayCounts[_ESCORT_CARRIER_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_ESCORT_CARRIER_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "heavy_cruiser" then
				prodArrayCounts[_HEAVY_CRUISER_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_HEAVY_CRUISER_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "light_cruiser" then
				prodArrayCounts[_LIGHT_CRUISER_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_LIGHT_CRUISER_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "submarine" then
				prodArrayCounts[_SUBMARINE_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_SUBMARINE_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "transport_ship" then
				prodArrayCounts[_TRANSPORT_SHIP_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_TRANSPORT_SHIP_] =  laTempCurrent:GetAt(nIndex)
				
			-- Start Air Unit counts
			elseif lsUnitType == "cag" then
				prodArrayCounts[_CAG_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_CAG_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "cas" then
				prodArrayCounts[_CAS_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_CAS_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "interceptor" then
				prodArrayCounts[_INTERCEPTOR_] = prodArrayCounts[_INTERCEPTOR_] + laTempProd:GetAt(nIndex)
				currentArrayCounts[_INTERCEPTOR_] = currentArrayCounts[_INTERCEPTOR_] + laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "multi_role" then
				prodArrayCounts[_MULTI_ROLE_] = prodArrayCounts[_MULTI_ROLE_] + laTempProd:GetAt(nIndex)
				currentArrayCounts[_MULTI_ROLE_] = currentArrayCounts[_MULTI_ROLE_] + laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "naval_bomber" then
				prodArrayCounts[_NAVAL_BOMBER_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_NAVAL_BOMBER_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "strategic_bomber" then
				prodArrayCounts[_STRATEGIC_BOMBER_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_STRATEGIC_BOMBER_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "tactical_bomber" then
				prodArrayCounts[_TACTICAL_BOMBER_] = prodArrayCounts[_TACTICAL_BOMBER_] + laTempProd:GetAt(nIndex)
				currentArrayCounts[_TACTICAL_BOMBER_] = currentArrayCounts[_TACTICAL_BOMBER_] + laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "transport_plane" then
				prodArrayCounts[_TRANSPORT_PLANE_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_TRANSPORT_PLANE_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "flying_bomb" then
				prodArrayCounts[_FLYING_BOMB_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_FLYING_BOMB_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "flying_rocket" then
				prodArrayCounts[_FLYING_ROCKET_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_FLYING_ROCKET_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "jet_int" then
				prodArrayCounts[_INTERCEPTOR_] = prodArrayCounts[_INTERCEPTOR_] + laTempProd:GetAt(nIndex)
				currentArrayCounts[_INTERCEPTOR_] = currentArrayCounts[_INTERCEPTOR_] + laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "jet_mr" then
				prodArrayCounts[_MULTI_ROLE_] = prodArrayCounts[_MULTI_ROLE_] + laTempProd:GetAt(nIndex)
				currentArrayCounts[_MULTI_ROLE_] = currentArrayCounts[_MULTI_ROLE_] + laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "jet_bomber" then
				prodArrayCounts[_TACTICAL_BOMBER_] = prodArrayCounts[_TACTICAL_BOMBER_] + laTempProd:GetAt(nIndex)
				currentArrayCounts[_TACTICAL_BOMBER_] = currentArrayCounts[_TACTICAL_BOMBER_] + laTempCurrent:GetAt(nIndex)
			end
		end		

		if ministerTagString == tagString then
			Utils.LUA_DEBUGOUT("Unit Counts...")
			for i = 1, table.getn(prodArrayCounts) do
				Utils.LUA_DEBUGOUT("Curr " .. tostring(i) .. ": " .. tostring(currentArrayCounts[i]))
				Utils.LUA_DEBUGOUT("Prod " .. tostring(i) .. ": " .. tostring(prodArrayCounts[i]))
			end
		end

		-- Process Land Units
		local liTotalLandUnits = 0
		
		--    PERFORMANCE: only process if IC has been allocated
		--    Naval check is adding for Transport ratio calculating
		if liNeededLandIC > 0 or liNeededNavalIC > 0 then

			-- Array order Garrison, Infantry, Motorized, Mechanized, Armor

			-- SSmith (08/06/2013)
			-- we will no longer include heavy armour in the unit count as they are support brigades
			-- ISTs will still be totalled for the French and UK scripts as they will be building ISTs!
			-- We will begin to phase out ISTs from the count in 1941 and completely by 1942

			local laLandUnitCount = {}
			laLandUnitCount[1] = prodArrayCounts[_GARRISON_BRIGADE_] + currentArrayCounts[_GARRISON_BRIGADE_]
			laLandUnitCount[2] = GetUnitCount(_INFANTRY_BRIGADE_, _PARATROOPER_BRIGADE_, prodArrayCounts, currentArrayCounts)
			laLandUnitCount[3] = prodArrayCounts[_MOTORIZED_BRIGADE_] + currentArrayCounts[_MOTORIZED_BRIGADE_]
			laLandUnitCount[4] = prodArrayCounts[_MECHANIZED_BRIGADE_] + currentArrayCounts[_MECHANIZED_BRIGADE_]
			laLandUnitCount[5] = GetUnitCount(_LIGHT_ARMOR_BRIGADE_, _ARMOR_BRIGADE_, prodArrayCounts, currentArrayCounts)

			local liISTCount = prodArrayCounts[_SUPER_HEAVY_ARMOR_BRIGADE_] + currentArrayCounts[_SUPER_HEAVY_ARMOR_BRIGADE_]
			if CCurrentGameState.GetCurrentDate():GetYear() < 1941 then
				laLandUnitCount[5] = laLandUnitCount[5] + liISTCount
			elseif CCurrentGameState.GetCurrentDate():GetYear() < 1942 then
				laLandUnitCount[5] = laLandUnitCount[5] + math.floor(liISTCount / 2)
			end

			laLandUnitCount[6] = prodArrayCounts[_MILITIA_BRIGADE_] + currentArrayCounts[_MILITIA_BRIGADE_]
			laLandUnitCount[7] = prodArrayCounts[_CAVALRY_BRIGADE_] + currentArrayCounts[_CAVALRY_BRIGADE_]

			-- SSmith (19/05/2013)
			-- I have switched the index for cavalry and infantry so that cavalry can be counted separately

			-- Used for Calculating Transports and Special Forces
			for i = 1, 7 do
				liTotalLandUnits = liTotalLandUnits + laLandUnitCount[i]
			end
			
			-- PERFORMANCE: Make sure you need the rest of this to run
			if liNeededLandIC > 0 then

				-- SSmith (19/05/2013)
				-- We now need to calculate our land force requirements
				-- First we will set the unit needs to 10% of what we already have
				-- This provides for a natural expansion of our existing forces

				local laLandUnitNeed = {}
				laLandUnitNeed[1] = laLandUnitCount[1] * 0.1
				laLandUnitNeed[2] = laLandUnitCount[2] * 0.1
				laLandUnitNeed[3] = laLandUnitCount[3] * 0.1
				laLandUnitNeed[4] = laLandUnitCount[4] * 0.1
				laLandUnitNeed[5] = laLandUnitCount[5] * 0.1
				laLandUnitNeed[6] = laLandUnitCount[6] * 0.1
				laLandUnitNeed[7] = laLandUnitCount[7] * 0.1

				-- Next we need to scale up the total land unit count by 10% (or to 10 units if less)

				local liTargetLandUnits = liTotalLandUnits * 1.1
				if liTargetLandUnits < 10 then
					liTargetLandUnits = 10
				end

				if ministerTagString == tagString then
					Utils.LUA_DEBUGOUT("Land Counts...")
					Utils.LUA_DEBUGOUT("laLandUnitCount[gar]: " .. tostring(laLandUnitCount[1]))
					Utils.LUA_DEBUGOUT("laLandUnitCount[inf]: " .. tostring(laLandUnitCount[2]))
					Utils.LUA_DEBUGOUT("laLandUnitCount[mot]: " .. tostring(laLandUnitCount[3]))
					Utils.LUA_DEBUGOUT("laLandUnitCount[mec]: " .. tostring(laLandUnitCount[4]))
					Utils.LUA_DEBUGOUT("laLandUnitCount[arm]: " .. tostring(laLandUnitCount[5]))
					Utils.LUA_DEBUGOUT("laLandUnitCount[mil]: " .. tostring(laLandUnitCount[6]))
					Utils.LUA_DEBUGOUT("laLandUnitCount[cav]: " .. tostring(laLandUnitCount[7]))
					Utils.LUA_DEBUGOUT("Total: " .. tostring(liTotalLandUnits))
					Utils.LUA_DEBUGOUT("Target: " .. tostring(liTargetLandUnits))
				end

				-- Our next task is to determine how our current totals compare with our planned ratios
				-- We will add or subtract this from the base requirements calculated above
				-- But we will also multiply the effect for more expensive armour

				laLandUnitNeed[1] = laLandUnitNeed[1] + (1.5 * ((liTargetLandUnits * laLandRatio[1]) - laLandUnitCount[1]))
				laLandUnitNeed[2] = laLandUnitNeed[2] + (2.0 * ((liTargetLandUnits * laLandRatio[2]) - laLandUnitCount[2]))
				laLandUnitNeed[3] = laLandUnitNeed[3] + (2.0 * ((liTargetLandUnits * laLandRatio[3]) - laLandUnitCount[3]))
				laLandUnitNeed[4] = laLandUnitNeed[4] + (2.5 * ((liTargetLandUnits * laLandRatio[4]) - laLandUnitCount[4]))
				laLandUnitNeed[5] = laLandUnitNeed[5] + (3.0 * ((liTargetLandUnits * laLandRatio[5]) - laLandUnitCount[5]))
				laLandUnitNeed[6] = laLandUnitNeed[6] + (0.5 * ((liTargetLandUnits * laLandRatio[6]) - laLandUnitCount[6]))
				laLandUnitNeed[7] = laLandUnitNeed[7] + (1.0 * ((liTargetLandUnits * laLandRatio[7]) - laLandUnitCount[7]))

				if ministerTagString == tagString then
					Utils.LUA_DEBUGOUT("laLandUnitNeed[gar]: " .. tostring(laLandUnitNeed[1]))
					Utils.LUA_DEBUGOUT("laLandUnitNeed[inf]: " .. tostring(laLandUnitNeed[2]))
					Utils.LUA_DEBUGOUT("laLandUnitNeed[mot]: " .. tostring(laLandUnitNeed[3]))
					Utils.LUA_DEBUGOUT("laLandUnitNeed[mec]: " .. tostring(laLandUnitNeed[4]))
					Utils.LUA_DEBUGOUT("laLandUnitNeed[arm]: " .. tostring(laLandUnitNeed[5]))
					Utils.LUA_DEBUGOUT("laLandUnitNeed[mil]: " .. tostring(laLandUnitNeed[6]))
					Utils.LUA_DEBUGOUT("laLandUnitNeed[cav]: " .. tostring(laLandUnitNeed[7]))
				end

				-- Just because we have existing units doesn't mean we can actually build them
				-- So we better check unit availability and also clear down any negatives as we go

				if lbGarrison and laLandUnitNeed[1] > 0 then
					laUnitNeeds[_GARRISON_BRIGADE_] = laLandUnitNeed[1]
				end
				if lbInfantry and laLandUnitNeed[2] > 0 then
					laUnitNeeds[_INFANTRY_BRIGADE_] = laLandUnitNeed[2]
				end
				if lbMotorized and laLandUnitNeed[3] > 0 then
					laUnitNeeds[_MOTORIZED_BRIGADE_] = laLandUnitNeed[3]
				end
				if lbMechanized and laLandUnitNeed[4] > 0 then
					laUnitNeeds[_MECHANIZED_BRIGADE_] = laLandUnitNeed[4]
				end
				
				-- Armour
				if laLandUnitNeed[5] > 0 then					
					if lbLightArmour and lbArmour then
						-- Build less Light Armour than Armour
						liLightArmourCount = prodArrayCounts[_LIGHT_ARMOR_BRIGADE_] + currentArrayCounts[_LIGHT_ARMOR_BRIGADE_]
						liArmourCount = prodArrayCounts[_ARMOR_BRIGADE_] + currentArrayCounts[_ARMOR_BRIGADE_]
						if liArmourCount <= (3 * liLightArmourCount) then
							if math.mod(CCurrentGameState.GetAIRand(), 4) == 1 then
								laUnitNeeds[_LIGHT_ARMOR_BRIGADE_] = laLandUnitNeed[5]
							else
								laUnitNeeds[_ARMOR_BRIGADE_] = laLandUnitNeed[5]
							end
						else
							if math.mod(CCurrentGameState.GetAIRand(), 4) == 1 then
								laUnitNeeds[_ARMOR_BRIGADE_] = laLandUnitNeed[5]
							else
								laUnitNeeds[_LIGHT_ARMOR_BRIGADE_] = laLandUnitNeed[5]
							end
						end
					elseif lbArmour then
						laUnitNeeds[_ARMOR_BRIGADE_] = laLandUnitNeed[5]
					elseif lbLightArmour then
						laUnitNeeds[_LIGHT_ARMOR_BRIGADE_] = laLandUnitNeed[5]
					end
				end
				
				if lbMilitia and laLandUnitNeed[6] > 0 then
					laUnitNeeds[_MILITIA_BRIGADE_] = laLandUnitNeed[6]
				end
				if lbCavalry and laLandUnitNeed[7] > 0 then
					laUnitNeeds[_CAVALRY_BRIGADE_] = laLandUnitNeed[7]
				end

				-- SSmith (19/05/2013)
				-- Special forces have been significantly re-worked
				-- The special forces ratio tells us how many of each we should have
				-- For now we will simply have more mountaineers than marines than paratroopers
				
				local liMountainTotal = prodArrayCounts[_BERGSJAEGER_BRIGADE_] + currentArrayCounts[_BERGSJAEGER_BRIGADE_]
				local liMarineTotal = prodArrayCounts[_MARINE_BRIGADE_] + currentArrayCounts[_MARINE_BRIGADE_]
				local liAirborneTotal = prodArrayCounts[_PARATROOPER_BRIGADE_] + currentArrayCounts[_PARATROOPER_BRIGADE_]

				local liMountainNeed = liMountainTotal * 0.1
				local liMarineNeed = liMarineTotal * 0.1
				local liAirborneNeed = liAirborneTotal * 0.1

				local liTotalMountainNeeded = liTargetLandUnits / laSpecialForcesRatio[1]
				local liTotalMarineNeeded = liTargetLandUnits / laSpecialForcesRatio[2]
				local liTotalAirborneNeeded = liTargetLandUnits / laSpecialForcesRatio[3]

				liMountainNeed = liMountainNeed + (4.0 * (liTotalMountainNeeded - liMountainTotal))
				liMarineNeed = liMarineNeed + (4.0 * (liTotalMarineNeeded - liMarineTotal))
				liAirborneNeed = liAirborneNeed + (4.0 * (liTotalAirborneNeeded - liAirborneTotal))
				
				if ministerTagString == tagString then
					Utils.LUA_DEBUGOUT("liMountainTotal: " .. tostring(liMountainTotal))
					Utils.LUA_DEBUGOUT("liMarineTotal: " .. tostring(liMarineTotal))
					Utils.LUA_DEBUGOUT("liAirborneTotal: " .. tostring(liAirborneTotal))
					Utils.LUA_DEBUGOUT("liMountainNeed: " .. tostring(liMountainNeed))
					Utils.LUA_DEBUGOUT("liMarineNeed: " .. tostring(liMarineNeed))
					Utils.LUA_DEBUGOUT("liAirborneNeed: " .. tostring(liAirborneNeed))
				end

				if lbMountain and liMountainNeed > 0 then
					laUnitNeeds[_BERGSJAEGER_BRIGADE_] = liMountainNeed
				end
				if lbMarine and canBuildNaval and liMarineNeed > 0 then
					laUnitNeeds[_MARINE_BRIGADE_] = liMarineNeed
				end
				if lbAirborne and canBuildAir and liAirborneNeed > 0 then
					laUnitNeeds[_PARATROOPER_BRIGADE_] = liAirborneNeed
				end

				-- SSmith (20/05/2013)
				-- The final step is to convert the land force needs to percentages

				local liLandSum = laUnitNeeds[_GARRISON_BRIGADE_] + laUnitNeeds[_INFANTRY_BRIGADE_] + laUnitNeeds[_MOTORIZED_BRIGADE_]
					+ laUnitNeeds[_MECHANIZED_BRIGADE_] + laUnitNeeds[_LIGHT_ARMOR_BRIGADE_] + laUnitNeeds[_ARMOR_BRIGADE_]
					+ laUnitNeeds[_MILITIA_BRIGADE_] + laUnitNeeds[_CAVALRY_BRIGADE_] + laUnitNeeds[_BERGSJAEGER_BRIGADE_]
					+ laUnitNeeds[_MARINE_BRIGADE_] + laUnitNeeds[_PARATROOPER_BRIGADE_]
				if liLandSum > 0 then
					laUnitNeeds[_GARRISON_BRIGADE_] = laUnitNeeds[_GARRISON_BRIGADE_] / liLandSum
					laUnitNeeds[_INFANTRY_BRIGADE_] = laUnitNeeds[_INFANTRY_BRIGADE_] / liLandSum
					laUnitNeeds[_MOTORIZED_BRIGADE_] = laUnitNeeds[_MOTORIZED_BRIGADE_] / liLandSum
					laUnitNeeds[_MECHANIZED_BRIGADE_] = laUnitNeeds[_MECHANIZED_BRIGADE_] / liLandSum
					laUnitNeeds[_LIGHT_ARMOR_BRIGADE_] = laUnitNeeds[_LIGHT_ARMOR_BRIGADE_] / liLandSum
					laUnitNeeds[_ARMOR_BRIGADE_] = laUnitNeeds[_ARMOR_BRIGADE_] / liLandSum
					laUnitNeeds[_MILITIA_BRIGADE_] = laUnitNeeds[_MILITIA_BRIGADE_] / liLandSum
					laUnitNeeds[_CAVALRY_BRIGADE_] = laUnitNeeds[_CAVALRY_BRIGADE_] / liLandSum
					laUnitNeeds[_BERGSJAEGER_BRIGADE_] = laUnitNeeds[_BERGSJAEGER_BRIGADE_] / liLandSum
					laUnitNeeds[_MARINE_BRIGADE_] = laUnitNeeds[_MARINE_BRIGADE_] / liLandSum
					laUnitNeeds[_PARATROOPER_BRIGADE_] = laUnitNeeds[_PARATROOPER_BRIGADE_] / liLandSum
				end

				if ministerTagString == tagString then
					Utils.LUA_DEBUGOUT("Final Land Needs...")
					Utils.LUA_DEBUGOUT("laUnitNeeds[gar]" .. tostring(laUnitNeeds[_GARRISON_BRIGADE_]))
					Utils.LUA_DEBUGOUT("laUnitNeeds[inf]" .. tostring(laUnitNeeds[_INFANTRY_BRIGADE_]))
					Utils.LUA_DEBUGOUT("laUnitNeeds[mot]" .. tostring(laUnitNeeds[_MOTORIZED_BRIGADE_]))
					Utils.LUA_DEBUGOUT("laUnitNeeds[mec]" .. tostring(laUnitNeeds[_MECHANIZED_BRIGADE_]))
					Utils.LUA_DEBUGOUT("laUnitNeeds[larm]" .. tostring(laUnitNeeds[_LIGHT_ARMOR_BRIGADE_]))
					Utils.LUA_DEBUGOUT("laUnitNeeds[arm]" .. tostring(laUnitNeeds[_ARMOR_BRIGADE_]))
					Utils.LUA_DEBUGOUT("laUnitNeeds[mil]" .. tostring(laUnitNeeds[_MILITIA_BRIGADE_]))
					Utils.LUA_DEBUGOUT("laUnitNeeds[cav]" .. tostring(laUnitNeeds[_CAVALRY_BRIGADE_]))
					Utils.LUA_DEBUGOUT("laUnitNeeds[mtn]" .. tostring(laUnitNeeds[_BERGSJAEGER_BRIGADE_]))
					Utils.LUA_DEBUGOUT("laUnitNeeds[mar]" .. tostring(laUnitNeeds[_MARINE_BRIGADE_]))
					Utils.LUA_DEBUGOUT("laUnitNeeds[par]" .. tostring(laUnitNeeds[_PARATROOPER_BRIGADE_]))
				end

			end
		end
		
		-- Process Air Units
		--    PERFORMANCE: only process if IC has been allocated
		if liNeededAirIC > 0 then

			-- SSmith (19/05/2013)
			-- We will apply the same basic logic to aircraft production
			-- Note that the unit counts don't include rocket interceptors at the moment
			-- This isn't a problem as I really need to prove the AI will use them before getting it to build them!

			--    Array order Fighter, CAS, Tactical, Naval Bomber, Strategic
			local laAirUnitCount = {}
			laAirUnitCount[1] = GetUnitCount(_INTERCEPTOR_, _MULTI_ROLE_, prodArrayCounts, currentArrayCounts)
			laAirUnitCount[2] = prodArrayCounts[_CAS_] + currentArrayCounts[_CAS_]
			laAirUnitCount[3] = prodArrayCounts[_TACTICAL_BOMBER_] + currentArrayCounts[_TACTICAL_BOMBER_]
			laAirUnitCount[4] = prodArrayCounts[_NAVAL_BOMBER_] + currentArrayCounts[_NAVAL_BOMBER_]
			laAirUnitCount[5] = prodArrayCounts[_STRATEGIC_BOMBER_] + currentArrayCounts[_STRATEGIC_BOMBER_]
						
			-- First we will set the unit needs to 10% of what we already have
			-- This provides for a natural expansion of our existing forces

			local laAirUnitNeed = {}
			laAirUnitNeed[1] = laAirUnitCount[1] * 0.1
			laAirUnitNeed[2] = laAirUnitCount[2] * 0.1
			laAirUnitNeed[3] = laAirUnitCount[3] * 0.1
			laAirUnitNeed[4] = laAirUnitCount[4] * 0.1
			laAirUnitNeed[5] = laAirUnitCount[5] * 0.1

			-- Next we need to scale up the total air unit count by 10% (or 5 units if less)

			local liTotalAirUnits = 0
			for i = 1, 5 do
				liTotalAirUnits = liTotalAirUnits + laAirUnitCount[i]
			end
			local liTargetAirUnits = liTotalAirUnits * 1.1
			if liTargetAirUnits < 5 then
				liTargetAirUnits = 5
			end

			if ministerTagString == tagString then
				Utils.LUA_DEBUGOUT("Air Counts...")
				Utils.LUA_DEBUGOUT("laAirUnitCount[ftr]: " .. tostring(laAirUnitCount[1]))
				Utils.LUA_DEBUGOUT("laAirUnitCount[cas]: " .. tostring(laAirUnitCount[2]))
				Utils.LUA_DEBUGOUT("laAirUnitCount[tac]: " .. tostring(laAirUnitCount[3]))
				Utils.LUA_DEBUGOUT("laAirUnitCount[nav]: " .. tostring(laAirUnitCount[4]))
				Utils.LUA_DEBUGOUT("laAirUnitCount[str]: " .. tostring(laAirUnitCount[5]))
				Utils.LUA_DEBUGOUT("Total: " .. tostring(liTotalAirUnits))
				Utils.LUA_DEBUGOUT("Target: " .. tostring(liTargetAirUnits))
			end

			-- Our next task is to determine how our current totals compare with our intended ratios
			-- We will add or subtract this from the base requirements calculated above
			-- But we will also multiply its effect to encourage the AI to align to its ratio

			laAirUnitNeed[1] = laAirUnitNeed[1] + (2 * ((liTargetAirUnits * laAirRatio[1]) - laAirUnitCount[1]))
			laAirUnitNeed[2] = laAirUnitNeed[2] + (2 * ((liTargetAirUnits * laAirRatio[2]) - laAirUnitCount[2]))
			laAirUnitNeed[3] = laAirUnitNeed[3] + (3 * ((liTargetAirUnits * laAirRatio[3]) - laAirUnitCount[3]))
			laAirUnitNeed[4] = laAirUnitNeed[4] + (3 * ((liTargetAirUnits * laAirRatio[4]) - laAirUnitCount[4]))
			laAirUnitNeed[5] = laAirUnitNeed[5] + (4.5 * ((liTargetAirUnits * laAirRatio[5]) - laAirUnitCount[5]))

			if ministerTagString == tagString then
				Utils.LUA_DEBUGOUT("laAirUnitNeed[ftr]: " .. tostring(laAirUnitNeed[1]))
				Utils.LUA_DEBUGOUT("laAirUnitNeed[cas]: " .. tostring(laAirUnitNeed[2]))
				Utils.LUA_DEBUGOUT("laAirUnitNeed[tac]: " .. tostring(laAirUnitNeed[3]))
				Utils.LUA_DEBUGOUT("laAirUnitNeed[nav]: " .. tostring(laAirUnitNeed[4]))
				Utils.LUA_DEBUGOUT("laAirUnitNeed[str]: " .. tostring(laAirUnitNeed[5]))
			end

			-- Just because we have existing units doesn't mean we can actually build them
			-- So we better check unit availability and also clear down any negatives as we go

			-- Fighters/Interceptors
			if laAirUnitNeed[1] > 0 then
				
				-- Interceptors are Light Fighters, primarily meant for home defense.
				-- Multi Roles are Heavy Fighters, primarily meant to achieve Air Superiority over foreign territory.
				-- Smaller countries should build Light Fighters only, majors can build Heavy Fighters 2:1

				-- SSmith (19/05/2013)
				-- We need to split production 2:1 in favour of the light fighter

				if lbLightFighter and lbHeavyFighter then
					liLightFighterCount = prodArrayCounts[_INTERCEPTOR_] + currentArrayCounts[_INTERCEPTOR_]
					liHeavyFighterCount = prodArrayCounts[_MULTI_ROLE_] + currentArrayCounts[_MULTI_ROLE_]
					if liLightFighterCount <= (3 * liHeavyFighterCount) then
						if math.mod(CCurrentGameState.GetAIRand(), 4) == 1 then
							laUnitNeeds[_MULTI_ROLE_] = laAirUnitNeed[1]
						else
							laUnitNeeds[_INTERCEPTOR_] = laAirUnitNeed[1]
						end
					else
						if math.mod(CCurrentGameState.GetAIRand(), 4) == 1 then
							laUnitNeeds[_INTERCEPTOR_] = laAirUnitNeed[1]
						else
							laUnitNeeds[_MULTI_ROLE_] = laAirUnitNeed[1]
						end
					end
				elseif lbLightFighter then
					laUnitNeeds[_INTERCEPTOR_] = laAirUnitNeed[1]
				end
			end
			if lbLightBomber and laAirUnitNeed[2] > 0 then
				laUnitNeeds[_CAS_] = laAirUnitNeed[2]
			end
			if lbMediumBomber and laAirUnitNeed[3] > 0 then
				laUnitNeeds[_TACTICAL_BOMBER_] = laAirUnitNeed[3]
			end
			if lbPatrolBomber and laAirUnitNeed[4] > 0 then
				laUnitNeeds[_NAVAL_BOMBER_] = laAirUnitNeed[4]
			end
			if lbHeavyBomber and laAirUnitNeed[5] > 0 then
				laUnitNeeds[_STRATEGIC_BOMBER_] = laAirUnitNeed[5]
			end
			
			-- Do we need Air Transports?
			if lbAirTransport then
				local liTotalParas = prodArrayCounts[_PARATROOPER_BRIGADE_] + currentArrayCounts[_PARATROOPER_BRIGADE_]
				if liTotalParas > 0 then
					local liTotalAirTrans = prodArrayCounts[_TRANSPORT_PLANE_] + currentArrayCounts[_TRANSPORT_PLANE_]
					local liTotalAirTransNeeded = math.floor(liTotalParas / 3)
					
					-- SSmith (20/05/2013)
					-- We will multiply the shortfall to encourage the AI to build

					if liTotalAirTransNeeded > liTotalAirTrans then
						laUnitNeeds[_TRANSPORT_PLANE_] = 8 * (liTotalAirTransNeeded - liTotalAirTrans)
					end

					if ministerTagString == tagString then
						Utils.LUA_DEBUGOUT("liTotalAirTrans: " .. tostring(liTotalAirTrans))
						Utils.LUA_DEBUGOUT("liTotalAirTransNeeded: " .. tostring(laUnitNeeds[_TRANSPORT_PLANE_]))
					end

				end
			end
			
			-- SSmith (20/05/2013)
			-- At the moment I don't want the AI building rockets!
			-- Calculate how many Flying Weapons are needed			
			--if lbFlyingBomb or lbFlyingRocket then
			--	local liTotalAirUnits = GetUnitCount(_CAS_, _TRANSPORT_PLANE_, prodArrayCounts, currentArrayCounts)
			--	local liTotalFlyingWeapons = GetUnitCount(_FLYING_BOMB_, _FLYING_ROCKET_, prodArrayCounts, currentArrayCounts)
			--	
			--	local liUnitIndex = _FLYING_BOMB_
			--	
			--	if lbFlyingRocket then
			--		liUnitIndex = _FLYING_ROCKET_
			--	end
			--	
			--	laUnitNeeds[liUnitIndex] = math.max(0, math.ceil((liTotalAirUnits / laRocketRatio[1]) * laRocketRatio[2]) - liTotalFlyingWeapons)
			--end
			
			-- Figure out if we need any CAGs
			local liCAGsNeeded = prodArrayCounts[_ESCORT_CARRIER_] + currentArrayCounts[_ESCORT_CARRIER_]
			liCAGsNeeded = liCAGsNeeded +((prodArrayCounts[_CARRIER_] + currentArrayCounts[_CARRIER_]) * 2)
			local liCAGsCount = prodArrayCounts[_CAG_] + currentArrayCounts[_CAG_]
			
			-- SSmith (20/05/2013)
			-- We will add a multiplier here to encourage the AI to replace missing CAGs

			if liCAGsNeeded > liCAGsCount then
				laUnitNeeds[_CAG_] = 2.5 * (liCAGsNeeded - liCAGsCount)
			end

			if ministerTagString == tagString then
				Utils.LUA_DEBUGOUT("liCAGsCount: " .. tostring(liCAGsCount))
				Utils.LUA_DEBUGOUT("liCAGsNeeded: " .. tostring(laUnitNeeds[_CAG_]))
			end

			-- SSmith (20/05/2013)
			-- The final step is to convert the air units needs to percentages

			local liAirSum = laUnitNeeds[_INTERCEPTOR_] + laUnitNeeds[_MULTI_ROLE_] + laUnitNeeds[_CAS_]
				+ laUnitNeeds[_TACTICAL_BOMBER_] + laUnitNeeds[_NAVAL_BOMBER_] + laUnitNeeds[_STRATEGIC_BOMBER_]
				+ laUnitNeeds[_TRANSPORT_PLANE_] + laUnitNeeds[_CAG_]
			if liAirSum > 0 then
				laUnitNeeds[_INTERCEPTOR_] = laUnitNeeds[_INTERCEPTOR_] / liAirSum
				laUnitNeeds[_MULTI_ROLE_] = laUnitNeeds[_MULTI_ROLE_] / liAirSum
				laUnitNeeds[_CAS_] = laUnitNeeds[_CAS_] / liAirSum
				laUnitNeeds[_TACTICAL_BOMBER_] = laUnitNeeds[_TACTICAL_BOMBER_] / liAirSum
				laUnitNeeds[_NAVAL_BOMBER_] = laUnitNeeds[_NAVAL_BOMBER_] / liAirSum
				laUnitNeeds[_STRATEGIC_BOMBER_] = laUnitNeeds[_STRATEGIC_BOMBER_] / liAirSum
				laUnitNeeds[_TRANSPORT_PLANE_] = laUnitNeeds[_TRANSPORT_PLANE_] / liAirSum
				laUnitNeeds[_CAG_] = laUnitNeeds[_CAG_] / liAirSum
			end

			if ministerTagString == tagString then
				Utils.LUA_DEBUGOUT("Final Air Needs...")
				Utils.LUA_DEBUGOUT("laUnitNeeds[int]" .. tostring(laUnitNeeds[_INTERCEPTOR_]))
				Utils.LUA_DEBUGOUT("laUnitNeeds[mr]" .. tostring(laUnitNeeds[_MULTI_ROLE_]))
				Utils.LUA_DEBUGOUT("laUnitNeeds[cas]" .. tostring(laUnitNeeds[_CAS_]))
				Utils.LUA_DEBUGOUT("laUnitNeeds[tac]" .. tostring(laUnitNeeds[_TACTICAL_BOMBER_]))
				Utils.LUA_DEBUGOUT("laUnitNeeds[nav]" .. tostring(laUnitNeeds[_NAVAL_BOMBER_]))
				Utils.LUA_DEBUGOUT("laUnitNeeds[str]" .. tostring(laUnitNeeds[_STRATEGIC_BOMBER_]))
				Utils.LUA_DEBUGOUT("laUnitNeeds[tra]" .. tostring(laUnitNeeds[_TRANSPORT_PLANE_]))
				Utils.LUA_DEBUGOUT("laUnitNeeds[cag]" .. tostring(laUnitNeeds[_CAG_]))
			end
		end
		
		-- Process Naval Units
		--    PERFORMANCE: only process if IC has been allocated
		if liNeededNavalIC > 0 then
			--    Array order Destroyers, Submarines, Cruisers, Capital, Escort Carrier, Carrier, Transport
			local laNavalUnitCount = {}
			laNavalUnitCount[1] = prodArrayCounts[_DESTROYER_] + currentArrayCounts[_DESTROYER_]
			laNavalUnitCount[2] = prodArrayCounts[_SUBMARINE_] + currentArrayCounts[_SUBMARINE_]
			laNavalUnitCount[3] = GetUnitCount(_LIGHT_CRUISER_, _HEAVY_CRUISER_, prodArrayCounts, currentArrayCounts)
			laNavalUnitCount[4] = GetUnitCount(_BATTLECRUISER_, _BATTLESHIP_, prodArrayCounts, currentArrayCounts)
			laNavalUnitCount[5] = prodArrayCounts[_ESCORT_CARRIER_] + currentArrayCounts[_ESCORT_CARRIER_]
			laNavalUnitCount[6] = prodArrayCounts[_CARRIER_] + currentArrayCounts[_CARRIER_]
			
			-- First we will set the unit needs to 10% of what we already have
			-- This provides for a natural expansion of our existing forces

			local laNavalUnitNeed = {}
			laNavalUnitNeed[1] = laNavalUnitCount[1] * 0.1
			laNavalUnitNeed[2] = laNavalUnitCount[2] * 0.1
			laNavalUnitNeed[3] = laNavalUnitCount[3] * 0.1
			laNavalUnitNeed[4] = laNavalUnitCount[4] * 0.1
			laNavalUnitNeed[5] = laNavalUnitCount[5] * 0.1
			laNavalUnitNeed[6] = laNavalUnitCount[6] * 0.1

			-- Next we need to scale up the total naval unit count by 10% (or 5 units if less)

			local liTotalNavalUnits = 0
			for i = 1, 6 do
				liTotalNavalUnits = liTotalNavalUnits + laNavalUnitCount[i]
			end
			local liTargetNavalUnits = liTotalNavalUnits * 1.1
			if liTargetNavalUnits < 5 then
				liTargetNavalUnits = 5
			end

			if ministerTagString == tagString then
				Utils.LUA_DEBUGOUT("Naval Counts...")
				Utils.LUA_DEBUGOUT("laNavalUnitCount[dd]: " .. tostring(laNavalUnitCount[1]))
				Utils.LUA_DEBUGOUT("laNavalUnitCount[ss]: " .. tostring(laNavalUnitCount[2]))
				Utils.LUA_DEBUGOUT("laNavalUnitCount[cc]: " .. tostring(laNavalUnitCount[3]))
				Utils.LUA_DEBUGOUT("laNavalUnitCount[bb]: " .. tostring(laNavalUnitCount[4]))
				Utils.LUA_DEBUGOUT("laNavalUnitCount[cvl]: " .. tostring(laNavalUnitCount[5]))
				Utils.LUA_DEBUGOUT("laNavalUnitCount[cv]: " .. tostring(laNavalUnitCount[6]))
				Utils.LUA_DEBUGOUT("Total: " .. tostring(liTotalNavalUnits))
				Utils.LUA_DEBUGOUT("Target: " .. tostring(liTargetNavalUnits))
			end

			-- Our next task is to determine how our current totals compare with our intended ratios
			-- We will add or subtract this from the base requirements calculated above
			-- But we will also multiply its effects, especially for more expensive units
			-- Carriers with CAGs are very expensive so we will apply a much larger multiplier!

			laNavalUnitNeed[1] = laNavalUnitNeed[1] + (2 * ((liTargetNavalUnits * laNavalRatio[1]) - laNavalUnitCount[1]))
			laNavalUnitNeed[2] = laNavalUnitNeed[2] + (2 * ((liTargetNavalUnits * laNavalRatio[2]) - laNavalUnitCount[2]))
			laNavalUnitNeed[3] = laNavalUnitNeed[3] + (2 * ((liTargetNavalUnits * laNavalRatio[3]) - laNavalUnitCount[3]))
			laNavalUnitNeed[4] = laNavalUnitNeed[4] + (3 * ((liTargetNavalUnits * laNavalRatio[4]) - laNavalUnitCount[4]))
			laNavalUnitNeed[5] = laNavalUnitNeed[5] + (2.5 * ((liTargetNavalUnits * laNavalRatio[5]) - laNavalUnitCount[5]))
			laNavalUnitNeed[6] = laNavalUnitNeed[6] + (3.5 * ((liTargetNavalUnits * laNavalRatio[6]) - laNavalUnitCount[6]))

			if ministerTagString == tagString then
				Utils.LUA_DEBUGOUT("laNavalUnitNeed[dd]: " .. tostring(laNavalUnitNeed[1]))
				Utils.LUA_DEBUGOUT("laNavalUnitNeed[ss]: " .. tostring(laNavalUnitNeed[2]))
				Utils.LUA_DEBUGOUT("laNavalUnitNeed[cc]: " .. tostring(laNavalUnitNeed[3]))
				Utils.LUA_DEBUGOUT("laNavalUnitNeed[bb]: " .. tostring(laNavalUnitNeed[4]))
				Utils.LUA_DEBUGOUT("laNavalUnitNeed[cvl]: " .. tostring(laNavalUnitNeed[5]))
				Utils.LUA_DEBUGOUT("laNavalUnitNeed[cv]: " .. tostring(laNavalUnitNeed[6]))
			end

			-- Just because we have existing units doesn't mean we can actually build them
			-- So we better check unit availability and also clear down any negatives as we go

			if lbDestroyer and laNavalUnitNeed[1] > 0 then
				laUnitNeeds[_DESTROYER_] = laNavalUnitNeed[1]
			end
			if lbSubmarine and laNavalUnitNeed[2] > 0 then
				laUnitNeeds[_SUBMARINE_] = laNavalUnitNeed[2]
			end
			-- Cruisers Elastic Random for Light and Heavy but leaning to Light
			if laNavalUnitNeed[3] > 0 then

				-- SSmith (19/05/2013)
				-- We need to split the production 3:1 between the cruiser types
			
				if lbLightCruiser and lbHeavyCruiser then
					liLightCruiserCount = prodArrayCounts[_LIGHT_CRUISER_] + currentArrayCounts[_LIGHT_CRUISER_]
					liHeavyCruiserCount = prodArrayCounts[_HEAVY_CRUISER_] + currentArrayCounts[_HEAVY_CRUISER_]
					if liLightCruiserCount <= (3 * liHeavyCruiserCount) then
						if math.mod(CCurrentGameState.GetAIRand(), 4) == 1 then
							laUnitNeeds[_HEAVY_CRUISER_] = laNavalUnitNeed[3]
						else
							laUnitNeeds[_LIGHT_CRUISER_] = laNavalUnitNeed[3]
						end
					else
						if math.mod(CCurrentGameState.GetAIRand(), 4) == 1 then
							laUnitNeeds[_LIGHT_CRUISER_] = laNavalUnitNeed[3]
						else
							laUnitNeeds[_HEAVY_CRUISER_] = laNavalUnitNeed[3]
						end
					end
				elseif lbLightCruiser then
					laUnitNeeds[_LIGHT_CRUISER_] = laNavalUnitNeed[3]
				elseif lbHeavyCruiser then
					laUnitNeeds[_HEAVY_CRUISER_] = laNavalUnitNeed[3]
				end
			end
			-- Capital ships, process one a time if need be
			if laNavalUnitNeed[4] > 0 then

				-- SSmith (19/05/2013)
				-- We won't set any technology restrictions
				-- And let's default to a 2:1 ratio in favour of battleships

				if lbBattlecruiser and lbBattleship then
					liBattlecruiserCount = prodArrayCounts[_BATTLECRUISER_] + currentArrayCounts[_BATTLECRUISER_]
					liBattleshipCount = prodArrayCounts[_BATTLESHIP_] + currentArrayCounts[_BATTLESHIP_]
					if liBattleshipCount <= (2 * liBattlecruiserCount) then
						if math.mod(CCurrentGameState.GetAIRand(), 4) == 1 then
							laUnitNeeds[_BATTLECRUISER_] = laNavalUnitNeed[4]
						else
							laUnitNeeds[_BATTLESHIP_] = laNavalUnitNeed[4]
						end
					else
						if math.mod(CCurrentGameState.GetAIRand(), 4) == 1 then
							laUnitNeeds[_BATTLESHIP_] = laNavalUnitNeed[4]
						else
							laUnitNeeds[_BATTLECRUISER_] = laNavalUnitNeed[4]
						end
					end
				elseif lbBattlecruiser then
					laUnitNeeds[_BATTLECRUISER_] = laNavalUnitNeed[4]
				elseif lbBattleship then
					laUnitNeeds[_BATTLESHIP_] = laNavalUnitNeed[4]
				end
			end

			if lbCAG then
				if lbLightCarrier and laNavalUnitNeed[5] > 0 then
					laUnitNeeds[_ESCORT_CARRIER_] = laNavalUnitNeed[5]
				end
				if lbCarrier and laNavalUnitNeed[6] > 0 then
					laUnitNeeds[_CARRIER_] = laNavalUnitNeed[6]
				end
			end			
			
			-- Calculate how many Transports are needed
			local liTotalTransports = (prodArrayCounts[_TRANSPORT_SHIP_] + currentArrayCounts[_TRANSPORT_SHIP_])
			local liTotalTransportsNeeded = math.ceil((liTotalLandUnits / laTransportLandRatio[1]) * laTransportLandRatio[2]) - liTotalTransports

			-- SSmith (20/05/2013)
			-- Use a multiplier to encourage the AI to satisfy the ratio
			-- Transports are cheap but important so we will give them a larger multiplier

			if liTotalTransportsNeeded > 0 then
				laUnitNeeds[_TRANSPORT_SHIP_] = 5.0 * liTotalTransportsNeeded
			end

			if ministerTagString == tagString then
				Utils.LUA_DEBUGOUT("liTotalTransports: " .. tostring(liTotalTransports))
				Utils.LUA_DEBUGOUT("liTotalTransportsNeeded: " .. tostring(laUnitNeeds[_TRANSPORT_SHIP_]))
			end

			-- SSmith (20/05/2013)
			-- The final step is to convert the naval forces needs to percentages

			local liNavalSum = laUnitNeeds[_DESTROYER_] + laUnitNeeds[_SUBMARINE_] + laUnitNeeds[_LIGHT_CRUISER_]
				+ laUnitNeeds[_HEAVY_CRUISER_] + laUnitNeeds[_BATTLESHIP_] + laUnitNeeds[_BATTLECRUISER_]
				+ laUnitNeeds[_ESCORT_CARRIER_] + laUnitNeeds[_CARRIER_] + laUnitNeeds[_TRANSPORT_SHIP_]
			if liNavalSum > 0 then
				laUnitNeeds[_DESTROYER_] = laUnitNeeds[_DESTROYER_] / liNavalSum
				laUnitNeeds[_SUBMARINE_] = laUnitNeeds[_SUBMARINE_] / liNavalSum
				laUnitNeeds[_LIGHT_CRUISER_] = laUnitNeeds[_LIGHT_CRUISER_] / liNavalSum
				laUnitNeeds[_HEAVY_CRUISER_] = laUnitNeeds[_HEAVY_CRUISER_] / liNavalSum
				laUnitNeeds[_BATTLESHIP_] = laUnitNeeds[_BATTLESHIP_] / liNavalSum
				laUnitNeeds[_BATTLECRUISER_] = laUnitNeeds[_BATTLECRUISER_] / liNavalSum
				laUnitNeeds[_ESCORT_CARRIER_] = laUnitNeeds[_ESCORT_CARRIER_] / liNavalSum
				laUnitNeeds[_CARRIER_] = laUnitNeeds[_CARRIER_] / liNavalSum
				laUnitNeeds[_TRANSPORT_SHIP_] = laUnitNeeds[_TRANSPORT_SHIP_] / liNavalSum
			end

			if ministerTagString == tagString then
				Utils.LUA_DEBUGOUT("Final Naval Needs...")
				Utils.LUA_DEBUGOUT("laUnitNeeds[dd]" .. tostring(laUnitNeeds[_DESTROYER_]))
				Utils.LUA_DEBUGOUT("laUnitNeeds[ss]" .. tostring(laUnitNeeds[_SUBMARINE_]))
				Utils.LUA_DEBUGOUT("laUnitNeeds[cl]" .. tostring(laUnitNeeds[_LIGHT_CRUISER_]))
				Utils.LUA_DEBUGOUT("laUnitNeeds[ca]" .. tostring(laUnitNeeds[_HEAVY_CRUISER_]))
				Utils.LUA_DEBUGOUT("laUnitNeeds[bb]" .. tostring(laUnitNeeds[_BATTLESHIP_]))
				Utils.LUA_DEBUGOUT("laUnitNeeds[bc]" .. tostring(laUnitNeeds[_BATTLECRUISER_]))
				Utils.LUA_DEBUGOUT("laUnitNeeds[cvl]" .. tostring(laUnitNeeds[_ESCORT_CARRIER_]))
				Utils.LUA_DEBUGOUT("laUnitNeeds[cv]" .. tostring(laUnitNeeds[_CARRIER_]))
				Utils.LUA_DEBUGOUT("laUnitNeeds[trp]" .. tostring(laUnitNeeds[_TRANSPORT_SHIP_]))
			end
		end
		
		-- Needs are calculated. Let's put our IC to some good use now!
		
		-- Used in each area to calculate local costs
		local liNewICCount
		
		-- Build Land Units

		if ministerTagString == tagString then
			Utils.LUA_DEBUGOUT("Building land units...")
		end

		if liNeededLandIC > 0 then
			liNewICCount = BuildLandUnits(liNeededLandIC, minister, false)
			ic = ic - (liNeededLandIC - liNewICCount)
			liNeededLandIC = liNewICCount
		else
			liNeededLandIC = 0
		end
		
		-- Build Air Units

		if ministerTagString == tagString then
			Utils.LUA_DEBUGOUT("liNeededLandIC: " .. tostring(liNeededLandIC))
			Utils.LUA_DEBUGOUT("Building air units...")
		end

		if liNeededAirIC > 0 then
			liNewICCount = BuildAirUnits(liNeededAirIC, minister, false)
			ic = ic - (liNeededAirIC - liNewICCount)
			liNeededAirIC = liNewICCount
		else
			liNeededAirIC = 0
		end
		
		-- Build Naval Units

		if ministerTagString == tagString then
			Utils.LUA_DEBUGOUT("liNeededAirIC: " .. tostring(liNeededAirIC))
			Utils.LUA_DEBUGOUT("Building convoys...")
		end

		if liNeededNavalIC > 0 then
		
			-- SSmith (20/05/2013)
			-- Let's only allow convoys to consume 35% of the naval budget!

			-- Build some more Convoys and Escorts if we need to!
			local icForConvoys = liNeededNavalIC * 0.35		-- Only build Convoys and Escorts from 35% of the IC meant for the Navy
			liNeededNavalIC = liNeededNavalIC - icForConvoys	-- Subtract the amount we would like to spend on Convoys
			-- Build what we need
			icForConvoys = ConstructConvoys(ai, minister, ministerTag, ministerCountry, icForConvoys )
			liNeededNavalIC = liNeededNavalIC + icForConvoys	-- Add back what we didn't spend on Convoys
			
			if ministerTagString == tagString then
				Utils.LUA_DEBUGOUT("liNeededNavalIC: " .. tostring(liNeededNavalIC))
				Utils.LUA_DEBUGOUT("Building naval units...")
			end

			liNewICCount = BuildNavalUnits(liNeededNavalIC, minister, false)
			ic = ic - (liNeededNavalIC - liNewICCount)
			liNeededNavalIC = liNewICCount
		else
			liNeededNavalIC = 0
		end

		if ministerTagString == tagString then
			Utils.LUA_DEBUGOUT("liNeededNavalIC: " .. tostring(liNeededNavalIC))
			Utils.LUA_DEBUGOUT("Building other...")
		end

		-- Build Other (additional Convoys and Buildings)
		if liNeededOtherIC > 0 then
			liNewICCount = BuildOtherUnits(liNeededOtherIC, ai, minister, ministerTag, ministerCountry, false)
			ic = ic - (liNeededOtherIC - liNewICCount)
			liNeededOtherIC = liNewICCount
		else
			liNeededOtherIC = 0
		end

		if ministerTagString == tagString then
			Utils.LUA_DEBUGOUT("liNeededOtherIC: " .. tostring(liNeededOtherIC))
			Utils.LUA_DEBUGOUT("Building leftovers...")
		end
				
		-- Now if we have IC still left try and find someplace to use it, but still don't go over the available IC!
		if ic > 1 then
			if liNeededOtherIC > liNeededAirIC and liNeededOtherIC > liNeededNavalIC and liNeededOtherIC > liNeededLandIC then	
				ic = BuildOtherUnits(ic, ai, minister, ministerTag, ministerCountry, false)
			elseif liNeededNavalIC > liNeededAirIC and liNeededNavalIC > liNeededLandIC and liNeededNavalIC > liNeededOtherIC then
				ic = BuildNavalUnits(ic, minister, false)
			elseif liNeededAirIC > liNeededLandIC and liNeededAirIC > liNeededNavalIC and liNeededAirIC > liNeededOtherIC then
				ic = BuildAirUnits(ic, minister, false)
			elseif liNeededLandIC > liNeededAirIC and liNeededLandIC > liNeededNavalIC and liNeededLandIC > liNeededOtherIC then
				ic = BuildLandUnits(ic, minister, false)
			end
					
			-- Last chance to use the IC
			if ic > 1 then
				ic = BuildLandUnits(ic, minister, true)
				if ic > 1 then
					ic = BuildAirUnits(ic, minister, true)
					if ic > 1 then
						ic = BuildNavalUnits(ic, minister, true)
						-- Don't use excess IC on buildings because it will screw up the build plans! (Because buildings don't have 'need arrays'.)
						-- if ic > 1 then
							-- ic = BuildOtherUnits(ic, ai, minister, ministerTag, ministerCountry, true)
						-- end
					end
				end
			end
		end
		
	else	-- We don't have enough Manpower or Officers to build any units. Let's build Buildings instead!
		ic = BuildOtherUnits(ic, ai, minister, ministerTag, ministerCountry, true)
	end

	--Utils.LUA_DEBUGOUT("ManageProduction ending: " .. ministerTagString)
end

-- #######################
-- Helper Build Methods
-- #######################
function BuildLandUnits(ic, minister, vbGoOver)

	if ( not Utils.ASSERT( ic ) )
	or ( not Utils.ASSERT( minister ) )
	or ( not Utils.ASSERT( vbGoOver ) )
	then
		return 0
	end

	-- Setup Attachment Brigade arrays

	local tagString = "XXX"
	--if tostring(minister:GetCountryTag()) == tagString then
	--	Utils.LUA_DEBUGOUT("")
	--	Utils.LUA_DEBUGOUT("BuildLandUnits: " .. tostring(minister:GetCountryTag()))
	--end

	local ministerCountry = minister:GetCountry()
	local totalIC = ministerCountry:GetTotalIC()
	local extendedDivision = minister:GetCountry():GetTechnologyStatus():GetLevel(CTechnologyDataBase.GetTechnology("fifth_brigade"))

	local GarrisonUnitArray = Utils.BuildGarrisonUnitArray(ministerCountry)
	local DefenceGarrisonUnitArray = Utils.BuildDefenceGarrisonUnitArray(ministerCountry)
	local LegUnitArray = Utils.BuildLegUnitArray(ministerCountry)
	local MotorizedUnitArray = Utils.BuildMotorizedUnitArray(ministerCountry)
	local ArmorUnitArray = Utils.BuildArmorUnitArray(ministerCountry)

	-- SSmith (21/05/2013)
	-- The main production function has been re-worked to produced a percentage-based array of unit needs
	-- This function will therefore be changed to implement those calculations
	-- First we will create an indexer array to hold pointers to our units

	if tostring(minister:GetCountryTag()) == tagString then
		Utils.LUA_DEBUGOUT("Creating indexer array...")
	end

	local laIndexer = {_GARRISON_BRIGADE_, _INFANTRY_BRIGADE_, _MOTORIZED_BRIGADE_, _MECHANIZED_BRIGADE_, _LIGHT_ARMOR_BRIGADE_, _ARMOR_BRIGADE_,
		_MILITIA_BRIGADE_, _CAVALRY_BRIGADE_, _BERGSJAEGER_BRIGADE_, _MARINE_BRIGADE_, _PARATROOPER_BRIGADE_};

	-- We will loop through our main code once for each element in the indexer array

	--if tostring(minister:GetCountryTag()) == tagString then
	--	Utils.LUA_DEBUGOUT("Looping...")
	--end

	local liUnitIndex = 0
	local liUnitType = 0
	local icLand = ic
	local icUnit = 0
	local icTemp = 0

	for pass = 1, table.getn(laIndexer) do

		-- The first task is to find the unit type with the highest need

		--if tostring(minister:GetCountryTag()) == tagString then
		--	Utils.LUA_DEBUGOUT("Getting unit index...")
		--	--liUnitIndex = GetMostImportantGer(laIndexer)
		--end

		liUnitIndex = GetMostImportant(laIndexer)

		if liUnitIndex > 0 and ic > 0.2 then

			-- We have found the most needed unit type and we still have some IC available
			-- Now allocate the percentage of IC for this unit type and build some units

			liUnitType = laIndexer[liUnitIndex]
			icUnit = math.min((icLand * laUnitNeeds[liUnitType]), ic)

			if tostring(minister:GetCountryTag()) == tagString then
				Utils.LUA_DEBUGOUT("")
				Utils.LUA_DEBUGOUT("BuildLandUnits: " .. tostring(minister:GetCountryTag()))
				Utils.LUA_DEBUGOUT("liUnitType: " .. tostring(liUnitType))
				Utils.LUA_DEBUGOUT("laUnitNeeds[]: " .. tostring(laUnitNeeds[liUnitType]))
				Utils.LUA_DEBUGOUT("ic: " .. tostring(ic))
				Utils.LUA_DEBUGOUT("icUnit: " .. tostring(icUnit))
			end

			if liUnitType == _GARRISON_BRIGADE_ then
				if math.random(100) > 66 then
					icTemp = BuildUnit(ic, icUnit, minister, _GARRISON_BRIGADE_, 0, "garrison_brigade", 2, GarrisonUnitArray, 1, "Build_Garrison", vbGoOver)
				else
					icTemp = BuildUnit(ic, icUnit, minister, _GARRISON_BRIGADE_, 0, "garrison_brigade", 2, DefenceGarrisonUnitArray, 1, "Build_Garrison", vbGoOver)
				end
			elseif liUnitType == _INFANTRY_BRIGADE_ then
				-- Only add support brigades for mediums and upwards!
				if totalIC < 15 then
					icTemp = BuildUnit(ic, icUnit, minister, _INFANTRY_BRIGADE_, 0, "infantry_brigade", 3, {}, 0, "Build_Infantry", vbGoOver)
				-- Handles Superior Firepower and give some variation to infantry division sizes
				elseif extendedDivision > 0 then
					-- 3 infantry and 2 Support
					icTemp = BuildUnit(ic, icUnit, minister, _INFANTRY_BRIGADE_, 0, "infantry_brigade", 3, LegUnitArray, 2, "Build_Infantry", vbGoOver)
				else
					-- 3 infantry and 1 Support
					icTemp = BuildUnit(ic, icUnit, minister, _INFANTRY_BRIGADE_, 0, "infantry_brigade", 3, LegUnitArray, 1, "Build_Infantry", vbGoOver)
				end
			elseif liUnitType == _MOTORIZED_BRIGADE_ then
				icTemp = BuildUnit(ic, icUnit, minister, _MOTORIZED_BRIGADE_, 0, "motorized_brigade", 3, MotorizedUnitArray, 1, "Build_Motorized", vbGoOver)
			elseif liUnitType == _MECHANIZED_BRIGADE_ then
				icTemp = BuildUnit(ic, icUnit, minister, _MECHANIZED_BRIGADE_, 0, "mechanized_brigade", 3, MotorizedUnitArray, 1, "Build_Mechanized", vbGoOver)
			elseif liUnitType == _LIGHT_ARMOR_BRIGADE_ then
				icTemp = BuildUnit(ic, icUnit, minister, _LIGHT_ARMOR_BRIGADE_,0, "light_armor_brigade", 2, ArmorUnitArray, 1, "Build_LightArmor", vbGoOver)
			elseif liUnitType == _ARMOR_BRIGADE_ then
				icTemp = BuildUnit(ic, icUnit, minister, _ARMOR_BRIGADE_, 0, "armor_brigade", 2, ArmorUnitArray, 1, "Build_Armor", vbGoOver)
			elseif liUnitType == _MILITIA_BRIGADE_ then
				icTemp = BuildUnit(ic, icUnit, minister, _MILITIA_BRIGADE_, 0, "militia_brigade", 3, {}, 0, "Build_Militia", vbGoOver)
			elseif liUnitType == _CAVALRY_BRIGADE_ then
				icTemp = BuildUnit(ic, icUnit, minister, _CAVALRY_BRIGADE_, 0, "cavalry_brigade", 2, {}, 0, "Build_Cavalry", vbGoOver)
			elseif liUnitType == _BERGSJAEGER_BRIGADE_ then
				icTemp = BuildUnit(ic, icUnit, minister, _BERGSJAEGER_BRIGADE_, 0, "bergsjaeger_brigade", 3, {}, 0, "Build_Mountain", vbGoOver)
			elseif liUnitType == _MARINE_BRIGADE_ then
				icTemp = BuildUnit(ic, icUnit, minister, _MARINE_BRIGADE_, 0, "marine_brigade", 3, {}, 0, "Build_Marine", vbGoOver)
			elseif liUnitType == _PARATROOPER_BRIGADE_ then
				icTemp = BuildUnit(ic, icUnit, minister, _PARATROOPER_BRIGADE_, 0, "paratrooper_brigade", 3, {}, 0, "Build_Paratrooper", vbGoOver)
			end

			-- If we managed to spend anything then zero this unit requirement
			-- Update the current IC available
			-- Clear down the indexer so that we don't try this unit again in this run

			if icTemp < icUnit then
				laUnitNeeds[liUnitType] = 0
			end				
			ic = ic - icUnit + icTemp
			laIndexer[liUnitIndex] = 0

			if tostring(minister:GetCountryTag()) == tagString then
				Utils.LUA_DEBUGOUT("icUnit: " .. tostring(icUnit))
				Utils.LUA_DEBUGOUT("icTemp: " .. tostring(icTemp))
				Utils.LUA_DEBUGOUT("ic: " .. tostring(ic))
			end
		end

	end

	return ic
end

function BuildAirUnits(ic, minister, vbGoOver)

	if ( not Utils.ASSERT( ic ) )
	or ( not Utils.ASSERT( minister ) )
	or ( not Utils.ASSERT( vbGoOver ) )
	then
		return 0
	end

	-- Check if we can build jets
	local ministerTech = minister:GetCountry():GetTechnologyStatus()
	local Jet_Int = ministerTech:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("jet_int"))
	local Jet_MR = ministerTech:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("jet_mr"))
	local Jet_Bomber = ministerTech:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("jet_bomber"))

	-- SSmith (21/05/2013)
	-- The main production function has been re-worked to produced a percentage-based array of unit needs
	-- This function will therefore be changed to implement those calculations
	-- First we will create an indexer array to hold pointers to our units

	local laIndexer = {_INTERCEPTOR_, _MULTI_ROLE_, _CAS_, _TACTICAL_BOMBER_, _NAVAL_BOMBER_,
		_STRATEGIC_BOMBER_, _TRANSPORT_PLANE_, _CAG_};

	-- We will loop through our main code once for each element in the indexer array

	local liUnitIndex = 0
	local liUnitType = 0
	local icAir = ic
	local icUnit = 0
	local icTemp = 0

	for pass = 1, table.getn(laIndexer) do

		-- The first task is to find the unit type with the highest need

		liUnitIndex = GetMostImportant(laIndexer)

		if liUnitIndex > 0 and ic > 0.2 then

			-- We have found the most needed unit type and we still have some IC available
			-- Now allocate the percentage of IC for this unit type and build some units

			liUnitType = laIndexer[liUnitIndex]
			icUnit = math.min((icAir * laUnitNeeds[liUnitType]), ic)

			local tagString = "XXX"
			if tostring(minister:GetCountryTag()) == tagString then
				Utils.LUA_DEBUGOUT("")
				Utils.LUA_DEBUGOUT("BuildAirUnits: " .. tostring(minister:GetCountryTag()))
				Utils.LUA_DEBUGOUT("liUnitType: " .. tostring(liUnitType))
				Utils.LUA_DEBUGOUT("laUnitNeeds[]: " .. tostring(laUnitNeeds[liUnitType]))
				Utils.LUA_DEBUGOUT("ic: " .. tostring(ic))
				Utils.LUA_DEBUGOUT("icUnit: " .. tostring(icUnit))
			end

			if liUnitType == _INTERCEPTOR_ then
				if Jet_Int and math.mod(CCurrentGameState.GetAIRand(), 2) == 1 then
					icTemp = BuildUnit(ic, icUnit, minister, _INTERCEPTOR_, 0, "jet_int", 1, {}, 0, "Build_JetInterceptor", vbGoOver)
				else
					icTemp = BuildUnit(ic, icUnit, minister, _INTERCEPTOR_, 0, "interceptor", 1, {}, 0, "Build_Interceptor", vbGoOver)
				end
			elseif liUnitType == _MULTI_ROLE_ then
				if Jet_MR and math.mod(CCurrentGameState.GetAIRand(), 2) == 1 then
					icTemp = BuildUnit(ic, icUnit, minister, _MULTI_ROLE_, 0, "jet_mr", 1, {}, 0, "Build_JetMultiRole", vbGoOver)
				else
					icTemp = BuildUnit(ic, icUnit, minister, _MULTI_ROLE_, 0, "multi_role", 1, {}, 0, "Build_MultiRole", vbGoOver)
				end
			elseif liUnitType == _CAS_ then
				icTemp = BuildUnit(ic, icUnit, minister, _CAS_, 0, "cas", 1, {}, 0, "Build_CAS", vbGoOver)
			elseif liUnitType == _TACTICAL_BOMBER_ then
				if Jet_Bomber and math.mod(CCurrentGameState.GetAIRand(), 2) == 1 then
					icTemp = BuildUnit(ic, icUnit, minister, _TACTICAL_BOMBER_, 0, "jet_bomber", 1, {}, 0, "Build_JetBomber", vbGoOver)
				else
					icTemp = BuildUnit(ic, icUnit, minister, _TACTICAL_BOMBER_, 0, "tactical_bomber", 1, {}, 0, "Build_TacBomber", vbGoOver)
				end
			elseif liUnitType == _NAVAL_BOMBER_ then
				icTemp = BuildUnit(ic, icUnit, minister, _NAVAL_BOMBER_, 0, "naval_bomber", 1, {}, 0, "Build_NavBomber", vbGoOver)
			elseif liUnitType == _STRATEGIC_BOMBER_ then
				icTemp = BuildUnit(ic, icUnit, minister, _STRATEGIC_BOMBER_, 0, "strategic_bomber", 1, {}, 0, "Build_StrategicBomber", vbGoOver)
			elseif liUnitType == _TRANSPORT_PLANE_ then
				icTemp = BuildUnit(ic, icUnit, minister, _TRANSPORT_PLANE_, 0, "transport_plane", 1, {}, 0, "Build_TransportPlane", vbGoOver)
			elseif liUnitType == _CAG_ then
				icTemp = BuildUnit(ic, icUnit, minister, _CAG_, 0, "cag", 1, {}, 0, "Build_CAG", vbGoOver)
			--elseif liUnitType == _FLYING_BOMB_ then
			--	icTemp = BuildUnit(ic, icUnit, minister, _FLYING_BOMB_, 4, "flying_bomb", 1, {}, 0, "Build_FlyingBomb", vbGoOver)
			--elseif liUnitType == _FLYING_ROCKET_ then
			--	icTemp = BuildUnit(ic, icUnit, minister, _FLYING_ROCKET_, 4, "flying_rocket", 1, {}, 0, "Build_FlyingRocket", vbGoOver)
			end

			-- If we managed to spend anything then zero this unit requirement
			-- Update the current IC available
			-- Clear down the indexer so that we don't try this unit again in this run

			if icTemp < icUnit then
				laUnitNeeds[liUnitType] = 0
			end				
			ic = ic - icUnit + icTemp
			laIndexer[liUnitIndex] = 0

			if tostring(minister:GetCountryTag()) == tagString then
				Utils.LUA_DEBUGOUT("icUnit: " .. tostring(icUnit))
				Utils.LUA_DEBUGOUT("icTemp: " .. tostring(icTemp))
				Utils.LUA_DEBUGOUT("ic: " .. tostring(ic))
			end
		end

	end
	
	return ic
end

function BuildNavalUnits(ic, minister, vbGoOver)

	if ( not Utils.ASSERT( ic ) )
	or ( not Utils.ASSERT( minister ) )
	or ( not Utils.ASSERT( vbGoOver ) )
	then
		return 0
	end

	-- SSmith (21/05/2013)
	-- The main production function has been re-worked to produced a percentage-based array of unit needs
	-- This function will therefore be changed to implement those calculations
	-- First we will create an indexer array to hold pointers to our units

	local laIndexer = {_DESTROYER_, _SUBMARINE_, _LIGHT_CRUISER_, _HEAVY_CRUISER_, _BATTLESHIP_,
		_BATTLECRUISER_, _ESCORT_CARRIER_, _CARRIER_, _TRANSPORT_SHIP_};

	-- We will loop through our main code once for each element in the indexer array

	local liUnitIndex = 0
	local liUnitType = 0
	local icNaval = ic
	local icUnit = 0
	local icTemp = 0

	for pass = 1, table.getn(laIndexer) do

		-- The first task is to find the unit type with the highest need

		liUnitIndex = GetMostImportant(laIndexer)

		if liUnitIndex > 0 and ic > 0.2 then

			-- We have found the most needed unit type and we still have some IC available
			-- Now allocate the percentage of IC for this unit type and build some units

			liUnitType = laIndexer[liUnitIndex]
			icUnit = math.min((icNaval * laUnitNeeds[liUnitType]), ic)

			local tagString = "XXX"
			if tostring(minister:GetCountryTag()) == tagString then
				Utils.LUA_DEBUGOUT("")
				Utils.LUA_DEBUGOUT("BuildNavalUnits: " .. tostring(minister:GetCountryTag()))
				Utils.LUA_DEBUGOUT("liUnitType: " .. tostring(liUnitType))
				Utils.LUA_DEBUGOUT("laUnitNeeds[]: " .. tostring(laUnitNeeds[liUnitType]))
				Utils.LUA_DEBUGOUT("ic: " .. tostring(ic))
				Utils.LUA_DEBUGOUT("icUnit: " .. tostring(icUnit))
			end

			if liUnitType == _DESTROYER_ then
				icTemp = BuildUnit(ic, icUnit, minister, _DESTROYER_, 0, "destroyer", 1, {}, 0, "Build_Destroyer", vbGoOver)
			elseif liUnitType == _SUBMARINE_ then
				icTemp = BuildUnit(ic, icUnit, minister, _SUBMARINE_, 0, "submarine", 1, {}, 0, "Build_Submarine", vbGoOver)
			elseif liUnitType == _LIGHT_CRUISER_ then
				icTemp = BuildUnit(ic, icUnit, minister, _LIGHT_CRUISER_, 0, "light_cruiser", 1, {}, 0, "Build_LightCruiser", vbGoOver)
			elseif liUnitType == _HEAVY_CRUISER_ then
				icTemp = BuildUnit(ic, icUnit, minister, _HEAVY_CRUISER_, 0, "heavy_cruiser", 1, {}, 0, "Build_HeavyCruiser", vbGoOver)
			elseif liUnitType == _BATTLESHIP_ then
				icTemp = BuildUnit(ic, icUnit, minister, _BATTLESHIP_, 0, "battleship", 1, {}, 0, "Build_Battleship", vbGoOver)
			elseif liUnitType == _BATTLECRUISER_ then
				icTemp = BuildUnit(ic, icUnit, minister, _BATTLECRUISER_, 0, "battlecruiser", 1, {}, 0, "Build_Battlecruiser", vbGoOver)
			elseif liUnitType == _ESCORT_CARRIER_ then
				icTemp = BuildUnit(ic, icUnit, minister, _ESCORT_CARRIER_, 0, "escort_carrier", 1, {}, 0, "Build_EscortCarrier", vbGoOver)
			elseif liUnitType == _CARRIER_ then
				icTemp = BuildUnit(ic, icUnit, minister, _CARRIER_, 0, "carrier", 1, {}, 0, "Build_Carrier", vbGoOver)
			elseif liUnitType == _TRANSPORT_SHIP_ then
				icTemp = BuildUnit(ic, icUnit, minister, _TRANSPORT_SHIP_, 0, "transport_ship", 1, {}, 0, "Build_Transport", vbGoOver)
			end

			-- If we managed to spend anything then zero this unit requirement
			-- Update the current IC available
			-- Clear down the indexer so that we don't try this unit again in this run

			if icTemp < icUnit then
				laUnitNeeds[liUnitType] = 0
			end				
			ic = ic - icUnit + icTemp
			laIndexer[liUnitIndex] = 0

			if tostring(minister:GetCountryTag()) == tagString then
				Utils.LUA_DEBUGOUT("icUnit: " .. tostring(icUnit))
				Utils.LUA_DEBUGOUT("icTemp: " .. tostring(icTemp))
				Utils.LUA_DEBUGOUT("ic: " .. tostring(ic))
			end

		end

	end
	
	return ic
end

function BuildOtherUnits(ic, ai, minister, ministerTag, ministerCountry, vbGoOver)

	if ( not Utils.ASSERT( ic ) )
	or ( not Utils.ASSERT( ai ) )
	or ( not Utils.ASSERT( minister ) )
	or ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( ministerCountry ) )
	or ( not Utils.ASSERT( vbGoOver ) )
	then
		return 0
	end

	if minister:GetCountry():GetNumOfPorts() > 0 then
		ic = ConstructConvoys(ai, minister, ministerTag, ministerCountry, ic )
	end
	
	ic = ConstructBuildings(ai, minister, ministerTag, ministerCountry, ic, vbGoOver )

	return ic
end

function BuildUnit(ic, icUnit, minister, viUnitIndex, viMaxSerial, vsType, viDivSize, voAttachUnitArray, viBrigadeCount, vsMethodOveride, vbGoOver)
	-- Only build one unit (Division) at a time, this function will loop over and over until we run out of IC

	if ( not Utils.ASSERT( ic ) )
	or ( not Utils.ASSERT( icUnit ) )
	or ( not Utils.ASSERT( minister ) )
	or ( not Utils.ASSERT( viUnitIndex ) )
	or ( not Utils.ASSERT( viMaxSerial ) )
	or ( not Utils.ASSERT( vsType ) )
	or ( not Utils.ASSERT( viDivSize ) )
	or ( not Utils.ASSERT( voAttachUnitArray ) )
	or ( not Utils.ASSERT( viBrigadeCount ) )
	or ( not Utils.ASSERT( vsMethodOveride ) )
	or ( not Utils.ASSERT( vbGoOver ) )
	then
		return 0
	end

	-- SSmith (21/05/2013)
	-- This function will no longer handle a single unit at a time but will instead use up all the available IC allocation
	-- It is still restricted by the total IC limit but is always allowed to go over the specific unit allocation
	-- All we need to pass to the called functions is the upper limit

	local tagString = "XXX"
	if tostring(minister:GetCountryTag()) == tagString then
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("BuildUnit: " .. tostring(minister:GetCountryTag()))
		Utils.LUA_DEBUGOUT("ic: " .. tostring(ic))
		Utils.LUA_DEBUGOUT("icUnit: " .. tostring(icUnit))
		Utils.LUA_DEBUGOUT("viUnitIndex: " .. tostring(viUnitIndex))
	end

	local icBefore
	local canBuild = (icUnit > 0.2)

	if tostring(minister:GetCountryTag()) == tagString then
		Utils.LUA_DEBUGOUT("canBuild: " .. tostring(canBuild))
	end

	while canBuild do
		icBefore = ic

		if tostring(minister:GetCountryTag()) == tagString then
			Utils.LUA_DEBUGOUT("icBefore: " .. tostring(icBefore))
		end

		-- Check to see if the Country AI file has an override
		if Utils.HasCountryAIFunction(minister:GetCountryTag(), vsMethodOveride) then
			ic = Utils.CallCountryAI(minister:GetCountryTag(), vsMethodOveride, ic, minister, viDivSize, vbGoOver)
		elseif table.getn(voAttachUnitArray) == 0 then
			ic = Utils.CreateDivision_nominor(minister, vsType, viMaxSerial, ic, viDivSize, viDivSize, vbGoOver)
		else
			ic = Utils.CreateDivision(minister, vsType, viMaxSerial, ic, viDivSize, viDivSize, voAttachUnitArray, viBrigadeCount, vbGoOver)
		end

		icUnit = icUnit - icBefore + ic
		canBuild = (ic < icBefore) and (icUnit > 0.2)

		if tostring(minister:GetCountryTag()) == tagString then
			Utils.LUA_DEBUGOUT("icUnit: " .. tostring(icUnit))
			Utils.LUA_DEBUGOUT("ic: " .. tostring(ic))
			Utils.LUA_DEBUGOUT("canBuild: " .. tostring(canBuild))
		end
	end
	
	return icUnit
end

-- Determines how many units are there within the given range
function GetUnitCount(viStart, viEnd, vaProdCounts, vaCurrentCounts)

	if ( not Utils.ASSERT( viStart ) )
	or ( not Utils.ASSERT( viEnd ) )
	or ( not Utils.ASSERT( vaProdCounts ) )
	or ( not Utils.ASSERT( vaCurrentCounts ) )
	then
		return 0
	end

	local UnitCount = 0
	-- math.max is used cause its possible an item can be nil
	while viStart <= viEnd do
		UnitCount = UnitCount + vaProdCounts[viStart] + vaCurrentCounts[viStart]
		viStart = viStart + 1
	end
	return UnitCount
end

-- Determines which unit is in the highest demand from the given range
function GetMostImportant(vaArray)

	if ( not Utils.ASSERT( vaArray ) )
	then
		return 0
	end

	-- SSmith (21/05/2013)
	-- This function has been re-worked for use by the new production logic
	-- It will find the index of the unit type with the highest requirement

	local liUnitIndex = 0
	local liMaxNeed = 0

	-- The first task is to find the unit type with the highest need

	for i = 1, table.getn(vaArray) do
		if vaArray[i] > 0 then
			if laUnitNeeds[vaArray[i]] > liMaxNeed then
				liUnitIndex = i
				liMaxNeed = laUnitNeeds[vaArray[i]]
			end
		end
	end

	return liUnitIndex
end

function GetMostImportantGer(vaArray)

	if ( not Utils.ASSERT( vaArray ) )
	then
		return 0
	end

	Utils.LUA_DEBUGOUT("GetMostImportant starting...")	

	-- SSmith (21/05/2013)
	-- This function has been re-worked for use by the new production logic
	-- It will find the index of the unit type with the highest requirement

	local liUnitIndex = 0
	local liMaxNeed = 0

	-- The first task is to find the unit type with the highest need

	Utils.LUA_DEBUGOUT("Count: " .. tostring(table.getn(vaArray)))

	for i = 1, table.getn(vaArray) do

		Utils.LUA_DEBUGOUT("i: " .. tostring(i))
		Utils.LUA_DEBUGOUT("vaArray[i]: " .. tostring(vaArray[i]))
		Utils.LUA_DEBUGOUT("liMaxNeed: " .. tostring(liMaxNeed))
		Utils.LUA_DEBUGOUT("liUnitIndex: " .. tostring(liUnitIndex))
		Utils.LUA_DEBUGOUT("laUnitNeeds[vaArray[i]]: " .. tostring(laUnitNeeds[vaArray[i]]))

		if laUnitNeeds[vaArray[i]] > liMaxNeed then
			liUnitIndex = vaArray[i]
			liMaxNeed = laUnitNeeds[vaArray[i]]
		end
	end

	Utils.LUA_DEBUGOUT("GetMostImportant ending...")

	return liUnitIndex
end

-- Converts the Unit ratio to a % based number. If there
--   are 0 units but a Ratio exists then it will set it to 1.
 function CalculateRatio(viUnitCount, viUnitRatio)

	if ( not Utils.ASSERT( viUnitCount ) )
	or ( not Utils.ASSERT( viUnitRatio ) )
	then
		return 0
	end

	local rValue
	
	if viUnitRatio == 0 then
		rValue = 0
	elseif viUnitCount == 0 then
		rValue = 1
	else
		rValue = viUnitCount / viUnitRatio
	end
	
	return rValue
end

-- Returns the correctly build ratio array
function GetBuildRatio(minister, ministerTag, vbNaval, vsType)

	if ( not Utils.ASSERT( minister ) )
	or ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( vbNaval ) )
	or ( not Utils.ASSERT( vsType ) )
	then
		return {}
	end

	-- SSmith (25/05/2013)
	-- The new production logic handles all the factors we need
	-- We therefore don't need two default production ratios
	-- So we will always use the DefaultProdLand if we don't have a country override

	if Utils.HasCountryAIFunction(ministerTag, vsType) then
		return Utils.CallCountryAI(ministerTag, vsType, minister)
	else
		return DefaultProdLand[vsType]( minister )

		--if vbNaval then
		--	return DefaultProdMix[vsType]( minister )
		--else
		--	return DefaultProdLand[vsType]( minister )	
		--end					
	end		
end

function GetPercentageRatio(vaArray)

	if not Utils.ASSERT(vaArray) then
		return {}
	end

	-- SSmith (19/05/2013)
	-- This function will convert the input array to percentages

	local total = 0
	for i = 1, table.getn(vaArray) do
		total = total + vaArray[i]
	end
	if total > 0 then
		for i = 1, table.getn(vaArray) do
			vaArray[i] = vaArray[i] / total
		end
	end

	return vaArray

end

function GetMultiplier(vaArray)

	if ( not Utils.ASSERT( vaArray ) )
	or table.getn(vaArray) < 2
	then	-- Overindexing an array is not the best idea
		return 0
	end

	local i = 2
	local liMultiplier = vaArray[1]
	
	while i <= table.getn(vaArray) do
		if liMultiplier < vaArray[i] then
			liMultiplier = vaArray[i]
		end
		i = i + 1
	end
	
	return liMultiplier
end
-- #######################
-- End of Helper Build Methods
-- #######################

-- #######################
-- Building Construction
-- #######################
function ConstructBuildings(ai, minister, ministerTag, ministerCountry, ic, vbGoOver)

	if ( not Utils.ASSERT( ai ) )
	or ( not Utils.ASSERT( minister ) )
	or ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( ministerCountry ) )
	or ( not Utils.ASSERT( ic ) )
	or ( not Utils.ASSERT( vbGoOver ) )
	then
		return 0
	end

	-- Buildings
	if ic > 0.2 then
		local lbProvinceCheck = false
		local laCorePrv = {}
		local liRocketCap = 5		-- We don't want to build any more than that combined
		local liReactorCap = 5		-- We don't want to build any more than that combined
		local loTechStatus = ministerCountry:GetTechnologyStatus()

		-- Set Province Checker <- Some things should mainly be built at war, others mainly at peace.
		if ministerCountry:IsAtWar() then
			if (math.random(100) > 80) then	-- 20% chance build our economy
				lbProvinceCheck = true
				laCorePrv = CoreProvincesLoop(ministerCountry, loTechStatus, liRocketCap, liReactorCap)
			end
		else
			--if (math.random(100) > 20) then	-- 80% chance build our economy
				lbProvinceCheck = true
				laCorePrv = CoreProvincesLoop(ministerCountry, loTechStatus, liRocketCap, liReactorCap)
			--end
		end
		
		-- Produce buildings until your out of IC that has been allocated
		--   Never have more than 1 rocket site or nuclear reactor
		local lbExit = false
		local liLoopCheck = 0
		
		while not ( lbExit ) do
			local coastal_fort = CBuildingDataBase.GetBuilding("coastal_fort" )
			local land_fort = CBuildingDataBase.GetBuilding( "land_fort" )
			local anti_air = CBuildingDataBase.GetBuilding("anti_air" )
			local industry = CBuildingDataBase.GetBuilding("industry" )
			local radar_station = CBuildingDataBase.GetBuilding("radar_station" )
			local nuclear_reactor = CBuildingDataBase.GetBuilding("nuclear_reactor" )
			local rocket_test = CBuildingDataBase.GetBuilding("rocket_test" )
			local infra = CBuildingDataBase.GetBuilding("infra")
			local air_base = CBuildingDataBase.GetBuilding("air_base")

			-- Nuclear Reactors stations
			if ic > 0.2 and loTechStatus:IsBuildingAvailable(nuclear_reactor)
			and lbProvinceCheck
			and ministerCountry:GetTotalIC() > 300
			then
				if Utils.HasCountryAIFunction( ministerTag, "Build_NuclearReactor" ) then
					ic = Utils.CallCountryAI( ministerTag, "Build_NuclearReactor", ic, minister, vbGoOver )
				elseif Utils.HasCountryAIFunction( ministerTag, "DontBuildBuilding" )
				and Utils.CallCountryAI( ministerTag, "DontBuildBuilding", minister, nuclear_reactor )
				then
					-- SKIP
				else
					if laCorePrv[ 2 ] < liReactorCap then
						local nuclear_reactorCost = ministerCountry:GetBuildCost( nuclear_reactor ):Get()
						
						if ( ic - nuclear_reactorCost ) >= 0 or vbGoOver then
							if table.getn( laCorePrv[ 5 ] ) > 0 then
								local reactorSite = laCorePrv[ 5 ][ math.random( table.getn( laCorePrv[ 5 ] ) ) ]
								if ministerCountry:GetTotalCoreBuildingLevels( nuclear_reactor:GetIndex() ):Get() > 0 then
									-- If we do have a Reactor already, then find it and build it up!
									for provinceId in ministerCountry:GetCoreProvinces() do
										local province = CCurrentGameState.GetProvince(provinceId)
										local provinceBuilding = province:GetBuilding(nuclear_reactor)
										if provinceBuilding:GetMax():Get() > 0 then
											reactorSite = provinceId
											break
										end
									end
								end
								
								if CCurrentGameState.GetProvince( reactorSite ):GetCurrentConstructionLevel( nuclear_reactor ) == 0 then
									local constructCommand = CConstructBuildingCommand( ministerTag, nuclear_reactor, reactorSite, 1 )

									if constructCommand:IsValid() then
										ai:Post( constructCommand )
										ic = ic - nuclear_reactorCost -- Upodate IC total
									end
								end
							end
						end
					end
				end
			end

			-- Rocket Test Site stations
			if ic > 0.2 and loTechStatus:IsBuildingAvailable(rocket_test)
			and lbProvinceCheck
			and ministerCountry:GetTotalIC() > 150
			then
				if Utils.HasCountryAIFunction(ministerTag, "Build_RocketTest") then
					ic = Utils.CallCountryAI(ministerTag, "Build_RocketTest", ic, minister, vbGoOver)
				elseif Utils.HasCountryAIFunction(ministerTag, "DontBuildBuilding")
				and Utils.CallCountryAI(ministerTag, "DontBuildBuilding", minister, rocket_test)
				then
					-- SKIP
				else
					if laCorePrv[1] < liRocketCap then
						local rocket_testCost = ministerCountry:GetBuildCost(rocket_test):Get()
						
						if (ic - rocket_testCost) >= 0 or vbGoOver then
							if table.getn(laCorePrv[5]) > 0 then
								local rocketSite = laCorePrv[5][math.random(table.getn(laCorePrv[5]))]
								if ministerCountry:GetTotalCoreBuildingLevels(rocket_test:GetIndex()):Get() > 0 then
									-- If we do have a Rocket Test Site already, then find it and build it up!
									for provinceId in ministerCountry:GetCoreProvinces() do
										local province = CCurrentGameState.GetProvince(provinceId)
										local provinceBuilding = province:GetBuilding(rocket_test)
										if provinceBuilding:GetMax():Get() > 0 then
											rocketSite = provinceId
											break
										end
									end
								end
								
								if CCurrentGameState.GetProvince( rocketSite ):GetCurrentConstructionLevel( rocket_test ) == 0 then
									local constructCommand = CConstructBuildingCommand(ministerTag, rocket_test, rocketSite, 1 )

									if constructCommand:IsValid() then
										ai:Post( constructCommand )
										ic = ic - rocket_testCost -- Upodate IC total
									end
								end
							end
						end
					end
				end
			end
			
			-- Industry
			if ic > 0.2 and loTechStatus:IsBuildingAvailable(industry) and lbProvinceCheck then
				if Utils.HasCountryAIFunction(ministerTag, "Build_Industry") then
					ic = Utils.CallCountryAI(ministerTag, "Build_Industry", ic, minister, vbGoOver)	
				elseif Utils.HasCountryAIFunction(ministerTag, "DontBuildBuilding")
				and Utils.CallCountryAI(ministerTag, "DontBuildBuilding", minister, industry)
				then
					-- SKIP
				else
					local industryCost = ministerCountry:GetBuildCost(industry):Get()
					
					if (ic - industryCost) >= 0 or vbGoOver then
						if table.getn(laCorePrv[6]) > 0 then
							local constructCommand = CConstructBuildingCommand(ministerTag, industry, laCorePrv[6][math.random(table.getn(laCorePrv[6]))], 1 )

							if constructCommand:IsValid() then
								ai:Post( constructCommand )
								ic = ic - industryCost -- Upodate IC total	
							end
						end
					end
				end
			end						
			
			-- Build Forts
			-- If not told otherwise, then build Forts on Front-provinces!
			if ic > 0.2 and loTechStatus:IsBuildingAvailable(land_fort) then
				if Utils.HasCountryAIFunction(ministerTag, "Build_Fort") then
					ic = Utils.CallCountryAI(ministerTag, "Build_Fort", ic, minister, vbGoOver)
				elseif Utils.HasCountryAIFunction(ministerTag, "DontBuildBuilding")
				and Utils.CallCountryAI(ministerTag, "DontBuildBuilding", minister, land_fort)
				then
					-- SKIP
				else
					local land_fortCost = ministerCountry:GetBuildCost(land_fort):Get()

					if (ic - land_fortCost) >= 0 or vbGoOver then
						local totalbuilt = 0
						
						for provinceId in ministerCountry:GetOwnedProvinces() do
							local province = CCurrentGameState.GetProvince(provinceId)
							local provinceBuilding = province:GetBuilding(land_fort)

							-- First make sure the province is a front province with at least some Infra.
							if province:IsFrontProvince(false) and province:GetBuilding(infra):GetMax():Get() > 1 then
								-- Check to see if nothing is being constructed.
								if province:GetCurrentConstructionLevel(land_fort) == 0 then
									local constructCommand = CConstructBuildingCommand(ministerTag, land_fort, provinceId, 1 )

									if constructCommand:IsValid() then
										ai:Post( constructCommand )
										totalbuilt = totalbuilt + 1
										ic = ic - land_fortCost -- Upodate IC total	

										-- Have two building max
										--   or Do not make the second pass your at max ic
										if totalbuilt >= 2 or (ic - land_fortCost) <= 0 then
											break 
										end
									end
								end
							end
						end
					end			
				end
			end
			
			-- Build Coastal Forts
			if ic > 0.2 and loTechStatus:IsBuildingAvailable(coastal_fort) then
				if Utils.HasCountryAIFunction(ministerTag, "Build_CoastalFort") then
					ic = Utils.CallCountryAI(ministerTag, "Build_CoastalFort", ic, minister, vbGoOver)
				elseif Utils.HasCountryAIFunction(ministerTag, "DontBuildBuilding")
				and Utils.CallCountryAI(ministerTag, "DontBuildBuilding", minister, coastal_fort)
				then
					-- SKIP	
				else
					-- Get Costal Fort information
					local coastal_fortCost = ministerCountry:GetBuildCost(coastal_fort):Get()
					
					--Make sure you wont go into the negative (Performance helper)
					if (ic - coastal_fortCost) >= 0 or vbGoOver then
						for navalBaseProvince in ministerCountry:GetNavalBases() do
							if tostring(navalBaseProvince:GetOwner()) == tostring(ministerTag) then
								local provinceBuilding = navalBaseProvince:GetBuilding(coastal_fort)
								
								-- Make sure one is not being built already
								if navalBaseProvince:GetCurrentConstructionLevel(coastal_fort) == 0 then
									if ministerCountry:IsBuildingAllowed(coastal_fort, navalBaseProvince) then
										local constructCommand = CConstructBuildingCommand( ministerTag, coastal_fort, navalBaseProvince:GetProvinceID(), 1 )

										if constructCommand:IsValid() then
											ai:Post( constructCommand )
											ic = ic - coastal_fortCost -- Upodate IC total
											break 
										end
									end
								end
							end
						end
					end
				end
			end
			
			-- Build Anti Air
			if ic > 0.2 and loTechStatus:IsBuildingAvailable(anti_air) then
				if Utils.HasCountryAIFunction(ministerTag, "Build_AntiAir") then
					ic = Utils.CallCountryAI(ministerTag, "Build_AntiAir", ic, minister, vbGoOver)
				elseif Utils.HasCountryAIFunction(ministerTag, "DontBuildBuilding")
				and Utils.CallCountryAI(ministerTag, "DontBuildBuilding", minister, anti_air)
				then
					-- SKIP
				else
					local anti_airCost = ministerCountry:GetBuildCost(anti_air):Get()

					if (ic - anti_airCost) >= 0 or vbGoOver then
						local totalbuilt = 0
						
						for provinceId in ministerCountry:GetOwnedProvinces() do
							local province = CCurrentGameState.GetProvince(provinceId)
							local provinceBuilding = province:GetBuilding(anti_air)

							-- First make sure the province has Industry (performance reasons done first)
							if province:HasBuilding(industry) then
								-- Check to see if nothing is being constructed.
								--    Also make sure its not on the front. If everything is good then go ahead and build some
								if province:GetCurrentConstructionLevel(anti_air) == 0 and not province:IsFrontProvince(false) then
									local constructCommand = CConstructBuildingCommand(ministerTag, anti_air, provinceId, 1 )

									if constructCommand:IsValid() then
										ai:Post( constructCommand )
										totalbuilt = totalbuilt + 1
										ic = ic - anti_airCost -- Upodate IC total	

										-- Have two building max
										--   or Do not make the second pass your at max ic
										if totalbuilt >= 2 or (ic - anti_airCost) <= 0 then
											break 
										end
									end
								end
							end
						end
					end
				end
			end
			
			-- Radar stations
			if ic > 0.2 and loTechStatus:IsBuildingAvailable(radar_station) then
				if Utils.HasCountryAIFunction(ministerTag, "Build_Radar") then
					ic = Utils.CallCountryAI(ministerTag, "Build_Radar", ic, minister, vbGoOver)
				elseif Utils.HasCountryAIFunction(ministerTag, "DontBuildBuilding")
				and Utils.CallCountryAI(ministerTag, "DontBuildBuilding", minister, radar_station)
				then
					-- SKIP
				else
					local radar_stationCost = ministerCountry:GetBuildCost(radar_station):Get()
					
					if (ic - radar_stationCost) >= 0 or vbGoOver then
						for province in ministerCountry:GetAirBases() do
							-- Do this check first before any others (performance reasons)
							if tostring(province:GetOwner()) == tostring(ministerTag) then
								local provinceBuilding = province:GetBuilding(radar_station)
								
								-- Make sure it is not a front province and that the province does not have 5 or more already.
								if provinceBuilding:GetMax():Get() < 5 and not province:IsFrontProvince(false) then
									if ministerCountry:IsBuildingAllowed(radar_station, province) then
										if not (province:GetCurrentConstructionLevel(radar_station) > 0) then
											local constructCommand = CConstructBuildingCommand(ministerTag, radar_station, province:GetProvinceID(), 1)

											if constructCommand:IsValid() then
												ai:Post( constructCommand )
												ic = ic - radar_stationCost -- Upodate IC total	
												break 
											end
										end
									end
								end
							end
						end
					end
				end
			end

			-- Build Airfields
			-- If not told otherwise, just build up our already started Airfields!
			if ic > 0.2 and loTechStatus:IsBuildingAvailable(air_base) then
				if Utils.HasCountryAIFunction(ministerTag, "Build_AirBase") then
					ic = Utils.CallCountryAI(ministerTag, "Build_AirBase", ic, minister, vbGoOver)
				elseif Utils.HasCountryAIFunction(ministerTag, "DontBuildBuilding")
				and Utils.CallCountryAI(ministerTag, "DontBuildBuilding", minister, air_base)
				then
					-- SKIP
				else
					local air_baseCost = ministerCountry:GetBuildCost(air_base):Get()
					
					if (ic - air_baseCost) >= 0 or vbGoOver then
						for province in ministerCountry:GetAirBases() do
							-- Do this check first before any others (performance reasons)
							if tostring(province:GetOwner()) == tostring(ministerTag) then
								local provinceBuilding = province:GetBuilding(air_base)
								
								if ministerCountry:IsBuildingAllowed(air_base, province) then
									if not (province:GetCurrentConstructionLevel(air_base) > 0) then
										local constructCommand = CConstructBuildingCommand(ministerTag, air_base, province:GetProvinceID(), 1)

										if constructCommand:IsValid() then
											ai:Post( constructCommand )
											ic = ic - air_baseCost -- Upodate IC total	
											break 
										end
									end
								end
							end
						end
					end
				end
			end
			
			-- Infrastructure
			if ic > 0.2 and loTechStatus:IsBuildingAvailable(infra) and lbProvinceCheck then
				if Utils.HasCountryAIFunction(ministerTag, "Build_Infrastructure") then
					ic = Utils.CallCountryAI(ministerTag, "Build_Infrastructure", ic, minister, vbGoOver)
				elseif Utils.HasCountryAIFunction(ministerTag, "DontBuildBuilding")
				and Utils.CallCountryAI(ministerTag, "DontBuildBuilding", minister, infra)
				then
					-- SKIP
				else
					local infraCost = ministerCountry:GetBuildCost(infra):Get()
					
					if (ic - infraCost) >= 0 or vbGoOver then
						local liRandomIndex
						
						-- Limit it to three provinces at a time
						for i = 1, 3 do
							if table.getn(laCorePrv[3]) > 0 then
								liRandomIndex = math.random(table.getn(laCorePrv[3]))
								local constructCommand = CConstructBuildingCommand(ministerTag, infra, laCorePrv[3][liRandomIndex], 1 )

								if constructCommand:IsValid() then
									if (ic - infraCost) >= 0 or vbGoOver then
										ai:Post( constructCommand )
										ic = ic - infraCost -- Upodate IC total	
										table.remove(laCorePrv[3], liRandomIndex)
									else
										break
									end
								end
							elseif table.getn(laCorePrv[4]) > 0 then
								liRandomIndex = math.random(table.getn(laCorePrv[4]))
								local constructCommand = CConstructBuildingCommand(ministerTag, infra, laCorePrv[4][liRandomIndex], 1 )

								if constructCommand:IsValid() then
									if (ic - infraCost) >= 0 or vbGoOver then
										ai:Post( constructCommand )
										ic = ic - infraCost -- Upodate IC total	
										table.remove(laCorePrv[4], liRandomIndex)
									else
										break
									end
								end
							end
							
							-- If there is no IC left do not loop another time
							if ic <= 0.2 then
								break
							end
						end
					end
				end
			end	
			
			-- Loop Check Exit after 5 passes means we cant build any buildings
			if ic <= 1 or liLoopCheck >= 5 then
				lbExit = true
			else
				liLoopCheck = liLoopCheck + 1
			end
		end
	end
	
	return ic
end

function CalculateHomeProduced(ministerCountry, voResourceType)

	if ( not Utils.ASSERT( ministerCountry ) )
	or ( not Utils.ASSERT( voResourceType ) )
	then
		return 0
	end

	local liConvoyedIn = ministerCountry:GetConvoyedIn():Get(voResourceType):Get()
	local liDailyHome = ministerCountry:GetHomeProduced():Get(voResourceType):Get()
	local liDailyExpense = ministerCountry:GetDailyExpense(voResourceType):Get()
	
	if liConvoyedIn > 0 then
		-- If the Convoy in exceeds Home Produced by 10% it means they have a glutten coming in or
		--   are a sea bearing country like ENG or JAP
		--   so go ahead and count this as home produced up to 80% of it just in case something happens!
		if liDailyHome > liDailyExpense then
			liDailyHome = liDailyHome + liConvoyedIn
		elseif liConvoyedIn > (liDailyHome * 0.1) then
			liDailyHome = liDailyHome + (liConvoyedIn * 0.9)
		end
	end	
	
	return liDailyHome
end

function CoreProvincesLoop(ministerCountry, voTechStatus, viRocketCap, viReactorCap)

	if ( not Utils.ASSERT( ministerCountry ) )
	or ( not Utils.ASSERT( voTechStatus ) )
	or ( not Utils.ASSERT( viRocketCap ) )
	or ( not Utils.ASSERT( viReactorCap ) )
	then
		return 0
	end

	local liExpenseFactor = 0
	local liHomeFactor = 0
	local lbBuildIndustry = false
	local laCorePrv = {}
	
	liExpenseFactor = ministerCountry:GetDailyExpense(CGoodsPool._ENERGY_):Get() * 0.5
	liExpenseFactor = liExpenseFactor + ministerCountry:GetDailyExpense(CGoodsPool._METAL_):Get()
	liExpenseFactor = liExpenseFactor + (ministerCountry:GetDailyExpense(CGoodsPool._RARE_MATERIALS_):Get() * 2)
	
	liHomeFactor = CalculateHomeProduced(ministerCountry, CGoodsPool._ENERGY_) * 0.5
	liHomeFactor = liHomeFactor + CalculateHomeProduced(ministerCountry, CGoodsPool._METAL_)
	liHomeFactor = liHomeFactor + (CalculateHomeProduced(ministerCountry, CGoodsPool._RARE_MATERIALS_) * 2)
	
	-- We produce more than what we use so build more industry
	if liHomeFactor > liExpenseFactor then
		lbBuildIndustry = true
	end
	
	local nuclear_reactor = CBuildingDataBase.GetBuilding("nuclear_reactor" )
	local rocket_test = CBuildingDataBase.GetBuilding("rocket_test" )
	local infra = CBuildingDataBase.GetBuilding("infra" )
	local industry = CBuildingDataBase.GetBuilding("industry" )

	-- The GetTotalCoreBuildingLevels counts on map and in the production que together
	local liRocketSiteCount = ministerCountry:GetTotalCoreBuildingLevels(rocket_test:GetIndex()):Get()
	local liReactorSiteCount = ministerCountry:GetTotalCoreBuildingLevels(nuclear_reactor:GetIndex()):Get()
	local laCorePrvLowInfra69 = {}
	local laCorePrvLowInfra99 = {}
	local laCorePrvIndustry = {}
	local laCorePrvBuildIndustry = {}

	for provinceId in ministerCountry:GetCoreProvinces() do
		local province = CCurrentGameState.GetProvince(provinceId)
		local provinceBuilding = province:GetBuilding(infra)
		local isFrontProvince = province:IsFrontProvince(false)
		
		-- Infrastructure
		local liConstructionLevel = province:GetCurrentConstructionLevel(infra)
		local liBuildingSize = provinceBuilding:GetMax():Get()
		
		-- Only consider provinces with at lest level 2! We don't want to civilize level 1 provinces!
		if liBuildingSize > 1 and liBuildingSize < 7 and not(liConstructionLevel > 0) and not(isFrontProvince) then
			table.insert(laCorePrvLowInfra69, provinceId)
		elseif liBuildingSize > 1 and liBuildingSize < 10 and not(liConstructionLevel > 0) and not(isFrontProvince) then
			table.insert(laCorePrvLowInfra99, provinceId)
		end
		
		-- Rocket Test Site
		provinceBuilding = province:GetBuilding(rocket_test)
		liConstructionLevel = province:GetCurrentConstructionLevel(rocket_test)
		
		-- First make sure the province has Industry (performance reasons done first)
		if province:HasBuilding(industry) and not(isFrontProvince) then
			-- Check to see if it has less than 5 Reactors and nothing is being constructed.
			--    Also make sure its not on the front. If everythign is good then go ahead and build some
			
			if (voTechStatus:IsBuildingAvailable(rocket_test) and liRocketSiteCount < viRocketCap) or (voTechStatus:IsBuildingAvailable(nuclear_reactor) and liReactorSiteCount < viReactorCap) then
				if not(province:GetCurrentConstructionLevel(rocket_test) > 0) and not(province:GetCurrentConstructionLevel(nuclear_reactor) > 0) then
					table.insert(laCorePrvIndustry, provinceId)
				end
			end
			
			if lbBuildIndustry then
				if province:GetBuilding(industry):GetMax():Get() < 9
				and province:GetBuilding(infra):GetMax():Get() > 4		-- Lower Infra would make hurt the performance of the IC there!
				and not(province:GetCurrentConstructionLevel(industry) > 0)
				then
					table.insert(laCorePrvBuildIndustry, provinceId)
				end
			end
		end		
	end
	
	table.insert(laCorePrv, liRocketSiteCount)
	table.insert(laCorePrv, liReactorSiteCount)
	table.insert(laCorePrv, laCorePrvLowInfra69)
	table.insert(laCorePrv, laCorePrvLowInfra99)
	table.insert(laCorePrv, laCorePrvIndustry)
	table.insert(laCorePrv, laCorePrvBuildIndustry)
	
	return laCorePrv
end
-- #######################
-- End Building Construction
-- #######################


-- #######################
-- Convoy Building
-- #######################
function ConstructConvoys(ai, minister, ministerTag, ministerCountry, ic)

	if ( not Utils.ASSERT( ai ) )
	or ( not Utils.ASSERT( minister ) )
	or ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( ministerCountry ) )
	or ( not Utils.ASSERT( ic ) )
	then
		return 0
	end

	if ministerCountry:GetNumOfPorts() < 1 then
		return ic
	end
	-- Check the total size of all our ports combined!
	-- That should give a pretty good lower limit to how many convoys we should want in reserve!
	-- Although it will need to be scaled.
	local naval_base = CBuildingDataBase.GetBuilding( "naval_base" )
	local PortCount = ministerCountry:GetTotalCoreBuildingLevels(naval_base:GetIndex()):Get() * 0.15
	-- Check how much the engine thinks we want and add the supposed reserve amount to that!
	local TransportsNeeded = ministerCountry:GetTotalNeededConvoyTransports()
	local TransportsCurrent = ministerCountry:GetTotalConvoyTransports()
	
	TransportsNeeded = TransportsNeeded + PortCount

	-- SSmith (11/05/2013)
	-- Convoy building needs a bit of country-specific balancing
	-- Britain needs to build fewer convoys
	-- Japan needs to more convoys

	local ministerTagString = tostring(ministerTag)
	if ministerTagString == "ENG" then
		TransportsNeeded = TransportsNeeded * 0.65
	elseif ministerTagString == "JAP" then
		TransportsNeeded = TransportsNeeded * 1.35
	end

	if TransportsNeeded > TransportsCurrent and PortCount > 0 then
		local TransportConstruction = minister:CountTransportsUnderConstruction()
		local TransportsActuallyNeeded = TransportsNeeded - TransportsCurrent - TransportConstruction
		local maxSerial
		
		-- Majors build 20% more than you need
		if (ministerCountry:IsMajor()) then
			maxSerial = 5
			TransportsActuallyNeeded = TransportsActuallyNeeded * 1.20
		else
			maxSerial = 2
		end
		
		if TransportsActuallyNeeded > 0 then
			local cost = ministerCountry:GetConvoyBuildCost():Get()
			local buildRequestCount = TransportsActuallyNeeded / defines.economy.CONVOY_CONSTRUCTION_SIZE
			buildRequestCount = math.ceil( math.max( buildRequestCount, 1) )
			ic = BuildTransportOrEscort(ai, ministerTag, buildRequestCount, maxSerial, false, cost, ic)
		end
	end
	
	-- Let's add the number of Convoys under construction to get how many we currently have!
	-- The number of needed Escorts will be based on that.
	TransportsCurrent = TransportsCurrent + minister:CountTransportsUnderConstruction()
	
	-- Now Process Escorts Check
	--   Performance check make sure they have IC to actually work with

	-- SSmith (27/05/2013)
	-- We can't build escorts if we can't build destroyers!

	local techStatus = ministerCountry:GetTechnologyStatus()
	local lbDestroyer = techStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("destroyer"))

	if ic > 0 and lbDestroyer then
		local EscortsNeeded		-- I don't trust the built-in function...

		-- SSmith (27/05/2013)
		-- At the moment escorts are probably not cost-effective!
		-- So we will build much fewer of them unless this changes (was 50% and 25%)

		if ministerCountry:IsAtWar() then
			-- If we are at war, build half as many escorts as many Convoys we have!
			EscortsNeeded = TransportsCurrent * 0.25
		else
			-- Otherwise 25% is enough.
			EscortsNeeded = TransportsCurrent * 0.10
		end
		local EscortsCurrent = ministerCountry:GetEscorts()

		if EscortsNeeded > EscortsCurrent and PortCount > 0 then
			local EscortsConstruction = minister:CountEscortsUnderConstruction()
			local EscortsActuallyNeeded = EscortsNeeded - EscortsCurrent - EscortsConstruction

			if EscortsActuallyNeeded > 0 then
				local cost = ministerCountry:GetEscortBuildCost():Get()
				local buildRequestCount = EscortsActuallyNeeded / defines.economy.CONVOY_CONSTRUCTION_SIZE
				buildRequestCount = math.ceil( math.max( buildRequestCount, 1) )
				ic = BuildTransportOrEscort(ai, ministerTag, buildRequestCount, 4, true, cost, ic)
			end 
		end
	end
	
	return ic
end

--ConvoyOrEscort = is a boolean (true = escort, false = convoy)
function BuildTransportOrEscort(ai, ministerTag, total_transports, maxSerial, ConvoyOrEscort, cost, ic)

	if ( not Utils.ASSERT( ai ) )
	or ( not Utils.ASSERT( ministerTag ) )
	or ( not Utils.ASSERT( total_transports ) )
	or ( not Utils.ASSERT( maxSerial ) )
	or ( not Utils.ASSERT( ConvoyOrEscort ) )
	or ( not Utils.ASSERT( cost ) )
	or ( not Utils.ASSERT( ic ) )
	then
		return 0
	end

	if ministerTag:GetCountry():GetNumOfPorts() < 1 then
		return ic
	end
	
	local i = 0 -- Counter for amount of convoys/escorts already built
	
	while i < total_transports do
		local buildcount
		
		if 	total_transports >= (i + maxSerial) then
			buildcount = maxSerial
			i = i + maxSerial
		else
			buildcount = total_transports - i
			i = total_transports
		end
		
		local res = ic - cost

		if res > 0 then
			local buildCommand = CConstructConvoyCommand(ministerTag, ConvoyOrEscort, buildcount)
			ai:Post(buildCommand)
			
			ic = ic - cost
		end
	end
	
	return ic
end
-- #######################
-- END Convoy Building
-- #######################