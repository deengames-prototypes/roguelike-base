class_name ProjectileShooter
extends Node

signal hit(target)

const TILE_SIZE = 32
const HALF_TILE_SIZE = Vector2(TILE_SIZE / 2, TILE_SIZE / 2)
const VELOCITY = 400

const PROJECTILES = {
	"player": preload("res://contexts/core/scenes/entities/Projectile.tscn")
}

var projectile:Node2D

func shoot(target) -> void:
	projectile = PROJECTILES["player"].instantiate()
	# Hits entities
	projectile.area_entered.connect(func(x): on_hit(x))
	# Hits walls/tilemaps
	projectile.body_entered.connect(func(x): on_hit(x))
	get_parent().add_child(projectile)
	
	# Half-tile-size is used to center objects *perfectly* 
	var start_position = get_parent().global_position + HALF_TILE_SIZE
	var stop_position = target.global_position + HALF_TILE_SIZE
	var travel_time = (stop_position - start_position).length() / VELOCITY
	
	projectile.global_position = start_position
	var tween = self.create_tween()
	tween.tween_property(projectile, "global_position", stop_position, travel_time)

func on_hit(hit_who):
	hit.emit(hit_who)
	projectile.queue_free()
