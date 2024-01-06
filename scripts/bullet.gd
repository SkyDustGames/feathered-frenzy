class_name Bullet extends RigidBody2D

@export var bullet_speed: float
@export var damage: float

func _ready():
	apply_impulse(Vector2(bullet_speed, 0).rotated(rotation))

func _on_lifetimer_timeout():
	queue_free()

func _on_area_entered(area):
	if area.is_in_group("chest"):
		area.drop_coins()
		queue_free()
	if area.is_in_group("enemy"):
		area.damage(damage)
		queue_free()
