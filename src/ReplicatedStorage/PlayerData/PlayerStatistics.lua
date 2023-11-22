local PlayerStatisticsModule = {}

local playerStatistics = {}

local abilityCooldowns = {
	dash = 0,5,
	ceacceleration = 1,
	guard = 0,
	punch = 0.5,
	quickstrike = 5,
}

local function initializePlayerData(player)
	if not playerStatistics[player.UserId] then
		playerStatistics[player.UserId] = {
			maxHealth = 100,
			strength = 1,
			speed = 1,
			stamina = 100,
			ceOutput = 10,
			ceCapacity = 100,
			defense = 0,
		}
	end
end

function PlayerStatisticsModule.SetPlayerState(player, stateName, stateValue)
	initializePlayerData(player)
	playerStatistics[player.UserId][stateName] = stateValue
end

function PlayerStatisticsModule.GetPlayerState(player, stateName)
	initializePlayerData(player)
	return playerStatistics[player.UserId][stateName]
end

function PlayerStatisticsModule.DealPhysicalDamage(player, humanoid, damage)
	if not player then
		humanoid.Health = humanoid.Health - damage
		return
	end

	humanoid.Health -= damage - (damage * playerStatistics[player.UsedId]["defense"])
end

return PlayerStatisticsModule