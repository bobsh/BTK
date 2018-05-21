local CurrencyManager = {}

-- Services
local DataStoreService = game:GetService("DataStoreService")

-- Setable variables
local initialFunds = 0

-- Constants
local DATASTORE_RETRIES = 3

-- Private variables
local playerDataStore = DataStoreService:GetDataStore("PlayerData")

-- Private functions

-- Function to retry the passed in function several times. If the passed in function
-- is unable to be run then this function returns false and creates an error.
local function dataStoreRetry(dataStoreFunction)
	local tries = 0
	local success
	local data = nil
	repeat
		tries = tries + 1
		success = pcall(function() data = dataStoreFunction() end)
		if not success then wait(1) end
	until tries == DATASTORE_RETRIES or success
	if not success then
		error('Could not access DataStore! Warn players that their data might not get saved!')
	end
	return success, data
end

-- Attempts to process a list of transactions (either all deposits or withdrawls). Set deposit
-- to true if depositing currency, set to false if withdrawing
local function batchTransactions(playerId, transactions, deposit)
	local balance = 0

	-- Get sum of all transactions
	local total = 0
	for i = 1, #transactions do
		if deposit then
			total = total + transactions[i]
		else
			total = total - transactions[i]
		end
	end

	local enoughMoney = true
	local success = dataStoreRetry(function()
		playerDataStore:UpdateAsync(playerId, function(oldData)
			-- Check if player has enough funds to cover transaction
			if oldData.Currency + total >= 0 then
				oldData.Currency = oldData.Currency + total
			else
				enoughMoney = false
			end
			balance = oldData.Currency
			return oldData
		end)
		return true
	end)

	return success, balance, enoughMoney
end

-- Sets the initial amount of money to grant to players the first time they join
function CurrencyManager:SetInitialFunds(initial)
	initialFunds = initial
end

-- Deposits a table of transactions for the given player
function CurrencyManager:DepositBatch(playerId, deposits)
	return batchTransactions(playerId, deposits, true)
end

-- Deposits the given amount of currency for the given player
function CurrencyManager:Deposit(playerId, amount)
	return batchTransactions(playerId, {amount}, true)
end

-- Deposits a table of transactions for the given player
function CurrencyManager:WithdrawBatch(playerId, withrawals)
	return batchTransactions(playerId, withrawals, false)
end

-- Withdraws the given amount of currency from the given player
function CurrencyManager:Withdraw(playerId, amount)
	return batchTransactions(playerId, {amount}, false)
end

-- Sets up the datastore for a player when that player first joins the game
function CurrencyManager:InitializePlayer(playerId)
	local success = dataStoreRetry(function()
		playerDataStore:UpdateAsync(playerId, function(oldData)
			if not oldData or oldData == {} then
				oldData = {}
				oldData.Currency = initialFunds
				oldData.LastLoginReward = 0
				return oldData
			end
		end)
	end)
	return success
end

-- Checks the current balance of currency a player has
function CurrencyManager:GetBalance(playerId)
	local balance = 0
	dataStoreRetry(function()
		local playerData = playerDataStore:GetAsync(playerId)
		balance = playerData.Currency
		return true
	end)
	return balance
end

return CurrencyManager