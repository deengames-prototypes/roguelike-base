class_name Monster
extends BaseEntity

func _ready() -> void:
	CoreEventBus.player_moving.connect(try_to_move)
	super._ready()

func try_to_move():
	# TODO: AI
	var directions = [Vector2i.UP, Vector2i.DOWN, Vector2i.RIGHT, Vector2i.LEFT]
	directions.shuffle()
	
	for direction in directions:
		if not can_move(direction):
			continue
		
		if await self.move(direction):
			break
