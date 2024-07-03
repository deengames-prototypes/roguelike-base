class_name EntityTweener
extends Node

var _entity_data:Array2D
var _move_checker:MoveChecker

func _init(entity_data:Array2D, move_checker:MoveChecker):
	_entity_data = entity_data
	_move_checker = move_checker
	
func move(tree:SceneTree, entity:Node2D, coordinates:Vector2i, emit_player_events:bool = false) -> void:
	if "is_tweening" in entity and entity.is_tweening:
		return
	
	var entity_tile = Vector2i(entity.position / 32)
	_entity_data.set_at(entity_tile, null)
	_entity_data.set_at(coordinates, entity)
	
	if emit_player_events:
		# Triggers monsters to move
		CoreEventBus.player_moving.emit()
	
	if "is_tweening" in entity: 
		# For player. Don't allow multiple moves concurrently.
		entity.is_tweening = true
		
	# Has to be done here, or we get a "Tween started with no tweeners" error.
	var tween = tree.create_tween()
	tween.tween_property(entity, "position", Vector2(coordinates) * 32, 0.1)
	
	tween.finished.connect(func():
		if "is_tweening" in entity:
			entity.is_tweening = false
		if emit_player_events:
			CoreEventBus.player_moved.emit())

func attack(tree:SceneTree, entity:Node2D, direction:Vector2) -> void:
	direction = direction.normalized()
	
	# Has to be done here, or we get a "Tween started with no tweeners" error.
	var tween = tree.create_tween()
	tween.tween_property(entity, "position", entity.position + (direction * 16), 0.1)
	tween.finished.connect(func():
		tween = tree.create_tween()
		tween.tween_property(entity, "position", entity.position - (direction * 16), 0.1))
