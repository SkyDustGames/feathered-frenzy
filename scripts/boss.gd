extends Area2D

@export var attacks: int
@export var max_attacks: int
@export var health: float
@export var explosion_time: float
@export var stage1_explosion: float
@export var stage0_explosion: float
@export var bullet_prefab: PackedScene
@export var player: Node2D
@export var marker: Sprite2D
var attack
var attack_count = 0
var offset = 0.0
var explosion_timer = 0
var pos_offset = Vector2.ZERO
var pos = Vector2.ZERO

func _ready():
	next_attack()

func explode(angle_offset, pos_offset):
	if angle_offset == 0: angle_offset = randf_range(-TAU, TAU)
	for i in range(6):
		var bullet = bullet_prefab.instantiate()
		bullet.rotation = i * 72 + angle_offset
		bullet.position = pos_offset + 16 * Vector2.from_angle(bullet.rotation)
		add_sibling(bullet)
		ParticleManager.spawn_particle(4, bullet)
	AudioManager.play_sound("shoot")

func init_attack_0():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 1)
	await tween.finished
	marker.show()
	pos = player.position + Vector2(randf_range(-25, 25), randf_range(-25, 25))
	marker.position = pos

func init_attack_1():
	offset = 0
	pos_offset = player.global_position
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 1)
	await tween.finished
	
	marker.show()
	marker.position = pos_offset
	await get_tree().create_timer(1).timeout

func init_attack_2():
	AudioManager.play_sound("pause")
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 1)
	await tween.finished
	monitoring = true
	await get_tree().create_timer(0.2).timeout

func attack_0(delta):
	explosion_timer += delta
	if explosion_timer >= stage0_explosion:
		explode(0, pos)
		pos = player.position + Vector2(randf_range(-25, 25), randf_range(-25, 25))
		marker.position = pos
		explosion_timer = 0

func attack_1(delta):
	offset += 0.25 * delta
	explosion_timer += delta
	if explosion_timer >= stage1_explosion:
		explode(offset, pos_offset)
		explosion_timer = 0

func attack_2(delta):
	position.x = move_toward(position.x, player.position.x, delta * 50)
	position.y = move_toward(position.y, player.position.y, delta * 50)
	
	if player.position.x < position.x:
		$AnimationPlayer.play("run_left")
	else:
		$AnimationPlayer.play("run_right")
	
	explosion_timer += delta
	if explosion_timer >= explosion_time:
		explode(0, position)
		explosion_timer = 0

func next_attack():
	$AnimationPlayer.play("idle_down")
	marker.hide()
	attack = -1
	var new_attack = randi() % attacks
	attack_count += 1
	if attack_count >= max_attacks:
		new_attack = 2
		attack_count = 0
	await call("init_attack_" + str(new_attack))
	attack = new_attack
	$AttackTimer.stop()
	$AttackTimer.start()

func _process(delta):
	if health <= 0:
		explosion_timer += delta
		offset += delta
		if explosion_timer >= 0.1:
			explode(offset, position)
			explosion_timer = 0
		return
	
	if has_method("attack_" + str(attack)):
		call("attack_" + str(attack), delta)

func damage():
	health -= 1
	modulate = Color(1000, 1000, 1000, 1)
	ParticleManager.spawn_particle(3, self)
	await get_tree().create_timer(0.1).timeout
	if health <= 0:
		player.invincible = true
		$AttackTimer.stop()
		hide()
		var tween = get_tree().create_tween()
		tween.tween_property($"../Camera2D/Parallax", "modulate", Color.TRANSPARENT, 5)
		tween.parallel().tween_property($"../Camera2D/MainBG", "modulate", Color.BLACK, 5)
		tween.tween_property($"..", "modulate", Color.BLACK, 5)
		await get_tree().create_timer(5).timeout
		$"../CanvasLayer".queue_free()
		set_process(false)
		await tween.finished
		SceneManager.change_scene("res://scenes/credits.tscn")
		return
	modulate = Color.WHITE

func _on_body_entered(body):
	if body.is_in_group("bullet"):
		damage()
		set_deferred("monitoring", false)
		next_attack()
		body.queue_free()
		AudioManager.play_sound("explosion")
	elif body.is_in_group("player"):
		body.damage(1)
		body.position = Vector2.ZERO
