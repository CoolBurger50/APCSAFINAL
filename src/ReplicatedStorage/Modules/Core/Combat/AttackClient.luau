local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunSerice = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Player = game:GetService("Players").LocalPlayer
local CharacterModel = Player.Character or Player.CharacterAdded:Wait()

local Modules = ReplicatedStorage.Modules
local Shared = Modules.Shared

local Assets = ReplicatedStorage.Assets
local Animations = Assets.Animations

local WeaponTypeAssets = require(Shared.Info.WeaponTypesAssets)
local HelperFunctions = require(Shared.HelperFunctions)
local Network = require(Shared.Network.Network)
local Packets = require(Shared.Network.Packets)
local HitboxController = require(Modules.Controllers.HitboxController)


local AttackClient = {}
local connections = {}

function AttackClient.attack(character)
	local player = game.Players:GetPlayerFromCharacter(character)
	local rootPart = character.HumanoidRootPart

	local combo = character:GetAttribute("combo")
	local weaponType = character:GetAttribute("weapon")

	local animAddress = WeaponTypeAssets[weaponType].Anims["M"..combo]

	HelperFunctions.stopAll(character)

	local attackAnim= HelperFunctions.playAnim(character, animAddress, true)
	attackAnim.Priority = Enum.AnimationPriority.Action4
	
	local LogicData = {module = "AttackServer", 
		method = "logic", msg = "", animLength = attackAnim.Length}

	Network.Fire(LogicData, "Core", player)

	local params = {
		part = rootPart,
		cframe = rootPart.CFrame * CFrame.new(0,0,-3) + rootPart.AssemblyLinearVelocity * 0.1,
		filter = {character}
	}

	local hitbox = HitboxController.new(params)
	
	hitbox.display = character:GetAttribute("showhitboxes")

	local hitWindow = attackAnim.Length / 2

	task.delay(hitWindow, function()
		local hits = hitbox:start()

		Network.Fire({
			module = "AttackServer",method = "main",msg = "",
			hits = hits
		}, "Hitbox", player)
	end)
end

function AttackClient.parry(character, character2, animLengh)
	if connections["parry"] then
		connections["parry"]:Disconnect()
	end

	local rootPart = character.HumanoidRootPart

	connections["parry"] = RunSerice.PostSimulation:Connect(function()
		HelperFunctions.velocity(rootPart, rootPart.CFrame.LookVector * 20, 0.000001, true).MaxAxesForce = Vector3.new(55555,0,55555)
	end)

	task.delay(animLengh, function()
		local BlockData = {module = "BlockServer", 
			method = "parryStop", msg = "begin", animLength = 0}

		Network.Fire(BlockData, "Core", game.Players:GetPlayerFromCharacter(character))

		if connections["parry"] then
			connections["parry"]:Disconnect()
		end
	end)
end

CharacterModel:GetAttributeChangedSignal("canfeint"):Connect(function()
	if not CharacterModel:GetAttribute("canfeint") then return end
	if CharacterModel:GetAttribute("feinted") then return end
	UserInputService.InputEnded:Connect(function(input, isTyping)
		if isTyping then return end

		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			Packets.FeintServer:Fire()
		end
	end)
end)

function AttackClient.playSFX(character, sfx)
	
end

return AttackClient