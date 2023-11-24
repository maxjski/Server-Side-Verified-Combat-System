local PunchModule = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local PlayerStatisticsModule = require(ReplicatedStorage.PlayerData.PlayerStatistics)
local PlayerActionsModule = require(ReplicatedStorage.PlayerData.PlayerActionsModule)
local animationIds = require(ReplicatedStorage.PlayerData.AnimationIDs)

PunchModule["id"] = "punch"
PunchModule["animationId"] = animationIds.PunchOne
PunchModule["animationIds"] = {
	animationIds.PunchOne,
	animationIds.PunchTwo,
	animationIds.PunchThree,
	animationIds.PunchFour,
}
PunchModule["energyCost"] = 10
PunchModule["cooldown"] = 0.3
PunchModule["punchCounter"] = 1
PunchModule["animationTracks"] = nil

local function getDmg(player)
	return 20 + PlayerStatisticsModule.GetPlayerState(player, "strength")
end	

function PunchModule.loadAnimations(player)
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	local animator = humanoid:WaitForChild("Animator")
	
	PunchModule["animationTracks"] = {}
	for i, animationId in ipairs(PunchModule["animationIds"]) do
		local animation = Instance.new("Animation")
		animation.AnimationId = animationId
		local animationTrack = animator:LoadAnimation(animation)
		
		PunchModule["animationTracks"][i] = animationTrack
	end
end

function PunchModule.playAnimation(player)
	if not PunchModule["animationTracks"]  then
		PunchModule.loadAnimations(player)
	end
	
	local animationTrack = PunchModule["animationTracks"][PunchModule["punchCounter"]]
	animationTrack:Play()
	
	if PunchModule["punchCounter"] < 4  then
		PunchModule["punchCounter"] += 1
	else
		PunchModule["punchCounter"] = 1
	end
end

function PunchModule.usable(player)
	if PlayerActionsModule.IsCooldownComplete(player, PunchModule["id"]) and not PlayerActionsModule.GetPlayerState(player, "inAction") then
		PlayerActionsModule.StartCooldown(player, PunchModule.id, PunchModule.cooldown)
		return true
	end

	return false
end

-- returns humanoid hit by the punch
function PunchModule.getHitHumanoid(player)
	local character = player.Character or player.CharacterAdded:Wait()
	local rayDirection = character.HumanoidRootPart.CFrame.lookVector
	local rayOrigin = character.HumanoidRootPart.CFrame.Position + rayDirection

	local raycastResult = workspace:Raycast(rayOrigin, rayDirection * 3)

	-- Create a thin box to visualize the ray
	local rayVisualization = Instance.new("Part")
	rayVisualization.Size = Vector3.new(0.2, 0.2, (rayDirection * 3).Magnitude) -- Thin and stretched
	rayVisualization.CFrame = CFrame.new(rayOrigin + rayDirection * 1.5, rayOrigin) -- Positioned in the middle of the ray
	rayVisualization.Anchored = true
	rayVisualization.CanCollide = false
	rayVisualization.Color = Color3.new(1, 0, 0) -- Red color for visibility
	rayVisualization.Parent = workspace
	
	if raycastResult then
		local hit = raycastResult.Instance
		if hit and hit:IsDescendantOf(workspace) then
			local hitHumanoid = hit.Parent:FindFirstChildWhichIsA("Humanoid")
			if hitHumanoid and hitHumanoid ~= character:FindFirstChildWhichIsA("Humanoid") then
				return hitHumanoid
			end
		end
	end
	
	return nil
end

function PunchModule.execute(player)
	if not player then return end

	PlayerActionsModule.SetPlayerState(player, "inAction", true)
	
	local hitHumanoid = PunchModule.getHitHumanoid(player)
	
	if not hitHumanoid or not hitHumanoid:IsA("Humanoid") then
		wait(PunchModule["cooldown"])
		PlayerActionsModule.SetPlayerState(player, "inAction", false)
		return
	end

	local character = hitHumanoid.Parent
	local hitPlayer = Players:GetPlayerFromCharacter(character)
	
	PlayerStatisticsModule.DealPhysicalDamage(hitPlayer, hitHumanoid, getDmg(player))
	
	wait(PunchModule["cooldown"])
	PlayerActionsModule.SetPlayerState(player, "inAction", false)
end

return PunchModule
