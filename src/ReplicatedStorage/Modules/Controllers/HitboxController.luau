--! strict

local Hitbox = {}
Hitbox.__index = Hitbox

export type Hitbox = typeof(setmetatable(
	{} :: {
		size : Vector3;
		part : BasePart;
		cframe : CFrame;
		filter : {},
		hitChars : {}
	},
	Hitbox
))

function Hitbox.new(params : {})
	local self = {
		size = params.size or Vector3.new(7, 5,7),
		part = params.part,
		cframe = params.cframe,
		filter = params.filter,
		display = params.display or false,
		hitChars = {}
	}
	
	setmetatable(self, Hitbox)
	
	self:_main()
	
	return self
end

function Hitbox:_main()
	self.overlapParams = OverlapParams.new()
	self.overlapParams.FilterType = Enum.RaycastFilterType.Exclude
	self.overlapParams.FilterDescendantsInstances = self.filter
end

function Hitbox:start()
	self.hits = workspace:GetPartBoundsInBox(self.cframe , self.size, self.overlapParams)
	
	for _, hit in self.hits do
		if table.find(self.hitChars, hit.Parent) or 
			not hit.Parent:FindFirstChildWhichIsA("Humanoid") then
			continue
		end
		
		local character = hit.Parent
		
		if character:GetAttribute("iframes") then
			continue
		end
		
		table.insert(self.hitChars, character)
	end
	
	if self.display then
		require(script.Show)(self.cframe, self.size)
	end
	
	return self.hitChars
end

return Hitbox