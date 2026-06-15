local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local WeaponController = require(Modules.Controllers.WeaponController)
local SharedModules = Modules.Shared
local Remotes = ReplicatedStorage.Remotes

local Packets = require(SharedModules.Network.Packets)

local GameManager = require(SharedModules.GameManager)
GameManager.new()


Packets.SetAttribute.OnServerEvent:Connect(function(Player : Player, Attribute : string, Value : any)
	local Character = Player.Character or Player.CharacterAdded:Wait()
	Character:SetAttribute(Attribute, Value)
end)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage:WaitForChild("Modules")

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		character:WaitForChild("Right Arm")
		WeaponController:WeldUnEquip(character:GetAttribute("weapon"), character)
	end)
end)