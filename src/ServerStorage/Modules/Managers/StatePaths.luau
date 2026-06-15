return {
	neutral = {
		canAttack = true,
		canRun = true,
		canBlock = true,
		busy = false,
		walkSpeed = 16,
		jumpHeight = 3,
		jumpPower = 32.368,
		priority = 0
	},
	stunned = {
		canAttack = false,
		canRun = false,
		canBlock = false,
		busy = true,
		walkSpeed = 0,
		jumpHeight = 0,
		jumpPower = 0,
		priority = 1
	},
	running = {
		canAttack = true,
		walkSpeed = 22,
		jumpHeight = 2.5,
		jumpPower = 29.8,
		priority = 0.1,
	},
	attacking = {
		canRun = false,
		busy = true,
		walkSpeed = 7,
		jumpHeight = 0,
		jumpPower = 0,
		priority = 0.2
	},
	blocking = {
		canAttack = false,
		canRun = false,
		busy = true,
		walkSpeed = 5,
		jumpHeight = 0,
		jumpPower = 0,
		priority = 0.21
	},
	dashing = {
		canAttack = false,
		canRun = false,
		canBlock = false,
		busy = true,
		walkSpeed = 0,
		jumpHeight = 0,
		jumpPower = 0,
		priority = 0.205,
	}
}
