local EnemyModule = {}

local enemyActions = {
    inAction = false,
    inSprint = false,
    recovering = false,
    critRecovering = false,
    stunned = false,
    cooldowns = {}
}

local enemyStatistics = {
    maxHealth = 100,
    strength = 1,
    speed = 1,
    stamina = 100,
    ceOutput = 10,
    ceCapacity = 100,
    defense = 0.9,
    walkSpeed = 10
}

function EnemyModule.SetPlayerState(player, stateName, stateValue)
	EnemyModule(player)
	enemyStatistics[player.UserId][stateName] = stateValue
end

function EnemyModule.GetPlayerState(player, stateName)
	EnemyModule(player)
	return enemyStatistics[player.UserId][stateName]
end

function EnemyModule.DealPhysicalDamage(humanoid, damage)
	humanoid.Health -= damage - (damage * enemyStatistics.defense)
end

return EnemyModule