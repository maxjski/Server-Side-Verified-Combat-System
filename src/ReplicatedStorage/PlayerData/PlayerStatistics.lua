local PlayerStatisticsModule = {}

local playerStatistics = {}

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
			walkSpeed = 10
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

function PlayerStatisticsModule.DealPhysicalDamage(player, damage)
	local humanoid = player.Character:WaitForChild("Humanoid")
	humanoid.Health -= damage - (damage * playerStatistics[player.UserId]["defense"])
end

return PlayerStatisticsModule