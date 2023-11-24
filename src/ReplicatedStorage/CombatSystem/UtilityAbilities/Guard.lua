local guardModule = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerStatisticsModule = require(ReplicatedStorage.PlayerData.PlayerStatistics)
local PlayerActionsModule = require(ReplicatedStorage.PlayerData.PlayerActionsModule)
local animationIds = require(ReplicatedStorage.PlayerData.AnimationIDs)

guardModule["id"] = "guard"
guardModule["animationId"] = animationIds.Guard
guardModule["energyCost"] = 10

function guardModule.playAnimation(player)
	local humanoid = player.Character:WaitForChild("Humanoid")
	local animator = humanoid:WaitForChild("Animator")
	
	local abilityAnimation = Instance.new("Animation")
	abilityAnimation.AnimationId = guardModule.animationId
	local animationTrack = animator:LoadAnimation(abilityAnimation)
	animationTrack:Play()
end

function guardModule.usable(player)
	return true
end

function guardModule.stopable(player)
	return true
end

function guardModule.execute(player)
	local humanoid = player.Character:WaitForChild("Humanoid")
	
	humanoid.WalkSpeed = 0
	humanoid.JumpHeight = 0

	PlayerStatisticsModule.SetPlayerState(player, "defensive", 0.9)
end

function guardModule.stop(player)
	local humanoid = player.Character:WaitForChild("Humanoid")

	if PlayerActionsModule.GetPlayerState(player, "inSprint") then
		humanoid.WalkSpeed = 30 + PlayerStatisticsModule.GetPlayerState(player, "speed")
		humanoid.JumpHeight = 20 + PlayerStatisticsModule.GetPlayerState(player, "speed")
	else 
		humanoid.WalkSpeed = 10 + (PlayerStatisticsModule.GetPlayerState(player, "speed")/2)
		humanoid.JumpHeight = 10 + PlayerStatisticsModule.GetPlayerState(player, "speed")
	end

	PlayerStatisticsModule.SetPlayerState(player, "defensive", 0)
end

return guardModule
