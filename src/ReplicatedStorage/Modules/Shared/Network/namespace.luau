local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.Modules.Shared

local ByteNet = require(Shared.ByteNet)

return ByteNet.defineNamespace("Network", function()
	return {
		Core = ByteNet.definePacket({
			value = ByteNet.struct({
				module = ByteNet.string,
				method = ByteNet.string,
				msg = ByteNet.string,
				animLength = ByteNet.float32
			})
		}),
		
		Hitbox = ByteNet.definePacket({
			value = ByteNet.struct({
				module = ByteNet.string,
				method = ByteNet.string,
				msg = ByteNet.string,
				hits = ByteNet.array(ByteNet.inst)
			})
		}),
		
		Client = ByteNet.definePacket({
			value = ByteNet.struct({
				module = ByteNet.string,
				method = ByteNet.string,
				msg = ByteNet.string,
				animLength = ByteNet.float32,
				character = ByteNet.inst
			})
		}),
		
		ComboClient = ByteNet.definePacket({
			value = ByteNet.struct({
				module = ByteNet.string,
				method = ByteNet.string,
				character2 = ByteNet.inst,
				animLength = ByteNet.float32,
				character = ByteNet.inst
			})
		})
	}
end)

