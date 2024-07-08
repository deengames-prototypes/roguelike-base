class_name Player
extends BaseEntity

var direction_vectors = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}

func _unhandled_key_input(event: InputEvent) -> void:
	if is_moving:
		return
	
	# Clear who is moving where this turn
	BaseEntity.moving_next_turn.fill(null) 

	for direction in direction_vectors.keys():
		var direction_vector:Vector2i = direction_vectors[direction]
		if event.is_action_pressed("ui_%s" % direction):
			if not can_move(direction_vector):
				continue
			
			move(direction_vector)
			break

func pre_move():
	CoreEventBus.player_moving.emit()

func post_move():
	CoreEventBus.player_moved.emit()
