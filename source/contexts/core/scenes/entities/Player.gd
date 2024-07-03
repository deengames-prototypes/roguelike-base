class_name Player
extends Node2D

var sight_radius:int = 3
var is_tweening:bool = false # UI RESPONSIBILITY, MOVE OUT OF HERE

# TODO: fields that we save, go in a Resource that's in here? Or in SaveData? idk.
var current_health:int = 10
var max_health:int = 10

func is_dead():
	return current_health <= 0

func hurt(damage:int = 1):
	current_health -= max(damage, 0)
	if is_dead():
		CoreEventBus.player_died.emit()
		self.queue_free()
