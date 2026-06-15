local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Network = require(ReplicatedStorage.Modules.Shared.Network.Network)

local SharedModules = ReplicatedStorage.Modules.Shared

local HelperFunctions = require(SharedModules.HelperFunctions)
local WeaponTypesAnims = require(SharedModules.Info.WeaponTypesAssets)

local Packets = require(SharedModules.Network.Packets)

local Animations = ReplicatedStorage.Assets.Animations
local MovementAnimations = Animations.Movement

local camera = workspace.CurrentCamera

local DashDirections = {
	Front = Vector3.new(0,0,-1),
	Back = Vector3.new(0,0,1.3),
	Right = Vector3.new(1,0,0),
	Left = Vector3.new(-1,0,0),
}

local DashClient = {}

local function faceFoward(rootPart)
	task.spawn(function()
		for i = 0, .5/0.01 do
			rootPart.CFrame = CFrame.lookAt(
				rootPart.Position, 
				rootPart.Position + (camera.CFrame.LookVector * Vector3.new(1,0,1)))
			task.wait()
		end
	end)
end

function DashClient.dash(character, direction)
	local rootPart = character.HumanoidRootPart

	character:GetAttributeChangedSignal("state"):Connect(function()
		
		if character:GetAttribute("state") == "dashing" then
			UserInputService.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton2 then
					if character:GetAttribute("state") ~= "dashing" then return end
					if character:GetAttribute("cancelRolled") then return end	
					character:SetAttribute("cancelRolled", true)
					HelperFunctions.stopAll(character)
					local loadedAnim = HelperFunctions.playAnim(character, MovementAnimations.DashCancel, true)
					loadedAnim.Priority = Enum.AnimationPriority.Action3
					loadedAnim:AdjustSpeed(loadedAnim.Length * 3)
					
					HelperFunctions.dampVelocity(rootPart, 0.4)
					task.delay(3, function()
						character:SetAttribute("cancelRolled", false)
					end)
					return
				end
			end)
				
		end
	end)
	
	HelperFunctions.clearVelocity(rootPart)
	
	local force = direction == "Back" and 25 or 40 
	
	local velocity = DashDirections[direction] * force
	local weaponType = character:GetAttribute("weapon")
	Packets.SetAttribute:Fire("iframes", true)

	task.delay(.4, function()
		Packets.SetAttribute:Fire("iframes", false)
	end)
	local debrisTime = 0.5
	
	local MaxForce = Vector3.new(55555,0,55555)
	
	faceFoward(character.HumanoidRootPart)
	
	local dashAnim = WeaponTypesAnims[weaponType].Anims[direction.."Dash"]
	
	local loadedAnim = HelperFunctions.playAnim(character, dashAnim, true)
	loadedAnim:AdjustSpeed(loadedAnim.Length * 2)
	
	loadedAnim.Priority = Enum.AnimationPriority.Action4
	
	HelperFunctions.dashVelocity(rootPart, velocity, debrisTime, MaxForce)
	
	Network.Fire({module = "DashServer", 
		method = "main", 
		msg = direction, animLength = loadedAnim.Length}, "Core")
end

return DashClient