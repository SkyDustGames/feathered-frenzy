extends Area2D

@export var coin_count: int
@export var x_var: float
@export var y_var: float
@export var coin_prefab: PackedScene
var coins_dropped = false

func drop_coins():
	if coins_dropped: return
	coins_dropped = true
	
	for i in range(coin_count):
		var coin = coin_prefab.instantiate()
		coin.position = position + Vector2(randf_range(-x_var, x_var), randf_range(-y_var, y_var))
		call_deferred("add_sibling", coin)
	ParticleManager.spawn_particle(0, self)
	$Sprite2D.frame += 1
	AudioManager.play_sound("pickupCoin")
	await get_tree().create_timer(1).timeout
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		drop_coins()
