extends CharacterBody2D

@export var speed: float
@export var health: float
@export var camera_follow = true
@onready var camera = $"../../Camera2D"
@onready var health_label = $"../../CanvasLayer/Health"
@onready var coins_label = $"../../CanvasLayer/Coins"
@onready var animator = $AnimationPlayer
var coins: int = 0
var facing = "right"
var invincible = false
var can_shoot = true
var coins_gained_in_wave = 0

func _ready():
	if health_label: health_label.text = str(health)

func _physics_process(_delta):
	var direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	)
	
	if direction:
		velocity = direction * speed
	else:
		velocity = Vector2(0, 0)
	
	if direction.y > 0: facing = "down"
	elif direction.y < 0: facing = "up"
	elif direction.x > 0: facing = "right"
	elif direction.x < 0: facing = "left"
	
	animator.play(("run" if direction.x != 0 || direction.y != 0 else "idle") + "_" + facing)

	move_and_slide()
	
	if position.x <= -1350: position.x = -1350
	if position.x >= 1350: position.x = 1350
	if position.y <= -650: position.y = -650
	if position.y >= 800: position.y = 800
	
	if camera_follow: camera.position = position

func add_coin(count = 1):
	coins += count
	coins_gained_in_wave += 1
	coins_label.text = str(coins)
	AudioManager.play_sound("pickupCoin")

func damage(amount):
	if invincible: return
	health -= amount
	health_label.text = str(health)
	if health <= 0:
		AudioManager.play_sound("death")
		ParticleManager.spawn_particle(2, self)
		position = Vector2.ZERO
		coins -= coins_gained_in_wave
		$"../..".restart_wave()
		health = 3
		health_label.text = "3"
		return
	
	AudioManager.play_sound("hitHurt")
	ParticleManager.spawn_particle(1, self)
	modulate = Color(100, 100, 100)
	invincible = true
	await get_tree().create_timer(0.2).timeout
	modulate = Color.WHITE
	for i in range(4):
		modulate.a = 0 if modulate.a == 1 else 1
		await get_tree().create_timer(0.2).timeout
	invincible = false
