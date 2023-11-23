local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

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
	[Enum.KeyCode.LeftControl] = dashModule,
	[Enum.KeyCode.F] = guardModule,
	[Enum.KeyCode.C] = ceAccelerationModule,
}

local function onInputBegan(input, gameProcessed)
	if gameProcessed then return end

	local abilityModule = keyToAbility[input.KeyCode] or keyToAbility[input.UserInputType]
	if not abilityModule or not abilityModule.usable(LocalPlayer) then return end
	
	if ValidateAbilityAction:InvokeServer(abilityModule.id) then
		return
	end
end

UserInputService.InputBegan:Connect(onInputBegan)