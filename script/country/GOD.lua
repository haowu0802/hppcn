-----------------------------------------------------------
-- LUA Hearts of Iron 3 Switzerland File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 4/27/2010
-----------------------------------------------------------

local P = {}
AI_GOD = P

function P.HandleMobilization(minister, needsMobilization)
	return false
end

function P.DiploScore_JoinFaction(score, minister, faction)
	return 0
end

function P.DiploScore_InviteToFaction(score, ai, actor, recipient, observer)
	return 0
end

function P.DiploScore_Guarantee(score, ai, actor, recipient, observer)
	return 0
end

function P.DiploScore_OfferTrade(score, ai, actor, recipient, observer, voTradedFrom, voTradedTo)
	return 0
end

function P.DiploScore_OfferMilitaryAccess(score, ai, actor, recipient, observer, action)
	return 0
end

function P.DiploScore_DemandMilitaryAccess( score, ai, actor, recipient, observer )
    return 0
end

function P.DiploScore_Alliance( score, ai, actor, recipient, observer, action)
	return 0
end

function P.DiploScore_InviteToFaction( score, ai, actor, recipient, observer)
	return 0
end

function P.ForeignMinister_EvaluateDecision(score, agent, decision, scope)

	if tostring(decision:GetKey()) == "setup_event" then
		-- Clear all the logs!
		
		-- Nil Parameters
		local nil_params = io.open( "mod\\HPP\\logs\\nil_params.log", "r" )
		if nil_params then
			nil_params:close()
			nil_params = io.open( "mod\\HPP\\logs\\nil_params.log", "w" )
			nil_params:write( "" )
			nil_params:close()
		end
		-- Trade Logs
		local trade_logs = io.open( "mod\\HPP\\logs\\trade_logs.log", "r" )
		if trade_logs then
			trade_logs:close()
			trade_logs = io.open( "mod\\HPP\\logs\\trade_logs.log", "w" )
			trade_logs:write( "" )
			trade_logs:close()
		end
		-- Decision Logs
		local decision_logs = io.open( "mod\\HPP\\logs\\decision_logs.log", "r" )
		if decision_logs then
			decision_logs:close()
			decision_logs = io.open( "mod\\HPP\\logs\\decision_logs.log", "w" )
			decision_logs:write( "" )
			decision_logs:close()
		end
		-- Diplomacy Logs
		local decision_logs = io.open( "mod\\HPP\\logs\\diplomacy_logs.log", "r" )
		if decision_logs then
			decision_logs:close()
			decision_logs = io.open( "mod\\HPP\\logs\\diplomacy_logs.log", "w" )
			decision_logs:write( "" )
			decision_logs:close()
		end
		-- The Strategic logs are restarted on their own.
		
		-- Check the starting manpower levels just before the setup event changes them around!
		local manpower_log = io.open( "mod\\HPP\\logs\\manpower_log.log", "r" )
		if manpower_log then
			manpower_log:close()
			manpower_log = io.open( "mod\\HPP\\logs\\manpower_log.log", "w" )
			-- Iterate through all the currently existing countries and log their manpower level!
			for country in CCurrentGameState.GetCountries() do
				if country:GetCountryTag():IsValid() and country:GetCountryTag():IsReal() and country:Exists() then
					manpower_log:write( Utils.FindCountryNameByTag( country:GetCountryTag() ) .. "\n" )
					manpower_log:write( "\tManpower: " .. tostring( country:GetManpower():Get() ) .. "\n" )
				end
			end
			manpower_log:close()
		end
		
		-- Then take this decision immediately!
		return 100
	end

	if score == 0 then
		return 0
	else
		return 100
	end
end


return AI_GOD
