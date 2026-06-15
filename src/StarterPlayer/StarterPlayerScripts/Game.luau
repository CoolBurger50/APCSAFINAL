local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = ReplicatedStorage.Modules
local SharedModules = Modules.Shared
local Packets = require(SharedModules.Network.Packets)
local HelperFunctions = require(SharedModules.HelperFunctions)

local ShiftLockContol = script.Parent:WaitForChild("PlayerModule"):WaitForChild("CameraModule"):WaitForChild("MouseLockController")
ShiftLockContol:WaitForChild("BoundKeys").Value = "LeftAlt"

local player = game.Players.LocalPlayer

local function setupCharacter(character)
	local function updateHighlight(attribute)
		local highlight = character:FindFirstChild(attribute)

		if character:GetAttribute(attribute) then
			if not highlight then
				highlight = Instance.new("Highlight")
				highlight.Name = attribute
				highlight.OutlineColor = Color3.new(1, 1, 1)
				highlight.FillTransparency = 1
				highlight.OutlineTransparency = 0.3
				highlight.DepthMode = Enum.HighlightDepthMode.Occluded
				highlight.Parent = character
			end

			highlight.Enabled = true
		elseif highlight then
			highlight:Destroy()
		end
	end

	updateHighlight("iframes")

	character:GetAttributeChangedSignal("iframes"):Connect(function()
		updateHighlight("iframes")
	end)
	
	character:GetAttributeChangedSignal("parry"):Connect(function()
		updateHighlight("parry")
	end)
end

if player.Character then
	setupCharacter(player.Character)
end

Packets.cancelAnimation.OnClientEvent:Connect(function()
	HelperFunctions.stopAll(game.Players.LocalPlayer.Character)
end)

player.CharacterAdded:Connect(setupCharacter)