-- StateManager Module Script
-- Save this as a ModuleScript named StateManager in ReplicatedStorage

local StateManager = {}

StateManager.playerConfigs = {
	normalSpeed = 8,
	normalJump = 8,
	sprintSpeed = 32,
	sprintJump = 15
}

local playerStates = {}

function StateManager.SetPlayerState(player, stateName, stateValue)
	if not playerStates[player.UserId] then
		playerStates[player.UserId] = {}
	end

	playerStates[player.UserId][stateName] = stateValue
end

function StateManager.GetPlayerState(player, stateName)
	if not playerStates[player.UserId] then
		return nil
	end

	return playerStates[player.UserId][stateName]
end

function StateManager.IsPlayerState(player, stateName)
	return playerStates[player.UserId] and playerStates[player.UserId][stateName] or false
end

function StateManager.ClearPlayerState(player)
	playerStates[player.UserId] = nil
end

-- Clear states on player leaving to prevent memory leaks
game.Players.PlayerRemoving:Connect(function(player)
	StateManager.ClearPlayerState(player)
end)

return StateManager
