local Pocket = {}
Pocket.__index = Pocket

export type Pocket = typeof(setmetatable(
	{} :: {
		_items: { any },
	},
	Pocket
))

function Pocket.new(): Pocket
	local self = setmetatable({}, Pocket)
	
	self._items = {}

	return self
end

function Pocket.add<T>(self: Pocket, item: T): T
	table.insert(self._items, item)

	return item
end

function Pocket.destroy(self: Pocket)
	for _, item in self._items do
		if typeof(item) == "function" then
			item()
		elseif typeof(item) == "thread" then
			task.cancel(item)
		elseif typeof(item) == "RBXScriptConnection" then
			item:Disconnect()
		elseif typeof(item) == "Instance" then
			item:Destroy()
		elseif typeof(item) == "table" then
			(item :: any):destroy()
		end
	end

	table.clear(self._items)
end

return Pocket