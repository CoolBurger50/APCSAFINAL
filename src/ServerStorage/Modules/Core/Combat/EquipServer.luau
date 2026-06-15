local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local StateManager = require(ServerStorage.Modules.Managers.StateManager)
local WeaponController = require(ReplicatedStorage.Modules.Controllers.WeaponController)
local Players = game:GetService("Players")
local Network = require(ReplicatedStorage.Modules.Shared.Network.Network)
local HelperFunctions = require(ReplicatedStorage.Modules.Shared.HelperFunctions)
local WeaponTypesAssets = require(ReplicatedStorage.Modules.Shared.Info.WeaponTypesAssets)
local EquipServer = {}
EquipServer.funcs = {
	equip = function(stateObject)
		if stateObject:get() == "equipped" then return end
		local character = stateObject.character
		local weaponType = character:GetAttribute("weapon")

		stateObject:set("equipped", true)
		WeaponController:DestroyWeapon(character)
		WeaponController:WeldEquip(weaponType, character)
		character:SetAttribute("equipped", true)
	end,

	unequip = function(stateObject)
		stateObject:neutralize("equipped")
		
		local character = stateObject.character
		local weaponType = character:GetAttribute("weapon")

		stateObject:set("equipped", false)
	
		WeaponController:DestroyWeapon(character)
		WeaponController:WeldUnEquip(weaponType, character)
		character:SetAttribute("equipped", false)

	end,
}
function EquipServer.main(player : Player, msg)
	local character = player.Character
	local stateObject = StateManager.new(character)
	EquipServer.funcs[msg](stateObject)
end
return EquipServer
