local CooldownManager = {}
CooldownManager.Cooldowns = {}

function CooldownManager.Set(key: string, duration: number)
	if not CooldownManager.Cooldowns[key] then
		CooldownManager.Cooldowns[key] = false
	end

	CooldownManager.Cooldowns[key] = true

	task.delay(duration, function()
		CooldownManager.Cooldowns[key] = false
	end)
end

function CooldownManager.Check(key: string)
	return CooldownManager.Cooldowns[key] or false
end

function CooldownManager.GetCooldowns()
	return CooldownManager.Cooldowns
end

return CooldownManager