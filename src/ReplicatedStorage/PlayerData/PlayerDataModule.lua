local PlayerDataModule = {}

PlayerDataModule.MAXHEALTH_KEY_NAME = "maxHealth"
PlayerDataModule.STRENGTH_KEY_NAME = "strength"
PlayerDataModule.SPEED_KEY_NAME = "speed"
PlayerDataModule.STAMINA_KEY_NAME = "stamina"
PlayerDataModule.CEOUTPUT_KEY_NAME = "ceOutput"
PlayerDataModule.CECAPACITY_KEY_NAME = "ceCapacity"
PlayerDataModule.DEFENSE_KEY_NAME = "defense"
PlayerDataModule.WALKSPEED_KEY_NAME = "walkSpeed"
PlayerDataModule.STATES_KEY_NAME = "states"

PlayerDataModule.INACTION_KEY_NAME = "inAction"
PlayerDataModule.INSPRINT_KEY_NAME = "inSpring"
PlayerDataModule.RECOVERING_KEY_NAME = "recovering"
PlayerDataModule.CRITRECOVERING_KEY_NAME = "critRecovering"
PlayerDataModule.STUNNED_KEY_NAME = "stunned"
PlayerDataModule.COOLDOWNS_KEY_NAME = "cooldowns"

local playerData = {}

local DEFAULT_PLAYER_DATA = {
	[PlayerDataModule.MAXHEALTH_KEY_NAME] = 100,
	[PlayerDataModule.STRENGTH_KEY_NAME] = 1,
	[PlayerDataModule.SPEED_KEY_NAME] = 1,
	[PlayerDataModule.STAMINA_KEY_NAME] = 100,
	[PlayerDataModule.CEOUTPUT_KEY_NAME] = 10,
	[PlayerDataModule.CECAPACITY_KEY_NAME] = 100,
	[PlayerDataModule.DEFENSE_KEY_NAME] = 0,
	[PlayerDataModule.WALKSPEED_KEY_NAME] = 10,
	[PlayerDataModule.STATES_KEY_NAME] = {
		[PlayerDataModule.INACTION_KEY_NAME] = false,
		[PlayerDataModule.INSPRINT_KEY_NAME] = false,
		[PlayerDataModule.RECOVERING_KEY_NAME] = false,
		[PlayerDataModule.CRITRECOVERING_KEY_NAME] = false,
		[PlayerDataModule.STUNNED_KEY_NAME] = false,
		[PlayerDataModule.COOLDOWNS_KEY_NAME] = {}
	}
}

local function cloneTable(table)
    local copy = {}
    for key, value in pairs(table) do
        if type(value) == "table" then
            copy[key] = cloneTable(value)
        else
            copy[key] = value
        end
    end
    return copy
end

local function getData(player)
    local userId = tostring(player.UserId)
    if not playerData[userId] then
        playerData[userId] = cloneTable(DEFAULT_PLAYER_DATA)
    end
    return playerData[userId]
end

function PlayerDataModule.GetPlayerStatistic(player, key)
	return getData(player)[key]
end

function PlayerDataModule.SetPlayerStatistic(player, key, value)
	local data = getData(player)
	data[key] = value
end

function PlayerDataModule.GetPlayerState(player, stateName)
	local data = getData(player)
	return data[PlayerDataModule.STATES_KEY_NAME][stateName]
end

function PlayerDataModule.SetPlayerState(player, stateName, stateValue)
	local data = getData(player)
	data[PlayerDataModule.STATES_KEY_NAME][stateName] = stateValue
end

function PlayerDataModule.TogglePlayerState(player, stateName)
	local data = getData(player)
	data[PlayerDataModule.STATES_KEY_NAME][stateName] = not data[PlayerDataModule.STATES_KEY_NAME][stateName]
end

function PlayerDataModule.DealPhysicalDamage(player, damage)
	local defense = PlayerDataModule.GetPlayerStatistic(player, "defense")
	print("defense: " .. defense)
	local humanoid = player.Character:WaitForChild("Humanoid")

	humanoid.Health -= damage - (damage * defense)
end

function PlayerDataModule.StartCooldown(player, abilityName, cooldownDuration)
	local data = getData(player)
	local endTime = time() + cooldownDuration
	data[PlayerDataModule.STATES_KEY_NAME][PlayerDataModule.COOLDOWNS_KEY_NAME][abilityName] = endTime
end

function PlayerDataModule.IsCooldownComplete(player, abilityName)
	local data = getData(player)
	local endTime = data[PlayerDataModule.STATES_KEY_NAME][PlayerDataModule.COOLDOWNS_KEY_NAME][abilityName]
	if not endTime then return true end
	return time() >= endTime
end

return PlayerDataModule