local WeaponStats = {}
WeaponStats.__index = WeaponStats

WeaponStats.Link = {
	M1Debounce = 0.65;
	M1FinisherDebounce = 1;
};

function WeaponStats:ReturnWeaponStat(Weapon, Stat)
	return WeaponStats[Weapon][Stat]
end

return WeaponStats