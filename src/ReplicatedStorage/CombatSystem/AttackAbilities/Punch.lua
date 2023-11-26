local PunchModule = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local PlayerDataModule = require(ReplicatedStorage.PlayerData.PlayerDataModule)
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
	return 20 + PlayerDataModule.GetPlayerStatistic(player, "strength")
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
	print(PlayerDataModule.GetPlayerStatistic(player, PlayerDataModule.DEFENSE_KEY_NAME))
	local inAction = PlayerDataModule.GetPlayerState(player, "inAction")
	if inAction then
		return false
	end

	if PlayerDataModule.IsCooldownComplete(player, PunchModule["id"]) and not PlayerDataModule.GetPlayerState(player, "inAction") then
		PlayerDataModule.StartCooldown(player, PunchModule.id, PunchModule.cooldown)
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
	
	if raycastResult then
		local hit = raycastResult.Instance
		if hit and hit:IsDescendantOf(workspace) then
			local hitHumanoid = hit.Parent:FindFirstChildWhichIsA("Humanoid")
			if hitHumanoid and hitHumanoid ~= character:FindFirstChildWhichIsA("Humanoid") then
				print("HIT PLAYER")
				return hitHumanoid
			end
		end
	end
	
	print("NO HIT")
	return nil
end

function PunchModule.executeClient(player)
	if not player then return end

	PlayerDataModule.SetPlayerState(player, "inAction", true)
	
	wait(PunchModule["cooldown"])
	PlayerDataModule.SetPlayerState(player, "inAction", false)
end

function PunchModule.execute(player)
	print("PUNCH")
	if not player then return end

	PlayerDataModule.SetPlayerState(player, "inAction", true)
	
	local hitHumanoid = PunchModule.getHitHumanoid(player)
	print("HIT HUMANOID: " .. tostring(hitHumanoid))
	
	if hitHumanoid and hitHumanoid:IsA("Humanoid") then
		local character = hitHumanoid.Parent
		local hitPlayer = Players:GetPlayerFromCharacter(character)
		if hitPlayer then
			PlayerDataModule.DealPhysicalDamage(hitPlayer, getDmg(player))
		else
			print("HIT NPC")
			local EnemyModule = require(character.EnemyModule)
			EnemyModule.DealPhysicalDamage(hitHumanoid, getDmg(player))
		end
	end
	
	task.spawn(function()
		task.wait(0.5)
		PlayerDataModule.SetPlayerState(player, "inAction", false)
	end)
end

return PunchModule
