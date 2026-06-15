local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local SharedModules = ReplicatedStorage.Modules.Shared

local WeaponTypesAssets = require(SharedModules.Info.WeaponTypesAssets)
local Network = require(ReplicatedStorage.Modules.Shared.Network.Network)
local Pocket = require(SharedModules.Pocket)
local HelperFunctions = require(SharedModules.HelperFunctions)

local Run = {}
local Connections = {}

local RunNetwork = {
	module = "RunServer",
	method = "main",
	msg = "run",
	animLength = 0
}

local StopRunNetwork = {
	module = "RunServer",
	method = "main",
	msg = "stop",
	animLength = 0
}

local runAnim
local currentType

function Run.begin(character)
	local humanoid = character.Humanoid
	local speed = 1
	
	Connections["Run"] = RunService.RenderStepped:Connect(function()
		if not character:GetAttribute("canRun") then
			if runAnim and runAnim.IsPlaying then
				runAnim:Stop()
			end
			return
		end
		
		local moveDir = humanoid.MoveDirection.Magnitude
		
		if moveDir <= 0 and runAnim and runAnim.IsPlaying then
			Run.stop(character)
		end
		
		if humanoid.FloorMaterial == Enum.Material.Air then
			if runAnim and runAnim.IsPlaying then	
				if 0.2 < math.round(runAnim.speed) then
					runAnim:AdjustSpeed(0.2)
				end
			end
		else
			if runAnim and speed ~= math.round(runAnim.speed) then
				runAnim:AdjustSpeed(speed)
			end
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.W) and not character:GetAttribute("state"):match("running") and moveDir > 0 then
			local weaponType = character:GetAttribute("weapon")
			local anim = WeaponTypesAssets[weaponType].Anims.Run
			
			if runAnim and runAnim.IsPlaying and currentType:match("weaponType") then
				return
			end
			
			if runAnim and runAnim.IsPlaying then
				runAnim:Stop()
			end
			
			runAnim = HelperFunctions.playAnim(character, anim, true)
			currentType = weaponType
			
			Network.Fire(RunNetwork, "Core")
		end

	end)
end

function Run.stop(character)
	if Connections["Run"] then
		Connections["Run"]:Disconnect()
		Connections["Run"] = nil
		
		if runAnim and runAnim.IsPlaying then
			runAnim:Stop()
		end
		Network.Fire(StopRunNetwork, "Core")
	end
end

return Run