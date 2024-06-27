class_name PlayerMovementSystem
extends Node

var _tile_data:Array2D
var _entity_data:Array2D

var _player:Player
var _move_checker:MoveChecker
var _entity_tweener:EntityTweener

func _init(tile_data:Array2D, entity_data:Array2D, player:Player) -> void:
	_tile_data = tile_data
	_entity_data = entity_data
	_player = player
	
	_move_checker = MoveChecker.new(_tile_data, _entity_data)
	_entity_tweener = EntityTweener.new(_entity_data, _move_checker)

func _process(_delta: float) -> void:
	var movement = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down", 0.2)
	
	if movement.x == 0 and movement.y == 0:
		return
	
	var tree = get_tree()
	var player_tile = Vector2i(_player.position / 32)
	if movement.x != 0:
		_entity_tweener.move(tree, _player, player_tile + (Vector2i.LEFT if movement.x < 0 else Vector2i.RIGHT), true)
	elif movement.y != 0:
		_entity_tweener.move(tree, _player, player_tile + (Vector2i.UP if movement.y < 0 else Vector2i.DOWN), true)
