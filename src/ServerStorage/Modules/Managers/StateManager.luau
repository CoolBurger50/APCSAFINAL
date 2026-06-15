local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Pocket = require(ReplicatedStorage.Modules.Shared.Pocket)
local StatePaths = require(script.StatePaths)

local StateManager = {}
local cache = {}

local function setValues(stateValues : {}, excluded : {}, character : Model)
	for attribute, value in stateValues do
		if excluded[attribute] then
			continue
		end

		character:SetAttribute(attribute, value)
	end
end

StateManager.__index = StateManager

export type StateManager = typeof(setmetatable(
	{} :: {
		character : Model,
		_paths : {},
		_pocket : Pocket.Pocket,
		_excluded : {}
	},
	StateManager))

function StateManager.new(character, new)
	if cache[character] and not new then 
		return cache[character]
	end

	local self = setmetatable({}, StateManager)

	self.character = character
	self._paths = StatePaths
	self._pocket = Pocket.new()
	self._excluded = {
		walkSpeed = "walkSpeed",
		jumpHeight = "jumpHeight",
		jumpPower = "jumpPower",
		priority = "priority"
	}

	self:handleStates()

	cache[character] = self

	return self
end

function StateManager:modify(path, attribute, value)
	self._paths[path][attribute] = value
end

function StateManager:handleStates()
	local humanoid : Humanoid = self.character:WaitForChild("Humanoid")
	self.character:SetAttribute("state", "neutral")

	local function handleStates()
		local currentState = self.character:GetAttribute("state")
		for state, values in self._paths do
			if currentState ~= state then
				continue
			end

			self.character:SetAttribute("state", state)
			setValues(values, self._excluded, self.character)
		end
	end

	handleStates()

	self._pocket:add(self.character:GetAttributeChangedSignal("state"):Connect(handleStates))

	humanoid.Died:Once(function()
		self:cleanup()
	end)
end

function StateManager:neutralize(currentState)
	local humanoid : Humanoid = self.character:WaitForChild("Humanoid")
	local state = self.character:GetAttribute("state")
	--warn(state)
	if state ~= currentState then
		return
	end

	self.character:SetAttribute("state", "neutral")
	humanoid.WalkSpeed = self._paths.neutral.walkSpeed
	humanoid.JumpHeight = self._paths.neutral.jumpHeight
	humanoid.JumpPower = self._paths.neutral.jumpPower

end

function StateManager:set(state : string, value : boolean, forcePrioritize : boolean)
	local currentState = self.character:GetAttribute("state")

	local function setState()
		self.character:SetAttribute("state", state)

		local humanoid : Humanoid = self.character:WaitForChild("Humanoid")

		if self._paths[state].walkSpeed then
			humanoid.WalkSpeed = self._paths[state].walkSpeed
		end
		if self._paths[state].jumpHeight then
			humanoid.JumpHeight = self._paths[state].jumpHeight
		end
		if self._paths[state].jumpPower then
			humanoid.JumpPower = self._paths[state].jumpPower
		end
	end

	if forcePrioritize and currentState ~= "stunned" and currentState ~= "softStun" and currentState ~= state then
		setState()
		return
	end

	if value and currentState ~= state then
		local success, result = pcall(function()
			return self._paths[state].priority > self._paths[currentState].priority
		end)

		if success and result then
			setState()
		end
	end

end

function StateManager:get()
	return self.character:GetAttribute("state")
end

function StateManager:cleanup() 
	self._pocket:destroy()
end

return StateManager