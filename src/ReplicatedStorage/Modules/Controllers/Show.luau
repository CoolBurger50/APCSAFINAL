return function(cframe, size)
	local part = Instance.new("Part") do
		part.Parent = workspace
		part.CFrame = cframe
		part.Size = size
		
		part.CanCollide = false
		part.Transparency = 0.5
		part.Material = Enum.Material.ForceField
		part.BrickColor = BrickColor.new("Bright red")
		part.Anchored = true
		
		game.Debris:AddItem(part, 0.1)
	end
end