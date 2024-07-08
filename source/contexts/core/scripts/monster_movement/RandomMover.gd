class_name RandomMover
extends Node

var _target:Monster

func _init(target) -> void:
	_target = target
	
func try_to_move():
	var directions = [Vector2i.UP, Vector2i.DOWN, Vector2i.RIGHT, Vector2i.LEFT]
	directions.shuffle()
	
	for direction in directions:
		if not _target.can_move(direction):
			continue
		
		if await _target.move(direction):
			break
