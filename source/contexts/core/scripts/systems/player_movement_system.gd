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
	if _player.is_tweening:
		return
		
	if not can_move(coordinates):
		return
	
	var player_tile = Vector2i(_player.position / 32)
	_entity_data.set_at(player_tile, null)
	_entity_data.set_at(coordinates, _player)
	
	var tween = get_tree().create_tween()
	_player.is_tweening = true
	tween.tween_property(_player, "position", Vector2(coordinates) * 32, 0.1)
	tween.finished.connect(func():
		_player.is_tweening = false
		CoreEventBus.player_moved.emit()
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

func _process(_delta: float) -> void:
	var movement = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down", 0.2)
	
	if movement.x == 0 and movement.y == 0:
		return
	
	var player_tile = Vector2i(_player.position / 32)
	if movement.x != 0:
		move(player_tile + (Vector2i.LEFT if movement.x < 0 else Vector2i.RIGHT))
	elif movement.y != 0:
		move(player_tile + (Vector2i.UP if movement.y < 0 else Vector2i.DOWN))
		
