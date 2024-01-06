extends Node2D

@export var swan_prefab: PackedScene
@export var armored_swan: PackedScene
@export var max_waves: int
@export var enemy_count: int
@export var radius: float
@export var spawn_time: float
@export var pistol_sprite: Texture2D
@onready var player = $Environment/Player
@onready var dialogue_label = $Environment/Player/Label
@onready var wave_label = $CanvasLayer/WaveCountdown
var wave = 1
var spawn_timer = 0
var armor_chance = 0
var wave_countdown = 25.0
var alive_enemies = 0
var spawned_all = false
var swans = []

func _ready():
	AudioManager.play_sound("sinister-abode", true)

func end_cutscene():
	AudioManager.play_sound("it-takes-a-hero", true)
	var dialogue = ["Wait...", "Why am I even doing this?"]
	for string in dialogue:
		dialogue_label.text = string
		await get_tree().create_timer(3).timeout
	
	dialogue_label.text = ""
	
	player.reparent(self)
	
	var other = player.duplicate()
	other.process_mode = Node.PROCESS_MODE_DISABLED
	other.position = player.position + Vector2(100, 0)
	player.add_sibling(other)
	
	var other_label = other.get_node("Label")
	other_label.text = "Hello."
	await get_tree().create_timer(1).timeout
	
	dialogue_label.text = "Who are you?"
	await get_tree().create_timer(3).timeout
	dialogue = ["You.", "We are not good people, Player."]
	for string in dialogue:
		other_label.text = string
		await get_tree().create_timer(3).timeout

	dialogue_label.text = "What are you talking about?"
	await get_tree().create_timer(3).timeout
	
	dialogue_label.text = ""
	other_label.text = "We'll see."
	player.get_node("Weapon").switch_weapon(0, 0, null, pistol_sprite)
	var tween = create_tween()
	tween.tween_property($Environment, "modulate", Color.TRANSPARENT, 5)
	await tween.finished
	SceneManager.change_scene("res://scenes/final_boss.tscn")

func swan_dead():
	alive_enemies -= 1
	if alive_enemies <= 0:
		enemy_count += 1
		spawn_time -= 0.1
		wave += 1
		$Environment/Player.coins_gained_in_wave = 0
		swans = []
		armor_chance += 0.1
		wave_countdown = 10.0
		
		if wave > max_waves:
			wave_label.text = ""
			end_cutscene()

func restart_wave():
	for swan in swans:
		if is_instance_valid(swan): swan.queue_free()
	swans = []
	alive_enemies = 0
	spawned_all = false

func _process(delta):
	if wave > max_waves: return
	
	if spawned_all:
		if alive_enemies <= 0:
			wave_countdown -= delta
			wave_label.text = "%.0f" % wave_countdown
			if wave_countdown <= 0:
				wave_label.text = "WAVE %d" % wave
				spawned_all = false
		return
	
	spawn_timer += delta
	if spawn_timer >= spawn_time:
		var swan
		if randf() < armor_chance:
			swan = armored_swan.instantiate()
		else:
			swan = swan_prefab.instantiate()
		swan.dead.connect(swan_dead)
		swan.position = player.position + radius * Vector2.from_angle(randf_range(-TAU, TAU))
		add_child(swan)
		swans.append(swan)
		spawn_timer = 0
		alive_enemies += 1
	spawned_all = alive_enemies >= enemy_count
