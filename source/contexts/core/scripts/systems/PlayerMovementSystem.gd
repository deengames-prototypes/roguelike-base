class_name PlayerMovementSystem
extends Node

var _tile_data:Array2D
var _entity_data:Array2D

var _player:Player
var _move_checker:MoveChecker
var _entity_tweener:EntityTweener
var _monster_mover:MonsterMover

func _init(tile_data:Array2D, entity_data:Array2D, player:Player) -> void:
	_tile_data = tile_data
	_entity_data = entity_data
	_player = player
	
	_move_checker = MoveChecker.new(_tile_data, _entity_data)
	_entity_tweener = EntityTweener.new(_entity_data, _move_checker)
	_monster_mover = MonsterMover.new(_tile_data, _entity_data, _player)
	
func _process(_delta: float) -> void:
	if not is_instance_valid(_player) or _player.is_dead():
		return
	
	# TODO: don't let the player do this until all monsters move. If there are any...
	if Input.is_action_just_pressed("ui_accept"):
		# Pass turn. This is what makes players monsters move.
		CoreEventBus.player_moving.emit()
		# Probably triggers post-move logic.
		CoreEventBus.player_moved.emit()
		return
		
	var movement = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down", 0.2)
	
	if movement.x == 0 and movement.y == 0:
		return
	
	var tree = get_tree()
	var player_tile = Vector2i(_player.position / 32)
	var target_tile = player_tile
	
	if movement.x != 0:
		target_tile += Vector2i.LEFT if movement.x < 0 else Vector2i.RIGHT
	elif movement.y != 0:
		target_tile += Vector2i.UP if movement.y < 0 else Vector2i.DOWN

	if not _move_checker.can_move(target_tile):
		# Is there a monster there?
		var occupant = _move_checker.get_occupant(target_tile)
		if occupant == null:
			# A solid wall, a chasm, etc.
			return
		
		# Not sure if/how to move this into a player melee system...
		if occupant is Monster:
			occupant.hurt()
			_entity_tweener.attack(get_tree(), _player, target_tile - player_tile)
		return

	_entity_tweener.move(tree, _player, target_tile)
	_monster_mover.move_all_monsters()
