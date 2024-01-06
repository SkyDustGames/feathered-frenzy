extends Node2D

@export var shoot_delay: float
@export var accuracy: float
@export var bullet_prefab: PackedScene
var shoot_timer: float

func _process(delta):
	if shoot_delay < 0: return
	if shoot_timer > 0:
		shoot_timer -= delta
	if Input.is_action_pressed("shoot") and shoot_timer <= 0 and bullet_prefab and $"..".can_shoot:
		AudioManager.play_sound("shoot")
		var bullet = bullet_prefab.instantiate()
		bullet.position = $FirePoint.global_position
		bullet.rotation = rotation + randf_range(-accuracy, accuracy)
		get_parent().add_sibling(bullet)
		shoot_timer = shoot_delay
		ParticleManager.spawn_particle(4, $FirePoint)
	look_at(get_global_mouse_position())
	$Sprite.flip_v = global_rotation_degrees < -90 or global_rotation_degrees > 90

func switch_weapon(shoot_time, unaccuracy, bullet, sprite):
	shoot_delay = shoot_time
	accuracy = unaccuracy
	bullet_prefab = bullet
	$Sprite.texture = sprite
	AudioManager.play_sound("switchWeapon")
