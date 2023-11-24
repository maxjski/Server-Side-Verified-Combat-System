local PlayerActionsModule = {}

local playersData = {}

local function initializePlayerData(player)
	if not playersData[player.UserId] then
		playersData[player.UserId] = {
			inAction = false,
			inSprint = false,
			recovering = false,
			critRecovering = false,
			stunned = false,
			cooldowns = {}
		}
	end
end

function PlayerActionsModule.SetPlayerState(player, stateName, stateValue)
	initializePlayerData(player)
	playersData[player.UserId][stateName] = stateValue
end

function PlayerActionsModule.GetPlayerState(player, stateName)
	initializePlayerData(player)
	return playersData[player.UserId][stateName]
end

function PlayerActionsModule.TogglePlayerState(player, stateName)
	playersData[player.UserId][stateName] = not playersData[player.UserId][stateName]
end

function PlayerActionsModule.StartCooldown(player, abilityName, cooldownDuration)
	initializePlayerData(player)
	local endTime = time() + cooldownDuration
	playersData[player.UserId].cooldowns[abilityName] = endTime
end

function PlayerActionsModule.IsCooldownComplete(player, abilityName)
	initializePlayerData(player)
	local endTime = playersData[player.UserId].cooldowns[abilityName]
	if not endTime then return true end
	return time() >= endTime
end

return PlayerActionsModule