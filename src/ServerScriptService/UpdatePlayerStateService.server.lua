local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local UpdatePlayerStateEvent = ReplicatedStorage:WaitForChild("UpdatePlayerState")
local StateManager = require(ServerStorage.StateManager)

local function setPlayerState(player, stateName, stateValue)
	if not player  then
		return
	end
	
	StateManager.SetPlayerState(player, stateName, stateValue)
end

UpdatePlayerStateEvent.OnServerEvent:Connect(setPlayerState)
