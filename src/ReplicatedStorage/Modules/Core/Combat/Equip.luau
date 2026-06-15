local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local SharedModules = ReplicatedStorage.Modules.Shared
local WeaponTypesAssets = require(SharedModules.Info.WeaponTypesAssets)
local Network = require(ReplicatedStorage.Modules.Shared.Network.Network)
local HelperFunctions = require(SharedModules.HelperFunctions)
local WeaponController = require(ReplicatedStorage.Modules.Controllers.WeaponController)
local EquipClient = {}
local equipAnim
local currentWeaponType
local EquipNetwork = {
	module = "EquipServer",
	method = "main",
	msg = "equip",
	animLength = 0
}
local UnequipNetwork = {
	module = "EquipServer",
	method = "main",
	msg = "unequip",
	animLength = 0
}
function EquipClient.equip(character)
	local weaponType = character:GetAttribute("weapon")

	if not weaponType then return end

	local weaponTypeAsset = WeaponTypesAssets[weaponType]
	if not weaponTypeAsset then return end

	if equipAnim and equipAnim.IsPlaying then
		equipAnim:Stop()
	end




	local anim = weaponTypeAsset.Anims.Equip
	equipAnim = HelperFunctions.playAnim(character, anim, true)
	currentWeaponType = weaponType

	Network.Fire(EquipNetwork, "Core")
end
function EquipClient.unequip(character)
	local weaponType = character:GetAttribute("weapon")

	if not weaponType then return end

	local weaponTypeAsset = WeaponTypesAssets[weaponType]
	if not weaponTypeAsset then return end

	if equipAnim and equipAnim.IsPlaying then
		equipAnim:Stop()
	end

	

	local anim = weaponTypeAsset.Anims.Unequip
	if anim then
		equipAnim = HelperFunctions.playAnim(character, anim, true)
	end
	
	
	
	currentWeaponType = nil
	Network.Fire(UnequipNetwork, "Core")
end
return EquipClient