extends Area2D

const MOVE_TIME_SECONDS:float = 0.25
const TILE_SIZE:int = 32

var is_moving:bool = false

@onready var ray = $RayCast2D

var inputs = {
	"ui_right": Vector2.RIGHT,
	"ui_left": Vector2.LEFT,
	"ui_up": Vector2.UP,
	"ui_down": Vector2.DOWN
}

func _unhandled_key_input(event: InputEvent) -> void:
	if is_moving:
		return
		
	for direction in inputs.keys():
		if event.is_action_pressed(direction):
			move(direction)

func move(direction):
	ray.target_position = inputs[direction] * TILE_SIZE
	ray.force_raycast_update()
	if !ray.is_colliding():
		var tween = create_tween()
		tween.tween_property(self, "position",
			position + inputs[direction] * TILE_SIZE, MOVE_TIME_SECONDS).set_trans(Tween.TRANS_SINE)
		is_moving = true
		await tween.finished
		is_moving = false
