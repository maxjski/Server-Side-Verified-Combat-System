local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ValidateAbilityAction = ReplicatedStorage.NetworkCommunication.RemoteFunctions:WaitForChild("ValidateAbilityAction")
local Abilities = require(ReplicatedStorage.CombatSystem.Abilities)

local function validateAbilityActionHandler(player, abilityId)
	if not abilityId or not player or not Abilities[abilityId] then
		return
	end
	
	local abilityModule = Abilities[abilityId]
	
	if abilityModule.usable(player) then
		abilityModule.execute(player)
	end
	
	return false
end

ValidateAbilityAction.OnServerInvoke = validateAbilityActionHandler