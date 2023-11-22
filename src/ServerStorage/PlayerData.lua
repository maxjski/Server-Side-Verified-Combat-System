local PlayerData = {}
PlayerData.WALK_SPEED_KEY_NAME = "WalkSpeed"

local playerData = {
  --[[
    [userId: string] = {
      ["WalkSpeed"] = walkSpeed: number
    }
  ]]
}

local DEFAULT_PLAYER_DATA = {
	[PlayerData.WALK_SPEED_KEY_NAME] = 8
}

local function getData(player)
	local data = playerData[tostring(player.UserId)] or DEFAULT_PLAYER_DATA
	playerData[tostring(player.UserId)] = data
	return data
end

function PlayerData.getValue(player, key)
	return getData(player)[key]
end

function PlayerData.updateValue(player, key, updateFunction)
	local data = getData(player)
	local oldValue = data[key]
	local newValue = updateFunction(oldValue)

	data[key] = newValue
	return newValue
end

return PlayerData