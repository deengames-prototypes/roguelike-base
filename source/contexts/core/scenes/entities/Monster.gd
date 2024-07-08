class_name Monster
extends BaseEntity

func _ready() -> void:
	CoreEventBus.player_moving.connect(try_to_move)

func try_to_move():
	var direction = [Vector2i.UP, Vector2i.DOWN, Vector2i.RIGHT, Vector2i.LEFT].pick_random()
	self.move(direction)
