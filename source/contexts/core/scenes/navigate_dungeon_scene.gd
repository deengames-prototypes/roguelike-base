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

@onready var _defogger = Defogger.new(_tile_data, %DungeonTileMap, TILE_LAYERS["fog"])

var _tile_data = Array2D.new(MAP_SIZE_TILES.x, MAP_SIZE_TILES.y)
var _entity_data = Array2D.new(MAP_SIZE_TILES.x, MAP_SIZE_TILES.y)
# aka is_fogged. coordinates => true if fogged up
var _fog_data = Array2D.new(MAP_SIZE_TILES.x, MAP_SIZE_TILES.y)

var _player_position = Vector2i(6, 3)

func _ready():
	# TODO: move out
	_generate_dungeon()
	
	_populate_tiles()
	_populate_entities()
	_defogger.remove_fog(_entity_data.get_at(_player_position))

func _generate_dungeon() -> void:
	_tile_data.fill("ground")
	
	for x in range(MAP_SIZE_TILES.x):
		_tile_data.set_at(Vector2i(x, 0), "wall")
		_tile_data.set_at(Vector2i(x, MAP_SIZE_TILES.y - 1), "wall")
	
	for y in range(MAP_SIZE_TILES.y):
		_tile_data.set_at(Vector2i(0, y), "wall")
		_tile_data.set_at(Vector2i(MAP_SIZE_TILES.x - 1, y), "wall")
	
	for y in range(MAP_SIZE_TILES.y):
		for x in range(MAP_SIZE_TILES.x):
			_fog_data.set_at(Vector2i(x, y), true) # true => is_fogged
	
func _populate_tiles() -> void:
	%DungeonTileMap.clear()
	
	for y in range(MAP_SIZE_TILES.y):
		for x in range(MAP_SIZE_TILES.x):
			var coordinates = Vector2i(x, y)
			var tile_name = _tile_data.get_at(coordinates)
			var atlas_coordinates = TILE_NAME_TO_OFFSET[tile_name]
			%DungeonTileMap.set_cell(TILE_LAYERS["structure"], Vector2i(x, y), 0, atlas_coordinates)
			
			var is_fogged = _fog_data.get_at(coordinates)
			if is_fogged:
				%DungeonTileMap.set_cell(TILE_LAYERS["fog"], Vector2i(x, y), 0, TILE_NAME_TO_OFFSET["fog"])

func _populate_entities()-> void:
	var player = Player.instantiate()
	add_child(player)
	player.position = _player_position * 32
	# Data moves to synch with scene, to start. After this, data drives it.
	_entity_data.set_at(_player_position, player)
