extends Node2D

const particles = [
	preload("res://prefabs/particles/chest.tscn"),
	preload("res://prefabs/particles/damage.tscn"),
	preload("res://prefabs/particles/death.tscn"),
	preload("res://prefabs/particles/rocket_explosion.tscn"),
	preload("res://prefabs/particles/shoot.tscn"),
]

func spawn_particle(index: int, parent: Node2D) -> void:
	var particle = particles[index].instantiate()
	parent.call_deferred("add_child", particle)
	particle.emitting = true
	await particle.finished
	particle.queue_free()
