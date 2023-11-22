local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local getPlayerState = ReplicatedStorage:WaitForChild("GetPlayerState")

-- Function to create animations
local function createAnimation(animationId)
	local animation = Instance.new("Animation")
	animation.AnimationId = "rbxassetid://" .. animationId
	return animation
end

-- ANIMATIONS
local animations = {
	[Enum.KeyCode.W] = createAnimation("15396268116"),
	[Enum.KeyCode.D] = createAnimation("15396354051"),
	[Enum.KeyCode.A] = createAnimation("15396440480")
}

-- Tracker Variables
local DOUBLE_PRESS_INTERVAL = 0.2 -- Time in seconds to wait for a double press
local canslide = true
local lastPressTime = {}

local UIS = game:GetService("UserInputService")

local function performDash(keyCode)
	
	if getPlayerState:InvokeServer("isPoweringUp") or getPlayerState:InvokeServer("isGuarding") then
		return
	end
	
	local currentTime = tick()
	if not canslide or currentTime - (lastPressTime[keyCode] or 0) > DOUBLE_PRESS_INTERVAL then
		lastPressTime[keyCode] = currentTime
		return
	end

	-- Double press detected
	canslide = false
	lastPressTime[keyCode] = 0

	local animation = animations[keyCode]
	local direction = keyCode == Enum.KeyCode.W and char.HumanoidRootPart.CFrame.lookVector or
		char.HumanoidRootPart.CFrame.rightVector * (keyCode == Enum.KeyCode.A and -1 or 1)

	local playAnim = char.Humanoid:LoadAnimation(animation)
	playAnim:Play()

	local slide = Instance.new("BodyVelocity")
	slide.MaxForce = Vector3.new(1, 0, 1) * 15000
	slide.Velocity = direction * 100
	slide.Parent = char.HumanoidRootPart
	
	for count = 1, 3 do
		wait(0.1)
		slide.Velocity = slide.Velocity * 0.9
	end
	
	slide:Destroy()
	wait(0.5)
	canslide = true
end

local function dashHandler(input, gameProcessed)
	if gameProcessed or not animations[input.KeyCode] then return end
	performDash(input.KeyCode)
end

UIS.InputBegan:Connect(dashHandler)
