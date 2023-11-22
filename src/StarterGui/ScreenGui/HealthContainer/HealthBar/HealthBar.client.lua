local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- Paste script into a LocalScript that is
-- parented to a Frame within a Frame
local frame = script.Parent
local container = frame.Parent
container.BackgroundColor3 = Color3.new(0, 0, 0) -- black

-- This function is called when the humanoid's health changes
local function onHealthChanged()
	local human = player.Character.Humanoid
	local percent = human.Health / human.MaxHealth
	-- Change the size of the inner bar
	frame.Size = UDim2.new(percent, 0, 1, 0)
	-- Change the color of the health bar
	if percent < 0.1 then
		frame.BackgroundColor3 = Color3.new(1, 0, 0) -- black
	elseif percent < 0.4 then
		frame.BackgroundColor3 = Color3.new(1, 0, 0) -- yellow
	else
		frame.BackgroundColor3 = Color3.new(1, 0, 0) -- green
	end
end

-- This function runs is called the player spawns in
local function onCharacterAdded(character)
	local human = character:WaitForChild("Humanoid")
	-- Pattern: update once now, then any time the health changes
	human.HealthChanged:Connect(onHealthChanged)
	onHealthChanged()
end

-- Connect our spawn listener; call it if already spawned
player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then
	onCharacterAdded(player.Character)
end