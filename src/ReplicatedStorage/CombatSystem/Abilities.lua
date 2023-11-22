local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AttackAbilities = ReplicatedStorage.CombatSystem.AttackAbilities
local UtilityAbilities = ReplicatedStorage.CombatSystem.UtilityAbilities

local PunchModule = require(AttackAbilities:WaitForChild("Punch"))
local QuickStrikeModule = require(AttackAbilities:WaitForChild("QuickStrike"))

local CEAccelerationModule = require(UtilityAbilities:WaitForChild("CEAcceleration"))
local DashModule = require(UtilityAbilities:WaitForChild("Dash"))
local GuardModule = require(UtilityAbilities:WaitForChild("Guard"))

local Abilities = {
	punch = PunchModule,
	quickstrike = QuickStrikeModule,
	ceacceleration = CEAccelerationModule,
	dash = DashModule,
	guard = GuardModule,
}

return Abilities
