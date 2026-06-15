local ContextActionService = game:GetService("ContextActionService")

local CharacterController = {}
CharacterController.__index = CharacterController

function CharacterController.new(character, inputs)
	local self = setmetatable({}, CharacterController)
	self.character = character
	self.inputs = inputs
	self:bindInputs()
	return self
end

function CharacterController:bindInputs()
	for name, value in self.inputs do
		ContextActionService:BindAction(name, value.Callback, false, value.Keycode)
	end
end

return CharacterController