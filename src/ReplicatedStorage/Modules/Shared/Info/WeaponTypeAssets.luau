local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")

local Assets = ReplicatedStorage.Assets

local Animations = Assets.Animations
local SFX = Assets.SFX

local CombatAnims = Animations.Combat
local GeneralAnims = CombatAnims.General
local WeaponAnims = CombatAnims.Weapons

local IdleAnims = Animations.Idle

local MovementAnims = Animations.Movement

local LinkAnims = WeaponAnims.Link
local LinkSFX = SFX.Weapons.Link

local WeaponTypesAssets = {}

local assets = {}

local function preloadAnimations(animationTable)
	for _, anim in Animations:GetDescendants() do
		if anim:IsA("Animation") then
			table.insert(assets, anim)
		end
	end
	ContentProvider:PreloadAsync(assets)
end

WeaponTypesAssets.Link = {
	Anims = {
		Idle = IdleAnims.Link,
		
		LeftDash = MovementAnims.LeftDash,
		RightDash = MovementAnims.RightDash,
		BackDash = MovementAnims.BackDash,
		FrontDash = MovementAnims.FrontDash,
		Run = MovementAnims.Run,
		
		Parry = GeneralAnims.Parry,
		Hit1 = GeneralAnims.hit1,
		Hit2 = GeneralAnims.hit2,
		Hit3 = GeneralAnims.hit3,
		Hit4 = GeneralAnims.hit4,
		GuardBroken = GeneralAnims.GuardBroken,
		
		M0 = LinkAnims.m1,
		M1 = LinkAnims.m2,
		M2 = LinkAnims.m3,
		M3 = LinkAnims.m4,
		Parried = LinkAnims.Parried,
		Block = LinkAnims.Block,
		Equip = LinkAnims.Equip
	},
	Sfx = {
		M1 = LinkSFX.Combat.M1
	}
}

for _, weaponType in WeaponTypesAssets do
	task.spawn(function()
		preloadAnimations(assets)
	end)
end

return WeaponTypesAssets