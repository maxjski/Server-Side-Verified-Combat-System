local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- import network communication
local ValidateAbilityAction = ReplicatedStorage.NetworkCommunication.RemoteFunctions:WaitForChild("ValidateAbilityAction")
local ValidateStopAbilityAction = ReplicatedStorage.NetworkCommunication.RemoteFunctions:WaitForChild("ValidateStopAbilityAction")

-- import all ability modules
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
	[Enum.KeyCode.LeftControl] = dashModule,
	[Enum.KeyCode.F] = guardModule,
	[Enum.KeyCode.C] = ceAccelerationModule,
}

local keyToStopAbility = {
	[Enum.KeyCode.F] = guardModule,
}

for _, abilityModule in pairs(keyToAbility) do
	if abilityModule.loadAnimations then
		abilityModule.loadAnimations(LocalPlayer)
	end
end

local function onInputBegan(input, gameProcessed)
	if gameProcessed then return end

	local abilityModule = keyToAbility[input.KeyCode] or keyToAbility[input.UserInputType]
	if not abilityModule or not abilityModule.usable(LocalPlayer) then return end
	
	if abilityModule.playAnimation then
		abilityModule.playAnimation(LocalPlayer)
	end

	if ValidateAbilityAction:InvokeServer(abilityModule.id) then
		return
	end
end

local function onInputEnded(input, gameProcessed)
	if gameProcessed then return end

	local abilityModule = keyToStopAbility[input.KeyCode] or keyToStopAbility[input.UserInputType]
	if not abilityModule or not abilityModule.usable(LocalPlayer) then return end

	if ValidateStopAbilityAction:InvokeServer(abilityModule.id) then
		return
	end
end


UserInputService.InputBegan:Connect(onInputBegan)
UserInputService.InputEnded:Connect(onInputEnded)