class_name MoveChecker
extends Node

var _tile_data:Array2D
var _entity_data:Array2D

func _init(tile_data:Array2D, entity_data:Array2D):
	_tile_data = tile_data
	_entity_data = entity_data
	
	# Lol. But prevents returning GCed stuff.
	CoreEventBus.monster_died.connect(func(m):
		var coordinates = Vector2i(m.position / 32)
		_entity_data.set_at(coordinates, null)
	)

func can_move(coordinates:Vector2i) -> bool:
	if not _tile_data.is_in_bounds(coordinates):
		return false
		
	if not "ground" in _tile_data.get_at(coordinates):
		return false
	
	if _entity_data.has(coordinates):
		return false # occupied
	
	var tile_name = _tile_data.get_at(coordinates)
	return "ground" in tile_name

func get_occupant(coordinates:Vector2i) -> Node:
	return _entity_data.get_at(coordinates)
