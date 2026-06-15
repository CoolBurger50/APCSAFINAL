local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage.Modules
local Shared = Modules.Shared

local WeaponTypeAssets = require(Shared.Info.WeaponTypesAssets)
local HelperFunctions = require(Shared.HelperFunctions)
local Network = require(Shared.Network.Network)

local Block = {}

local blockAnim

local function blockCooldown(character)
	character:SetAttribute("canBlock", false)

	task.delay(0.25, function()
		character:SetAttribute("canBlock", true)
	end)
end

function Block.block(character)
	if character:GetAttribute("state") == "attacking" then return end
	local player = game:GetService("Players"):GetPlayerFromCharacter(character)
	
	local weaponType = character:GetAttribute("weapon")
	
	local blockAddress = WeaponTypeAssets[weaponType].Anims.Block
	
	blockAnim = HelperFunctions.playAnim(character, blockAddress, true)
	
	local BlockData = {module = "BlockServer", 
		method = "main", msg = "begin", animLength = 0}
	
	Network.Fire(BlockData, "Core", player)
end

function Block.endBlock(character)
	local player = game:GetService("Players"):GetPlayerFromCharacter(character)

	if blockAnim and blockAnim.IsPlaying then
		blockAnim:Stop()
		
		local BlockData = {module = "BlockServer", 
			method = "main", msg = "stop", animLength = 0}
		
		Network.Fire(BlockData, "Core", player)
		blockCooldown(character)
	end
end

return Block