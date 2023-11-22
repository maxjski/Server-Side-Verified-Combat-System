local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:WaitForChild("Animator")

local ValidateAbilityAction = ReplicatedStorage.NetworkCommunication.RemoteFunctions:WaitForChild("ValidateAbilityAction")

local attackAbilities = ReplicatedStorage.CombatSystem.AttackAbilities
local utilityAbilities = ReplicatedStorage.CombatSystem.UtilityAbilities

local QuickStrikeModule = require(attackAbilities:WaitForChild("QuickStrike"))
local PunchModule = require(attackAbilities:WaitForChild("Punch"))
local dashModule = require(utilityAbilities:WaitForChild("Dash"))
local ceAccelerationModule = require(utilityAbilities:WaitForChild("CEAcceleration"))
local guardModule = require(utilityAbilities:WaitForChild("Guard"))

local keyToAbility = {
	[Enum.UserInputType.MouseButton1] = PunchModule,
	[Enum.KeyCode.Q] = QuickStrikeModule,
	[Enum.KeyCode.W] = dashModule,
	[Enum.KeyCode.A] = dashModule,
	[Enum.KeyCode.D] = dashModule,
	[Enum.KeyCode.F] = guardModule,
	[Enum.KeyCode.LeftControl] = ceAccelerationModule,
}

local doublePressTimeWindow = 0.25
local lastKeyPressTime = {}

local function isDoublePress(keyCode)
	local currentTime = tick()
	if not lastKeyPressTime[keyCode] then
		lastKeyPressTime[keyCode] = currentTime
		return false
	end

	local timeSinceLastPress = currentTime - lastKeyPressTime[keyCode]
	lastKeyPressTime[keyCode] = currentTime

	return timeSinceLastPress <= doublePressTimeWindow
end


local function onInputBegan(input, gameProcessed)
	if gameProcessed then return end

	local abilityModule = keyToAbility[input.KeyCode] or keyToAbility[input.UserInputType]
	if not abilityModule or not abilityModule.usable(LocalPlayer) then return end
	
	if not abilityModule.doublePress then
		if ValidateAbilityAction:InvokeServer(abilityModule.id) then
			return
		end
		return
	end
	
	if isDoublePress(input.KeyCode) then
		if ValidateAbilityAction:InvokeServer(abilityModule.id) then
			return
		end
		return
	end
end

UserInputService.InputBegan:Connect(onInputBegan)