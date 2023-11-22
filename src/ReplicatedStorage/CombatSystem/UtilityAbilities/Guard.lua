local dashModule = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local animationIds = require(ReplicatedStorage.PlayerData.AnimationIDs)

dashModule["id"] = "guard"
dashModule["animationId"] = animationIds.FDash
dashModule["energyCost"] = 10

function dashModule.usable(player)
	return true
end

return dashModule
