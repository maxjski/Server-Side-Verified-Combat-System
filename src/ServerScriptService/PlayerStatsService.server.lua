-- Modules
local ServerStorage = game:GetService("ServerStorage")
local PlayerData = require(ServerStorage.PlayerData)

local WALK_SPEED_KEY_NAME = PlayerData.WALK_SPEED_KEY_NAME

-- Set player statistics
game.Players.PlayerAdded:Connect(function(player)
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:FindFirstChild("Humanoid")
	
	humanoid.WalkSpeed = PlayerData.getValue(player, WALK_SPEED_KEY_NAME)
end)