class_name RandomStrategy
extends Node

var _target:Monster

func _init(target) -> void:
	_target = target
	
func get_moves() -> Array:
	var possible_moves = [Vector2i.UP, Vector2i.DOWN, Vector2i.RIGHT, Vector2i.LEFT]
	return possible_moves
