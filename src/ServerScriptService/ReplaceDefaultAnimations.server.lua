local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local animationIds = require(ReplicatedStorage.PlayerData.AnimationIDs)

local function onCharacterAdded(character)
	-- Get animator on humanoid
	local humanoid = character:WaitForChild("Humanoid")
	local animator = humanoid:WaitForChild("Animator")

	-- Stop all animation tracks
	for _, playingTrack in animator:GetPlayingAnimationTracks() do
		playingTrack:Stop(0)
	end

	local animateScript = character:WaitForChild("Animate")
	animateScript.run.RunAnim.AnimationId = animationIds["Run"]
	animateScript.walk.WalkAnim.AnimationId = animationIds["Walk"]
	--animateScript.jump.JumpAnim.AnimationId = animationIds["Jump"]
	animateScript.idle.Animation1.AnimationId = animationIds["Idle"]
	animateScript.idle.Animation2.AnimationId = animationIds["Idle"]
	--animateScript.fall.FallAnim.AnimationId = "rbxassetid://"
	--animateScript.swim.Swim.AnimationId = "rbxassetid://"
	--animateScript.swimidle.SwimIdle.AnimationId = "rbxassetid://"
	--animateScript.climb.ClimbAnim.AnimationId = "rbxassetid://"
end

local function onPlayerAdded(player)
	player.CharacterAppearanceLoaded:Connect(onCharacterAdded)
end

Players.PlayerAdded:Connect(onPlayerAdded)