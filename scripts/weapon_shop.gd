extends ColorRect

@onready var player = $"../../Environment/Player"

func get_weapon_position(weapon_name):
	match weapon_name:
		"SwanPoison":
			return Vector2(-25, -25)
		"MachineGun":
			return Vector2(25, -25)
		"SniperRifle":
			return Vector2(-25, 25)
		"RocketLauncher":
			return Vector2(25, 25)

func buy(weapon, price):
	if player.coins >= price:
		player.add_coin(-price)
		var pickup = load(weapon).instantiate()
		pickup.position = player.position + get_weapon_position(pickup.name)
		get_tree().current_scene.add_child(pickup)
		hide()
		AudioManager.play_sound("buy")
		player.can_shoot = true
