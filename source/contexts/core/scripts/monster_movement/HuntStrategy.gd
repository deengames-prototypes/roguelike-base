class_name HuntStrategy
extends Node

var _target:Monster
var _player:Player

func _init(target) -> void:
	_target = target

func _ready():
	_player = get_tree().get_first_node_in_group("Player")
	
func get_moves() -> Array:
	var possible_moves = []
	
	var diff = _player.position - _target.position
	
	if diff.x != 0:
		possible_moves.push_back(Vector2i(sign(diff.x), 0))
	if diff.y != 0:
		possible_moves.push_back(Vector2i(0, sign(diff.y)))
	
	return possible_moves
