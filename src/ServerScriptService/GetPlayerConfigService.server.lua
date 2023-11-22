local ServerStorage = game:GetService("ServerStorage")
local StateManager = require(ServerStorage.StateManager)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GetPlayerState = ReplicatedStorage:WaitForChild("GetPlayerConfig")

local function handleGetPlayerState(player, state)
	-- Optional: Perform additional checks to ensure the request is valid
	return StateManager.playerConfigs[state]
end

GetPlayerState.OnServerInvoke = handleGetPlayerState