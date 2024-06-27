class_name MonsterMovementSystem
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
	
	# Respond to the player-is-about-to-move signal
	CoreEventBus.player_moving.connect(_on_player_moving)

func _on_player_moving():
	var monsters = get_tree().get_nodes_in_group("Monsters")
	
	for monster in monsters:
		var monster_tile_position = Vector2i(monster.position / 32)
		var vector_to_player = (_player.position - monster.position)
		
		var distance_to_player:float = vector_to_player.length() / 32
		if distance_to_player > monster.stalking_range:
			continue # sit idly. Can also wander around aimlessly.
		
		# we stalkin', yo. Randomly...
		var potential_moves = []
		if vector_to_player.x != 0:
			potential_moves.append(Vector2i(sign(vector_to_player.x), 0))
		if vector_to_player.y != 0:
			potential_moves.append(Vector2i(0, sign(vector_to_player.y)))
		
		if len(potential_moves) == 0:
			push_error("Monster doesn't seem to have any legal moves ...")
			continue
		
		var valid_moves = []
		for move in potential_moves:
			if _move_checker.can_move(monster_tile_position + move):
				valid_moves.append(move)
		
		if len(valid_moves) == 0:
			continue
		
		var move = valid_moves.pick_random()
		var tree = get_tree()
		_entity_tweener.move(tree, monster, monster_tile_position + move)
