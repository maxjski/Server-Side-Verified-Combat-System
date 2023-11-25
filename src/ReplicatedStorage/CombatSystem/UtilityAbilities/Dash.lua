local dashModule = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerActionsModule = require(ReplicatedStorage.PlayerData.PlayerActionsModule)
local animationIds = require(ReplicatedStorage.PlayerData.AnimationIDs)

dashModule["id"] = "dash"
dashModule["animationId"] = animationIds.FDash
dashModule["energyCost"] = 10
dashModule["cooldown"] = 0.5

function dashModule.playAnimation(player)
    local humanoid = player.Character:WaitForChild("Humanoid")
    local animator = humanoid:WaitForChild("Animator")
    
    local abilityAnimation = Instance.new("Animation")
    abilityAnimation.AnimationId = dashModule.animationId
    local animationTrack = animator:LoadAnimation(abilityAnimation)
    animationTrack:Play()
end

function dashModule.usable(player)
	if PlayerActionsModule.IsCooldownComplete(player, dashModule.id) then
		PlayerActionsModule.StartCooldown(player, dashModule.id, dashModule.cooldown)
		return PlayerActionsModule.GetPlayerState(player, "inAction") == false
	end
	
	return false
end

function dashModule.executeClien(player)
    if not player  then	return end
    PlayerActionsModule.SetPlayerState(player, "inAction", true)

    task.spawn(function()
        task.wait(dashModule["cooldown"])
        PlayerActionsModule.SetPlayerState(player, "inAction", false)
    end)
end

function dashModule.execute(player)
    PlayerActionsModule.SetPlayerState(player, "inAction", true)
	local root = player.Character:FindFirstChild("HumanoidRootPart")

    local i = Instance.new('BodyPosition')
    i.MaxForce = Vector3.new(100000, 0, 100000) -- y-component is 0 because we don't want them to fly
    i.P = 100000
    i.D = 2000
    i.Position = (root.CFrame*CFrame.new(0, 0, -30)).Position --get 20 units in front of the player
    i.Parent = root
    task.spawn(function()
        task.wait(dashModule["cooldown"])
        PlayerActionsModule.SetPlayerState(player, "inAction", false)
        i:Destroy()
    end)
end

return dashModule
