class_name MonsterMovementSystem
extends Node

var _tile_data:Array2D
var _entity_data:Array2D

func _init(tile_data:Array2D, entity_data:Array2D) -> void:
	_tile_data = tile_data
	_entity_data = entity_data
	
	# Respond to the player-is-about-to-move signal
	CoreEventBus.player_moving.connect(_on_player_moving)

func _on_player_moving():
	pass
