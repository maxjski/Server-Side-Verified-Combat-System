local guardModule = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerStatisticsModule = require(ReplicatedStorage.PlayerData.PlayerStatistics)
local PlayerActionsModule = require(ReplicatedStorage.PlayerData.PlayerActionsModule)
local animationIds = require(ReplicatedStorage.PlayerData.AnimationIDs)

guardModule["id"] = "guard"
guardModule["animationId"] = animationIds.Guard
guardModule["energyCost"] = 10
guardModule["animationTrack"] = nil

function guardModule.loadAnimations(player)
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	local animator = humanoid:WaitForChild("Animator")
	
	local animation = Instance.new("Animation")
	animation.AnimationId = guardModule.animationId
	local animationTrack = animator:LoadAnimation(animation)
	
	guardModule["animationTrack"] = animationTrack
end

function guardModule.playAnimation(player)
	if not guardModule["animationTrack"]  then
		guardModule.loadAnimations(player)
	end
	
	guardModule["animationTrack"]:Play()
end

function guardModule.stopAnimation(player)
	if not guardModule["animationTrack"]  then
		guardModule.loadAnimations(player)
	end
	
	guardModule["animationTrack"]:Stop()
end

function guardModule.usable(player)
	return PlayerActionsModule.GetPlayerState(player, "inAction") == false
end

function guardModule.stopable(player)
	return true
end

function guardModule.execute(player)
	local humanoid = player.Character:WaitForChild("Humanoid")
	
	humanoid.WalkSpeed = 0
	humanoid.JumpHeight = 0

	PlayerActionsModule.SetPlayerState(player, "inAction", true)
	PlayerStatisticsModule.SetPlayerState(player, "defensive", 0.9)
end

function guardModule.stop(player)
	print("STOPPING")
	local humanoid = player.Character:WaitForChild("Humanoid")

	if PlayerActionsModule.GetPlayerState(player, "inSprint") then
		humanoid.WalkSpeed = 30 + PlayerStatisticsModule.GetPlayerState(player, "speed")
		humanoid.JumpHeight = 20 + PlayerStatisticsModule.GetPlayerState(player, "speed")
	else 
		humanoid.WalkSpeed = 10 + (PlayerStatisticsModule.GetPlayerState(player, "speed")/2)
		humanoid.JumpHeight = 10 + PlayerStatisticsModule.GetPlayerState(player, "speed")
	end

	PlayerActionsModule.SetPlayerState(player, "inAction", false)
	PlayerStatisticsModule.SetPlayerState(player, "defensive", 0)
end

return guardModule
