extends Bullet

var colliders = []

func _on_lifetimer_timeout():
	explode()

func explode():
	for collider in colliders:
		if collider.is_in_group("chest"):
			collider.drop_coins()
		elif collider.is_in_group("enemy"):
			collider.damage(damage)
	$Sprite2D.hide()
	AudioManager.play_sound("explosion")
	await ParticleManager.spawn_particle(3, self)
	queue_free()

func _on_area_entered(area):
	if area.is_in_group("chest") || area.is_in_group("enemy"):
		explode()

func _on_explosion_area_entered(area):
	colliders.append(area)

func _on_explosion_area_exited(area):
	colliders.remove_at(colliders.find(area))

func _on_explosion_body_entered(body):
	colliders.append(body)

func _on_explosion_body_exited(body):
	colliders.remove_at(colliders.find(body))
