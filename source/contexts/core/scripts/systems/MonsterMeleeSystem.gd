class_name MonsterMeleeSystem
extends Node

var _entity_data:Array2D
var _player:Player

var _move_checker:MoveChecker
var _entity_tweener:EntityTweener

func _init(tile_data:Array2D, entity_data:Array2D, player:Player) -> void:
	_entity_data = entity_data
	_player = player
	
	_move_checker = MoveChecker.new(tile_data, _entity_data)
	_entity_tweener = EntityTweener.new(_entity_data, _move_checker)
	
	CoreEventBus.player_moved.connect(_on_player_moving)

func _on_player_moving():
	var monsters = get_tree().get_nodes_in_group("Monsters")
	
	for monster in monsters:
		if monster.used_turn:
			continue
			
		var monster_tile_position = Vector2i(monster.position / 32)
		var vector_to_player = (_player.position - monster.position)
		
		var distance_to_player:float = vector_to_player.length() / 32
		if distance_to_player > 1:
			continue # sit idly. Can also wander around aimlessly.
		
		monster.used_turn = true
		
		# STAB! STAB!!!!!!
		var tree = get_tree()
		_entity_tweener.attack(tree, monster, vector_to_player)
		_player.hurt()
