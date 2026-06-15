local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HelperFunctions = {}

function HelperFunctions.playAnim(Character, Anim, ShouldReturn)
	local Humanoid = Character.Humanoid
	local Animator = Humanoid.Animator

	local LoadedAnim = Animator:LoadAnimation(Anim)

	LoadedAnim:Play()


	if ShouldReturn then
		return LoadedAnim
	end
end

function HelperFunctions.stopAll(character)
	local humanoid = character.Humanoid
	local animator = humanoid.Animator
	
	for _, anim in animator:GetPlayingAnimationTracks() do
		if anim.Name == "Animation1" or anim.Name == "Animation2"  or anim.Name == "WalkAnim" then
			continue
		end
		
		anim:Stop()
	end
end

function HelperFunctions.dashVelocity(part, velocity, debrisTime, maxForce)
	local linearVelocity = Instance.new("LinearVelocity")
	local attachment = Instance.new("Attachment")
	attachment.Parent = part

	linearVelocity.ForceLimitsEnabled = true
	linearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
	linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.Attachment0
	linearVelocity.ForceLimitMode = Enum.ForceLimitMode.PerAxis
	linearVelocity.MaxAxesForce = maxForce or Vector3.new(99999,0, 99999) 

	attachment.WorldPosition = part.AssemblyCenterOfMass

	linearVelocity.Attachment0 = attachment
	linearVelocity.Parent = attachment
	linearVelocity.VectorVelocity = velocity

	game.Debris:AddItem(linearVelocity, debrisTime)
end

function HelperFunctions.dampVelocity(part, dampFacto)
	dampFactor = dampFactor or 0.4 
	local velocityToModify = part:FindFirstChild("BodyVelocity", true) 
		or part:FindFirstChild("LinearVelocity", true)
	if velocityToModify then
		if velocityToModify:IsA("BodyVelocity") then
			velocityToModify.Velocity = velocityToModify.Velocity * dampFactor
		elseif velocityToModify:IsA("LinearVelocity") then
			velocityToModify.VectorVelocity = velocityToModify.VectorVelocity * dampFactor
		end
	end
end

function HelperFunctions.clearVelocity(part, exception) 
	local velocityToDestroy = part:FindFirstChild("BodyVelocity", true) 
		or part:FindFirstChild("LinearVelocity", true)
	if velocityToDestroy then
		if exception and velocityToDestroy.Name:match(exception) then
			return
		end
		velocityToDestroy:Destroy()
	end
end

function HelperFunctions.velocity(Part, Velocity, Debris, ReturnVelocity, name)
	local LinearVelocity = Instance.new("LinearVelocity")
	LinearVelocity.Name = name or "LinearVelocity"
	
	LinearVelocity.ForceLimitMode = Enum.ForceLimitMode.PerAxis
	LinearVelocity.MaxAxesForce = Vector3.new(99999,99999,99999)
	LinearVelocity.VectorVelocity = Velocity
	LinearVelocity.Parent = Part
	LinearVelocity.Attachment0 = Part:FindFirstChild("Attachment") or Instance.new("Attachment", Part)
	
	game.Debris:AddItem(LinearVelocity, Debris)
	if ReturnVelocity then
		return LinearVelocity
	end
end

return HelperFunctions