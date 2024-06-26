extends Node2D

const Player = preload("res://contexts/core/scenes/entities/Player.tscn")

const MAP_SIZE_TILES = Vector2i(50, 50)

const TILE_LAYERS = {
	"structure": 0,
	"interactive": 1, # entities, that aren't player/monsters.
	"fog": 2
}

# TODO: populate programmatically
const TILE_NAME_TO_OFFSET = {
	"ground": Vector2i.ZERO,
	"wall": Vector2i.RIGHT,
	"fog": Vector2i.RIGHT * 2
}

var _tile_data = Array2D.new(MAP_SIZE_TILES.x, MAP_SIZE_TILES.y)
var _entity_data = Array2D.new(MAP_SIZE_TILES.x, MAP_SIZE_TILES.y)
var _fog_data = Array2D.new(MAP_SIZE_TILES.x, MAP_SIZE_TILES.y) # coordinates => is_fogged

var _player_position = Vector2i(6, 3)

func _ready():
	# TODO: move out
	_generate_dungeon()
	
	_populate_tiles()
	_populate_entities()
	_update_fog()

func _generate_dungeon() -> void:
	_tile_data.fill("ground")
	
	for x in range(MAP_SIZE_TILES.x):
		_tile_data.set_at(x, 0, "wall")
		_tile_data.set_at(x, MAP_SIZE_TILES.y - 1, "wall")
	
	for y in range(MAP_SIZE_TILES.y):
		_tile_data.set_at(0, y, "wall")
		_tile_data.set_at(MAP_SIZE_TILES.x - 1, y, "wall")
	
	for y in range(MAP_SIZE_TILES.y):
		for x in range(MAP_SIZE_TILES.x):
			_fog_data.set_at(x, y, true) # true => is_fogged
	
func _populate_tiles() -> void:
	%DungeonTileMap.clear()
	
	for y in range(MAP_SIZE_TILES.y):
		for x in range(MAP_SIZE_TILES.x):
			var tile_name = _tile_data.get_at(x, y)
			var atlas_coordinates = TILE_NAME_TO_OFFSET[tile_name]
			%DungeonTileMap.set_cell(TILE_LAYERS["structure"], Vector2i(x, y), 0, atlas_coordinates)
			
			var is_fogged = _fog_data.get_at(x, y)
			if is_fogged:
				%DungeonTileMap.set_cell(TILE_LAYERS["fog"], Vector2i(x, y), 0, TILE_NAME_TO_OFFSET["fog"])

func _populate_entities()-> void:
	var player = Player.instantiate()
	add_child(player)
	player.position = _player_position * 32
	# Data moves to synch with scene, to start. After this, data drives it.
	_entity_data.set_at(_player_position.x, _player_position.y, player)

func _update_fog() -> void:
	var player = _entity_data.get_at(_player_position.x, _player_position.y)
	for y in range(-player.sight_radius, player.sight_radius + 1):
		for x in range(-player.sight_radius, player.sight_radius + 1):
			var lit_cell = Vector2i(_player_position.x + x, _player_position.y + y)
			
			# Gives WeIrD results
			#if (lit_cell - _player_position).length() > player.sight_radius:
				#continue
				
			_fog_data.set_at(_player_position.x + x, _player_position.y + y, false) # false => is_fog = no
			# -1 source = erase
			%DungeonTileMap.set_cell(TILE_LAYERS["fog"], lit_cell, -1, Vector2i.ZERO)
