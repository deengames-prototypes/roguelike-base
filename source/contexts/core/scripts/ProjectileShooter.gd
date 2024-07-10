class_name ProjectileShooter
extends Node

signal hit(target)

const TILE_SIZE = 32
const HALF_TILE_SIZE = Vector2(TILE_SIZE / 2, TILE_SIZE / 2)

const PROJECTILES = {
	"player": preload("res://contexts/core/scenes/entities/Projectile.tscn")
}

const VELOCITY = 100

func shoot(target) -> void:
	var projectile = PROJECTILES["player"].instantiate()
	get_parent().add_child(projectile)
	
	# Half-tile-size is used to center objects *perfectly* :)
	var start_position = get_parent().global_position + HALF_TILE_SIZE
	var stop_position = target.global_position + HALF_TILE_SIZE
	var travel_time = (stop_position - start_position).length() / VELOCITY
	
	projectile.global_position = start_position
	var tween = self.create_tween()
	tween.tween_property(projectile, "global_position", stop_position, travel_time)
	tween.finished.connect(func():
		hit.emit(target)
		projectile.queue_free()
	)
