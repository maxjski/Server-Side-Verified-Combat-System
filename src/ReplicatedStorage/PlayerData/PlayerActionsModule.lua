local PlayerActionsModule = {}

local playersData = {}

local abilityCooldowns = {
	dash = 0,5,
	ceacceleration = 1,
	guard = 0,
	punch = 0.5,
	quickstrike = 5,
}

local function initializePlayerData(player)
	if not playersData[player.UserId] then
		playersData[player.UserId] = {
			inPowerMode = false,
			inAction = false,
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