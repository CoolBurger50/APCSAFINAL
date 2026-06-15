local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local character = script.Parent.Parent
local CombatModules = ReplicatedStorage.Modules.Core.Combat

local AttackClient = require(CombatModules.AttackClient)
local DashClient = require(CombatModules.DashClient)
local RunClient = require(CombatModules.RunClient)
local EquipClient = require(CombatModules.EquipClient)
local BlockClient = require(CombatModules.BlockClient)
local Packets = require(ReplicatedStorage.Modules.Shared.Network.Packets)
local Network = require(ReplicatedStorage.Modules.Shared.Network.Network)

local WeaponStats = require(ReplicatedStorage.Modules.Shared.Info.WeaponStats)

local CooldownManager = require(ReplicatedStorage.Modules.Shared.Cooldown)
CooldownManager.Cooldowns = {}

local CombatInputs = {}

local DashData = {
	[Enum.KeyCode.W] = "Front",
	[Enum.KeyCode.S] = "Back",
	[Enum.KeyCode.D] = "Right",
	[Enum.KeyCode.A] = "Left"
}

local function checkState(callback)
	return function(name, state)
		if state ~= Enum.UserInputState.Begin then
			return
		end
		return callback()
	end
end

CombatInputs = {
	Equip = {
		Keycode = Enum.KeyCode.E,
		Callback = checkState(function()
			if CooldownManager.Check("Equip") then
				return
			end

			CooldownManager.Set("Equip", 1)

			if character:GetAttribute("equipped") then
				EquipClient.unequip(character)
			else
				EquipClient.equip(character)
			end
		end)
	},
	Attack = {
		Keycode = Enum.UserInputType.MouseButton1,

		Callback = checkState(function()
			if not character:GetAttribute("equipped") then
				return
			end
			if CooldownManager.Check("Attack") or not character:GetAttribute("canAttack") then
				return
			end

			local CurrentWeapon = character:GetAttribute("weapon")
			local M1Debounce = WeaponStats:ReturnWeaponStat(CurrentWeapon, "M1Debounce")

			local Cooldown = character:GetAttribute("combo") == 3 and 1.42 or M1Debounce
			CooldownManager.Set("Attack", Cooldown)

			AttackClient.attack(character)
		end),
	},
	Dash = {
		Keycode = Enum.KeyCode.Q,

		Callback = checkState(function()
			if character:GetAttribute("busy") or CooldownManager.Check("Dash") then
				return
			end

			local direction

			for key, data in DashData do
				if not UserInputService:IsKeyDown(key) then
					continue
				end
				
				if data == "Front" then
					direction = data
					break
				end
				
				if data == "Back" then
					direction = data
					break
				end

				direction = data
			end
			
			if direction == nil then
				direction = "Front"
			end
			
			CooldownManager.Set("Dash", 1.5)

			DashClient.dash(character, direction)		
		end)
	},
	Run = {
		Keycode = Enum.KeyCode.LeftShift,

		Callback = function(_, state)
			if state == Enum.UserInputState.Begin then
				RunClient.begin(character)
			elseif state == Enum.UserInputState.End then
				RunClient.stop(character)
			end

			return Enum.ContextActionResult.Pass
		end,
	},
	Block = {
		Keycode = Enum.KeyCode.F,

		Callback = function(_, state)
			if not character:GetAttribute("equipped") then
				return
			end
			
			if state == Enum.UserInputState.Begin then
				if not character:GetAttribute("canBlock") then
					return
				end
				BlockClient.block(character)
			elseif state == Enum.UserInputState.End then
				BlockClient.endBlock(character)
			end
		end,
	}
}

return CombatInputs