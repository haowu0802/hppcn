-- HPP TRADE LUA
-- Re-written by SSmith (December 2013)

-- Trade calculations in HPP are made based on current/ideal stockpile levels 
-- This is made necessary because the resource "storage" effects make the nett daily change an unreliable indicator

-- EXE functions:-

-- ProposeTrades (called by the EXE to create new trades)
-- EvaluateExistingTrades (called by the EXE to cancel unwanted trades)
-- DiploScore_OfferTrade (determines another AI's response to a trade offer)

-- Support functions:-

-- GetTradePosition (called when making or cancelling trades to work out what resources we want)
-- GetTradePartners (called when making trades to get a list of possible trading partners)
-- GetTradeFactors (calculates the recipient country's response to a trade proposal)
-- CheckTradeLimit (used to decide whether we want more trades of a given type)
-- GetTradeLimits (used to check whether we have enough trades of every type)
-- CheckAvailableConvoys (used to confirm we have enough convoys for an import trade)
-- CheckTradeDiplomacy (used to decide if we have enough diplomacy to trade)
-- ApplyTradeModifiers (adjusts the current resource ratios for specific countries)


-- ########################
-- Global Variables
-- ########################

local _SUPPLIES_ = CGoodsPool._SUPPLIES_
local _FUEL_ = CGoodsPool._FUEL_
local _MONEY_ = CGoodsPool._MONEY_
local _CRUDE_OIL_ = CGoodsPool._CRUDE_OIL_
local _METAL_ = CGoodsPool._METAL_
local _ENERGY_ = CGoodsPool._ENERGY_
local _RARE_MATERIALS_ = CGoodsPool._RARE_MATERIALS_


-- ###########################
-- Called by the EXE!
-- ###########################
-- function ForeignMinister_ManageTrade( ai, ministerTag )
-- 		NOT USED!!!
-- end

-- CALLED BY THE EXE Tries to set up new trades
function ProposeTrades( ai, ministerTag )

	if not ( Utils.ASSERT( ai ) )
	or not ( Utils.ASSERT( ministerTag ) )
	or not ( ministerTag:IsValid() )
	or not ( ministerTag:IsReal() )
	then
		return
	end

	-- Create a table to hold the input parameters to this function

	local Params = {
		AI = ai,
		MinisterTag = ministerTag
	}

	-- Create a table to hold any working objects or values

	local Work = {
		MinisterCountry = Params.MinisterTag:GetCountry(),
		DiplomacyCost = defines.diplomacy.TRADE_INFLUENCE_COST,
		DiplomacyPoints = 0,
		TotalIC = 0,
		IsAtWar = false,
		IsGovernmentInExile = false,
		FreeTradeRule = false,
		CashRich = false
	}

	Work.DiplomacyPoints = Work.MinisterCountry:GetDiplomaticInfluence():Get()
	Work.TotalIC = Work.MinisterCountry:GetTotalIC()

	-- Performance checks
	-- Make sure we really need to be running this code

	if Work.MinisterCountry:IsSubject() or tostring(Params.MinisterTag) == "GOD"	-- Puppets cannot trade and neither should GOD
	or Work.DiplomacyPoints < Work.DiplomacyCost					-- Check for diplomacy points
	or (Work.TotalIC + 20) < math.mod(CCurrentGameState.GetAIRand(), 50) then	-- Skip smaller countries some of the time
		return
	end

	Work.IsAtWar = Work.MinisterCountry:IsAtWar()
	Work.IsGovernmentInExile = Work.MinisterCountry:IsGovernmentInExile()

	if (not Work.IsAtWar or Work.IsGovernmentInExile)				-- Check less often when at peace or in exile
	and math.mod(CCurrentGameState.GetAIRand(), 2) == 0 then
		return
	end

	local tagString = "XXX"
	if tostring(Params.MinisterTag) == tagString then
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("ProposeTrades...")
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("Influence: " .. tostring(Work.DiplomacyPoints))
	end

	-- First we will calculate our trade requirements
	-- If we have enough money we won't propose selling resources

	local fnParams = {
		MinisterTag = Params.MinisterTag,
		MinisterCountry = Work.MinisterCountry,
		Cancelling = false
	}
	local TradePosition = GetTradePosition( fnParams )

	-- Use this information to find out if we are over our trade limits

	fnParams = {
		MinisterTag = Params.MinisterTag,
		MinisterCountry = Work.MinisterCountry,
		TotalIC = Work.TotalIC,
		TradePosition = TradePosition,
		Cancelling = false
	}
	local TradeLimits = GetTradeLimits ( fnParams )

	-- Check our available diplomacy

	fnParams = {
		MinisterTag = Params.MinisterTag,
		TotalIC = Work.TotalIC,
		Diplomacy = Work.DiplomacyPoints,
		TradePosition = TradePosition
	}
	local TradeDiplomacy = CheckTradeDiplomacy( fnParams )

	Work.CashRich = (TradePosition[_MONEY_].Ratio > 1)
	Work.FreeTradeRule = Work.MinisterCountry:GetRules():GetValue(CRule._RULE_FREE_RESOURCE_GIFTS_)

	-- Then we will consider making a trade in each resource

	for i = 0, 6 do

		if Work.DiplomacyPoints < Work.DiplomacyCost then

			return		-- If we are out of diplomacy then exit now for performance

		elseif i ~= _MONEY_
		and (not Work.IsGovernmentInExile or (i ~= _SUPPLIES_ and i ~= _FUEL_)) then

			-- We can only trade resources (not money)
			-- If we are government-in-exile we can't trade supplies or fuel

			-- Check the trading table to decide if we want to buy or sell
			-- And make sure we have a trade slot available
			-- As a last resort we will try to get free resources if we can
			-- If our diplomacy pool is getting low we are less likely to trade

			local Resource = {
				Buy = false,
				Sell = false,
				FreeOnly = false,
				DiplomacyModifier = math.max((10 - Work.DiplomacyPoints) * 2.5, 0),
				MinTradeFactor = 75,
				MaxTradeFactor = 0,
				HasConvoys = false,
				TradeMade = false,
				PartnerCountry,
				TradeQty = 0,
				MaxTradeQty = 0
			}

			if math.mod(CCurrentGameState.GetAIRand(), 100) < (TradePosition[i].BuyOffer - Resource.DiplomacyModifier)
			and TradeLimits[i].ImportsValid and TradeDiplomacy[i].OpenToTrade then
				Resource.Buy = true
			else
				fnParams.Buy = false
				if math.mod(CCurrentGameState.GetAIRand(), 100) < (TradePosition[i].SellOffer - Resource.DiplomacyModifier)
				and TradeLimits[i].ExportsValid and TradeDiplomacy[_MONEY_].OpenToTrade then
					Resource.Sell = true
				else
					fnParams.Buy = true
					if math.mod(CCurrentGameState.GetAIRand(), 100) < (TradePosition[i].BuyFree - Resource.DiplomacyModifier)
					and (Work.IsAtWar or Work.FreeTradeRule)
					and TradeLimits[i].ImportsValid and TradeDiplomacy[i].OpenToTrade then
						Resource.Buy = true
						Resource.FreeOnly = true
					end
				end
			end

			if Resource.Buy or Resource.Sell then

				-- Our potential trading partners may or may not be enthusiastic about the trade
				-- If the trade is important to us or we have a lot of diplomacy free we can pursue unlikely deals
				-- Otherwise we will play it safe

				if Resource.Buy and not Resource.FreeOnly then
					Resource.MinTradeFactor = Resource.MinTradeFactor - math.min(TradePosition[i].BuyOffer / 2, 25)
				elseif Resource.Sell then
					Resource.MinTradeFactor = Resource.MinTradeFactor - math.min(TradePosition[i].SellOffer / 2, 25)
				end
				if Work.DiplomacyPoints > 10 then
					Resource.MinTradeFactor = Resource.MinTradeFactor - math.min(Work.DiplomacyPoints - 10, 25)
				elseif Work.DiplomacyPoints < 10 then
					Resource.MinTradeFactor = Resource.MinTradeFactor + ((10 - Work.DiplomacyPoints) * 2.5)
				end

				-- Check that we have enough convoys for import trades

				fnParams = {
					MinisterTag = Params.MinisterTag,
					ConvoysFree = Work.MinisterCountry:GetTransports(),
					Ratio = TradePosition[i].Ratio,
					TotalIC = Work.TotalIC,
					IsAtWar = Work.IsAtWar
				}
				Resource.HasConvoys = CheckAvailableConvoys( fnParams )

				-- Next get a table of possible trading partners

				fnParams = {
					MinisterTag = Params.MinisterTag,
					MinisterCountry = Work.MinisterCountry,
					Goods = i,
					Buy = Resource.Buy,
					MinTradeFactor = Resource.MinTradeFactor,
					HasConvoys = Resource.HasConvoys,
					FreeOnly = Resource.FreeOnly,
					CashRich = Work.CashRich,
					IsAtWar = Work.IsAtWar,
					FreeTradeRule = Work.FreeTradeRule,
					TotalIC = Work.TotalIC
				}
				local TradePartners = GetTradePartners( fnParams )

				if tostring(Params.MinisterTag) == tagString then
					Utils.LUA_DEBUGOUT("")
					Utils.LUA_DEBUGOUT("ProposeTrades (partners)...")
					Utils.LUA_DEBUGOUT("")
					for j = 1, table.getn(TradePartners) do
						Utils.LUA_DEBUGOUT(tostring(TradePartners[j].PartnerTag) .. ": " .. tostring(TradePartners[j].TradeFactor))
					end
				end

				-- We will find the highest potential trade factor

				for j = 1, table.getn(TradePartners) do
					if TradePartners[j].TradeFactor > Resource.MaxTradeFactor then
						Resource.MaxTradeFactor = TradePartners[j].TradeFactor
					end
				end

				local index
				local work
				while table.getn(TradePartners) > 0 and not Resource.TradeMade do

					index = math.random(table.getn(TradePartners))

					work = Resource.MaxTradeFactor - TradePartners[index].TradeFactor
					if work < math.mod(CCurrentGameState.GetAIRand(), 25) then

						-- We have chosen a partner
						if tostring(Params.MinisterTag) == tagString then
							Utils.LUA_DEBUGOUT("")
							Utils.LUA_DEBUGOUT("Chosen: " .. tostring(TradePartners[index].PartnerTag))
						end

						Resource.PartnerCountry = TradePartners[index].PartnerTag:GetCountry()

						-- Calculate the trade quantity we want
						-- If we are buying and our stockpile is low then we want more
						-- If we are selling with a high stockpile we will sell more
						-- But our offer will be capped to fit our trading partner

						if Resource.Buy then
							work =  2 - math.min(TradePosition[i].Ratio, 1)
						else
							work =  math.min(math.max(TradePosition[i].Ratio, 1), 2)
						end

						Resource.TradeQty = TradePosition[i].Required * 0.001
						Resource.MaxTradeQty = Support.GetEffectiveResourceLimit( Resource.PartnerCountry, i ) * 0.001

						if i < _MONEY_ then
							Resource.TradeQty = Resource.TradeQty / 2
							Resource.MaxTradeQty = Resource.MaxTradeQty / 2
						end

						Resource.TradeQty = math.max( math.min( math.max( Work.TotalIC / 10, 2 ), 5 ), Resource.TradeQty )
						if Resource.Sell then
							Resource.TradeQty = math.max( (TradePosition[i].Stockpile / 4000), Resource.TradeQty )
						end
						Resource.TradeQty = math.ceil(Resource.TradeQty * work)

						Resource.MaxTradeQty = math.max( math.min( math.max( Resource.PartnerCountry:GetTotalIC() / 10, 2 ), 5 ), Resource.MaxTradeQty )
						if Resource.Buy then
							Resource.MaxTradeQty = math.max( (Resource.PartnerCountry:GetPool():Get( i ):Get() / 4000), Resource.MaxTradeQty )
						end
						Resource.MaxTradeQty = math.ceil(Resource.MaxTradeQty * 2)

						if tostring(Params.MinisterTag) == tagString then
							Utils.LUA_DEBUGOUT("")
							Utils.LUA_DEBUGOUT("Trading:    " .. tostring(i))
							Utils.LUA_DEBUGOUT("Qty Factor: " .. tostring(work))
							Utils.LUA_DEBUGOUT("Trade Qty:  " .. tostring(Resource.TradeQty))
							Utils.LUA_DEBUGOUT("Max Trade:  " .. tostring(Resource.MaxTradeQty))
						end

						Resource.TradeQty = math.min(math.min(Resource.TradeQty, Resource.MaxTradeQty), 50)
						if Resource.Sell then
							Resource.TradeQty = - Resource.TradeQty
						end

						if tostring(Params.MinisterTag) == tagString then
							Utils.LUA_DEBUGOUT("Final Qty:  " .. tostring(Resource.TradeQty))
						end

						-- Now we can actually propose the trade!
						-- But we will check their response before proceeding

						local aiTradeAction = CTradeAction( Params.MinisterTag, TradePartners[index].PartnerTag )
						aiTradeAction:SetTrading( CFixedPoint( Resource.TradeQty ), i )

						if aiTradeAction:IsValid() and aiTradeAction:IsSelectable()
						and aiTradeAction:GetAIAcceptance() > Resource.MinTradeFactor then

							-- Make the trade if possible

							Params.AI:PostAction( aiTradeAction )
							Work.DiplomacyPoints = Work.DiplomacyPoints - 1
							Resource.TradeMade = true
							if tostring(Params.MinisterTag) == tagString then
								Utils.LUA_DEBUGOUT("")
								Utils.LUA_DEBUGOUT("ProposeTrades (done)...")
								Utils.LUA_DEBUGOUT("")
								Utils.LUA_DEBUGOUT("Traded: " .. tostring(TradePartners[index].PartnerTag))
							end
						else
							-- Otherwise remove this country from the list and try again!

							table.remove(TradePartners, index)
						end

						-- Recalculate the best trade factor

						Resource.MaxTradeFactor = 0
						for j = 1, table.getn(TradePartners) do
							if TradePartners[j].TradeFactor > Resource.MaxTradeFactor then
								Resource.MaxTradeFactor = TradePartners[j].TradeFactor
							end
						end
					end
				end

				if tostring(Params.MinisterTag) == tagString then
					Utils.LUA_DEBUGOUT("")
					Utils.LUA_DEBUGOUT("ProposeTrades completed OK")
				end
			end
		end
	end
end

-- ######################################################################################
-- CALLED BY THE EXE Looks through the current trade routes and cancels them as necessary

function EvalutateExistingTrades( ai, ministerTag )

	if not ( Utils.ASSERT( ai ) )
	or not ( Utils.ASSERT( ministerTag ) )
	or not ( ministerTag:IsValid() )
	or not ( ministerTag:IsReal() )
	then
		return
	end

	-- Create a table to hold the input parameters to this function

	local Params = {
		AI = ai,
		MinisterTag = ministerTag
	}

	local tagString = "XXX"
	if tostring(Params.MinisterTag) == tagString then
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("EvaluatingExistingTrades...")
		Utils.LUA_DEBUGOUT("")
	end

	-- Create a table to hold working objects and values

	local Work = {
		MinisterCountry = Params.MinisterTag:GetCountry(),
		CurrentTag = Params.MinisterTag,
		TotalIC = 0,
		Transports = 0,
		IsAtWar = false,
		MaxNoOfCancels = 0,
		MinCancelFactor = 0,
		EndLoop = false
	}
	Work.TotalIC = Work.MinisterCountry:GetTotalIC()
	Work.Transports = Work.MinisterCountry:GetTransports()
	Work.IsAtWar = Work.MinisterCountry:IsAtWar()

	-- Create a table to hold the number of trades we have of each resource
	-- For efficiency we will also use this to hold the results from calling GetTradeFactors

	local TradeTotals = {}
	for i = 0, 6 do

		TradeTotals[i] = {
			NoOfImports = 0,
			NoOfExports = 0,
			BuyFactor = -1,
			SellFactor = -1
		}
	end

	-- We should get information about our current trade position
	-- If we are open to setting up new trades then we shouldn't cancel trades of that type

	local fnParams = {
		MinisterTag = Params.MinisterTag,
		MinisterCountry = Work.MinisterCountry,
		Cancelling = true
	}
	local TradePosition = GetTradePosition( fnParams )

	-- Use this information to find out if we are over our trade limits

	fnParams = {
		MinisterTag = Params.MinisterTag,
		MinisterCountry = Work.MinisterCountry,
		TotalIC = Work.TotalIC,
		TradePosition = TradePosition,
		Cancelling = true
	}
	local TradeLimits = GetTradeLimits ( fnParams )

	-- Create tables to hold information we need about each of our current trades

	local TradeRoutes = {}
	local CancelOptions = {}

	-- Evaluate our trade routes

	local route = 0			-- This will hold the index to the TradeRoutes table
	local option = 0		-- This will hold the index to the CancelOptions table

	for loTradeRoute in Work.MinisterCountry:AIGetTradeRoutes() do

		route = route + 1

		if tostring(Params.MinisterTag) == tagString then
			Utils.LUA_DEBUGOUT("Responsible : " .. tostring(loTradeRoute:GetConvoyResponsible()))
			Utils.LUA_DEBUGOUT("From :        " .. tostring(loTradeRoute:GetFrom()))
			Utils.LUA_DEBUGOUT("To :          " .. tostring(loTradeRoute:GetTo()))
			Utils.LUA_DEBUGOUT("From 0 :      " .. tostring(loTradeRoute:GetTradedFromOf(0)))
			Utils.LUA_DEBUGOUT("From 1 :      " .. tostring(loTradeRoute:GetTradedFromOf(1)))
			Utils.LUA_DEBUGOUT("From 2 :      " .. tostring(loTradeRoute:GetTradedFromOf(2)))
			Utils.LUA_DEBUGOUT("From 3 :      " .. tostring(loTradeRoute:GetTradedFromOf(3)))
			Utils.LUA_DEBUGOUT("From 4 :      " .. tostring(loTradeRoute:GetTradedFromOf(4)))
			Utils.LUA_DEBUGOUT("From 5 :      " .. tostring(loTradeRoute:GetTradedFromOf(5)))
			Utils.LUA_DEBUGOUT("From 6 :      " .. tostring(loTradeRoute:GetTradedFromOf(6)))
			Utils.LUA_DEBUGOUT("To 0 :        " .. tostring(loTradeRoute:GetTradedToOf(0)))
			Utils.LUA_DEBUGOUT("To 1 :        " .. tostring(loTradeRoute:GetTradedToOf(1)))
			Utils.LUA_DEBUGOUT("To 2 :        " .. tostring(loTradeRoute:GetTradedToOf(2)))
			Utils.LUA_DEBUGOUT("To 3 :        " .. tostring(loTradeRoute:GetTradedToOf(3)))
			Utils.LUA_DEBUGOUT("To 4 :        " .. tostring(loTradeRoute:GetTradedToOf(4)))
			Utils.LUA_DEBUGOUT("To 5 :        " .. tostring(loTradeRoute:GetTradedToOf(5)))
			Utils.LUA_DEBUGOUT("To 6 :        " .. tostring(loTradeRoute:GetTradedToOf(6)))
			Utils.LUA_DEBUGOUT("Inactive :    " .. tostring(loTradeRoute:IsInactive()))
			Utils.LUA_DEBUGOUT("Valid :       " .. tostring(loTradeRoute:IsValid()))
		end

		-- Create a local table to hold information about this route
		-- Find our trading partner

		local Route = {
			FromTag = loTradeRoute:GetFrom(),
			PartnerTag,
			PartnerCountry,
			IsInactive = false,
			Value = 125,
			Goods = -1,
			Buy = true,
			GovernmentsInExile = false,
			NeedConvoy = false,
			FreeTradeRule = false,
			AllowDebts = false
		}
		if Route.FromTag == Params.MinisterTag then
			Route.PartnerTag = loTradeRoute:GetTo()
		else
			Route.PartnerTag = Route.FromTag
		end
		Route.PartnerCountry = Route.PartnerTag:GetCountry()

		-- On change of trading partner we will reset the results from GetTradeFactors

		if Route.PartnerTag ~= Work.CurrentTag then
			Work.CurrentTag = Route.PartnerTag
			for i = 0, 6 do
				TradeTotals[i].BuyFactor = -1
				TradeTotals[i].SellFactor = -1
			end
		end

		-- Create an entry in the TradeRoutes table

		TradeRoutes[route] = {
			TradeRoute = loTradeRoute,
			PartnerTag = Route.PartnerTag,
			Cancel = false
		}

		-- Set up the parameters we will need to call GetTradeFactors
		-- For efficiency we will only call this once per trade type for each trading partner

		local fnParams = {
			MinisterTag = Route.PartnerTag,
			MinisterCountry = Route.PartnerCountry,
			PartnerTag = Params.MinisterTag,
			PartnerCountry = Work.MinisterCountry,
			Goods = 0,
			Buy = false,
			FreeOnly = false,
			Proposing = false,
			Cancelling = true,
			MinisterRelation,
			MinisterIsAtWar = false,
			MinisterAllowDebts = false,
			FreeTradeRule = false,
			NeedConvoy = false,
			MinisterIC = 0,
			PartnerIC = 0,
			PartnerIsSubject = false,
			PartnerOverlord = false
		}

		if not loTradeRoute:IsValid() then

			-- We will always cancel invalid

			TradeRoutes[route].Cancel = true

		else

			if tostring(Params.MinisterTag) == tagString then
				Utils.LUA_DEBUGOUT("")
				Utils.LUA_DEBUGOUT("Partner:   " .. tostring(Route.PartnerTag))
				Utils.LUA_DEBUGOUT("Diplomat:  " .. tostring(Work.MinisterCountry:HasDiplomatEnroute(Route.PartnerTag)))
				Utils.LUA_DEBUGOUT("Diplomat:  " .. tostring(Route.PartnerCountry:HasDiplomatEnroute(Params.MinisterTag)))
			end

			-- If we have diplomats en route we won't touch this trade because it could be newly created

			if not Work.MinisterCountry:HasDiplomatEnroute(Route.PartnerTag)
			and not Route.PartnerCountry:HasDiplomatEnroute(Params.MinisterTag) then

				-- We need to determine the value of all active trades

				Route.Value = 125
				Route.Goods = -1
				Route.Buy = true
				Route.IsInactive = loTradeRoute:IsInactive()

				Route.GovernmentsInExile = Work.MinisterCountry:IsGovernmentInExile() or Route.PartnerCountry:IsGovernmentInExile()
				Route.NeedConvoy = Work.MinisterCountry:NeedConvoyToTradeWith(Route.PartnerTag)
				Route.FreeTradeRule = Work.MinisterCountry:GetRules():GetValue(CRule._RULE_FREE_RESOURCE_GIFTS_)
					and Route.PartnerCountry:GetRules():GetValue(CRule._RULE_FREE_RESOURCE_GIFTS_)
				Route.AllowDebts = Work.MinisterCountry:GetRelation(Route.PartnerTag):AllowDebts() and Work.IsAtWar

				-- Now find out what is being traded and whether we want that trade

				for i = 0, 6 do

					if i ~= _MONEY_ then

						local Resource = {
							QtyFrom = loTradeRoute:GetTradedFromOf(i):Get(),
							QtyTo = loTradeRoute:GetTradedToOf(i):Get(),
							IsExport = false,
							IsImport = false
						}
						if Route.FromTag == Params.MinisterTag then	-- We proposed this trade
							if Resource.QtyFrom > 0 then		-- Export
								Resource.IsExport = true
							elseif Resource.QtyTo > 0 then		-- Import
								Resource.IsImport = true
							end
						else						-- They proposed this trade
							if Resource.QtyFrom > 0 then		-- Import
								Resource.IsImport = true
							elseif Resource.QtyTo > 0 then		-- Export
								Resource.IsExport = true
							end
						end

						if Route.GovernmentsInExile and (i == _SUPPLIES_ or i == _FUEL_)
						and (Resource.QtyFrom > 0 or Resource.QtyTo > 0) then

							-- Supply and Fuel trades with governments-in-exile make no sense

							TradeRoutes[route].Cancel = true

						else
							-- We will now calculate what we think of this trade

							fnParams.Goods = i

							if Resource.IsExport then

								-- Exporting (check first if we even need to check this trade closely)

								if Route.Value > 0 then

									if Route.IsInactive then			-- Cancel inactive trades

										Route.Value = 0

									elseif not TradeLimits[i].ExportsValid then	-- Cancel if we are over our trade limit

										if Route.FreeTradeRule then
											Route.Value = 0
										elseif Route.Value > 10 then
											Route.Value = 10
										end

									elseif TradePosition[i].SellOffer <= 0 then	-- Check this one more carefully

										if TradeTotals[i].SellFactor < 0 then

											fnParams.Buy = true
											local Trade = GetTradeFactors( fnParams )
											TradeTotals[i].SellFactor = Trade.AcceptFactor

											if tostring(Params.MinisterTag) == tagString then
												Utils.LUA_DEBUGOUT("")
												Utils.LUA_DEBUGOUT("EvaluateExistingTrades...")
												Utils.LUA_DEBUGOUT("")
												Utils.LUA_DEBUGOUT("Exporting: " .. tostring(i))
												Utils.LUA_DEBUGOUT("Quantity:  " .. tostring(loTradeRoute:GetTradedFromOf(i)))
												Utils.LUA_DEBUGOUT("Accept:    " .. tostring(Trade.AcceptFactor))
												Utils.LUA_DEBUGOUT("")
											end
										end

										if TradeTotals[i].SellFactor < Route.Value then
											Route.Value = TradeTotals[i].SellFactor
										end
									end
								end

								if Route.Goods < 0 then
									Route.Buy = false
									Route.Goods = i
								else
									Route.Goods = 2		-- This is a complex trade with multiple resources
								end

							elseif Resource.IsImport then

								-- Importing (check first if we even need to check this trade closely)

								if Route.Value > 0 then

									if Route.IsInactive then			-- Cancel inactive trades

										Route.Value = 0

									elseif not TradeLimits[i].ImportsValid then	-- Cancel if we are over our trade limit

										if Route.FreeTradeRule or Route.AllowDebts then
											if Route.Value > 10 then
												Route.Value = 10
											end
										else
											Route.Value = 0
										end

									elseif ((TradePosition[_MONEY_].Ratio < 0.1 and i < _METAL_)	-- We are short of cash
									or (TradePosition[_MONEY_].Ratio < 0.25 and i == _FUEL_))	-- And we are paying
									and not Route.FreeTradeRule and not Route.AllowDebts then	-- So cancel this trade

										Route.Value = 0

									elseif TradePosition[i].BuyOffer <= 0		-- Check this one more carefully
									or (Route.NeedConvoy and Work.Transports < 1) then

										if TradeTotals[i].BuyFactor < 0 then

											fnParams.Buy = false
											local Trade = GetTradeFactors( fnParams )
											TradeTotals[i].BuyFactor = Trade.AcceptFactor

											if tostring(Params.MinisterTag) == tagString then
												Utils.LUA_DEBUGOUT("")
												Utils.LUA_DEBUGOUT("EvaluateExistingTrades...")
												Utils.LUA_DEBUGOUT("")
												Utils.LUA_DEBUGOUT("Importing: " .. tostring(i))
												Utils.LUA_DEBUGOUT("Quantity:  " .. tostring(loTradeRoute:GetTradedToOf(i)))
												Utils.LUA_DEBUGOUT("Accept:    " .. tostring(Trade.AcceptFactor))
												Utils.LUA_DEBUGOUT("")
											end
										end

										if TradeTotals[i].BuyFactor < Route.Value then
											Route.Value = TradeTotals[i].BuyFactor
										end
									end
								end

									if Route.Goods < 0 then
									Route.Goods = i
								else
									Route.Goods = 2		-- This is a complex trade with multiple resources
								end
							end
						end
					end
				end

				if tostring(Params.MinisterTag) == tagString then
					Utils.LUA_DEBUGOUT("Row:       " .. tostring(r))
					Utils.LUA_DEBUGOUT("Resource:  " .. tostring(Route.Goods))
					Utils.LUA_DEBUGOUT("Value:     " .. tostring(Route.Value))
					Utils.LUA_DEBUGOUT("")
				end

				if TradeRoutes[route].Cancel == false and Route.Goods >= 0 then

					-- We will log details of any trade we might potentially cancel

					if Route.Value < 100 then

						option = option + 1
						CancelOptions[option] = {
							Route = route,
							Goods = Route.Goods,
							Buy = Route.Buy,
							Value = Route.Value
						}
					end

					-- We will also add it into our totals

					if Route.Buy then
						TradeTotals[Route.Goods].NoOfImports = TradeTotals[Route.Goods].NoOfImports + 1
					else
						TradeTotals[Route.Goods].NoOfExports = TradeTotals[Route.Goods].NoOfExports + 1
					end
				end
			end
		end
	end

	-- We will allow for up to 25% of our trades to be cancelled
	-- Also set limits for the number of trades of each type that can be cancelled
	-- Complex trades (stored as "money" above) are only created by the player and we will only allow one to be cancelled

	Work.MaxNoOfCancels = 0
	for i = 0, 6 do

		if tostring(Params.MinisterTag) == tagString then
			Utils.LUA_DEBUGOUT("Resource: " .. tostring(i))
			Utils.LUA_DEBUGOUT("NoOfImports: " .. tostring(TradeTotals[i].NoOfImports))
			Utils.LUA_DEBUGOUT("NoOfExports: " .. tostring(TradeTotals[i].NoOfExports))
		end

		Work.MaxNoOfCancels = Work.MaxNoOfCancels + TradeTotals[i].NoOfImports
		Work.MaxNoOfCancels = Work.MaxNoOfCancels + TradeTotals[i].NoOfExports

		if i == _MONEY_ then
			TradeTotals[i].NoOfImports = 1
			TradeTotals[i].NoOfExports = 1
		else
			TradeTotals[i].NoOfImports = math.ceil(TradeTotals[i].NoOfImports / 4)
			TradeTotals[i].NoOfExports = math.ceil(TradeTotals[i].NoOfExports / 4)
		end

		if tostring(Params.MinisterTag) == tagString then
			Utils.LUA_DEBUGOUT("NoOfImports: " .. tostring(TradeTotals[i].NoOfImports))
			Utils.LUA_DEBUGOUT("NoOfExports: " .. tostring(TradeTotals[i].NoOfExports))
		end

	end

	if tostring(Params.MinisterTag) == tagString then
		Utils.LUA_DEBUGOUT("Cancellable: " .. tostring(Work.MaxNoOfCancels))
	end

	Work.MaxNoOfCancels = math.ceil(Work.MaxNoOfCancels / 4)

	-- Calculate the worst cancellation factor
	-- Test it to see if want to cancel anything at all

	Work.MinCancelFactor = 100
	for j = 1, table.getn(CancelOptions) do
		if CancelOptions[j].Value < Work.MinCancelFactor then
			Work.MinCancelFactor = CancelOptions[j].Value
		end
	end

	Work.EndLoop = false
	if (math.mod(CCurrentGameState.GetAIRand(), 50) + 50) < Work.MinCancelFactor then
		Work.EndLoop = true
	end

	if tostring(Params.MinisterTag) == tagString then
		Utils.LUA_DEBUGOUT("Cancels:     " .. tostring(Work.MaxNoOfCancels))
		Utils.LUA_DEBUGOUT("Min factor:  " .. tostring(Work.MinCancelFactor))
		Utils.LUA_DEBUGOUT("End loop:    " .. tostring(Work.EndLoop))
		Utils.LUA_DEBUGOUT("")
	end

	while Work.MaxNoOfCancels > 0 and table.getn(CancelOptions) > 0 and not Work.EndLoop do

		option = math.random(table.getn(CancelOptions))

		local work = CancelOptions[option].Value - Work.MinCancelFactor
		if work < math.mod(CCurrentGameState.GetAIRand(), 10) then

			-- We have chosen a trade to cancel

			route = CancelOptions[option].Route
			TradeRoutes[route].Cancel = true

			-- Now we deduct it from the total trades we are allowed to cancel

			Work.MaxNoOfCancels = Work.MaxNoOfCancels - 1

			local i = CancelOptions[option].Goods

			if tostring(Params.MinisterTag) == tagString then
				Utils.LUA_DEBUGOUT("Cancelling:  " .. tostring(route))
				Utils.LUA_DEBUGOUT("Cancels:     " .. tostring(Work.MaxNoOfCancels))
				Utils.LUA_DEBUGOUT("Resource:    " .. tostring(i))
			end

			if i == _MONEY_ then

				-- We have just cancelled a complex (player-created) trade
				-- We will only do this once

				TradeTotals[i].NoOfImports = 0
				TradeTotals[i].NoOfExports = 0
				for j = 1, table.getn(CancelOptions) do
					if CancelOptions[j].Goods == i then
						CancelOptions[j].Value = 100
					end
				end
			else
				if CancelOptions[option].Buy then

					-- We have just cancelled an import trade
					-- Check whether we are allowed to cancel any more of these

					TradeTotals[i].NoOfImports = TradeTotals[i].NoOfImports -1
					if TradeTotals[i].NoOfImports < 1 then
						for j = 1, table.getn(CancelOptions) do
							if CancelOptions[j].Goods == i and CancelOptions[j].Buy then
								CancelOptions[j].Value = 100
							end
						end
					end
				else

					-- We have just cancelled an export trade
					-- Check whether we are allowed to cancel any more of these

					TradeTotals[i].NoOfExports = TradeTotals[i].NoOfExports -1
					if TradeTotals[i].NoOfExports < 1 then
						for j = 1, table.getn(CancelOptions) do
							if CancelOptions[j].Goods == i and not CancelOptions[j].Buy then
								CancelOptions[j].Value = 100
							end
						end
					end
				end
			end

			-- Now we can remove the processed row by index

			table.remove(CancelOptions, option)

			-- Recalculate the worst cancellation factor
			-- And re-test to see if we want to cancel anything else

			Work.MinCancelFactor = 100
			for j = 1, table.getn(CancelOptions) do
				if CancelOptions[j].Value < Work.MinCancelFactor then
					Work.MinCancelFactor = CancelOptions[j].Value
				end
			end
			if (math.mod(CCurrentGameState.GetAIRand(), 50) + 50) < Work.MinCancelFactor then
				Work.EndLoop = true
			end

			if tostring(Params.MinisterTag) == tagString then
				Utils.LUA_DEBUGOUT("")
				Utils.LUA_DEBUGOUT("Min factor:  " .. tostring(Work.MinCancelFactor))
				Utils.LUA_DEBUGOUT("End loop:    " .. tostring(Work.EndLoop))
			end

		end
	end

	-- Finally loop through the trade routes and do the actual cancellations

	for r = 1, table.getn(TradeRoutes) do

		if tostring(Params.MinisterTag) == tagString then
			Utils.LUA_DEBUGOUT("")
			Utils.LUA_DEBUGOUT("Processing:   " .. tostring(r))
			Utils.LUA_DEBUGOUT("Parties:      " .. tostring(TradeRoutes[r].TradeRoute:GetFrom()) .. " " .. tostring(TradeRoutes[r].TradeRoute:GetTo()))
			Utils.LUA_DEBUGOUT("Cancelling:   " .. tostring(TradeRoutes[r].Cancel))
		end

		if TradeRoutes[r].Cancel then

			--Utils.LOG_AI_CANCEL_TRADE( Params.MinisterTag, TradeRoutes[r].PartnerTag, TradeRoutes[r].TradeRoute )

			local aiTradeAction = CTradeAction( Params.MinisterTag, TradeRoutes[r].PartnerTag )
			aiTradeAction:SetRoute( TradeRoutes[r].TradeRoute )
			aiTradeAction:SetValue( false )
			if aiTradeAction:IsValid() and aiTradeAction:IsSelectable() then
				Params.AI:PostAction( aiTradeAction )
			end
		end
	end

end


-- ###################
-- DIPLOMACY FUNCTIONS
-- ###################

-- Determines if recipient would want to accept such a trade
function DiploScore_OfferTrade( ai, actor, recipient, observer, voTradeAction, Export, Import )

	if not ( Utils.ASSERT( ai ) )
	or not ( Utils.ASSERT( actor ) )
	or not ( Utils.ASSERT( recipient ) )
	or not ( Utils.ASSERT( observer ) )
	or not ( Utils.ASSERT( voTradeAction ) )
	or not ( Utils.ASSERT( Export ) )
	or not ( Utils.ASSERT( Import ) )
	then
		return 0
	end

	-- Create a table to hold the input parameters to this function

	local Params = {
		AI = ai,
		Actor = actor,
		Recipient = recipient,
		Observer = observer,
		TradeAction = voTradeAction,
		Export = Export,
		Import = Import
	}

	local tagString = "XXX"
	if tostring(Params.Actor) == tagString or tostring(Params.Recipient) == tagString then
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("DiploScore_OfferTrade...")
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("Parties:   " .. tostring(Params.Actor) .. ": " .. tostring(Params.Recipient))
		Utils.LUA_DEBUGOUT("Exiles:    " .. tostring(Work.GovernmentsInExile))
	end

	-- Create a table to hold any working objects or values

	local Work = {
		Score = 100,
		IsValid = false,
		ActorCountry = Params.Actor:GetCountry(),
		RecipientCountry = Params.Recipient:GetCountry(),
		TotalIC = 0,
		GovernmentsInExile = false,
		TradeQty = 0,
		MaxTradeQty = 0
	}
	Work.GovernmentsInExile = (Work.ActorCountry:IsGovernmentInExile() or Work.RecipientCountry:IsGovernmentInExile())
	Work.TotalIC = Work.RecipientCountry:GetTotalIC()

	-- We need to find out what we are being asked to buy or sell
	-- We need to check each resource to check our trading position
	-- Then our chance of acceptance should be the lowest factor returned

	-- Set up the parameters we will need to call GetTradeFactors

	local fnParams = {
		MinisterTag = Params.Actor,
		MinisterCountry = Work.ActorCountry,
		PartnerTag = Params.Recipient,
		PartnerCountry = Work.RecipientCountry,
		Goods = 0,
		Buy = false,
		FreeOnly = false,
		Proposing = false,
		Cancelling = false,
		MinisterRelation,
		MinisterIsAtWar = false,
		MinisterAllowDebts = false,
		FreeTradeRule = false,
		NeedConvoy = false,
		MinisterIC = 0,
		PartnerIC = 0,
		PartnerIsSubject = false,
		PartnerOverlord = false
	}

	for i = 0, 6 do
		if i ~= _MONEY_ then

			-- Check if the actor is importing this resource

			Work.TradeQty = Utils.ResourceValueOfType( Params.Import, i )

			if Work.TradeQty > 0 then

				if Work.GovernmentsInExile and (i == _SUPPLIES_ or i == _FUEL_) then
					Work.Score = 0
				else
					Work.MaxTradeQty = Support.GetEffectiveResourceLimit( Work.RecipientCountry, i ) * 0.001
					if i < _MONEY_ then
						Work.MaxTradeQty = Work.MaxTradeQty / 2
					end
					Work.MaxTradeQty = math.max( math.min( math.max( Work.TotalIC / 10, 2 ), 5 ), Work.MaxTradeQty )
					Work.MaxTradeQty = math.max( (Work.RecipientCountry:GetPool():Get( i ):Get() / 4000), Work.MaxTradeQty )
					Work.MaxTradeQty = math.ceil(Work.MaxTradeQty * 2) + 0.01

					if Work.TradeQty > Work.MaxTradeQty then
						Work.Score = 0
					else
						-- This is what we are selling

						fnParams.Goods = i
						fnParams.Buy = true
						local Trade = GetTradeFactors( fnParams )

						if Trade.AcceptFactor < Work.Score then
							Work.Score = Trade.AcceptFactor
						end
						Work.IsValid = true
					end
				end

				if tostring(Params.Actor) == tagString or tostring(Params.Recipient) == tagString then
					Utils.LUA_DEBUGOUT("Exporting: " .. tostring(i) .. ": " .. tostring(Work.TradeQty))
					Utils.LUA_DEBUGOUT("Accept:    " .. tostring(Work.Score))
				end
			end

			-- Check if the actor is exporting this resource

			Work.TradeQty = Utils.ResourceValueOfType( Params.Export, i )

			if Work.TradeQty > 0 then

				if Work.GovernmentsInExile and (i == _SUPPLIES_ or i == _FUEL_) then
					Work.Score = 0
				else
					Work.MaxTradeQty = Support.GetEffectiveResourceLimit( Work.RecipientCountry, i ) * 0.001
					if i < _MONEY_ then
						Work.MaxTradeQty = Work.MaxTradeQty / 2
					end
					Work.MaxTradeQty = math.max( math.min( math.max( Work.TotalIC / 10, 2 ), 5 ), Work.MaxTradeQty )
					Work.MaxTradeQty = math.ceil(Work.MaxTradeQty * 2) + 0.01

					if Work.TradeQty > Work.MaxTradeQty then
						Work.Score = 0
					else
						-- This is what we are buying

						fnParams.Goods = i
						fnParams.Buy = false
						local Trade = GetTradeFactors( fnParams )

						if Trade.AcceptFactor < Work.Score then
							Work.Score = Trade.AcceptFactor
						end
						Work.IsValid = true
					end
				end

				if tostring(Params.Actor) == tagString or tostring(Params.Recipient) == tagString then
					Utils.LUA_DEBUGOUT("Importing: " .. tostring(i) .. ": " .. tostring(Work.TradeQty))
					Utils.LUA_DEBUGOUT("Accept:    " .. tostring(Work.Score))
				end
			end
		end
	end

	-- We will just check that there are some resources being traded!

	if not Work.IsValid then
		Work.Score = 0
	end

	if tostring(Params.Actor) == tagString or tostring(Params.Recipient) == tagString then
		Utils.LUA_DEBUGOUT("Work.Score:     " .. tostring(Work.Score))
	end

	--Work.Score = Utils.CallScoredCountryAI( Params.Recipient, "DiploScore_OfferTrade", Work.Score, Params.AI, Params.Actor, Params.Recipient, Params.Observer, Params.Export, Params.Import )
	
	--Utils.LOG_AI_PROPOSED_TRADE( Params.Actor, Params.Recipient, Params.Export, Params.Import, Work.Score, 0, 0 )

	return Work.Score
end


-- #################
-- SUPPORT FUNCTIONS
-- #################

-- This function will calculate our base probabilities to buy or sell each commodity
-- It will be used to determine which trades we offer and to check which trades we should cancel

function GetTradePosition( Params )

	if not ( Utils.ASSERT( Params.MinisterTag ) )
	or not ( Utils.ASSERT( Params.MinisterCountry ) )
	or not ( Utils.ASSERT( Params.Cancelling ) )
	then
		return {}
	end

	local TradePosition = {}

	local Work = {
		GoodsPool = Params.MinisterCountry:GetPool()
	}

	-- Loop through each resource

	for i = 0, 6 do

		-- Set up default table values

		TradePosition[i] = {
			Stockpile = Work.GoodsPool:Get( i ):Get(),					-- The current stockpile level
			Required = Support.GetEffectiveResourceLimit( Params.MinisterCountry, i ),	-- The required stockpile level
			Ratio = 1,									-- The ratio (current/required)
			BuyFactor = 0,									-- The chance to agree to buy (another country's proposal)
			SellFactor = 0,									-- The chance to agree to sell
			SellThreshold = 0,								-- The minimum ratio at which we will sell (derived from money)
			BuyOffer = 0,									-- The chance to offer to buy (our proposal)
			BuyFree = 0,									-- The chance to offer to buy if we can get free resources
			SellOffer = 0									-- The chance to offer to sell
		}

		-- Calculate our stockpile ratio (current/required)

		if TradePosition[i].Required > 0 then
			TradePosition[i].Ratio = TradePosition[i].Stockpile / TradePosition[i].Required
		elseif TradePosition[i].Stockpile > 100 then
			TradePosition[i].Ratio = TradePosition[i].Stockpile / 100
		end

		-- Now apply any customer ratio modifiers for this country

		local fnParams = {
			MinisterTag = Params.MinisterTag,
			Goods = i,
			Ratio = TradePosition[i].Ratio
		}
		TradePosition[i].Ratio = ApplyTradeModifiers( fnParams )

		-- Calculate our base buying/selling factors for this commodity

		if i == _MONEY_ then

			-- Money is a special case
			-- It will influence our preference to buy or sell all of the other commodities

			TradePosition[i].SellThreshold = 0.5	-- By default we will not sell if we have below 50% of our required stockpile

			if TradePosition[i].Ratio < 1 then							-- Money is short
				TradePosition[i].SellFactor = (1 - TradePosition[i].Ratio) * 75			-- We will sell more
				TradePosition[i].BuyFactor = -TradePosition[i].SellFactor			-- We will buy less
				TradePosition[i].SellThreshold = 0.5 - ((1 - TradePosition[i].Ratio) / 4)	-- We will accept a lower stockpile level

			elseif TradePosition[i].Ratio > 1 then								-- Money is good
				TradePosition[i].BuyFactor = math.min(((TradePosition[i].Ratio - 1) / 4) * 100, 25)	-- We will buy less
				TradePosition[i].SellFactor = -TradePosition[i].BuyFactor				-- We will sell more
			end
		else
			-- Other commodities

			TradePosition[i].BuyFactor = ((2 - TradePosition[i].Ratio) * 100) - 75		-- Buy if our stockpile is low
			TradePosition[i].SellFactor = (TradePosition[i].Ratio * 100) - 75		-- Sell if our stockpile is high

			-- If our stockpile of essential industrial resources is particularly low then we really need to buy

			if i > _CRUDE_OIL_ then
				if TradePosition[i].Ratio < 0.25 then
					TradePosition[i].BuyFactor = TradePosition[i].BuyFactor + ((0.25 - TradePosition[i].Ratio) * 100)
					TradePosition[i].SellFactor = TradePosition[i].SellFactor - ((0.25 - TradePosition[i].Ratio) * 100)
				end
				if TradePosition[i].Ratio < 0.10 then
					TradePosition[i].BuyFactor = TradePosition[i].BuyFactor + ((0.10 - TradePosition[i].Ratio) * 250)
					TradePosition[i].SellFactor = TradePosition[i].SellFactor - ((0.10 - TradePosition[i].Ratio) * 250)
				end
			end
		end
	end

	-- Now that we have calculated all the base factors we will modify them according to our money situation

	for i = 0, 6 do

		if i ~= _MONEY_ then

			-- Our chance to buy free resources will not be affected by money
			-- Otherwise we will be keener to buy if we have money or to sell if we don't
			-- But we won't buy if our money stockpile gets too low
			-- And we won't sell if our resource stockpile is getting low

			TradePosition[i].BuyFree = TradePosition[i].BuyFactor

			-- If our stockpile of cash is getting low then we should scale back purchases of non-essentials

			if TradePosition[_MONEY_].Ratio < 0.25 and i == _CRUDE_OIL_ then
				TradePosition[i].BuyFactor = TradePosition[i].BuyFactor - ((0.25 - TradePosition[_MONEY_].Ratio) * 100)
				TradePosition[i].SellFactor = TradePosition[i].SellFactor + ((0.25 - TradePosition[_MONEY_].Ratio) * 100)
			elseif TradePosition[_MONEY_].Ratio < 0.50 and i < _CRUDE_OIL_ then
				TradePosition[i].BuyFactor = TradePosition[i].BuyFactor - ((0.50 - TradePosition[_MONEY_].Ratio) * 100)
				TradePosition[i].SellFactor = TradePosition[i].SellFactor + ((0.50 - TradePosition[_MONEY_].Ratio) * 100)
			end

			if TradePosition[_MONEY_].Ratio < 0.1 or (TradePosition[_MONEY_].Ratio < 0.25 and i == _FUEL_)
			or (TradePosition[_MONEY_].Ratio < 0.35 and i == _FUEL_ and not Params.Cancelling) then
				TradePosition[i].BuyFactor = -100
			else
				TradePosition[i].BuyFactor = TradePosition[i].BuyFactor + TradePosition[_MONEY_].BuyFactor
			end

			if TradePosition[i].Ratio < TradePosition[_MONEY_].SellThreshold then
				TradePosition[i].SellFactor = -100
			else
				TradePosition[i].SellFactor = TradePosition[i].SellFactor + TradePosition[_MONEY_].SellFactor
			end

			-- There will be time when we might be prepared to both buy and sell
			-- In which case we won't care much either way about making a trade offer
			-- So we won't unless the chance is at least 50%

			if TradePosition[i].BuyFactor > TradePosition[i].SellFactor then
				TradePosition[i].BuyOffer = TradePosition[i].BuyFactor - math.max(TradePosition[i].SellFactor,0)
				if TradePosition[i].BuyOffer < 50 then
					TradePosition[i].BuyOffer = 0
				else
					TradePosition[i].BuyOffer = math.max(TradePosition[i].BuyOffer - 25, 0)
				end
			elseif TradePosition[i].SellFactor > TradePosition[i].BuyFactor then
				TradePosition[i].SellOffer = TradePosition[i].SellFactor - math.max(TradePosition[i].BuyFactor,0)
				TradePosition[i].SellOffer = math.max(TradePosition[i].SellOffer - 50, 0)
			end
		end
	end

	local tagString = "XXX"
	if tostring(Params.MinisterTag) == tagString then
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("GetTradePosition...")
		Utils.LUA_DEBUGOUT("")
		for i = 0, table.getn(TradePosition) do
			Utils.LUA_DEBUGOUT("ID:            " .. tostring(i))
			Utils.LUA_DEBUGOUT("Stockpile:     " .. tostring(TradePosition[i].Stockpile))
			Utils.LUA_DEBUGOUT("Required:      " .. tostring(TradePosition[i].Required))
			Utils.LUA_DEBUGOUT("Ratio:         " .. tostring(TradePosition[i].Ratio))
			Utils.LUA_DEBUGOUT("BuyFactor:     " .. tostring(TradePosition[i].BuyFactor))
			Utils.LUA_DEBUGOUT("SellFactor:    " .. tostring(TradePosition[i].SellFactor))
			Utils.LUA_DEBUGOUT("SellThreshold: " .. tostring(TradePosition[i].SellThreshold))
			Utils.LUA_DEBUGOUT("BuyOffer:      " .. tostring(TradePosition[i].BuyOffer))
			Utils.LUA_DEBUGOUT("BuyFree:       " .. tostring(TradePosition[i].BuyFree))
			Utils.LUA_DEBUGOUT("SellOffer:     " .. tostring(TradePosition[i].SellOffer))
		end
	end

	return TradePosition
end


-- ##################################################################################################
-- This function will return a table of available trading partners for the commodity we want to trade

function GetTradePartners( Params )

	if not ( Utils.ASSERT( Params.MinisterTag ) )
	or not ( Utils.ASSERT( Params.MinisterCountry ) )
	or not ( Utils.ASSERT( Params.Goods ) )
	or not ( Utils.ASSERT( Params.Buy ) )
	or not ( Utils.ASSERT( Params.MinTradeFactor ) )
	or not ( Utils.ASSERT( Params.HasConvoys ) )
	or not ( Utils.ASSERT( Params.FreeOnly ) )
	or not ( Utils.ASSERT( Params.CashRich ) )
	or not ( Utils.ASSERT( Params.IsAtWar ) )
	or not ( Utils.ASSERT( Params.FreeTradeRule ) )
	or not ( Utils.ASSERT( Params.TotalIC ) )
	then
		return {}
	end

	local TradePartners = {}

	local Work = {
		MinisterRelation
	}

	local tagString = "XXX"
	if tostring(Params.MinisterTag) == tagString then
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("GetTradePartners...")
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("Trading:       " .. tostring(Params.Goods))
		Utils.LUA_DEBUGOUT("Buying:        " .. tostring(Params.Buy))
		Utils.LUA_DEBUGOUT("Min factor:    " .. tostring(Params.MinTradeFactor))
		Utils.LUA_DEBUGOUT("Convoys:       " .. tostring(Params.HasConvoys))
		Utils.LUA_DEBUGOUT("Free only:     " .. tostring(Params.FreeOnly))
		Utils.LUA_DEBUGOUT("Cash rich:     " .. tostring(Params.CashRich))
		Utils.LUA_DEBUGOUT("IsAtWar:       " .. tostring(Params.IsAtWar))
		Utils.LUA_DEBUGOUT("FreeTradeRule: " .. tostring(Params.FreeTradeRule))
		Utils.LUA_DEBUGOUT("Total IC:      " .. tostring(Params.TotalIC))
	end

	-- We will have to consider every country in the game so efficiency is important!

	local index = 0
	for loPartnerCountry in CCurrentGameState.GetCountries() do

		local Partner = {
			Tag = loPartnerCountry:GetCountryTag(),
			IsValid = true,
			IsSubject = false,
			Overlord,
			FreeTradeRule = loPartnerCountry:GetRules():GetValue(CRule._RULE_FREE_RESOURCE_GIFTS_),
			NeedConvoy = false,
			TotalIC = 0
		}

		if loPartnerCountry:Exists() and Partner.Tag ~= Params.MinisterTag and tostring(Partner.Tag) ~= "GOD" then

			Partner.IsSubject = loPartnerCountry:IsSubject()
			Partner.Overlord = loPartnerCountry:GetOverlord()
			Partner.IsValid = true
			Partner.NeedConvoy = Params.MinisterCountry:NeedConvoyToTradeWith(Partner.Tag)
			Partner.TotalIC = loPartnerCountry:GetTotalIC()

			-- We will ignore smaller countries most of the time for efficiency
			-- We can always trade with our puppets
			-- Otherwise trade can only be between independent countries
			-- If we have full cash reserves we will only consider selling to our puppets
			-- Governments-in-exile can't trade supplies or fuel
			-- Convoy trading is impossible without a port
			-- Convoy trading will be declined if we are importing and are short of convoys
			-- We can't trade with enemies or anyone embargoed or if we have a diplomat en route
			-- If we want free resources then only consider countries that allow us debt or have the free trade rule 

			if (Partner.TotalIC + 20) < math.mod(CCurrentGameState.GetAIRand(), 100) then
				Partner.IsValid = false
			elseif Partner.IsSubject and Partner.Overlord ~= Params.MinisterTag then
				Partner.IsValid = false
			elseif Params.CashRich and not Params.Buy and not Partner.IsSubject then
				Partner.IsValid = false
			elseif loPartnerCountry:IsGovernmentInExile()
		    	and (Params.Goods == _SUPPLIES_ or Params.Goods == _FUEL_) then
				Partner.IsValid = false
			elseif Partner.NeedConvoy
			and ((Params.MinisterCountry:GetNumOfPorts() < 1 or loPartnerCountry:GetNumOfPorts() < 1)
			or (Params.Buy and not Params.HasConvoys)) then
				Partner.IsValid = false
			else
				Work.MinisterRelation = Params.MinisterCountry:GetRelation(Partner.Tag)
				if Work.MinisterRelation:HasWar() or Work.MinisterRelation:HasEmbargo()
				or Params.MinisterCountry:HasDiplomatEnroute(Partner.Tag) then
					Partner.IsValid = false
				elseif Params.FreeOnly
				and (not Params.IsAtWar or not Work.MinisterRelation:AllowDebts())
				and (not Params.FreeTradeRule or not Partner.FreeTradeRule) then
					Partner.IsValid = false
				end
			end

			if tostring(Params.MinisterTag) == tagString then
				Utils.LUA_DEBUGOUT(tostring(Partner.Tag) .. ": valid:  " .. tostring(Partner.IsValid))
			end

			if Partner.IsValid then

				-- This country is a possible trading partner so we need to gather more information

				local fnParams = {
					MinisterTag = Params.MinisterTag,
					MinisterCountry = Params.MinisterCountry,
					PartnerTag = Partner.Tag,
					PartnerCountry = loPartnerCountry,
					Goods = Params.Goods,
					Buy = Params.Buy,
					FreeOnly = Params.FreeOnly,
					Proposing = true,
					Cancelling = false,
					MinisterRelation = Work.MinisterRelation:GetValue():Get(),
					MinisterIsAtWar = Params.IsAtWar,
					MinisterAllowDebts = (Work.MinisterRelation:AllowDebts() and Params.IsAtWar),
					FreeTradeRule = (Params.FreeTradeRule and Partner.FreeTradeRule),
					NeedConvoy = Partner.NeedConvoy,
					MinisterIC = Params.TotalIC,
					PartnerIC = Partner.TotalIC,
					PartnerIsSubject = Partner.IsSubject,
					PartnerOverlord = Partner.Overlord
				}
				local Trade = GetTradeFactors( fnParams )

				-- The table returned holds a trade factor indicating their opinion of the trade
				-- There is also a factor for their chance of acceptance (puppets have no choice!)
				-- And there is also a modifier to our preference for doing business with them!

				if (Trade.AcceptFactor + Trade.OfferFactor) > Params.MinTradeFactor
				and Trade.AcceptFactor > 10 then
					if tostring(Params.MinisterTag) == tagString then
						Utils.LUA_DEBUGOUT(tostring(Partner.Tag) .. ": trade:  " .. tostring(Trade.TradeFactor))
						Utils.LUA_DEBUGOUT(tostring(Partner.Tag) .. ": accept: " .. tostring(Trade.AcceptFactor))
						Utils.LUA_DEBUGOUT(tostring(Partner.Tag) .. ": offer:  " .. tostring(Trade.OfferFactor))
					end

					-- Store the details of every possible trade partner
					-- We will consider the recipient's true opinion here so we don't just take stuff our puppets need

					index = index + 1
					TradePartners[index] = {
						PartnerTag = Partner.Tag,
						TradeFactor = Trade.TradeFactor + Trade.OfferFactor
					}
				else
					if tostring(Params.MinisterTag) == tagString then
						Utils.LUA_DEBUGOUT(tostring(Partner.Tag) .. ": no trade")
					end
				end
			end
		end
	end

	return TradePartners
end


-- #############################################################################
-- This function will calculate a country's response to a particular trade offer
--
-- IMPORTANT:-
-- This function does a lot of work and is called very many times and causes CTDs!!!
-- In the interest of the game's stability it is important that it only does what is strictly necessary!

-- Thus we should quit the function at the first opportunity!
-- It is called to propose trades, to evaluate existing trades and to check the recipient's diplo score
-- And so we should only do the checks that are necessary for the calling context!

function GetTradeFactors( Params )

	if not ( Utils.ASSERT( Params.MinisterTag ) )
	or not ( Utils.ASSERT( Params.MinisterCountry ) )
	or not ( Utils.ASSERT( Params.PartnerTag ) )
	or not ( Utils.ASSERT( Params.PartnerCountry ) )
	or not ( Utils.ASSERT( Params.Goods ) )
	or not ( Utils.ASSERT( Params.Buy ) )
	or not ( Utils.ASSERT( Params.FreeOnly ) )
	or not ( Utils.ASSERT( Params.Proposing ) )
	or not ( Utils.ASSERT( Params.Cancelling ) )
	then
		return {}
	end

	-- The majority of calls to this function will be proposing trades
	-- We only need to get these parameters in the minority of cases

	if not Params.Proposing then
		loMinisterRelation = Params.MinisterCountry:GetRelation(Params.PartnerTag)
		Params.MinisterRelation = loMinisterRelation:GetValue():Get()
		Params.MinisterIsAtWar = Params.MinisterCountry:IsAtWar()
		Params.MinisterAllowDebts = (loMinisterRelation:AllowDebts() and Params.MinisterIsAtWar)
		Params.FreeTradeRule = (Params.MinisterCountry:GetRules():GetValue(CRule._RULE_FREE_RESOURCE_GIFTS_) 
			and Params.PartnerCountry:GetRules():GetValue(CRule._RULE_FREE_RESOURCE_GIFTS_))
		Params.NeedConvoy = Params.MinisterCountry:NeedConvoyToTradeWith(Params.PartnerTag)
		Params.MinisterIC = Params.MinisterCountry:GetTotalIC()
		Params.PartnerIC = Params.PartnerCountry:GetTotalIC()
		Params.PartnerIsSubject = Params.PartnerCountry:IsSubject()
		Params.PartnerOverlord = Params.PartnerCountry:GetOverlord()
	end

	local tagString = "XXX"
	if tostring(Params.MinisterTag) == tagString or tostring(Params.PartnerTag) == tagString then
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("GetTradeFactors...")
	end

	local Trade = {
		TradeFactor = 0,	-- The recipient's opinion of this trade
		AcceptFactor = 0,	-- The recipient's chance of accepting this trade
		OfferFactor = 0		-- Any modifier to the actor's preference for trading with the recipient
	}

	-- Check for free trading (Comintern) and debt facility
	-- If we are looking to get free resources there's no point continuing if we can't

	if Params.FreeOnly and not Params.FreeTradeRule and not Params.MinisterAllowDebts then
		return Trade
	end

	-- Create a table to hold working values

	local Work = {
		PartnerIsAtWar = Params.PartnerCountry:IsAtWar(),
		GoodsPool = Params.PartnerCountry:GetPool()
	}

	-- Get their money situation (uses the same logic as the GetTradePosition function)

	local Money = {
		Stockpile = Work.GoodsPool:Get( _MONEY_ ):Get(),				-- Their current money stockpile level
		Required = Support.GetEffectiveResourceLimit( Params.PartnerCountry, _MONEY_ ),	-- Their required money stockpile level
		Ratio = 1,									-- The ratio (current/required)
		BuyFactor = 0,									-- The money modifier to their buy chance
		SellFactor = 0,									-- The money modifier to their sell chance
		SellThreshold = 0.5								-- The minimum resource ratio at which they will sell
	}

	if Money.Required > 0 then
		Money.Ratio = Money.Stockpile / Money.Required
	elseif Money.Stockpile > 100 then
		Money.Ratio = Money.Stockpile / 100
	end

	if Money.Ratio < 1 then							-- Money is short
		Money.SellFactor = (1 - Money.Ratio) * 75			-- They will sell more
		Money.BuyFactor = -Money.SellFactor				-- They will buy less
		Money.SellThreshold = 0.5 - ((1 - Money.Ratio) / 4)		-- They will sell down to a lower stockpile ratio

	elseif Money.Ratio > 1 then						-- Money is good
		Money.BuyFactor = math.min(((Money.Ratio - 1) / 4) * 100, 25)	-- They will buy less
		Money.SellFactor = -Money.BuyFactor				-- They will sell more
	end

	-- Get their resource situation (uses the same logic as the GetTradePosition function)

	local Resource = {
		Stockpile = Work.GoodsPool:Get( Params.Goods ):Get(),					-- Their current resource stockpile level
		Required = Support.GetEffectiveResourceLimit( Params.PartnerCountry, Params.Goods ),	-- Their required resource stockpile level
		Ratio = 1										-- The ratio (current/required)
	}

	if Resource.Required > 0 then
		Resource.Ratio = Resource.Stockpile / Resource.Required
	elseif Resource.Stockpile > 100 then
		Resource.Ratio = Resource.Stockpile / 100
	end

	-- Now apply any custom ratio modifiers for this country

	local fnParams = {
		MinisterTag = Params.PartnerTag,
		Goods = Params.Goods,
		Ratio = Resource.Ratio
	}
	Resource.Ratio = ApplyTradeModifiers( fnParams )

	-- Now we can calculate how much they like our trade proposal

	if Params.Buy then

		if not Params.Cancelling then

			-- Check they have free selling trade slots

			fnParams = {
				MinisterTag = Params.PartnerTag,
				MinisterCountry = Params.PartnerCountry,
				TotalIC = Params.PartnerIC,
				Goods = Params.Goods,
				Ratio = Resource.Ratio,
				Buy = false
			}
			if not CheckTradeLimit( fnParams ) then
				return Trade
			end
		end

		if Params.FreeTradeRule then

			-- With the free trading rule (Comintern) we can ignore the financial factor
			-- But they should refuse if their stockpile is low

			if Resource.Ratio < 0.5 then
				return Trade
			else
				Trade.TradeFactor = (Resource.Ratio * 100) - 75
			end
		else
			-- They will sell if their stockpile is high or they need money
			-- But not if their stockpile is too low

			if Resource.Ratio < Money.SellThreshold then
				return Trade
			else
				Trade.TradeFactor = (Resource.Ratio * 100) - 75 + Money.SellFactor
			end

			-- If their stockpile of cash is low then they should be selling non-essentials

			if Money.Ratio < 0.25 and Params.Goods == _CRUDE_OIL_ then
				Trade.TradeFactor = Trade.TradeFactor + ((0.25 - Money.Ratio) * 100)
			elseif Money.Ratio < 0.50 and Params.Goods < _CRUDE_OIL_ then
				Trade.TradeFactor = Trade.TradeFactor + ((0.50 - Money.Ratio) * 100)
			end
		end

		-- If their stockpile of essential industrial resources is particularly low then they shouldn't be selling

		if Params.Goods > _CRUDE_OIL_ then
			if Resource.Ratio < 0.25 then
				Trade.TradeFactor = Trade.TradeFactor - ((0.25 - Resource.Ratio) * 100)
			end
			if Resource.Ratio < 0.10 then
				Trade.TradeFactor = Trade.TradeFactor - ((0.10 - Resource.Ratio) * 250)
			end
		end
	else
		-- Check they have free buying trade slots

		if not Params.Cancelling then

			-- Check they have free selling trade slots

			fnParams = {
				MinisterTag = Params.PartnerTag,
				MinisterCountry = Params.PartnerCountry,
				TotalIC = Params.PartnerIC,
				Goods = Params.Goods,
				Ratio = Resource.Ratio,
				Buy = true
			}
			if not CheckTradeLimit( fnParams ) then
				return Trade
			end
		end

		-- If we are cancelling a trade we will apply a -25 penalty if we are out of convoys
		-- Otherwise convoy trading will be declined if the buyer has a shortage of convoys

		if Params.NeedConvoy then
			if Params.Cancelling then
				if Params.PartnerCountry:GetTransports() < 1 then
					Trade.TradeFactor = -25
				end
			else
				fnParams = {
					MinisterTag = Params.PartnerTag,
					ConvoysFree = Params.PartnerCountry:GetTransports(),
					Ratio = Resource.Ratio,
					TotalIC = Params.PartnerIC,
					IsAtWar = Work.PartnerIsAtWar
				}
				if not CheckAvailableConvoys( fnParams ) then
					return Trade
				end
			end
		end

		if Params.FreeTradeRule or (Params.PartnerCountry:GetRelation(Params.MinisterTag):AllowDebts() and Work.PartnerIsAtWar) then

			-- We have free trading (Comintern) or we allow them to buy using the debt facility
			-- In which case they will accept our generosity unless their stockpiles are getting full

			Trade.TradeFactor = Trade.TradeFactor + ((2 - Resource.Ratio) * 100) - 75

		else
			-- They will buy if their stockpile is low provided they have money

			if Money.Ratio < 0.1 or (Money.Ratio < 0.25 and Params.Goods == _FUEL_) 
			or (Money.Ratio < 0.35 and Params.Goods == _FUEL_ and not Params.Cancelling) then
				return Trade
			else
				Trade.TradeFactor = Trade.TradeFactor + ((2 - Resource.Ratio) * 100) - 75 + Money.BuyFactor
			end

			-- If their stockpile of cash is low then they shouldn't be buying non-essentials

			if Money.Ratio < 0.25 and Params.Goods == _CRUDE_OIL_ then
				Trade.TradeFactor = Trade.TradeFactor - ((0.25 - Money.Ratio) * 100)
			elseif Money.Ratio < 0.50 and Params.Goods < _CRUDE_OIL_ then
				Trade.TradeFactor = Trade.TradeFactor - ((0.50 - Money.Ratio) * 100)
			end
		end

		-- If their stockpile of essential industrial resources is particularly low then they should really want to buy

		if Params.Goods > _CRUDE_OIL_ then
			if Resource.Ratio < 0.25 then
				Trade.TradeFactor = Trade.TradeFactor + ((0.25 - Resource.Ratio) * 100)
			end
			if Resource.Ratio < 0.10 then
				Trade.TradeFactor = Trade.TradeFactor + ((0.10 - Resource.Ratio) * 250)
			end
		end
	end

	-- We will make sure the factor is in the range -100 to +150 before applying diplomatic and other modifiers

	Trade.TradeFactor = math.min(math.max(Trade.TradeFactor, -100), 150)

	if tostring(Params.MinisterTag) == tagString or tostring(Params.PartnerTag) == tagString then
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("GetTradeFactors...")
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("Parties:    " .. tostring(Params.MinisterTag) .. ": " .. tostring(Params.PartnerTag))
		Utils.LUA_DEBUGOUT("Trading:    " .. tostring(Params.Goods))
		Utils.LUA_DEBUGOUT("Buying:     " .. tostring(Params.Buy))
		Utils.LUA_DEBUGOUT("FreeOnly:   " .. tostring(Params.FreeOnly))
		Utils.LUA_DEBUGOUT("Cancelling: " .. tostring(Params.Cancelling))
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("Cash Stockpile:     " .. tostring(Money.Stockpile))
		Utils.LUA_DEBUGOUT("Cash Required:      " .. tostring(Money.Required))
		Utils.LUA_DEBUGOUT("Cash Ratio:         " .. tostring(Money.Ratio))
		Utils.LUA_DEBUGOUT("Cash BuyFactor:     " .. tostring(Money.BuyFactor))
		Utils.LUA_DEBUGOUT("Cash SellFactor:    " .. tostring(Money.SellFactor))
		Utils.LUA_DEBUGOUT("Cash SellThreshold: " .. tostring(Money.SellThreshold))
		Utils.LUA_DEBUGOUT("Rsrc Stockpile:     " .. tostring(Resource.Stockpile))
		Utils.LUA_DEBUGOUT("Rsrc Required:      " .. tostring(Resource.Required))
		Utils.LUA_DEBUGOUT("Rsrc Ratio:         " .. tostring(Resource.Ratio))
		Utils.LUA_DEBUGOUT("Trde TradeFactor:   " .. tostring(Trade.TradeFactor))
		Utils.LUA_DEBUGOUT("Trde OfferFactor:   " .. tostring(Trade.OfferFactor))
		Utils.LUA_DEBUGOUT("")
	end

	-- Account for diplomatic factors affecting this trade

	if Params.MinisterRelation > 0 then
		Trade.TradeFactor = Trade.TradeFactor + (Params.MinisterRelation / 8)	-- Maximum +25 bonus for good relations
	elseif Params.MinisterRelation < 0 then
		Trade.TradeFactor = Trade.TradeFactor + (Params.MinisterRelation / 4)	-- Maximum -50 penalty for bad relations
	end

	if tostring(Params.MinisterTag) == tagString then
		Utils.LUA_DEBUGOUT("Relations:    " .. tostring(Trade.TradeFactor))
	end

	Trade.TradeFactor = Trade.TradeFactor - ((1 - Support.ThreatFactor(Params.PartnerTag, Params.MinisterTag)) * 50)  -- Maximum -50 penalty for our threat to them

	if tostring(Params.MinisterTag) == tagString or tostring(Params.PartnerTag) == tagString then
		Utils.LUA_DEBUGOUT("Their threat: " .. tostring(Support.ThreatFactor(Params.MinisterTag, Params.PartnerTag)) .. ": " .. tostring(Trade.OfferFactor))
		Utils.LUA_DEBUGOUT("Our threat:   " .. tostring(Support.ThreatFactor(Params.PartnerTag, Params.MinisterTag)) .. ": " .. tostring(Trade.TradeFactor))
	end

	fnParams = {
		MinisterTag = Params.MinisterTag,
		MinisterCountry = Params.MinisterCountry,
		TargetTag = Params.PartnerTag,
		TargetCountry = Params.PartnerCountry
	}
	if Support.IsMilitaryAlly( fnParams ) then
		Trade.TradeFactor = Trade.TradeFactor + 10			-- Bonus +10 if we are allies
		if Params.MinisterIsAtWar or Work.PartnerIsAtWar then
			Trade.TradeFactor = Trade.TradeFactor + 10		-- Further +10 if either party is at war
		end
	end

	if not Params.NeedConvoy then
		Trade.TradeFactor = Trade.TradeFactor + 10			-- Bonus +10 if we can trade without convoys
	end

	if Params.Proposing then

		-- Calculate factors affecting the proposing country's attitude to this partner

		Trade.OfferFactor = (Support.ThreatFactor(Params.MinisterTag, Params.PartnerTag) - 1) * 50	-- Maximum -50 penalty for their threat to us

		if Params.Buy and (Params.FreeTradeRule or Params.MinisterAllowDebts) and not Params.FreeOnly then
			Trade.OfferFactor = Trade.OfferFactor + 25				-- Bonus +25 if we are getting resources for free
		end

		if not Params.Buy and Params.FreeTradeRule then
			if Params.PartnerIsSubject and Params.PartnerOverlord == Params.MinisterTag then
				Trade.OfferFactor = Trade.OfferFactor - 15			-- Penalty -15 if we are giving resources away to puppets
			else
				Trade.OfferFactor = Trade.OfferFactor - 50			-- Penalty -50 if we are giving resources away to others
			end
		end

		if not Params.PartnerIsSubject or Params.PartnerOverlord ~= Params.MinisterTag then
			local work = Params.MinisterIC / Params.PartnerIC
			work = math.min(math.max(work - 1, 0), 25)
			Trade.OfferFactor = Trade.OfferFactor - work				-- Maximum penalty -25 when proposing trades to small countries

			if tostring(Params.MinisterTag) == tagString or tostring(Params.PartnerTag) == tagString then
				Utils.LUA_DEBUGOUT("Size:         " .. tostring(work))
			end

		end
	end

	if tostring(Params.MinisterTag) == tagString or tostring(Params.PartnerTag) == tagString then
		Utils.LUA_DEBUGOUT("Geo-Diplo:    " .. tostring(Trade.TradeFactor))
	end

	-- Finally we will make sure the trade factor is in the range 0 to 125

	Trade.TradeFactor = math.min(math.max(Trade.TradeFactor, 0), 125)

	if Params.PartnerIsSubject and Params.PartnerOverlord == Params.MinisterTag then
		if Params.Cancelling then
			Trade.AcceptFactor = math.min(Trade.TradeFactor + 25, 125)	-- Our puppet will be reluctant to cancel!
		else
			Trade.AcceptFactor = math.max(Trade.TradeFactor, 100)		-- Our puppet will always say yes!
		end
	else
		Trade.AcceptFactor = Trade.TradeFactor
	end

	if tostring(Params.MinisterTag) == tagString or tostring(Params.PartnerTag) == tagString then
		Utils.LUA_DEBUGOUT("Final Trade:  " .. tostring(Trade.TradeFactor))
		Utils.LUA_DEBUGOUT("Final Accept: " .. tostring(Trade.AcceptFactor))
		Utils.LUA_DEBUGOUT("Final Offer:  " .. tostring(Trade.OfferFactor))
	end

	return Trade
end


-- #############################################################################
-- This function will check whether we want to accept another trade of this type

function CheckTradeLimit ( Params )

	if not ( Utils.ASSERT( Params.MinisterTag ) )
	or not ( Utils.ASSERT( Params.MinisterCountry ) )
	or not ( Utils.ASSERT( Params.TotalIC ) )
	or not ( Utils.ASSERT( Params.Goods ) )
	or not ( Utils.ASSERT( Params.Ratio ) )
	or not ( Utils.ASSERT( Params.Buy ) )
	then
		return false
	end

	local Work = {
		MaxNoOfTrades = 0,
		CurrentNoOfTrades = 0
	}

	-- The AI will be allowed one trade plus one extra for every 20 IC it has (rounding up)

	if Params.Buy then
		Work.MaxNoOfTrades = 1 + math.ceil( (Params.TotalIC * 0.05) / math.max(Params.Ratio, 0.1) )
	else
		Work.MaxNoOfTrades = 1 + math.ceil( (Params.TotalIC * 0.05) * Params.Ratio )
	end

	-- Now calculate the current number of active trades we have

	for loTradeRoute in Params.MinisterCountry:AIGetTradeRoutes() do
		if loTradeRoute:IsValid() and not loTradeRoute:IsInactive() then
			-- Only count active trade routes!
			if loTradeRoute:GetFrom() == Params.MinisterTag then						-- This is a trade we offered
				if (Params.Buy and loTradeRoute:GetTradedToOf( Params.Goods ):Get() > 0)		-- We are buying and this is an import
				or (not Params.Buy and loTradeRoute:GetTradedFromOf( Params.Goods ):Get() > 0) then	-- We are selling and this is an export
					Work.CurrentNoOfTrades = Work.CurrentNoOfTrades + 1
				end
			else												-- Otherwise it's a trade they offered
				if (Params.Buy and loTradeRoute:GetTradedFromOf( Params.Goods ):Get() > 0)		-- We are buying and this is an import
				or (not Params.Buy and loTradeRoute:GetTradedToOf( Params.Goods ):Get() > 0) then	-- We are selling and this is an export
					Work.CurrentNoOfTrades = Work.CurrentNoOfTrades + 1
				end
			end
		end
	end

	local tagString = "XXX"
	if tostring(Params.MinisterTag) == tagString then
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("CheckTradeLimit...")
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("Partner:        " .. tostring(Params.MinisterTag))
		Utils.LUA_DEBUGOUT("Trading:        " .. tostring(Params.Goods))
		Utils.LUA_DEBUGOUT("Buying:         " .. tostring(Params.Buy))
		Utils.LUA_DEBUGOUT("Ratio:          " .. tostring(Params.Ratio))
		Utils.LUA_DEBUGOUT("Cancelling:     " .. tostring(Params.Cancelling))
		Utils.LUA_DEBUGOUT("IC:             " .. tostring(Params.TotalIC))
		Utils.LUA_DEBUGOUT("Max trades:     " .. tostring(Work.MaxNoOfTrades))
		Utils.LUA_DEBUGOUT("Current trades: " .. tostring(Work.CurrentNoOfTrades))
	end

	if Work.CurrentNoOfTrades < Work.MaxNoOfTrades then
		return true
	end

	return false
end


-- #####################################################################
-- This function will check whether we want to accept trades of any type

function GetTradeLimits ( Params )

	if not ( Utils.ASSERT( Params.MinisterTag ) )
	or not ( Utils.ASSERT( Params.MinisterCountry ) )
	or not ( Utils.ASSERT( Params.TotalIC ) )
	or not ( Utils.ASSERT( Params.TradePosition ) )
	or not ( Utils.ASSERT( Params.Cancelling ) )
	then
		return {}
	end

	local TradeLimits = {}

	local tagString = "XXX"
	if tostring(Params.MinisterTag) == tagString then
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("GetTradeLimits...")
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("Country:        " .. tostring(Params.MinisterTag))
		Utils.LUA_DEBUGOUT("IC:             " .. tostring(Params.TotalIC))
	end

	-- Create a table to hold the counts of our imports and exports

	local Counts = {}
	for i = 0, 6 do
		Counts[i] = {
			NoOfImports = 0,
			NoOfExports = 0,
			MaxNoOfImports = 0,
			MaxNoOfExports = 0
		}
	end

	-- Now calculate the current number of active trades we have of each type

	for loTradeRoute in Params.MinisterCountry:AIGetTradeRoutes() do

		if loTradeRoute:IsValid() and not loTradeRoute:IsInactive() then				-- Only count active trade routes!

			if loTradeRoute:GetFrom() == Params.MinisterTag then					-- This is a trade we offered
				for i = 0, 6 do
					if i ~= _MONEY_ then
						if loTradeRoute:GetTradedToOf( i ):Get() > 0 then		-- This is an import
							Counts[i].NoOfImports = Counts[i].NoOfImports + 1
						elseif loTradeRoute:GetTradedFromOf( i ):Get() > 0 then		-- This is an export
							Counts[i].NoOfExports = Counts[i].NoOfExports + 1
						end
					end
				end
			else											-- This was a trade someone else offered
				for i = 0, 6 do
					if i ~= _MONEY_ then
						if loTradeRoute:GetTradedFromOf( i ):Get() > 0 then		-- This is an import
							Counts[i].NoOfImports = Counts[i].NoOfImports + 1
						elseif loTradeRoute:GetTradedToOf( i ):Get() > 0 then		-- This is an export
							Counts[i].NoOfExports = Counts[i].NoOfExports + 1
						end
					end
				end
			end
		end
	end

	-- Now let's calculate our maximum number of trades of each type

	for i = 0, 6 do

		-- The AI will be allowed one trade plus one extra for every 20 IC it has (rounding up)

		Counts[i].MaxNoOfImports = 1 + math.ceil( (Params.TotalIC * 0.05) / math.max(Params.TradePosition[i].Ratio, 0.1) )
		Counts[i].MaxNoOfExports = 1 + math.ceil( (Params.TotalIC * 0.05) * Params.TradePosition[i].Ratio )

		-- Calculate the final values
		
		if Cancelling then
			TradeLimits[i] = {
				ImportsValid = (Counts[i].NoOfImports <= Counts[i].MaxNoOfImports),
				ExportsValid = (Counts[i].NoOfExports <= Counts[i].MaxNoOfExports)
			}
		else
			TradeLimits[i] = {
				ImportsValid = (Counts[i].NoOfImports < Counts[i].MaxNoOfImports),
				ExportsValid = (Counts[i].NoOfExports < Counts[i].MaxNoOfExports)
			}
		end

		local tagString = "XXX"
		if tostring(Params.MinisterTag) == tagString then
			Utils.LUA_DEBUGOUT("")
			Utils.LUA_DEBUGOUT("Trading:        " .. tostring(i))
			Utils.LUA_DEBUGOUT("Cancelling:     " .. tostring(Params.Cancelling))
			Utils.LUA_DEBUGOUT("Ratio:          " .. tostring(Params.TradePosition[i].Ratio))
			Utils.LUA_DEBUGOUT("Cur imports:    " .. tostring(Counts[i].NoOfImports))
			Utils.LUA_DEBUGOUT("Max imports:    " .. tostring(Counts[i].MaxNoOfImports))
			Utils.LUA_DEBUGOUT("Valid:          " .. tostring(TradeLimits[i].ImportsValid))
			Utils.LUA_DEBUGOUT("Cur exports:    " .. tostring(Counts[i].NoOfExports))
			Utils.LUA_DEBUGOUT("Max exports:    " .. tostring(Counts[i].MaxNoOfExports))
			Utils.LUA_DEBUGOUT("Valid:          " .. tostring(TradeLimits[i].ExportsValid))
		end
	end

	return TradeLimits
end


-- ########################################################################
-- This function checks if we have enough convoys to handle an import trade

function CheckAvailableConvoys( Params )

	if not ( Utils.ASSERT( Params.MinisterTag ) )
	or not ( Utils.ASSERT( Params.ConvoysFree ) )
	or not ( Utils.ASSERT( Params.Ratio ) )
	or not ( Utils.ASSERT( Params.TotalIC ) )
	or not ( Utils.ASSERT( Params.IsAtWar ) )
	then
		return false
	end

	-- NOTE: the figure for free convoys makes sense most of the time but on some days seems too high
	-- Possibly because some convoys don't need to run every day?

	local Work = {
		ConvoysNeeded = 0
	}

	-- We require a minimum of 5 free convoys
	-- But we want convoys equal to 20% of our IC up to a maximum of 20
	-- We will double our requirement if we're at war

	Work.ConvoysNeeded = math.min(math.max(Params.TotalIC / 5, 5), 20)
	if Params.IsAtWar then
		Work.ConvoysNeeded = Work.ConvoysNeeded * 2
	end

	-- The more desperate we are for resources the fewer free convoys we require

	if Params.Ratio < 1 then
		Work.ConvoysNeeded = math.max(Work.ConvoysNeeded * Params.Ratio, 1)
	end

	local tagString = "XXX"
	if tostring(Params.MinisterTag) == tagString then
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("CheckAvailableConvoys...")
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("Convoys: " .. tostring(Params.MinisterTag) .. ": " .. tostring(Params.ConvoysFree) .. " / " .. tostring(Work.ConvoysNeeded))
	end

	if Params.ConvoysFree < Work.ConvoysNeeded then
		return false
	else
		return true
	end
end


-- #########################################################
-- This function checks if we have enough diplomacy to trade

function CheckTradeDiplomacy ( Params )

	if not ( Utils.ASSERT( Params.MinisterTag ) )
	or not ( Utils.ASSERT( Params.TotalIC ) )
	or not ( Utils.ASSERT( Params.Diplomacy ) )
	or not ( Utils.ASSERT( Params.TradePosition ) )
	then
		return {}
	end

	local TradeDiplomacy = {}

	local Limits = {
		Low = 0,
		Medium = 0,
		High = 0
	}

	-- Calculate diplomacy limits based on the country's IC

	if Params.TotalIC < 10 then		-- 5
		Limits.Low = 2
		Limits.Medium = 3
		Limits.High = 4
	elseif Params.TotalIC < 30 then		-- 5, 10
		Limits.Low = 4
		Limits.Medium = 6
		Limits.High = 8
	elseif Params.TotalIC < 100 then	-- 5, 10, 15
		Limits.Low = 6
		Limits.Medium = 9
		Limits.High = 12
	else					-- 5, 15, 25
		Limits.Low = 6
		Limits.Medium = 10
		Limits.High = 16
	end

	local tagString = "XXX"
	if tostring(Params.MinisterTag) == tagString then
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("CheckTradeDiplomacy...")
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("Country:   " .. tostring(Params.MinisterTag))
		Utils.LUA_DEBUGOUT("IC:        " .. tostring(Params.TotalIC))
		Utils.LUA_DEBUGOUT("Diplomacy: " .. tostring(Params.Diplomacy))
		Utils.LUA_DEBUGOUT("Low:       " .. tostring(Limits.Low))
		Utils.LUA_DEBUGOUT("Medium:    " .. tostring(Limits.Medium))
		Utils.LUA_DEBUGOUT("High:      " .. tostring(Limits.High))
	end

	-- Decide whether we can trade each resource

	for i = 0, 6 do

		TradeDiplomacy[i] = {
			OpenToTrade = false
		}

		if i == _MONEY_ then

			-- Decide if we can sell anything (store this against money)

			if Params.TradePosition[i].Ratio < 0.1 then
				TradeDiplomacy[i].OpenToTrade = true
			elseif Params.TradePosition[i].Ratio < 0.25 and Params.Diplomacy >= Limits.Low then
				TradeDiplomacy[i].OpenToTrade = true
			elseif Params.TradePosition[i].Ratio < 0.50 and Params.Diplomacy >= Limits.Medium then
				TradeDiplomacy[i].OpenToTrade = true
			elseif Params.Diplomacy >= Limits.High then
				TradeDiplomacy[i].OpenToTrade = true
			end

		elseif i > _CRUDE_OIL_ then

			-- Decide if we can buy essential industrial resources

			if Params.TradePosition[i].Ratio < 0.1 then
				TradeDiplomacy[i].OpenToTrade = true
			elseif Params.TradePosition[i].Ratio < 0.25 and Params.Diplomacy >= Limits.Low then
				TradeDiplomacy[i].OpenToTrade = true
			elseif Params.TradePosition[i].Ratio < 0.50 and Params.Diplomacy >= Limits.Medium then
				TradeDiplomacy[i].OpenToTrade = true
			elseif Params.Diplomacy >= Limits.High then
				TradeDiplomacy[i].OpenToTrade = true
			end

		elseif i < _METAL_ then

			-- Decide if we can buy other resources

			if Params.TradePosition[i].Ratio < 0.1 and Params.Diplomacy >= Limits.Low then
				TradeDiplomacy[i].OpenToTrade = true
			elseif Params.TradePosition[i].Ratio < 0.25 and Params.Diplomacy >= Limits.Medium then	
				TradeDiplomacy[i].OpenToTrade = true
			elseif Params.TradePosition[i].Ratio >= Limits.High then
				TradeDiplomacy[i].OpenToTrade = true
			end
		end

		if tostring(Params.MinisterTag) == tagString then
			Utils.LUA_DEBUGOUT("")
			Utils.LUA_DEBUGOUT("Goods:     " .. tostring(i))
			Utils.LUA_DEBUGOUT("Ratio:     " .. tostring(Params.TradePosition[i].Ratio))
			Utils.LUA_DEBUGOUT("Trade:     " .. tostring(TradeDiplomacy[i].OpenToTrade))
		end
	end

	return TradeDiplomacy
end


-- ##########################################################
-- Adjusts the current resource ratios for specific countries

function ApplyTradeModifiers ( Params )

	if not ( Utils.ASSERT( Params.MinisterTag ) )
	or not ( Utils.ASSERT( Params.Goods ) )
	or not ( Utils.ASSERT( Params.Ratio ) )
	then
		return 1
	end

	local tagString = "XXX"
	if tostring(Params.MinisterTag) == tagString then
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("ApplyTradeModifiers...")
		Utils.LUA_DEBUGOUT("")
		Utils.LUA_DEBUGOUT("Goods:     " .. tostring(Params.Goods))
		Utils.LUA_DEBUGOUT("Ratio In:  " .. tostring(Params.Ratio))
	end

	if tostring(Params.MinisterTag) == "ENG" then
		if Params.Goods == _CRUDE_OIL_ then
			Params.Ratio = Params.Ratio * 0.25
		elseif Params.Goods == _METAL_ then
			Params.Ratio = Params.Ratio * 0.75
		end
	elseif tostring(Params.MinisterTag) == "GER" then
		if Params.Goods == _FUEL_ then
			Params.Ratio = Params.Ratio * 0.5
		elseif Params.Goods == _CRUDE_OIL_ or Params.Goods == _RARE_MATERIALS_ then
			Params.Ratio = Params.Ratio * 0.25
		end
	elseif tostring(Params.MinisterTag) == "FRA" or tostring(Params.MinisterTag) == "ITA"
	or tostring(Params.MinisterTag) == "POR" then
		if Params.Goods == _CRUDE_OIL_ then
			Params.Ratio = Params.Ratio * 0.25
		end
	end

	if tostring(Params.MinisterTag) == tagString then
		Utils.LUA_DEBUGOUT("Ratio Out:  " .. tostring(Params.Ratio))
	end

	return Params.Ratio

end

