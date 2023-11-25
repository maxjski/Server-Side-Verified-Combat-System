local guardModule = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerDataModule = require(ReplicatedStorage.PlayerData.PlayerDataModule)
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
	return PlayerDataModule.GetPlayerState(player, "inAction") == false
end

function guardModule.stopable(player)
	return true
end

function guardModule.executeClient(player)
	if not player  then	return end
	PlayerDataModule.SetPlayerState(player, "inAction", true)
end

function guardModule.stopClient(player)
	if not player  then	return end
	PlayerDataModule.SetPlayerState(player, "inAction", false)
end

function guardModule.execute(player)
	local humanoid = player.Character:WaitForChild("Humanoid")
	
	humanoid.WalkSpeed = 0
	humanoid.JumpHeight = 0

	PlayerDataModule.SetPlayerState(player, "inAction", true)
	PlayerDataModule.SetPlayerStatistic(player, "defensive", 0.9)
	print(PlayerDataModule.GetPlayerStatistic(player, "defensive"))
end

function guardModule.stop(player)
	local humanoid = player.Character:WaitForChild("Humanoid")

	if PlayerDataModule.GetPlayerState(player, "inSprint") then
		humanoid.WalkSpeed = 30 + PlayerDataModule.GetPlayerStatistic(player, "speed")
		humanoid.JumpHeight = 20 + PlayerDataModule.GetPlayerStatistic(player, "speed")
	else 
		humanoid.WalkSpeed = 10 + (PlayerDataModule.GetPlayerStatistic(player, "speed")/2)
		humanoid.JumpHeight = 10 + PlayerDataModule.GetPlayerStatistic(player, "speed")
	end

	PlayerDataModule.SetPlayerState(player, "inAction", false)
	PlayerDataModule.SetPlayerStatistic(player, "defensive", 0)
end

return guardModule
