local CEAccelerationModule = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerStatisticsModule = require(ReplicatedStorage.PlayerData.PlayerStatistics)
local PlayerActionsModule = require(ReplicatedStorage.PlayerData.PlayerActionsModule)
local animationIds = require(ReplicatedStorage.PlayerData.AnimationIDs)

CEAccelerationModule["id"] = "ceacceleration"
CEAccelerationModule["animationId"] = animationIds.PowerUp
CEAccelerationModule["energyCost"] = 10
CEAccelerationModule["cooldown"] = 1

local function getSpeedAndJump(player, isSprinting)
	if isSprinting then
		return 30 + PlayerStatisticsModule.GetPlayerState(player, "speed"), 20 + PlayerStatisticsModule.GetPlayerState(player, "speed")
	else
		return 10 + (PlayerStatisticsModule.GetPlayerState(player, "speed")/2), 10 + PlayerStatisticsModule.GetPlayerState(player, "speed")
	end
end

function CEAccelerationModule.usable(player)
	if PlayerActionsModule.IsCooldownComplete(player, CEAccelerationModule["id"]) then
		PlayerActionsModule.StartCooldown(player, CEAccelerationModule.id, CEAccelerationModule.cooldown)
		return true
	end
	
	return false
end

function CEAccelerationModule.execute(player)
	if not player  then
		print("ERROR: player empty")
		return	end
	
	local humanoid = player.Character:WaitForChild("Humanoid")
	local animator = humanoid:WaitForChild("Animator")
	
	local abilityAnimation = Instance.new("Animation")
	abilityAnimation.AnimationId = CEAccelerationModule.animationId
	local animationTrack = animator:LoadAnimation(abilityAnimation)
	animationTrack:Play()
	
	humanoid.WalkSpeed = 0
	humanoid.JumpHeight = 0
	
	local animator

	wait(0.5)

	PlayerActionsModule.TogglePlayerState(player, "inPowerMode")
	local isSprinting = PlayerActionsModule.GetPlayerState(player, "inPowerMode")
	
	print(isSprinting)
	print("SPEED")
	print(getSpeedAndJump(player, isSprinting))
	
	humanoid.WalkSpeed, humanoid.JumpHeight = getSpeedAndJump(player, isSprinting)
end

return CEAccelerationModule
