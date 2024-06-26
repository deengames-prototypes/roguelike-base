class_name Defogger
extends Node

var _fog_data:Array2D
var _dungeon_tile_map:TileMap
var _fog_layer:int
var _player:Player

func _init(player:Player, fog_data:Array2D, dungeon_tile_map:TileMap, fog_layer:int) -> void:
	_fog_data = fog_data
	_dungeon_tile_map = dungeon_tile_map
	_fog_layer = fog_layer
	_player = player
	
func remove_fog():
	var player_position = Vector2i(_player.position / 32)
	
	for y in range(-_player.sight_radius, _player.sight_radius + 1):
		for x in range(-_player.sight_radius, _player.sight_radius + 1):
			var lit_cell = player_position + Vector2i(x, y)
			
			# Gives WeIrD results
			#if (lit_cell - player_position).length() > player.sight_radius:
				#continue
				
			_fog_data.set_at(lit_cell, false) # false => is_fog = no
			# -1 source = erase
			_dungeon_tile_map.set_cell(_fog_layer, lit_cell, -1, Vector2i.ZERO)
