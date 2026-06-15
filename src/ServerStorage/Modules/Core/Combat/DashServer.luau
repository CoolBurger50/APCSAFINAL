local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Network = require(ReplicatedStorage.Modules.Shared.Network.Network)
local StateManager = require(ServerStorage.Modules.Managers.StateManager)

local DashServer = {}

function DashServer.main(player, direction, animLength)
	local character = player.Character
	
	local stateObject = StateManager.new(character)
	
	stateObject:set("dashing", true)
	
	task.delay(animLength - (animLength* 1/3), function()
		stateObject:neutralize("dashing")
	end)
end

return DashServer