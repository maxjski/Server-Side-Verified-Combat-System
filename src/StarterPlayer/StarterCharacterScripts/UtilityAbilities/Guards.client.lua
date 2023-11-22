local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local updatePlayerStateEvent = ReplicatedStorage:WaitForChild("UpdatePlayerState")
local getPlayerStateFunction = ReplicatedStorage:WaitForChild("GetPlayerState")
local getPlayerConfigFunction = ReplicatedStorage:WaitForChild("GetPlayerConfig")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Ensure that the character's humanoid contains an "Animator" object
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:WaitForChild("Animator")

-- Get Guard Animation
local Gaurd = Instance.new("Animation")
Gaurd.AnimationId = "rbxassetid://15404481198"


local UserInputService = game:GetService("UserInputService")

local guardAnimationTrack = animator:LoadAnimation(Gaurd)

local isGuarding = false
updatePlayerStateEvent:FireServer("isGuarding", isGuarding)

local function startGuard()
	
	if getPlayerStateFunction:InvokeServer("isPoweringUp") then
		return
	end
	
	humanoid.WalkSpeed = 2
	if not isGuarding then
		isGuarding = true
		updatePlayerStateEvent:FireServer("isGuarding", isGuarding)
		guardAnimationTrack:Play()
	end
end

local function stopGuard()
	if getPlayerStateFunction:InvokeServer("isSprinting") then
		humanoid.WalkSpeed = getPlayerConfigFunction:InvokeServer("sprintingSpeed")
	else
		humanoid.WalkSpeed = getPlayerConfigFunction:InvokeServer("normalSpeed")
	end
	
	if isGuarding then
		isGuarding = false
		updatePlayerStateEvent:FireServer("isGuarding", isGuarding)
		guardAnimationTrack:Stop() -- or adjust as needed to stop the guard action
	end
end

local function onInputBegan(input, gameProcessed)
	if input.KeyCode == Enum.KeyCode.F and not gameProcessed then
		startGuard()
	end
end

local function onInputEnded(input, gameProcessed)
	if input.KeyCode == Enum.KeyCode.F and not gameProcessed then
		stopGuard()
	end
end

UserInputService.InputBegan:Connect(onInputBegan)
UserInputService.InputEnded:Connect(onInputEnded)
