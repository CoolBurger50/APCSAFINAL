local StateManager = require(script.Parent.StateManager)
local StunManager = {}

function StunManager.stun(victim, duration)
	local stateObject = StateManager.new(victim)

	if stateObject:get() == "stunned" then return end

	victim:SetAttribute("lastHit", os.clock())
	stateObject:set("stunned", true)

	task.spawn(function()
		while (os.clock() - victim:GetAttribute("lastHit")) < duration do
			task.wait()
		end
		stateObject:neutralize("stunned")
	end)
end

return StunManager