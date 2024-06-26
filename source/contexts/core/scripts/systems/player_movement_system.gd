class_name PlayerMovementSystem
extends Node

var _tile_data:Array2D
var _entity_data:Array2D

var _player:Player

func _init(tile_data:Array2D, entity_data:Array2D, player:Player) -> void:
	_tile_data = tile_data
	_entity_data = entity_data
	_player = player

func move(coordinates:Vector2i) -> void:
	if not can_move(coordinates):
		return
	
	var player_tile = Vector2i(_player.position / 32)
	_entity_data.set_at(player_tile, null)
	_entity_data.set_at(coordinates, _player)
	
	var tween = get_tree().create_tween() 
	tween.tween_property(_player, "position", coordinates, 1)
	tween.finished.connect(func(): CoreEventBus.player_moved.emit())
	
func can_move(coordinates:Vector2i) -> bool:
	if not _tile_data.is_in_bounds(coordinates):
		return false
		
	if _entity_data.has(coordinates):
		return false # occupied
	
	var tile_name = _tile_data.get_at(coordinates)
	return "ground" in tile_name
