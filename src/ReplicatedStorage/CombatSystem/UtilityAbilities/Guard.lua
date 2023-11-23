local guardModule = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
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

function guardModule.execute(player)
	local humanoid = player.Character:WaitForChild("Humanoid")
	
	humanoid.WalkSpeed = 0
	humanoid.JumpHeight = 0
	
	humanoid.WalkSpeed = 16
	humanoid.JumpHeight = 7.2
end

return guardModule
