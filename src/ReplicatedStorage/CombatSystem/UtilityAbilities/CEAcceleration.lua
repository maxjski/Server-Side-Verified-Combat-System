local CEAccelerationModule = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerDataModule = require(ReplicatedStorage.PlayerData.PlayerDataModule)
local animationIds = require(ReplicatedStorage.PlayerData.AnimationIDs)

CEAccelerationModule["id"] = "ceacceleration"
CEAccelerationModule["animationId"] = animationIds.PowerUp
CEAccelerationModule["energyCost"] = 10
CEAccelerationModule["cooldown"] = 1

local function getSpeedAndJump(player, isSprinting)
	if isSprinting then
		return 30 + PlayerDataModule.GetPlayerStatistic(player, "speed"), 20 + PlayerDataModule.GetPlayerStatistic(player, "speed")
	else
		return 10 + (PlayerDataModule.GetPlayerStatistic(player, "speed")/2), 10 + PlayerDataModule.GetPlayerStatistic(player, "speed")
	end
end

function CEAccelerationModule.playAnimation(player)
	local humanoid = player.Character:WaitForChild("Humanoid")
	local animator = humanoid:WaitForChild("Animator")
	
	local abilityAnimation = Instance.new("Animation")
	abilityAnimation.AnimationId = CEAccelerationModule.animationId
	local animationTrack = animator:LoadAnimation(abilityAnimation)
	animationTrack:Play()
end

function CEAccelerationModule.usable(player)
	if PlayerDataModule.IsCooldownComplete(player, CEAccelerationModule["id"]) then
		PlayerDataModule.StartCooldown(player, CEAccelerationModule.id, CEAccelerationModule.cooldown)
		return PlayerDataModule.GetPlayerState(player, "inAction") == false
	end
	
	return false
end

function CEAccelerationModule.executeClient(player)
	if not player  then	return end
    PlayerDataModule.SetPlayerState(player, "inAction", true)

	task.spawn(function()
		task.wait(0.5)
		PlayerDataModule.SetPlayerState(player, "inAction", false)
		PlayerDataModule.TogglePlayerState(player, "inSprint")
	end)
end

function CEAccelerationModule.execute(player)
	if not player  then	return end
    PlayerDataModule.SetPlayerState(player, "inAction", true)
	
	local humanoid = player.Character:WaitForChild("Humanoid")
	
	humanoid.WalkSpeed = 0
	humanoid.JumpHeight = 0

	task.spawn(function()
		task.wait(0.5)
		PlayerDataModule.SetPlayerState(player, "inAction", false)
		PlayerDataModule.TogglePlayerState(player, "inSprint")
		local isSprinting = PlayerDataModule.GetPlayerState(player, "inSprint")
		humanoid.WalkSpeed, humanoid.JumpHeight = getSpeedAndJump(player, isSprinting)
	end)
end

return CEAccelerationModule
