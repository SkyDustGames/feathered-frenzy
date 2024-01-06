extends Area2D

signal dead()

@export var health = 2
@export var speed = 150.0
@export var chest_chance: float
@export var move_time: float
@export var coin_prefab: PackedScene
@export var chest_prefab: PackedScene
@export var heart_prefab: PackedScene
var stunned = false
var player = null
var move_timer = 0.0
var move_pos: Vector2

func _ready():
	move_pos = position

func _process(delta):
	if health <= 0: return
	
	if !stunned:
		if player != null:
			move_pos = player.position
		else:
			move_timer += delta
			if move_timer >= move_time:
				move_pos = randf_range(-96, 96) * Vector2.from_angle(randf_range(0, TAU))
				move_timer = 0
		var flip = move_pos.x <= position.x
		$Sprite2D.flip_h = flip
		if has_node("Armor"): $Armor.flip_h = flip
		position.x = move_toward(position.x, move_pos.x, speed * delta)
		position.y = move_toward(position.y, move_pos.y, speed * delta)

func damage(amount):
	if health <= 0: return
	
	health -= amount
	if health <= 0:
		AudioManager.play_sound("death")
		dead.emit()
		var drop: Node2D
		if $"../Environment/Player".health < 10 and randf() > 0.5:
			drop = heart_prefab.instantiate()
		elif randf() > chest_chance:
			drop = coin_prefab.instantiate()
		else: drop = chest_prefab.instantiate()
		drop.position = position
		call_deferred("add_sibling", drop)
		$Sprite2D.hide()
		if has_node("Armor"): $Armor.hide()
		await ParticleManager.spawn_particle(2, self)
		queue_free()
		return
	AudioManager.play_sound("hitHurt")
	ParticleManager.spawn_particle(1, self)
	modulate = Color(100, 100, 100, 100)
	stunned = true
	await get_tree().create_timer(0.1).timeout
	stunned = false
	modulate = Color.WHITE

func _on_body_entered(body):
	if body.is_in_group("player") and health > 0:
		body.damage(1)
		stunned = true
		$StunTimer.start()

func _on_stun_timer_timeout():
	stunned = false

func _on_seeing_range_entered(body):
	if body.is_in_group("player"): player = body

func _on_seeing_range_exited(body):
	if body.is_in_group("player"): player = null
