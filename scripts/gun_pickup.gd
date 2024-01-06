extends Area2D

@export var shoot_time: float
@export var accuracy: float
@export var bullet: PackedScene
var player = null

func _process(_delta):
	if Input.is_action_just_pressed("interact") and player != null:
		var weapon = player.get_node("Weapon")
		var tmp = { "shoot_time": shoot_time, "accuracy": accuracy, "bullet": bullet, "texture": $Sprite2D.texture }
		shoot_time = weapon.shoot_delay
		accuracy = weapon.accuracy
		bullet = weapon.bullet_prefab
		$Sprite2D.texture = weapon.get_node("Sprite").texture
		weapon.switch_weapon(tmp.shoot_time, tmp.accuracy, tmp.bullet, tmp.texture)

func _on_body_entered(body):
	player = body
	$Popup.show()

func _on_body_exited(_body):
	player = null
	$Popup.hide()
