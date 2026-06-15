local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local StateManager = require(ServerStorage.Modules.Managers.StateManager)

local RunServer = {}

RunServer.funcs = {
	run = function(stateObject)
		if stateObject:get() == "running" then return end

		stateObject:set("running", true)
	end,
	
	stop = function(stateObject)
		stateObject:neutralize("running")
	end,
}

function RunServer.main(player : Player, msg)
	local stateObject = StateManager.new(player.Character)
	
	RunServer.funcs[msg](stateObject)
end

return RunServer