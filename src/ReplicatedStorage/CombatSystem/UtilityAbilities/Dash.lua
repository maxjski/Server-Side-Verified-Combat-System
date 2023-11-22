local dashModule = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerActionsModule = require(ReplicatedStorage.PlayerData.PlayerActionsModule)
local animationIds = require(ReplicatedStorage.PlayerData.AnimationIDs)

dashModule["id"] = "dash"
dashModule["animationId"] = animationIds.FDash
dashModule["energyCost"] = 10
dashModule["doublePress"] = true
dashModule["cooldown"] = 0.5

function dashModule.usable(player)
	if PlayerActionsModule.IsCooldownComplete(player, "dash") then
		PlayerActionsModule.StartCooldown(player, dashModule.id, dashModule.cooldown)
		return true
	end
	
	return false
end

function dashModule.execute(player)
	print("dashPerformed")
end

return dashModule
