local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Players = game:GetService("Players")

local SharedModules = ReplicatedStorage.Modules.Shared
local Managers = ServerStorage.Modules.Managers

local HelperFunctions = require(SharedModules.HelperFunctions)
local DamageManager = {}

local function inFront(attacker, victim)
	local victimRoot = victim.HumanoidRootPart
	local attackerRoot = attacker.HumanoidRootPart

	local lookVector = victimRoot.CFrame.LookVector
	local toAttackerVector = (attackerRoot.Position - victimRoot.Position).Unit
	local angle = math.acos(lookVector:Dot(toAttackerVector))


	return angle < math.pi / 2
end

function DamageManager.canDamage(attacker, victim, blockCallback, parryCallback)
	if victim:GetAttribute("parry") and inFront(attacker, victim) then
		parryCallback()
		
		return false
	end
	if victim:GetAttribute("state") == "blocking" and inFront(attacker, victim) then
		if blockCallback then
			blockCallback()
		end
		return false
	end
	
	if victim:GetAttribute("state") == "ragdolled" or victim.Humanoid.Health == 0 then
		return false
	end
	
	if victim:GetAttribute("iframes") or attacker:GetAttribute("iframes") then
		return false
	end
	
	if victim:GetAttribute("feinted") or attacker:GetAttribute("feinted") then
		return false
	end
	
	return true
end

function DamageManager.damage(attacker, victim, damage)
	local victimHumanoid : Humanoid = victim.Humanoid
	
	victimHumanoid:TakeDamage(math.max(1, damage))
end

return DamageManager