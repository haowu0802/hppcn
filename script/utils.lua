local P = {}
Utils = P

-- Checks if the recieved parameter is nil or not
-- If it is nil, then we log the callstack to help with debugging and return with false.
-- Otherwise it returns with true.
function P.ASSERT( vVariable )
	if vVariable == nil then	-- Simply using 'not vVariable' would cause trouble for bool and probably even int
		local f = io.open("tfh\\mod\\HPP\\logs\\nil_params.log", "a")
		-- Let's check if opening the file was successful or not. We don't want to screw up the original
		-- log files because the HPP\logs folder didn't exist...
		if not f then
			return
		end
		-- First, a timestamp!
		f:write( os.date() .. ", Current callstack:\n" )
		-- Now the callstack itself, aquired with a loop
		local level = 2
		while true do
			local info = debug.getinfo(level, "Sln")
			
			if not info then break end	-- End of the line, buddy!
			
			if info.what ~= "C" then
				f:write( string.format( "\t%s, line %d: ", info.short_src, info.currentline ) )
				if info.name then
					f:write( info.name .. "\n" )
				else
					f:write( "NAME NOT FOUND\n" )	-- From experience, this usually happens when the current function was called by the .exe
				end
				f:write( "\t\tVariables:\n" )
				local nVariableCount = 1	-- What kind of madness is this? Indexing from 1?!
				while true do
					local name, value = debug.getlocal( level, nVariableCount )
					if not name then break end
					f:write( "\t\t" .. name .. " = " .. tostring( value ) .. "\n" )
					nVariableCount = nVariableCount + 1
				end
			end
			level = level + 1
		end
		f:close()
		return false
	else
		return true
	end
end

-- Logs a lot of values for the country
function P.LOG_AI_STRATEGY( ministerTag, ai )

	if not ( P.ASSERT( ministerTag ) )
	or not ( P.ASSERT( ai ) )
	then
		return
	end
	
	if not ministerTag:IsReal() or not ministerTag:IsValid() or tostring( ministerTag ) == "REB" or tostring( ministerTag ) == "---" then
		-- These aren't really valid, are they?
		return
	end
	
	-- If there's no 'strategy_logs' folder, the file won't be opened for writing and the function will return immediately
	local sFileName = "tfh\\mod\\HPP\\logs\\strategy_logs\\" .. tostring( ministerTag ) .. "_strategy.log"
	local sWriteType
	local pDate = CCurrentGameState.GetCurrentDate()
	
	local bFirstLogEntry = ( pDate:GetYear() == 1936 and pDate:GetMonthOfYear() == 0 and pDate:GetDayOfMonth() == 0 )
	
	if bFirstLogEntry then
		-- First entry, so reset the log
		sWriteType = "w"
	else
		-- Otherwise we should just append the new log
		sWriteType = "a"
	end
	
	local f = io.open( sFileName, sWriteType )
	if not f then
		return
	end

	local ministerCountry = ministerTag:GetCountry()
	if not ministerCountry or not ministerCountry:Exists() then
		return
	end
	local strategy = ministerCountry:GetStrategy()
	
	if bFirstLogEntry then
		-- These won't change during the game, so no need to log them every time
		f:write( P.FindCountryNameByTag( ministerTag ) .. "\n" )
		
		if strategy:GetPersonality() == CAIStrategy._AI_BALANCED_ then
			f:write( "Personality: BALANCED\n")
		elseif strategy:GetPersonality() == CAIStrategy._AI_DIPLOMAT_ then
			f:write( "Personality: DIPLOMAT\n")
		elseif strategy:GetPersonality() == CAIStrategy._AI_INDUSTRIALIST_	 then
			f:write( "Personality: INDUSTRIALIST\n")
		elseif strategy:GetPersonality() == CAIStrategy._AI_MILITARIST_ then
			f:write( "Personality: MILITARIST\n")
		elseif strategy:GetPersonality() == CAIStrategy._AI_UNDEFINED_ then
			f:write( "Personality: UNDIFINED\n")
		end
	end
	
	f:write( "\n\n --- --- --- --- --- --- --- --- --- --- --- --- \n\n" )
	
	-- Timestamp
	
	f:write( P.GameTimeStamp() .. "\n" )
	
	-- Economic stats
	
	f:write( "\nECONOMY\n\n" )
	f:write( "Total IC: " .. tostring( ministerCountry:GetTotalIC() ) .. "\n" )
	f:write( "Available IC: " .. tostring( ministerCountry:GetAvailableIC() ) .. "\n" )
	f:write( "Used IC: " .. tostring( ministerCountry:GetUsedIC():Get() ) .. "\n" )
	f:write( "Max IC: " .. tostring( ministerCountry:GetMaxIC() ) .. "\n" )
	f:write( "\n" )
	
	f:write( "Convoys, current/required: " .. tostring( ministerCountry:GetTotalConvoyTransports() ) .. "/" .. tostring( ministerCountry:GetTotalNeededConvoyTransports() ) .. "\n" )
	f:write( "Escorts, current: " .. tostring( ministerCountry:GetEscorts() ) .. "\n" )
	f:write( "\n" )
	
	f:write( "Average Money Balance: " .. tostring( ministerCountry:GetMoneyBalanceAverage():Get() ) .. "\n" )
	f:write( "Average Supply Balance: " .. tostring( ministerCountry:GetSupplyBalanceAverage():Get() ) .. "\n" )
	f:write( "Resources (Name: Stockpile / Convoyed In / Convoyed Out / Home Produced / Total Produced / Traded Away / Traded For)\n" )
	f:write( "\t\t(Daily Balance / Daily Expense / Daily Income / Daily Need)\n" )
	f:write( "(Sorry about the spacing, I did all I could...)\n" )
	local stockpile = ministerCountry:GetPool()
	local convoyedIn = ministerCountry:GetConvoyedIn()
	local convoyedOut = ministerCountry:GetConvoyedOut()
	local homeProduced = ministerCountry:GetHomeProduced()
	local totalProduced = ministerCountry:GetTotalProduced()
	local tradedAway = ministerCountry:GetTradedAway()
	local tradedFor = ministerCountry:GetTradedFor()
	
	local i = 0
	while i < CGoodsPool._GC_NUMOF_ do
		f:write( P.ResourceNameByID( i ) .. ": \n" .. tostring( stockpile:Get( i ):GetTruncated() ) .. "\t/\t"
			.. tostring( convoyedIn:Get( i ):GetTruncated() ) .. "\t/\t" .. tostring( convoyedOut:Get( i ):GetTruncated() ) .. "\t/\t"
			.. tostring( homeProduced:Get( i ):GetTruncated() ) .. "\t/\t" .. tostring( totalProduced:Get( i ):GetTruncated() ) .. "\t/\t"
			.. tostring( tradedAway:Get( i ):GetTruncated() ) .. "\t/\t" .. tostring( tradedFor:Get( i ):GetTruncated() ) .. "\n" 
		)
		f:write( tostring( ministerCountry:GetDailyBalance( i ) ) .. "\t/\t" .. tostring( ministerCountry:GetDailyExpense( i ) ) .. "\t/\t"
			.. tostring( ministerCountry:GetDailyIncome( i ) ) .. "\t/\t" .. tostring( ministerCountry:GetDailyNeed( i ) ) .. "\n" )
		i = i + 1
	end
	f:write( "\n" )
	
	-- Military stats
	
	f:write( "\nMILITARY\n\n" )
	f:write( "Officer Ratio: " .. tostring( ministerCountry:GetOfficerRatio():Get() ) .. "\n" )
	f:write( "Manpower: " .. tostring( ministerCountry:GetManpower():Get() ) .. "\n" )
	f:write( "\n" )
	
	f:write( "Number of Airfields: " .. tostring( ministerCountry:GetNumOfAirfields() ) .. "\n" )
	f:write( "Number of Ports: " .. tostring( ministerCountry:GetNumOfPorts() ) .. "\n" )
	f:write( "\n" )
	
	f:write( "Theatre priorities:\n" )
	local nTheatreNumber = 1 
	for theatre in strategy:GetTheatres() do
		f:write( tostring( nTheatreNumber ) .. ". theatre: " .. tostring( theatre:GetPriority() ) .. "\n" )
		nTheatreNumber = nTheatreNumber + 1
	end
	f:write( "\n" )
	
	f:write( "Comparative stats:\n" )
	local unitList = ministerCountry:GetUnits()
	f:write( "\tTotal Strength: " .. tostring( unitList:GetTotalStrength() ) .. "\n" )
	f:write( "\tArmies: " .. tostring( unitList:GetTotalAmountOfArmies() ) .. "\n" )
	f:write( "\tDivisions: " .. tostring( unitList:GetTotalAmountOfDivisions() ) .. "\n" )
	f:write( "\tRegiments: " .. tostring( unitList:GetTotalNumOfRegiments() ) .. "\n" )
	f:write( "\tPlanes: " .. tostring( unitList:GetTotalNumOfPlanes() ) .. "\n" )
	f:write( "\tShips: " .. tostring( unitList:GetTotalNumOfShips() ) .. "\n" )
	if unitList:GetTotalNumOfShips() > 0 then
		f:write( "\t\tWarships: " .. tostring( unitList:GetTotalNumOfWarShips() ) .. "\n" )
		f:write( "\t\tTransports: " .. tostring( unitList:GetTotalNumOfTransports() ) .. "\n" )
	end
	f:write( "\n" )
	
	-- This part is kinda pointles. It could be VERY useful, if there would be info other than their name...
	--f:write( "Units:\n")
	--for unit in ministerCountry:GetUnitsIterator() do
	--	f:write( unit:GetName():GetString() )
	--	if unit:IsMoving() then
	--		f:write( " (on the move)" )
	--	end
	--	f:write( "\n" )
	--end
	--f:write( "\n" )
	
	f:write( "Number of provinces controlled/owned: " .. tostring( ministerCountry:GetNumberOfControlledProvinces() ) .. "/" .. tostring( ministerCountry:GetNumberOfOwnedProvinces() ) .. "\n" )
	f:write( "\n" )
	
	if ministerCountry:IsAtWar() then
		f:write( "Strategy Warfare Impact:\n" )
		f:write( "Allies: " .. tostring( ministerCountry:GetStrategicWarfare():GetAlliesImpact():Get() ) .. "\n" )
		f:write( "Bombing: " .. tostring( ministerCountry:GetStrategicWarfare():GetBombingImpact():Get() ) .. "\n" )
		f:write( "Convoys: " .. tostring( ministerCountry:GetStrategicWarfare():GetConvoyImpact():Get() ) .. "\n" )
	end
	
	-- Political stats
	
	f:write( "\nPOLITICS\n\n" )
	f:write( "Capital: " .. P.FindProvinceNameByID( ministerCountry:GetCapital() ) .. " (" .. tostring( ministerCountry:GetCapital() ) .. ")\n" )
	local nActingCapitalProvID = ministerCountry:GetActingCapitalLocation():GetProvinceID()
	if not ( nActingCapitalProvID == ministerCountry:GetCapital() ) then
		f:write( "Acting capital: " .. P.FindProvinceNameByID( nActingCapitalProvID ) .. " (" .. tostring( nActingCapitalProvID ) .. ")\n" )
	end
	f:write( "Ideology: " .. P.FindLineInLocalisationFile( ministerCountry:GetRulingIdeology():GetKey():GetString(), "politics" ) .. "\n" )
	f:write( "Ruling Party: " .. P.FindLineInLocalisationFile( ministerCountry:GetRulingIdeology():GetKey():GetString() .. "_" .. tostring( ministerTag ), "Parties" ) .. "\n" )
	if ministerCountry:IsPuppet() then
		f:write( "Overlord: " .. P.FindCountryNameByTag( ministerCountry:GetOverlord() ) .. "\n" )
	end
	f:write( "Natinal Unity: " .. tostring( ministerCountry:GetNationalUnity():Get() ) .. "\n" )
	f:write( "Base Neutrality: " .. tostring( ministerCountry:GetNeutrality():Get() ) .. "\n" )
	f:write( "Effective Neutrality: " .. tostring( ministerCountry:GetEffectiveNeutrality():Get() ) .. "\n" )
	f:write( "Highest Threat: " .. P.FindCountryNameByTag( ministerCountry:GetHighestThreat() ) .. "\n" )
	f:write( "Highest Threat value: " .. tostring( ministerCountry:GetRelation( ministerCountry:GetHighestThreat() ):GetThreat():Get() ) .. "\n" )
	f:write( "\n" )
	
	if ministerCountry:HasFaction() then
		local sPrefix
		local sFactionName
		local FactionIdeologyGroupString = ministerCountry:GetFaction():GetIdeologyGroup():GetKey():GetString()
		
		if ministerCountry:IsFactionLeader() then
			sPrefix = "Leader"
		else
			sPrefix = "Member"
		end
		
		if FactionIdeologyGroupString == "democracy" then
			sFactionName = "Allies"
		elseif FactionIdeologyGroupString == "communism" then
			sFactionName = "Comintern"
		else
			sFactionName = "Axis"
		end
		
		f:write( sPrefix .. " of the " .. sFactionName .. "\n" )
	else
		for faction in CCurrentGameState.GetFactions() do
			if faction:GetIdeologyGroup():GetKey():GetString() == "democracy" and faction:GetFactionLeader() then
				f:write( "Distance from Allies: " .. tostring( ministerCountry:GetDiplomaticDistance( faction:GetFactionLeader() ):Get() ) .. "\n" )
			elseif faction:GetIdeologyGroup():GetKey():GetString() == "communism" and faction:GetFactionLeader() then
				f:write( "Distance from Comintern: " .. tostring( ministerCountry:GetDiplomaticDistance( faction:GetFactionLeader() ):Get() ) .. "\n" )
			elseif faction:GetFactionLeader() then
				f:write( "Distance from Axis: " .. tostring( ministerCountry:GetDiplomaticDistance( faction:GetFactionLeader() ):Get() ) .. "\n" )
			end
		end
		
	end
	f:write( "Number of allies: " .. tostring( ministerCountry:GetNumOfAllies() ) .. "\n" )
	
	-- Research
	
	f:write( "\nRESEARCH\n" )
	f:write( "Total Leadership: " .. tostring( ministerCountry:GetTotalLeadership():Get() ) .. "\n" )
	
	f:write( "Current projects:\n" )
	local techStatus = ministerCountry:GetTechnologyStatus()
	for tech in ministerCountry:GetCurrentResearch() do
		f:write( P.FindLineInLocalisationFile( tech:GetKey():GetString(), "technology" ) .. " (" .. tostring( techStatus:GetYear( tech, techStatus:GetLevel( tech ) + 1 ) ) .. ")\n" )
	end

	-- What else?
	
	f:write( "\n\n --- --- --- --- --- --- --- --- --- --- --- --- \n\n" )
	
	-- Country iterator:
	
	for targetCountry in CCurrentGameState.GetCountries() do
		local targetTag = targetCountry:GetCountryTag()
		
		-- Let's just work with relationst to Majors for now, otherwise there would be an insane amount of useless data...
		if targetTag:IsValid() and not ( targetTag == ministerTag )
		and not ( tostring( targetTag ) == "REB" ) and not ( tostring( targetTag ) == "---" )
		and targetTag:GetCountry():Exists() and targetTag:GetCountry():IsMajor()
		then
		
			f:write( "Target: " .. tostring( targetTag ) .. "\n")
			
			-- Diplomacy stats
			
			f:write( "\nDiplomacy\n" )
			f:write( "\tRelations: " .. tostring( ministerCountry:GetRelation( targetTag ):GetValue():Get() ) .. "\n" )
			f:write( "\tThreat from: " .. tostring( ministerCountry:GetRelation( targetTag ):GetThreat():Get() ) .. "\n" )
			f:write( "\tThreat against: " .. tostring( targetCountry:GetRelation( ministerTag ):GetThreat():Get() ) .. "\n" )

			f:write( "\tOther values:\n")
			-- Only show non-zero values
			if strategy:GetAccessScore( targetTag ) ~= 0 then
				f:write( "\t\tAccess score: " .. tostring( strategy:GetAccessScore( targetTag ) ) .. "\n" )
			end
			if strategy:GetAntagonism( targetTag ) ~= 0 then
				f:write( "\t\tAntagonism: " .. tostring( strategy:GetAntagonism( targetTag ) ) .. "\n" )
			end
			if strategy:GetFriendliness( targetTag ) ~= 0 then
				f:write( "\t\tFriendliness: " .. tostring( strategy:GetFriendliness( targetTag ) ) .. "\n" )
			end
			if strategy:GetProtectionism( targetTag ) ~= 0 then
				f:write( "\t\tProtectionism: " .. tostring( strategy:GetProtectionism( targetTag ) ) .. "\n" )
			end
			
			-- Intelligence stats
			
			f:write( "\nEspionage\n" )
			local spyPresence = ministerCountry:GetSpyPresence( targetTag )
			f:write( "\tPriority: " .. tostring( spyPresence:GetPriority() ) .. "\n" )
			f:write( "\tOur spies in their country: " .. tostring( spyPresence:GetLevel():Get() ) .. "\n" )
			if spyPresence:GetLevel():Get() > 0 then
				-- Only relevant if we do have spies there
				f:write( "\tCurrent mission: " .. P.SpyMissionByID( spyPresence:GetMission() ) .. "\n" )
				local lastChangeDate = spyPresence:GetLastMissionChangeDate()
				if lastChangeDate:GetYear() > 1 then
					-- It is set to year 1 if there wasn't any changes yet.
					f:write( "\tLast change date: " .. tostring( lastChangeDate:GetYear() ) .. " "
							.. P.MonthNameByNumber( lastChangeDate:GetMonthOfYear() )
							.. " " .. tostring( lastChangeDate:GetDayOfMonth() + 1 ) .. "\n" )
				end
			end
			
			f:write( "\n -*- -*- -*- -*- -*- -*- -*- \n" )
			
		end
		
	end
	
	f:close()
end

-- Logs a lot of values for the country
function P.LOG_AI_GLOBAL_STRATEGY()
	
	-- If there's no 'global_strategy.log' file, the function retruns immediately
	local sFileName = "tfh\\mod\\HPP\\logs\\global_strategy.log"
	
	local f = io.open( sFileName, "r" )
	if not f then
		return
	end
	f:close()
	
	local sWriteType
	local pDate = CCurrentGameState.GetCurrentDate()
	
	local bFirstLogEntry = ( pDate:GetYear() == 1936 and pDate:GetMonthOfYear() == 0 and pDate:GetDayOfMonth() == 0 )
	
	if bFirstLogEntry then
		-- First entry, so reset the log
		sWriteType = "w"
	else
		-- Otherwise we should just append the new log
		sWriteType = "a"
	end
	
	local f = io.open( sFileName, sWriteType )
	if not f then
		return
	end
	
	local totalEnergyProduction = 0
	local totalMetalProduction = 0
	local totalRaresProduction = 0
	
	local totalEnergyConsumption = 0
	local totalMetalConsumption = 0
	local totalRaresConsumption = 0
	
	for Country in CCurrentGameState.GetCountries() do
		
		totalEnergyProduction = totalEnergyProduction + Country:GetDailyIncome( CGoodsPool._ENERGY_ ):Get()
		totalMetalProduction = totalMetalProduction + Country:GetDailyIncome( CGoodsPool._METAL_ ):Get()
		totalRaresProduction = totalRaresProduction + Country:GetDailyIncome( CGoodsPool._RARE_MATERIALS_ ):Get()
		
		totalEnergyConsumption = totalEnergyConsumption + Country:GetDailyExpense( CGoodsPool._ENERGY_ ):Get()
		totalMetalConsumption = totalMetalConsumption + Country:GetDailyExpense( CGoodsPool._METAL_ ):Get()
		totalRaresConsumption = totalRaresConsumption + Country:GetDailyExpense( CGoodsPool._RARE_MATERIALS_ ):Get()
	
	end
	
	f:write( "Global resource productions " .. P.GameTimeStamp() .. " (" .. os.date() .. ")\n\n" )
	
	f:write( "Energy production: " .. tostring( totalEnergyProduction ) .. "\n" )
	f:write( "Energy consumption: " .. tostring( totalEnergyConsumption ) .. "\n\n" )
	
	f:write( "Metal production: " .. tostring( totalMetalProduction ) .. "\n" )
	f:write( "Metal consumption: " .. tostring( totalMetalConsumption ) .. "\n\n" )
	
	f:write( "Rare production: " .. tostring( totalRaresProduction ) .. "\n" )
	f:write( "Rare consumption: " .. tostring( totalRaresConsumption ) .. "\n\n\n" )
	
	f:close()
end

-- Logs canceled trades
function P.LOG_AI_CANCEL_TRADE( ministerTag, targetTag, TradeRoute )

	if not ( P.ASSERT( ministerTag ) )
	or not ( P.ASSERT( targetTag ) )
	or not ( P.ASSERT( TradeRoute ) )
	then
		return
	end
	
	-- If there's no 'trade_logs.log' file, the function retruns immediately
	local sFileName = "tfh\\mod\\HPP\\logs\\trade_logs.log"
	
	local f = io.open( sFileName, "r" )
	if not f then
		return
	else
		f = io.open( sFileName, "a" )
	end
	
	-- The event we are logging
	f:write( "Canceling trade, " .. P.GameTimeStamp() .. " (" .. os.date() .. ")\n\n" )
	f:write( "Actor: " .. P.FindCountryNameByTag( ministerTag ) .. "\n" )
	f:write( "Recipient: " .. P.FindCountryNameByTag( targetTag ) .. "\n" )
	
	f:write( "\tTrade specifics:\n")
	for i = 0, CGoodsPool._GC_NUMOF_ do
		if TradeRoute:GetTradedFromOf( i ):Get() > 0 then
			f:write( "\t\tActor exporting " .. P.ResourceNameByID( i ) .. ": " .. tostring( TradeRoute:GetTradedFromOf( i ):Get() ) .. "\n" )
		end
		if TradeRoute:GetTradedToOf( i ):Get() > 0 then
			f:write( "\t\tActor importing " .. P.ResourceNameByID( i ) .. ": " .. tostring( TradeRoute:GetTradedToOf( i ):Get() ) .. "\n" )
		end
	end
	
	f:write( "\tRelations factor: " .. tostring( Support.ThreatFactor( ministerTag, targetTag ) ) .. "\n" )
	f:write( "\tThreat factor: " .. tostring( Support.LinearFunction( -50, 75, ministerTag:GetCountry():GetRelation( targetTag ):GetValue():Get() ) ) .. "\n" )
	
	f:close()

end

-- Logs evaluated proposed trades
function P.LOG_AI_PROPOSED_TRADE( ministerTag, targetTag, Export, Import, score, TradeValue, DiplomaticMultiplier )

	if not ( P.ASSERT( ministerTag ) )
	or not ( P.ASSERT( targetTag ) )
	or not ( P.ASSERT( Export ) )
	or not ( P.ASSERT( Import ) )
	or not ( P.ASSERT( score ) )
	or not ( P.ASSERT( TradeValue ) )
	or not ( P.ASSERT( DiplomaticMultiplier ) )
	then
		return
	end
	
	-- Don't log trades offered by the player or those that won't be proposed anyway
	if ministerTag == CCurrentGameState.GetPlayer() or score < 50 then
		--return
	end
	
	-- If there's no 'trade_logs.log' file, the function retruns immediately
	local sFileName = "tfh\\mod\\HPP\\logs\\trade_logs.log"
	
	local f = io.open( sFileName, "r" )
	if not f then
		return
	else
		f:close()
		f = io.open( sFileName, "a" )
	end
	
	-- The event we are logging
	f:write( "Evaluating trade, " .. P.GameTimeStamp() .. " (" .. os.date() .. ")\n" )
	f:write( "\t" .. P.FindCountryNameByTag( ministerTag ) .. " offers trade agreement to " .. P.FindCountryNameByTag( targetTag ) .. "\n" )
	
	f:write( "\tTrade specifics:\n")
	for i = 0, CGoodsPool._GC_NUMOF_ do
		if P.ResourceValueOfType( Export, i ) > 0 then
			f:write( "\t\t" .. P.FindCountryNameByTag( ministerTag ) .. " exports " .. P.ResourceNameByID( i ) .. ": " .. tostring( P.ResourceValueOfType( Export, i ) ) .. "\n" )
		end
		if P.ResourceValueOfType( Import, i ) > 0 then
			f:write( "\t\t" .. P.FindCountryNameByTag( ministerTag ) .. " imports " .. P.ResourceNameByID( i ) .. ": " .. tostring( P.ResourceValueOfType( Import, i ) ) .. "\n" )
		end
	end
	
	f:write( "\tTrade value: " .. tostring( TradeValue ) .. "\n" )
	f:write( "\tDiplomatic multiplier: " .. tostring( DiplomaticMultiplier ) .. "\n" )
	f:write( "\tFinal score: " .. tostring( score ) .. "\n\n" )
	
	f:close()

end

-- Logs evaluated trade value calculation
function P.LOG_AI_TRADE_VALUE( ministerTag, partnerTag, Export, Import, score )

	if not ( P.ASSERT( ministerTag ) )
	or not ( P.ASSERT( partnerTag ) )
	or not ( P.ASSERT( Export ) )
	or not ( P.ASSERT( Import ) )
	or not ( P.ASSERT( score ) )
	then
		return
	end
	
	-- If there's no 'trade_logs.log' file, the function retruns immediately
	local sFileName = "tfh\\mod\\HPP\\logs\\trade_logs.log"
	
	local f = io.open( sFileName, "r" )
	if not f then
		return
	else
		f = io.open( sFileName, "a" )
	end
	
	-- The event we are logging
	f:write( "Trade Value, " .. P.GameTimeStamp() .. " (" .. os.date() .. ")\n" )
	f:write( "\t" .. P.FindCountryNameByTag( ministerTag ) .. " evaluates the value of a trade with " .. P.FindCountryNameByTag( partnerTag ) .."\n" )
	
	local ministerCountry = ministerTag:GetCountry()
	local partnerCountry = partnerTag:GetCountry()
	local pool = ministerCountry:GetPool()
	local partnerPool = partnerCountry:GetPool()
	f:write( "\tTrade specifics:\n")
	for i = 0, CGoodsPool._GC_NUMOF_ do
		if P.ResourceValueOfType( Export, i ) > 0 then
			f:write( "\t\t" .. P.FindCountryNameByTag( ministerTag ) .. " exports " .. P.ResourceNameByID( i ) .. ": " .. tostring( P.ResourceValueOfType( Export, i ) ) .. "\n" )
			f:write( "\t\t Current stockpile: " .. tostring( pool:GetFloat( i ) ) .. ", estimated limit: " .. tostring( Support.GetEffectiveResourceLimit( ministerCountry, i ) ) .. "\n" )
			f:write( "\t\t Current partner stockpile: " .. tostring( partnerPool:GetFloat( i ) ) .. ", estimated partner limit: " .. tostring( Support.GetEffectiveResourceLimit( partnerCountry, i ) ) .. "\n" )
		end
		if P.ResourceValueOfType( Import, i ) > 0 then
			f:write( "\t\t" .. P.FindCountryNameByTag( ministerTag ) .. " imports " .. P.ResourceNameByID( i ) .. ": " .. tostring( P.ResourceValueOfType( Import, i ) ) .. "\n" )
			f:write( "\t\t Current stockpile: " .. tostring( pool:GetFloat( i ) ) .. ", estimated limit: " .. tostring( Support.GetEffectiveResourceLimit( ministerCountry, i ) ) .. "\n" )
			f:write( "\t\t Current partner stockpile: " .. tostring( partnerPool:GetFloat( i ) ) .. ", estimated partner limit: " .. tostring( Support.GetEffectiveResourceLimit( partnerCountry, i ) ) .. "\n" )
		end
	end
	
	f:write( "\tFinal score: " .. tostring( score ) .. "\n\n" )
	
	f:close()

end

-- Logs decision
function P.LOG_DECISION( ministerTag, decisionString )
	if not ( P.ASSERT( ministerTag ) )
	or not ( P.ASSERT( decisionString ) )
	then
		return
	end
	
	-- If there's no 'decision_logs.log' file, the function retruns immediately
	local sFileName = "tfh\\mod\\HPP\\logs\\decision_logs.log"
	
	local f = io.open( sFileName, "r" )
	if not f then
		return
	else
		f = io.open( sFileName, "a" )
	end
	
	f:write( P.GameTimeStamp() .. ": " .. P.FindCountryNameByTag( ministerTag ) .. " used the decision: " .. decisionString .. "\n")
	f:close()
end

-- Logs important AI actions like mobilizing, declaring war, forging alliances, etc.
function P.LOG_DIPLOMACY( ministerTag, targetTag, diplomaticActionString )
	if not ( P.ASSERT( ministerTag ) )
	or not ( P.ASSERT( targetTag ) )
	or not ( P.ASSERT( diplomaticActionString ) )
	then
		return
	end
	
	-- If there's no 'diplomacy_logs.log' file, the function retruns immediately
	local sFileName = "tfh\\mod\\HPP\\logs\\diplomacy_logs.log"
	
	local f = io.open( sFileName, "r" )
	if not f then
		return
	else
		f = io.open( sFileName, "a" )
	end
	
	if ministerTag == targetTag then
		f:write( P.GameTimeStamp() .. ": " .. P.FindCountryNameByTag( ministerTag ) .. " made the following action: " .. diplomaticActionString .. "\n")
	else
		f:write( P.GameTimeStamp() .. ": " .. P.FindCountryNameByTag( ministerTag ) .. " made the following action to " .. P.FindCountryNameByTag( targetTag ) .. ": " .. diplomaticActionString .. "\n")
	end
	f:close()
end

-- I want to replace this with my own in the long run.
function P.LUA_DEBUGOUT(s)

	if not P.ASSERT( s ) then
		return
	end

	-- SSmith (02/05/2013)
	-- It will make life easier if I just get the debug command to return the game date

	local yy = CCurrentGameState.GetCurrentDate():GetYear()
	local mm = CCurrentGameState.GetCurrentDate():GetMonthOfYear() + 1
	local dd = CCurrentGameState.GetCurrentDate():GetDayOfMonth() + 1

	local f = io.open("lua_output.txt", "a")
	f:write(tostring(dd) .. "/" .. tostring(mm) .. "/" .. tostring(yy) .. ": " .. s .. "\n")
	f:close()
end

-----------------------------------------------------------------------------
-- calls specified function in country specific AI module if it exists
--
-- tag: country tag to load library for
-- funName: name of function to call if exists
-- currentScore - current score, returned if no module found
-- rest of args are passed to resolved funName and currentScore appended.
-----------------------------------------------------------------------------
function P.CallScoredCountryAI(tag, funName, currentScore, ...)
	local funRef = P.HasCountryAIFunction(tag, funName)
	if funRef then
		return funRef(currentScore, ...)
	end
	return currentScore
end

function P.CallCountryAI(tag, funName, ...)
	local funRef = P.HasCountryAIFunction(tag, funName)
	if funRef then
		return funRef(...)
	end
end

-- returns function ref if one exists, otherwise null
function P.HasCountryAIFunction(tag, funName)
	local countryModule = _G['AI_' .. tostring(tag)]
	if countryModule then
		local funRef = countryModule[funName]
		return funRef
	end
	return nil
end

-- returns list of files in a directory matching pattern
function P.ScanDir(dirname, pattern )
	local callit = os.tmpname()
	os.execute("dir /A-D /B "..dirname .. " >"..callit)
	local f = io.open(callit,"r")
	local rv = f:read("*all")
	f:close()
	os.remove(callit)

	tabby = {}
	local from  = 1
	local delim_from, delim_to = string.find( rv, "\n", from  )
	while delim_from do
		local subs = string.sub( rv, from , delim_from-1 )
		if string.match(subs, pattern) then
			table.insert( tabby, subs )
		end
		from  = delim_to + 1
		delim_from, delim_to = string.find( rv, "\n", from  )
	end
	return tabby
end

-- Create Unit with NO attachments
--    Used to create naval, air and land divisions with no special needs.
function P.CreateDivision_nominor(minister, vsType, viMaxSerial, ic, viUnitQuantity, viMaxPerDiv, vbGoOver)

	if ( not P.ASSERT( minister ) )
	or ( not P.ASSERT( vsType ) )
	or ( not P.ASSERT( viMaxSerial ) )
	or ( not P.ASSERT( ic ) )
	or ( not P.ASSERT( viUnitQuantity ) )
	or ( not P.ASSERT( viMaxPerDiv ) )
	or ( not P.ASSERT( vbGoOver ) )
	then
		return -1, -1
	end

	local ministerCountry = minister:GetCountry()
	local unitType = CSubUnitDataBase.GetSubUnit(vsType)	
	local liTotalDivisions
	if viMaxPerDiv == 0 then
		liTotalDivisions = viUnitQuantity
	else
		liTotalDivisions = math.floor( viUnitQuantity / viMaxPerDiv )
	end
	
	-- SSmith (30/05/2013)
	-- Always request a minimum of 1 unit

	liTotalDivisions = math.max( liTotalDivisions, 1)

	-- viMaxSerial tells how many ADDITIONAL units could be put into a serial, so let's increase it with one!
	viMaxSerial = viMaxSerial + 1
	
	local builderTag = CNullTag()
	-- Let's give the AI the ability to build kind-of licensed stuff!
	if vsType ~= "battleship" and vsType ~= "battlecruiser"		-- Except for capital ships,
	and vsType ~= "carrier" and vsType ~= "escort_carrier"		-- because they are not licensable,
	and vsType ~= "transport"									-- and transports, because they are the same for everyone.
	then
		if ministerCountry:IsSubject() then
			-- Puppets can use their master's stuff.
			builderTag = ministerCountry:GetOverlord()
		elseif ministerCountry:HasFaction() and ministerCountry:GetTotalIC() < 75 then
			-- Non-majors in a faction can use the Faction Leader's stuff.
			builderTag = ministerCountry:GetFaction():GetFactionLeader()
		end
	end
	
	if ic > 0.2 and ministerCountry:GetTechnologyStatus():IsUnitAvailable(unitType) then	
		local capitalProvId = ministerCountry:GetActingCapitalLocation():GetProvinceID()
		local bBuildReserve = unitType:IsRegiment()			-- Always build reserves, even at war!
		local i = 0 -- Counter for amount of units built

		-- SSmith (25/05/2013)
		-- The generic unit build cost calculation is useless
		-- The country build cost is better but is still inaccurate (probably due to practicals...)
		-- We can use the full cost for ships but we must reduce the cost for land/air units to 40% of the values in the unit files

		--local unitcost = unitType:GetBuildCostIC():Get()
		local unitcost = ministerCountry:GetBuildCostIC( CSubUnitDataBase.GetSubUnit(vsType), 1, bBuildReserve ):Get()

		local tagString = "XXX"
		if tostring(minister:GetCountryTag()) == tagString then
			Utils.LUA_DEBUGOUT("")
			Utils.LUA_DEBUGOUT("Unit Type: " .. vsType)
			Utils.LUA_DEBUGOUT("Unit Cost: " .. tostring(unitcost))
		end

		if not ( unitType:IsShip() ) then
			unitcost = unitcost * 0.4	-- Build costs for aircraft and ground forces are actually 40% of the values in the unit files!
		end

		if tostring(minister:GetCountryTag()) == tagString then
			Utils.LUA_DEBUGOUT("Adjs Cost: " .. tostring(unitcost))
			Utils.LUA_DEBUGOUT("Real Cost: " .. tostring(ministerCountry:GetBuildCostIC( CSubUnitDataBase.GetSubUnit(vsType), 1, bBuildReserve ):Get()))
			Utils.LUA_DEBUGOUT("True: " .. tostring(ministerCountry:GetBuildCostIC( CSubUnitDataBase.GetSubUnit(vsType), 1, true ):Get()))
			Utils.LUA_DEBUGOUT("False: " .. tostring(ministerCountry:GetBuildCostIC( CSubUnitDataBase.GetSubUnit(vsType), 1, false ):Get()))
			Utils.LUA_DEBUGOUT("True: " .. tostring(ministerCountry:GetBuildCostIC( CSubUnitDataBase.GetSubUnit(vsType), 1, true ):Get()) * 0.4)
			Utils.LUA_DEBUGOUT("False: " .. tostring(ministerCountry:GetBuildCostIC( CSubUnitDataBase.GetSubUnit(vsType), 1, false ):Get()) * 0.4)
		end

		-- SSmith (26/05/2013)
		-- CAG logic moved later so that the cost doesn't deter construction!
		
		while i < liTotalDivisions and ic > 0.2 do
			local buildcount
			
			if 	liTotalDivisions >= (i + viMaxSerial) then
				buildcount = viMaxSerial
				i = i + viMaxSerial
			else
				buildcount = liTotalDivisions - i
				i = liTotalDivisions
			end
			
			-- For whatever reason, subtracting a number from another didn't work, so let's multiply it by -1 and then add it... :confused:
			local totalcost = unitcost * viMaxPerDiv
			local res = ic + ( totalcost * -1 )

			-- SSmith (27/05/2013)
			-- We used to go over if we could afford 75% of the cost
			-- This is too big a hurdle for expensive units so we'll only demand 50%
			
			-- Even if we can go over the remaining IC we could allocate, we shouldn't really start builds with less than about 50% of its required IC cost!
			if res > 0.0 or ( vbGoOver and ( math.abs( res ) < totalcost * 0.50 ) ) then
				ic = res
				
				local orderlist = SubUnitList()
				-- Add the amount of brigades requested of the main type
				if viMaxPerDiv == 1 then
					SubUnitList.Append( orderlist, unitType )
				else
					for m = 1, viMaxPerDiv, 1 do
						SubUnitList.Append( orderlist, unitType )
					end
				end
				viUnitQuantity = viUnitQuantity - ( viMaxPerDiv * buildcount )
	
				minister:GetOwnerAI():Post( CConstructUnitCommand( minister:GetCountryTag(), orderlist, capitalProvId, buildcount, bBuildReserve, builderTag, CID() ) )
				
				-- If this was a Carrier, we need to add CAGs as well!

				-- SSmith (26/05/2013)
				-- CAGs are aircraft so the cost must be multiplied by 0.4
				-- The CAG cost was deterring construction so we apply in now after we've worked out the cost!

				if vsType == "carrier" then
					ic = ic - (ministerCountry:GetBuildCostIC( CSubUnitDataBase.GetSubUnit("cag"), 2, false ):Get() * 0.4)
					local caglist = SubUnitList()
					SubUnitList.Append( caglist, CSubUnitDataBase.GetSubUnit("cag") )
					minister:GetOwnerAI():Post(CConstructUnitCommand(minister:GetCountryTag(), caglist, capitalProvId, 1, false, builderTag, CID()))
					minister:GetOwnerAI():Post(CConstructUnitCommand(minister:GetCountryTag(), caglist, capitalProvId, 1, false, builderTag, CID()))
				elseif vsType == "escort_carrier" then
					ic = ic - (ministerCountry:GetBuildCostIC( CSubUnitDataBase.GetSubUnit("cag"), 1, false ):Get() * 0.4)
					local caglist = SubUnitList()
					SubUnitList.Append( caglist, CSubUnitDataBase.GetSubUnit("cag") )
					minister:GetOwnerAI():Post(CConstructUnitCommand(minister:GetCountryTag(), caglist, capitalProvId, 1, false, builderTag, CID()))
				end
			else
				i = liTotalDivisions --Causes it to exit loop
			end
		end
	end
	
	return ic, viUnitQuantity
end

-- Create Divisions with minor attachments
--    Used only for land untis and adding artillery etc....
function P.CreateDivision(minister, vsType, viMaxSerial, ic, viUnitQuantity, viMaxPerDiv, vaMinorUnitArray, viAttachments, vbGoOver)

	if ( not P.ASSERT( minister ) )
	or ( not P.ASSERT( vsType ) )
	or ( not P.ASSERT( viMaxSerial ) )
	or ( not P.ASSERT( ic ) )
	or ( not P.ASSERT( viUnitQuantity ) )
	or ( not P.ASSERT( viMaxPerDiv ) )
	or ( not P.ASSERT( vaMinorUnitArray ) )
	or ( not P.ASSERT( viAttachments ) )
	or ( not P.ASSERT( vbGoOver ) )
	then
		return -1, -1
	end

	local ministerCountry = minister:GetCountry()
	local unitType = CSubUnitDataBase.GetSubUnit(vsType)
	local liTotalDivisions
	if viMaxPerDiv == 0 then
		liTotalDivisions = viUnitQuantity
	else
		liTotalDivisions = math.floor( viUnitQuantity / viMaxPerDiv )
	end

	-- SSmith (30/05/2013)
	-- Always request a minimum of 1 unit

	liTotalDivisions = math.max( liTotalDivisions, 1)
	
	-- viMaxSerial tells how many ADDITIONAL units could be put into a serial, so let's increase it with one!
	viMaxSerial = viMaxSerial + 1
	
	local builderTag = CNullTag()
	-- Let's give the AI the ability to build kind-of licensed stuff!
	-- No need to check for Capital ships here, since those are handled by the other function.
	if ministerCountry:IsSubject() then
		-- Puppets can use their master's stuff.
		builderTag = ministerCountry:GetOverlord()
	elseif ministerCountry:HasFaction() and ministerCountry:GetTotalIC() < 75 then
		-- Non-majors in a faction can use the Faction Leader's stuff.
		builderTag = ministerCountry:GetFaction():GetFactionLeader()
	end
	
	if ic > 0.2 and ministerCountry:GetTechnologyStatus():IsUnitAvailable(unitType) then
		local capitalProvId = ministerCountry:GetActingCapitalLocation():GetProvinceID()
		local bBuildReserve =  unitType:IsRegiment()		-- Don't build regulars even at war!
		local i = 0 -- Counter for amount of units built

		-- SSmith (25/05/2013)
		-- The generic unit build cost calculation is useless
		-- The country build cost is better but is still inaccurate (probably due to practicals...)
		-- We can use the full cost for ships but we must reduce the cost for land/air units to 40% of the values in the unit files

		--local unitcost = unitType:GetBuildCostIC():Get() * 0.4	-- Build costs are actually 40% of the values in the unit files!
		local unitcost = ministerCountry:GetBuildCostIC( CSubUnitDataBase.GetSubUnit(vsType), 1, bBuildReserve ):Get() * 0.4

		local tagString = "XXX"
		if tostring(minister:GetCountryTag()) == tagString then
			Utils.LUA_DEBUGOUT("")
			Utils.LUA_DEBUGOUT("Unit Type: " .. vsType)
			Utils.LUA_DEBUGOUT("Unit Cost: " .. tostring(unitcost))
			Utils.LUA_DEBUGOUT("Real Cost: " .. tostring(ministerCountry:GetBuildCostIC( CSubUnitDataBase.GetSubUnit(vsType), 1, bBuildReserve ):Get()))
			Utils.LUA_DEBUGOUT("True: " .. tostring(ministerCountry:GetBuildCostIC( CSubUnitDataBase.GetSubUnit(vsType), 1, true ):Get()) * 0.4)
			Utils.LUA_DEBUGOUT("False: " .. tostring(ministerCountry:GetBuildCostIC( CSubUnitDataBase.GetSubUnit(vsType), 1, false ):Get()) * 0.4)
		end

		while i < liTotalDivisions and ic > 0.2 do
			local buildcount
			
			if 	liTotalDivisions >= (i + viMaxSerial) then
				buildcount = viMaxSerial
				i = i + viMaxSerial
			else
				buildcount = liTotalDivisions - i
				i = liTotalDivisions
			end
			
			-- For whatever reason, subtracting a number from another didn't work, so let's multiply it by -1 and then add it... :confused:
			local totalcost = unitcost * viMaxPerDiv
			local res = ic + ( totalcost * -1 )

			if tostring(minister:GetCountryTag()) == tagString then
				Utils.LUA_DEBUGOUT("Totl Cost: " .. tostring(totalcost))
			end
			
			-- SSmith (27/05/2013)
			-- We used to go over if we could afford 75% of the cost
			-- This is too big a hurdle for expensive units so we'll only demand 50%
			
			-- Even if we can go over the remaining IC we could allocate, we shouldn't really start builds with less than about 50% of its required IC cost!
			if res > 0.0 or ( vbGoOver and ( math.abs( res ) < totalcost * 0.50 ) ) then
				ic = res
				
				local orderlist = SubUnitList()
				-- Add the amount of brigades requested of the main type
				if viMaxPerDiv == 1 then
					SubUnitList.Append( orderlist, unitType )
				else
					for m = 1, viMaxPerDiv, 1 do
						SubUnitList.Append( orderlist, unitType )
					end
				end

				-- Attach a minor brigade if one can be attached
				--   updated the ic total for the minor unit being attached

				-- SSmith (25/05/2013)
				-- We need to reduce the IC by 40% of the base unit cost for land forces!

				for i = 1, viAttachments do
					local TotalMinors = table.getn(vaMinorUnitArray)
					if TotalMinors == 1 then
						SubUnitList.Append( orderlist, vaMinorUnitArray[1] )
						ic = ic - (ministerCountry:GetBuildCostIC( vaMinorUnitArray[1], 1, bBuildReserve ):Get() * 0.4)

						if tostring(minister:GetCountryTag()) == tagString then
							Utils.LUA_DEBUGOUT("Attach: " .. tostring(ministerCountry:GetBuildCostIC( vaMinorUnitArray[1], 1, bBuildReserve ):Get()) * 0.4)
						end

					elseif TotalMinors > 1 then
						local minorSelected = (math.random(TotalMinors))
						SubUnitList.Append( orderlist, vaMinorUnitArray[minorSelected] )
						ic = ic - (ministerCountry:GetBuildCostIC( vaMinorUnitArray[minorSelected], 1, bBuildReserve ):Get() * 0.4)

						if tostring(minister:GetCountryTag()) == tagString then
							Utils.LUA_DEBUGOUT("Attach: " .. tostring(ministerCountry:GetBuildCostIC( vaMinorUnitArray[minorSelected], 1, bBuildReserve ):Get()) * 0.4)
						end

					end
				end
				
				if vsType == "light_armor_brigade" or vsType == "armor_brigade" then			-- Additional support brigade for Armour!
					local MotorizedUnitArray = Utils.BuildMotorizedUnitArray(ministerCountry)	-- One from the motorized array.
					local TotalMinors = table.getn(MotorizedUnitArray)
					if TotalMinors > 0 then
						local minorSelected = (math.random(TotalMinors))
						SubUnitList.Append( orderlist, MotorizedUnitArray[minorSelected] )
						ic = ic - (ministerCountry:GetBuildCostIC( MotorizedUnitArray[minorSelected], 1, bBuildReserve ):Get() * 0.4)

						if tostring(minister:GetCountryTag()) == tagString then
							Utils.LUA_DEBUGOUT("Attach: " .. tostring(ministerCountry:GetBuildCostIC( MotorizedUnitArray[minorSelected], 1, bBuildReserve ):Get()) * 0.4)
						end

					end
				end				
				
				viUnitQuantity = viUnitQuantity - (viMaxPerDiv * buildcount)
				minister:GetOwnerAI():Post(CConstructUnitCommand(minister:GetCountryTag(), orderlist, capitalProvId, buildcount, bBuildReserve, builderTag, CID()))

				if ic < 0.2 then
					i = liTotalDivisions --Causes it to exit loop
				end
			else
				i = liTotalDivisions --Causes it to exit loop
			end
		end
	end

	return ic, viUnitQuantity
end

-- Setup Potential brigade attachments
-- ARMORED CARS
--    Not going to let the AI build armor cars

--- Build Leg Unit Array
function P.BuildLegUnitArray(ministerCountry)

	if not P.ASSERT( ministerCountry ) then
		return {}
	end
	
	-- Leg Brigades
	local LegUnitArray = {}
	local horse_towed_support_brigade = CSubUnitDataBase.GetSubUnit("horse_towed_support_brigade")
	local super_heavy_armor_brigade = CSubUnitDataBase.GetSubUnit("super_heavy_armor_brigade")
	local techStatus = ministerCountry:GetTechnologyStatus()
	
	-- If we can build Support Brigades, then we probably should.
	if techStatus:IsUnitAvailable(horse_towed_support_brigade) then
		table.insert( LegUnitArray, horse_towed_support_brigade )
		table.insert( LegUnitArray, horse_towed_support_brigade )
		table.insert( LegUnitArray, horse_towed_support_brigade )
		table.insert( LegUnitArray, horse_towed_support_brigade )
		table.insert( LegUnitArray, horse_towed_support_brigade )
		table.insert( LegUnitArray, horse_towed_support_brigade )
	end
	-- Don't add Infantry Support Tanks for GER, USA, SOV, ITA and JAP
	local ministerTagString = tostring(ministerCountry:GetCountryTag())
	if not (
		ministerTagString == 'USA' or ministerTagString == 'JAP'
		or ministerTagString == 'SOV' or ministerTagString == 'ITA'
		or ministerTagString == 'GER'
	)
	then
		if techStatus:IsUnitAvailable(super_heavy_armor_brigade) then
			table.insert( LegUnitArray, super_heavy_armor_brigade )
		end
	end
	
	return LegUnitArray
end

--- Build Motorized Unit Array
function P.BuildMotorizedUnitArray(ministerCountry)

	if not P.ASSERT( ministerCountry ) then
		return {}
	end
	
	-- Motorized Brigades
	local MotorizedUnitArray = {}
	local truck_towed_support_brigade = CSubUnitDataBase.GetSubUnit("truck_towed_support_brigade")
	local tank_destroyer_brigade = CSubUnitDataBase.GetSubUnit("tank_destroyer_brigade")
	local heavy_armor_brigade = CSubUnitDataBase.GetSubUnit("heavy_armor_brigade")
	local techStatus = ministerCountry:GetTechnologyStatus()
	
	-- SSmith (27/11/2013)
	-- Quick fix so that Germany doesn't build heavy armour before 1939
	local ministerTagString = tostring(ministerCountry:GetCountryTag())

	--Check to see if they can actually build heavy_armor_brigade
	if ministerCountry:GetTechnologyStatus():IsUnitAvailable(heavy_armor_brigade) 
	and (ministerTagString ~= "GER" or CCurrentGameState.GetCurrentDate():GetYear() > 1938) then
		table.insert( MotorizedUnitArray, heavy_armor_brigade )	-- Add H-Arm twice!
		table.insert( MotorizedUnitArray, heavy_armor_brigade )
		table.insert( MotorizedUnitArray, heavy_armor_brigade )
	end	
	--Check to see if they can actually build tank_destroyer_brigade
	if ministerCountry:GetTechnologyStatus():IsUnitAvailable(tank_destroyer_brigade) then
		table.insert( MotorizedUnitArray, tank_destroyer_brigade )
		table.insert( MotorizedUnitArray, tank_destroyer_brigade )
	end	
	--Check to see if they can actually build truck_towed_support_brigade
	if ministerCountry:GetTechnologyStatus():IsUnitAvailable(truck_towed_support_brigade) then
		table.insert( MotorizedUnitArray, truck_towed_support_brigade )
		table.insert( MotorizedUnitArray, truck_towed_support_brigade )
		table.insert( MotorizedUnitArray, truck_towed_support_brigade )
		table.insert( MotorizedUnitArray, truck_towed_support_brigade )
		table.insert( MotorizedUnitArray, truck_towed_support_brigade )
	end
	
	return MotorizedUnitArray
end

--- Build Armor Unit Array
function P.BuildArmorUnitArray(ministerCountry)

	if not P.ASSERT( ministerCountry ) then
		return {}
	end
	
	-- Armor Brigades
	local ArmorUnitArray = {}
	local motorized_brigade = CSubUnitDataBase.GetSubUnit("motorized_brigade")
	local mechanized_brigade = CSubUnitDataBase.GetSubUnit("mechanized_brigade")
	
	--Setup potential Armor UNIT minor brigades
	-- #############################################
	--Check to see if they can actually build motorized_brigade or mechanized_brigade
	if ministerCountry:GetTechnologyStatus():IsUnitAvailable(mechanized_brigade) then		-- Add MEC if we can
		table.insert( ArmorUnitArray, mechanized_brigade )
	elseif ministerCountry:GetTechnologyStatus():IsUnitAvailable(motorized_brigade) then	-- Add MOT if we can, and can't add MEC
		table.insert( ArmorUnitArray, motorized_brigade )
	end	
	
	return ArmorUnitArray
end

function P.BuildGarrisonUnitArray(ministerCountry)

	if not P.ASSERT( ministerCountry ) then
		return {}
	end
	
	-- Garrison Brigades
	local GarrisonUnitArray = {}
	-- Garrisons on partisan hunt shouldn't really use any additional brigades
	return GarrisonUnitArray
end	

function P.BuildDefenceGarrisonUnitArray(ministerCountry)

	if not P.ASSERT( ministerCountry ) then
		return {}
	end
	
	-- Garrison Brigades
	local DefenceGarrisonUnitArray = {}
	local horse_towed_support_brigade = CSubUnitDataBase.GetSubUnit("horse_towed_support_brigade")
	
	--Check to see if they can actually build horse_towed_support_brigade
	if ministerCountry:GetTechnologyStatus():IsUnitAvailable(horse_towed_support_brigade) then
		table.insert( DefenceGarrisonUnitArray, horse_towed_support_brigade )
	end
	
	return DefenceGarrisonUnitArray
end			

function P.Round(viNumber)

	if not P.ASSERT( viNumber ) then
		return 0
	end
	
	-- In case of floating point issue
	viNumber = tonumber(tostring(viNumber))

	if (viNumber - math.floor(viNumber)) >= 0.5 then
		return math.ceil(viNumber)
	else
		return math.floor(viNumber)
	end
end

function P.IsFriend(ai, voFaction, voCountry)

	if ( not P.ASSERT( ai ) )
	or ( not P.ASSERT( voFaction ) )
	or ( not P.ASSERT( voCountry ) )
	then
		return false
	end
	
	-- If they are a 25 or more distance from us then consider them a potential enemy
	-- 45 or more is real bad they are heavily aligning to someone else.
	local rValue = true
	
	for loFaction in CCurrentGameState.GetFactions() do
		if loFaction ~= voFaction then
			-- They are aligning with another faction
			if ai:GetNormalizedAlignmentDistance(voCountry, loFaction):Get() < 25 then
				rValue = false
				break
			end
		end
	end
	
	return rValue
end

function P.CalculateHomeProduced(loResource)

	if not P.ASSERT( loResource ) then
		return 0
	end
	
	local liDailyHome = loResource.vDailyHome
	
	if loResource.vConvoyedIn > 0 then
		-- If the Convoy in exceeds Home Produced by 10% it means they have a glutten coming in or
		--   are a sea bearing country like ENG or JAP
		--   so go ahead and count this as home produced up to 80% of it just in case something happens!
		if liDailyHome > loResource.vDailyExpense then
			liDailyHome = liDailyHome + loResource.vConvoyedIn
		elseif loResource.vConvoyedIn > (liDailyHome * 0.1) then
			liDailyHome = liDailyHome + (loResource.vConvoyedIn * 0.9)
		end
	end	
	
	return liDailyHome
end

-- Returns with the name of the month of that number
function P.MonthNameByNumber( nMonthNumber )

	if not P.ASSERT( nMonthNumber ) then
		return "ERROR"
	end

	-- Months are indexed from 0 as January
	if nMonthNumber == 0 then		return "January"
	elseif nMonthNumber == 1 then	return "February"
	elseif nMonthNumber == 2 then	return "March"
	elseif nMonthNumber == 3 then	return "April"
	elseif nMonthNumber == 4 then	return "May"
	elseif nMonthNumber == 5 then	return "June"
	elseif nMonthNumber == 6 then	return "July"
	elseif nMonthNumber == 7 then	return "August"
	elseif nMonthNumber == 8 then	return "September"
	elseif nMonthNumber == 9 then	return "October"
	elseif nMonthNumber == 10 then	return "November"
	elseif nMonthNumber == 11 then	return "December"
	else return "Unknown"
	end
end

-- Returns the name of the resource by its ID
function P.ResourceNameByID( resourceID )
	
	if not P.ASSERT( resourceID ) then
		return "ERROR"
	end
	
	if		resourceID == CGoodsPool._SUPPLIES_			then return "Supplies"
	elseif	resourceID == CGoodsPool._FUEL_				then return "Fuel"
	elseif	resourceID == CGoodsPool._MONEY_			then return "Money"
	elseif	resourceID == CGoodsPool._CRUDE_OIL_		then return "Crude Oil"
	elseif	resourceID == CGoodsPool._METAL_			then return "Metal"
	elseif	resourceID == CGoodsPool._ENERGY_			then return "Energy"
	elseif	resourceID == CGoodsPool._RARE_MATERIALS_	then return "Rare Materials"
	else return "Unknown"
	end
end

-- Returns the name of the production item IC can be allocated to
function P.ProductionDistributionName( distributionID )
	
	if not P.ASSERT( distributionID ) then
		return "ERROR"
	end
	
	if		distributionID == CDistributionSetting._PRODUCTION_CONSUMER_		then return "Consumer Goods"
	elseif	distributionID == CDistributionSetting._PRODUCTION_PRODUCTION_		then return "Production"
	elseif	distributionID == CDistributionSetting._PRODUCTION_SUPPLY_			then return "Supplies"
	elseif	distributionID == CDistributionSetting._PRODUCTION_REINFORCEMENT_	then return "Reinforcements"
	elseif	distributionID == CDistributionSetting._PRODUCTION_UPGRADE_			then return "Upgrades"
	else return "Unknown"
	end
end

-- Returns the name of the production item IC can be allocated to
function P.ProductionDistributionName( distributionID )
	
	if not P.ASSERT( distributionID ) then
		return "ERROR"
	end
	
	if		distributionID == CDistributionSetting._PRODUCTION_CONSUMER_		then return "Consumer Goods"
	elseif	distributionID == CDistributionSetting._PRODUCTION_PRODUCTION_		then return "Production"
	elseif	distributionID == CDistributionSetting._PRODUCTION_SUPPLY_			then return "Supplies"
	elseif	distributionID == CDistributionSetting._PRODUCTION_REINFORCEMENT_	then return "Reinforcements"
	elseif	distributionID == CDistributionSetting._PRODUCTION_UPGRADE_			then return "Upgrades"
	else return "Unknown"
	end
end

-- Returns the name of the Spy Mission by its ID
function P.SpyMissionByID( missionID )
	
	if not P.ASSERT( missionID ) then
		return "ERROR"
	end
	
	if		missionID == SpyMission.SPYMISSION_BOOST_OUR_PARTY		then return "Support our party"
	elseif	missionID == SpyMission.SPYMISSION_BOOST_RULING_PARTY	then return "Support ruling party"
	elseif	missionID == SpyMission.SPYMISSION_COUNTER_ESPIONAGE	then return "Counterespionage"
	elseif	missionID == SpyMission.SPYMISSION_DISRUPT_PRODUCTION	then return "Disrupt production"
	elseif	missionID == SpyMission.SPYMISSION_DISRUPT_RESEARCH		then return "Disrupt research"
	elseif	missionID == SpyMission.SPYMISSION_INCREASE_THREAT		then return "Increase threat"
	elseif	missionID == SpyMission.SPYMISSION_LOWER_NATIONAL_UNITY	then return "Lower national unity"
	elseif	missionID == SpyMission.SPYMISSION_MILITARY				then return "Military espionage"
	elseif	missionID == SpyMission.SPYMISSION_NONE					then return "None"
	elseif	missionID == SpyMission.SPYMISSION_POLITICAL			then return "Political espionage"
	elseif	missionID == SpyMission.SPYMISSION_RAISE_NATIONAL_UNITY	then return "Raise national unity"
	elseif	missionID == SpyMission.SPYMISSION_SUPPORT_RESISTANCE	then return "Support resistance"
	elseif	missionID == SpyMission.SPYMISSION_TECH					then return "Tech espionage"
	else	return "Unknown"
	end
end

-- Recieves a CGoodsValues object and a resource type and returns with the value of that type in the object
-- Because they couldn't use a proper Array for that, no, it would have been tooooo simple...
function P.ResourceValueOfType( GoodsValue, ResourceType )

	if not ( P.ASSERT( GoodsValue ) )
	or not ( P.ASSERT( ResourceType ) )
	then
		return 0
	end
	
	if		ResourceType == CGoodsPool._SUPPLIES_ 		then return GoodsValue.vSupplies
	elseif	ResourceType == CGoodsPool._FUEL_ 			then return GoodsValue.vFuel
	elseif	ResourceType == CGoodsPool._MONEY_ 			then return GoodsValue.vMoney
	elseif	ResourceType == CGoodsPool._CRUDE_OIL_ 		then return GoodsValue.vCrudeOil
	elseif	ResourceType == CGoodsPool._METAL_ 			then return GoodsValue.vMetal
	elseif	ResourceType == CGoodsPool._ENERGY_ 		then return GoodsValue.vEnergy
	elseif	ResourceType == CGoodsPool._RARE_MATERIALS_ then return GoodsValue.vRareMaterials
	else
		return 0
	end
end

-- Sets the appropriate value of a CGoodsValues object.
function P.SetValueForGoodsValues( GoodsValue, ResourceType, ResourceValue )

	if not ( P.ASSERT( GoodsValue ) )
	or not ( P.ASSERT( ResourceType ) )
	or not ( P.ASSERT( ResourceValue ) )
	then
		return
	end
	
	if		ResourceType == CGoodsPool._SUPPLIES_ 		then GoodsValue.vSupplies 		= ResourceValue
	elseif	ResourceType == CGoodsPool._FUEL_ 			then GoodsValue.vFuel			= ResourceValue
	elseif	ResourceType == CGoodsPool._MONEY_ 			then GoodsValue.vMoney			= ResourceValue
	elseif	ResourceType == CGoodsPool._CRUDE_OIL_ 		then GoodsValue.vCrudeOil		= ResourceValue
	elseif	ResourceType == CGoodsPool._METAL_ 			then GoodsValue.vMetal			= ResourceValue
	elseif	ResourceType == CGoodsPool._ENERGY_ 		then GoodsValue.vEnergy			= ResourceValue
	elseif	ResourceType == CGoodsPool._RARE_MATERIALS_ then GoodsValue.vRareMaterials	= ResourceValue
	end
end

-- Looks up the localisation string for the given ID from the given localisation file
function P.FindLineInLocalisationFile( sID, sFileName )

	if not ( P.ASSERT( sID ) )
	or not ( P.ASSERT( sFileName ) )
	then
		return "ERROR"
	end
	
	local f = io.open("mod\\HPP\\localisation\\" .. sFileName .. ".csv", "r")
	local sReturnString = "ID NOT FOUND"
	
	if f then
		local sLine	-- The temporary string we will store the line in
		local i, j	-- The index of the first ";" in the line
		while true do
			sLine = f:read("*line")
			if sLine == nil or sLine == "" then
				-- Empty lines would screw up the game as well,
				-- so we may assume that those mean the end of the file!
				break
			end
			if not string.find( sLine, "#" ) then		-- Comments can be disregarded.
				-- Find the first ";" mark
				i, j = string.find( sLine, ";" )
				if string.sub( sLine, 1, i - 1 ) == sID then
					-- This line starts with the ID we got as a parameter
					sLine = string.sub( sLine, j + 1 )	-- Remove the ID and the first ";"
					i, j = string.find( sLine, ";" )	-- Find the second ";" mark
					sReturnString = string.sub( sLine, 1, i - 1 )	-- Return with the second string from the line
				end
			end
		end
	else
		sReturnString = "FILE NOT FOUND"
	end
	
	f:close()
	
	return sReturnString
end

-- Looks up the province name by it's ID
function P.FindProvinceNameByID( nProvinceID )
	
	if not P.ASSERT( nProvinceID ) then
		return "ERROR"
	end
	
	return P.FindLineInLocalisationFile( "PROV" .. tostring( nProvinceID ), "province_names" )
end

-- Looks up the country name by a Country Tag
function P.FindCountryNameByTag( countryTag )
	
	if not P.ASSERT( countryTag ) then
		return "ERROR"
	end
	
	return P.FindLineInLocalisationFile( tostring( countryTag ), "countries" )
end

-- Returns the current in-game timestamp in a string
function P.GameTimeStamp()
	local pDate = CCurrentGameState.GetCurrentDate()
	return "Date: " .. tostring( pDate:GetYear() ) .. " " .. P.MonthNameByNumber( pDate:GetMonthOfYear() ) .. " " .. tostring( pDate:GetDayOfMonth() + 1 )
end

function P.SameIdeology(ministerCountry, TargetCountry, TargetIdeology)
	
	-- in this function we either get the target country or the target ideology
	if not P.ASSERT( ministerCountry )
	or (TargetCountry == nil and TargetIdeology == nil)
	then
		return false
	end
	
	if TargetIdeology == nil then
		TargetIdeology = TargetCountry:GetRulingIdeology()
	end
	
	local SameIdeology = false	
	local ministerGroupString = tostring(ministerCountry:GetRulingIdeology():GetGroup():GetKey())
	local TargetGroupString = tostring(TargetIdeology:GetGroup():GetKey())
	local TargetIdeologyString = tostring(TargetIdeology:GetKey())

	if ministerGroupString == TargetGroupString then
		SameIdeology = true
	elseif ministerGroupString == "democracy" and TargetIdeologyString == 'paternal_autocrat' then
		SameIdeology = true
	elseif ministerGroupString == "democracy" and TargetIdeologyString == 'left_wing_radical' then
		SameIdeology = true
	elseif ministerGroupString == 'fascism' and TargetIdeologyString == 'social_conservative' then
		SameIdeology = true
	elseif ministerGroupString == 'communism' and TargetIdeologyString == 'social_democrat' then
		SameIdeology = true
	end
	
	return SameIdeology
end

return Utils
