local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ServerModules = ServerStorage.Modules
local ServerManagers = ServerModules.Managers

local StateManager = require(ServerManagers.StateManager)

local CooldownManager = require(ReplicatedStorage.Modules.Shared.Cooldown)

local BlockServer = {}
BlockServer._parryTimers = {}

function BlockServer.main(player, msg)
	local stateObject = StateManager.new(player.Character)
	
	BlockServer[msg](player.Character, stateObject)
end

function BlockServer.begin(character, stateObject)
	local parryTime = 0.3
	character:SetAttribute("parry", true)

	if BlockServer._parryTimers[character] then
		task.cancel(BlockServer._parryTimers[character])
	end

	BlockServer._parryTimers[character] = task.delay(parryTime, function()
		character:SetAttribute("parry", false)
		BlockServer._parryTimers[character] = nil 
	end)

	stateObject:set("blocking", true)
end

function BlockServer.stop(character, stateObject)
	stateObject:neutralize("blocking")
end

return BlockServer