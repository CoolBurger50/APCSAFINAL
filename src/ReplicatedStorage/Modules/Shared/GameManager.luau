local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Managers = ServerStorage.Modules.Managers
local CoreModules = ServerStorage.Modules.Core
local CombatModules = CoreModules.Combat

local StateManager = require(Managers.StateManager)
local Attributes = require(Managers.Attributes)
local Namespace = require(ReplicatedStorage.Modules.Shared.Network.namespace)

local GameManager = {}
GameManager.__index = GameManager

function GameManager.new()
	local self = {}

	setmetatable(self, GameManager)

	self:main()

	return self
end

function GameManager:main()
	self:network()

	Players.PlayerAdded:Connect(function(player)
		self:onPlayerAdded(player)
	end)
end

function GameManager:onPlayerAdded(player : Player)
	player.CharacterAdded:Connect(function(character)
		self:onCharacterAdded(character)
	end)
end

function GameManager:onCharacterAdded(character :Model)
	local humanoid : Humanoid = character.Humanoid

	task.spawn(function()
		for attribute, value in Attributes do
			character:SetAttribute(attribute, value)
		end
	end)

	StateManager.new(character, true)
end

function GameManager:network()
	local function getModule(data, player)
		local targetModule = CombatModules[data.module]

		local module = require(targetModule)

		return module
	end
	
	Namespace.Core.listen(function(data, player)
		local module = getModule(data, player)
		module[data.method](player, data.msg, data.animLength)
	end)

	Namespace.Hitbox.listen(function(data, player)
		local module = getModule(data, player)
		module[data.method](player, data.msg, data.hits)
	end)
end

return GameManager