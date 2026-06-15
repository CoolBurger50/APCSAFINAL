local WeaponController = {}
WeaponController.__index = WeaponController

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Weapons = ReplicatedStorage:WaitForChild("Assets").Weapons

function WeaponController:WeldUnEquip(SelectedWeapon, Character)
	local Weapon = Weapons[SelectedWeapon]
	local Weapon_Folder = Weapon["Weapon_Folder"]:Clone()
	
	if SelectedWeapon == "Link" then
		local Link = Weapon_Folder.Link
		
		Weapon_Folder.Parent = Character
		
		Link.SheatheWeld.Part0 = Link
		Link.SheatheWeld.Part1 = Character["Torso"]
	end
end

function WeaponController:WeldEquip(SelectedWeapon, Character)
	local Weapon = Weapons[SelectedWeapon]
	local Weapon_Folder = Weapon["Weapon_Folder"]:Clone()
	local Weld_Folder = Weapons[tostring(Weapon)]["Weld_Folder"]:Clone()
	local Hilt = Weld_Folder.Hilt


	if SelectedWeapon == "Link" then
		local Link = Weapon_Folder.Link

		Weapon_Folder.Parent = Character
		Weld_Folder.Parent = Character

		Hilt.HiltWeld.Part0 = Character["Right Arm"]
		Hilt.HiltWeld.Part1 = Hilt

		Link.Hilt.Part0 = Link
		Link.Hilt.Part1 = Hilt
	elseif SelectedWeapon == "other weapons" then

	end
end

function WeaponController:DestroyWeapon(Character)
	for _, Object in Character:GetChildren() do
		if Object:IsA("Folder") or Object:IsA("MeshPart") then Object:Destroy() end
	end
end

function WeaponController:SetCombatType(SelectedWeapon, Character)
	Character:SetAttribute("weapon", SelectedWeapon)
end

return WeaponController

