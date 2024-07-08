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
		
	for direction in direction_vectors.keys():
		var direction_vector:Vector2i = direction_vectors[direction]
		if event.is_action_pressed("ui_%s" % direction):
			if not can_move(direction_vector):
				continue
			
			move(direction_vector, true)
			break
