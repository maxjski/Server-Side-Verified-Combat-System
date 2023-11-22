local ServerStorage = game:GetService("ServerStorage")
local StateManager = require(ServerStorage.StateManager)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GetPlayerState = ReplicatedStorage:WaitForChild("GetPlayerState")

local function handleGetPlayerState(player, state)
	-- Optional: Perform additional checks to ensure the request is valid
	return StateManager.IsPlayerState(player, state)
end

GetPlayerState.OnServerInvoke = handleGetPlayerState